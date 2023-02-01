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

  defstruct title: nil,
            mastery: 3,
            template: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  @typedoc "Schema type"
  @type t() :: %__MODULE__{}
end
