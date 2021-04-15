defmodule Animina.Formater do
  @doc ~S"""
  Formats an integer to a short humanized string.

  ## Examples

      iex> Animina.Formater.humanize_number(12)
      "12"
      iex> Animina.Formater.humanize_number(12023)
      "12K"
  """
  def humanize_number(value) when is_integer(value) do
    case value |> Integer.to_string() |> String.length() do
      1 -> Integer.to_string(value)
      2 -> Integer.to_string(value)
      3 -> Integer.to_string(value)
      4 -> Integer.to_string(floor(value / 1000)) <> "K"
      5 -> Integer.to_string(floor(value / 1000)) <> "K"
      6 -> Integer.to_string(floor(value / 1000)) <> "K"
      _ -> Integer.to_string(floor(value / 1_000_000)) <> "M"
    end
  end

  def to_html(markdown) do
    case Earmark.as_html(markdown) do
      {:ok, html_doc, []} -> html_doc
      _ -> markdown
    end
  end
end
