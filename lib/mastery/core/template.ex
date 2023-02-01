defmodule Mastery.Core.Template do
  @moduledoc """
  Represents a template for the quizzes.
  """

defstruct ~w(name category instructions raw compiled generators checkers)a
end
