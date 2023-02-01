defmodule Mastery.Core.Response do
  @moduledoc """
  Represents the data we need to collect users responses.
  """

  alias Mastery.Core.Quiz

  defstruct ~w(quiz_title template_name to email answer correct timestamp)a

  @typedoc "Schema type"
  @type t() :: %__MODULE__{}

  @spec new(Quiz.t(), String.t(), String.t()) :: t()
  def new(%Quiz{current_question: question, template: template} = quiz, email, answer) do
    checker = template.checker
    substitutions = question.substitutions

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: checker.(substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
