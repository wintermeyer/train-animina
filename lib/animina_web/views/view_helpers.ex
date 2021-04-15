defmodule AniminaWeb.ViewHelpers do
  @moduledoc """
  Helper functions for use with views.
  """

  @version Mix.Project.config()[:version]

  @doc """
  Returns the version number of the project.
  """
  def version, do: @version

  @min_password_length Application.fetch_env!(:animina, :min_password_length)

  @doc """
  Returns the min_password_length number of the project.
  """
  def min_password_length, do: @min_password_length

  @doc """
  Returns a comma seperated list of list elements.
  The last comma is replaced with an "und" ("and").
  """
  def comma_join_with_a_final_und(list) do
    list = Enum.filter(list, &(!is_nil(&1)))

    case Enum.count(list) do
      0 ->
        ""

      1 ->
        Enum.at(list, 0)

      _ ->
        {first_elements, last_elements} = Enum.split(list, -1)
        [last_element] = last_elements

        Enum.join(first_elements, ", ") <> " und " <> last_element
    end
  end

  def truncate(text, max_length \\ 30) do
    omission = "..."

    cond do
      not String.valid?(text) ->
        text

      String.length(text) < max_length ->
        text

      true ->
        length_with_omission = max_length - String.length(omission)

        "#{String.slice(text, 0, length_with_omission)}#{omission}"
    end
  end
end
