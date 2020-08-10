defmodule Weather.NoaaClient do
  @behaviour Weather.Client
  import SweetXml

  defmodule Response do
    defstruct [
      :station_id,
      :location,
      :weather,
      :temperature_string,
      :wind_string,
      :relative_humidity
    ]
  end

  @impl Weather.Client
  def fetch(location) do
    location
    |> url_for()
    |> HTTPoison.get()
    |> handle_response()
  end

  defp url_for(location), do: "https://w1.weather.gov/xml/current_obs/#{location}.xml"

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    response =
      body
      |> parse_xml()

    {:ok, response}
  end

  defp handle_response(_) do
    {:error, "Error fetching weather"}
  end

  defp parse_xml(body) do
    Map.keys(%Response{})
    |> List.delete_at(0)
    |> Enum.reduce(%Response{}, fn key, response ->
      Map.put(response, key, get_elem(body, Atom.to_string(key)))
    end)
  end

  defp get_elem(body, elem) do
    body
    |> xpath(~x"//current_observation/#{elem}/text()")
  end
end
