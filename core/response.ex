defmodule Mastery.Core.Response do
  @moduledoc """
  Represents the data we need to collect users responses.
  """

  defstruct ~w(quiz_title template_name to email answer correct timestamp)a
end
