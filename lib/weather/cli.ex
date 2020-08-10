defmodule Weather.CLI do
  @moduledoc """
  Parses the command line commands and dispatch all functions necessary to
  generate a weather report for a given location.
  """

  @client Application.get_env(:weather, :client)

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a location in the US (i.e. `SFO`)

  Returns a map of `%{location: location}`, or :help if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> validate_location()
    |> args_to_map()
  end

  defp args_to_map([location]) do
    location = String.upcase(location)
    %{location: location}
  end

  defp args_to_map(_) do
    :help
  end

  defp validate_location([location]) when is_binary(location) do
    cond do
      String.length(location) == 4 -> [location]
      true -> :help
    end
  end

  defp validate_location(_), do: :help

  def process(:help) do
    IO.puts("""
    usage: weather <location>
    """)
  end

  def process(%{location: location}) do
    @client.fetch(location)
  end
end
