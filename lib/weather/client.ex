defmodule Weather.Client do
  @callback fetch(String.t()) :: {:ok, %Weather.NoaaClient.Response{}} | {:error, String.t()}
end
