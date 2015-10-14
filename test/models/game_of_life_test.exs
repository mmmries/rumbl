defmodule Rumbl.GameOfLifeTest do
  use ExUnit.Case, async: true
  import Rumbl.GameOfLife

  test "it transforms params into a board" do
    assert parse_params(%{"1,1" => "1"}, {3,3}) == [[1,0,0],[0,0,0],[0,0,0]]
    assert parse_params(%{"1,3" => "1"}, {3,3}) == [[0,0,1],[0,0,0],[0,0,0]]
  end

  test "it generates an empty board" do
    assert generate({3,3}) == [[0,0,0],[0,0,0],[0,0,0]]
  end
end
