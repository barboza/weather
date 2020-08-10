defmodule CliTest do
  use ExUnit.Case
  doctest Weather

  alias Weather.CLI
  alias Weather.NoaaClient.Response

  import ExUnit.CaptureIO
  import Mox

  describe "parse_args/1" do
    test "accepts a location as paramenter" do
      assert CLI.parse_args(["KLAX"]) == %{location: "KLAX"}
    end

    test "returns :help if -h is passed as an argument" do
      assert CLI.parse_args(["-h"]) == :help
    end

    test "returns :help if --help is passed as an argument" do
      assert CLI.parse_args(["--help"]) == :help
    end

    test "returns :help if anything other than a location is passed" do
      assert CLI.parse_args(["not", "a", "location"]) == :help
    end

    test "accepts a lower case location" do
      assert CLI.parse_args(["klax"]) == %{location: "KLAX"}
    end

    test "only accepts locations with 4 characters" do
      assert CLI.parse_args(["angeles"]) == :help
      assert CLI.parse_args(["lx"]) == :help
    end
  end

  describe "process/1" do
    test "returns help text if :help is given" do
      assert capture_io(fn -> CLI.process(:help) end) == "usage: weather <location>\n\n"
    end

    test "returns a Response with the correct info when a location is passed" do
      Weather.ClientMock
      |> stub(:fetch, fn x -> %Response{station_id: x} end)

      assert Map.get(CLI.process(%{location: "KSFO"}), :station_id) == "KSFO"
    end
  end
end
