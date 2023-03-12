defmodule Mastery.Core.Quiz do
  @moduledoc """
  Represents the structure we need to as questions (quizzes) to users.

  Initially, all questions will start in `templates`. The quiz will select a question,
  and that question will move from `templates` to `used`. After all questions get
  asked once, unless they're mastered in the meantime, they'll move back from `used` to
  `templates`.

  Getting an answer right will increment a record, and getting enough right in a row
  will move a template from `used` to `mastered`. Getting an answer wrong will reset the
  record.
  """
  alias Mastery.Core.Question
  # alias Mastery.Core.Response
  alias Mastery.Core.Template

  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  @typedoc "Schema type"
  @type t() :: %__MODULE__{}

  @spec new([atom()]) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @spec add_template(t(), [atom()]) :: t()
  def add_template(quiz, fields) do
    template = %{category: category} = Template.new(fields)

    templates = Map.update(quiz.templates, category, [template], &[template | &1])

    %{quiz | templates: templates}
  end

  @spec select_question(t()) :: nil | t()
  def select_question(%__MODULE__{templates: t}) when map_size(t) == 0, do: nil

  def select_question(%__MODULE__{} = quiz) do
    quiz
    |> pick_current_question()
    |> move_template(:used)
    |> reset_template_cycle()
  end

  defp pick_current_question(quiz) do
    Map.put(quiz, :current_question, select_a_random_question(quiz))
  end

  defp select_a_random_question(quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new()
  end

  defp move_template(quiz, field) do
    quiz
    |> remove_template_from_category()
    |> add_template_to_field(field)
  end

  defp remove_template_from_category(quiz) do
    template = template(quiz)

    new_category_templates =
      quiz.templates |> Map.fetch!(template.category) |> List.delete(template)

    new_templates =
      if new_category_templates == [] do
        Map.delete(quiz.templates, template.category)
      else
        Map.put(quiz.templates, template.category, new_category_templates)
      end

    %{quiz | templates: new_templates}
  end

  defp add_template_to_field(quiz, field) do
    template = template(quiz)

    list = Map.get(quiz, field)

    Map.put(quiz, field, [template | list])
  end

  defp reset_template_cycle(%{templates: templates, used: used} = quiz)
       when map_size(templates) == 0 do
    %__MODULE__{
      quiz
      | templates: Enum.group_by(used, fn template -> template.category end),
        used: []
    }
  end

  defp reset_template_cycle(quiz), do: quiz

  defp template(quiz), do: quiz.current_question.template
end
