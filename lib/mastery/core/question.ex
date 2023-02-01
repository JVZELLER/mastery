defmodule Mastery.Core.Question do
  @moduledoc """
  Represents the structure of a question.
  """

  defstruct ~w(asked substitutions template)a

  @typedoc "Schema type"
  @type t() :: %__MODULE__{}
end
