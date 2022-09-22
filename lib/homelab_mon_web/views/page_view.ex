defmodule HomelabMonWeb.PageView do
  use HomelabMonWeb, :view

  def solar_edge_last_updated(%{"updated_at" => updated_at}) do
    Calendar.strftime(updated_at, "%d-%m-%Y %H:%M")
  end

  def solar_edge_last_updated(_), do: "n/a"
end
