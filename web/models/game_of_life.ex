defmodule Rumbl.GameOfLife do
  def generate({height,width}) do
    (1..height) |> Enum.map( fn(_row) ->
      (1..width) |> Enum.map( fn(_col) ->
        0
      end)
    end)
  end

  def parse_params(params, {height,width}) do
    (1..height) |> Enum.map( fn(row) ->
      (1..width) |> Enum.map( fn(col) ->
        case params["#{row},#{col}"] do
          "1" -> 1
          _ -> 0
        end
      end)
    end)
  end
end
