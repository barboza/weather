defmodule CliTest do
  use ExUnit.Case
  doctest Weather
  # use ExUnit.Case

  import Weather.CLI, only: [parse_args: 1]

  describe "parse_args/1" do
    test "accepts a location as paramenter" do
      assert Weather.CLI.parse_args(["LAX"]) == %{location: "LAX"}
    end

    test "returns :help if -h is passed as an argument" do
      assert Weather.CLI.parse_args(["-h"]) == :help
    end

    test "returns :help if --help is passed as an argument" do
      assert Weather.CLI.parse_args(["--help"]) == :help
    end

    test "returns :help if anything other than a location is passed" do
      assert Weather.CLI.parse_args(["not", "a", "location"]) == :help
    end

    test "accepts a lower case location" do
      assert Weather.CLI.parse_args(["lax"]) == %{location: "LAX"}
    end

    test "only accepts locations with 3 characters" do
      assert Weather.CLI.parse_args(["angeles"]) == :help
      assert Weather.CLI.parse_args(["lx"]) == :help
    end
  end
end
