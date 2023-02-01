defmodule Mastery.Core.Template do
  @moduledoc """
  Represents a template for the quizzes.
  """

  defstruct ~w(name category instructions raw compiled generators checkers)a

  @typedoc "Schema type"
  @type t() :: %__MODULE__{}

  @spec new(Keyword.t()) :: t()
  def new(fields) do
    raw = Keyword.fetch!(fields, :raw)

    struct!(__MODULE__, Keyword.put(fields, :compiled, EEx.compile_string(raw)))
  end
end
