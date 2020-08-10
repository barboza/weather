defmodule Weather.Client do
  @moduledoc false

  @callback fetch(String.t()) :: {:ok, %Weather.NoaaClient.Response{}} | {:error, String.t()}
end
