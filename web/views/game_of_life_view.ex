defmodule Rumbl.GameOfLifeView do
  use Rumbl.Web, :view

  def checked?("1"), do: "checked"
  def checked?(_), do: ""
end
