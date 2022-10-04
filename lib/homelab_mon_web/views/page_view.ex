defmodule HomelabMonWeb.PageView do
  use HomelabMonWeb, :view

  def solar_edge_last_updated(%{"updatedAt" => updated_at}) do
    IO.inspect(updated_at, label: "Updated at")
    Calendar.strftime(updated_at, "%d-%m-%Y %H:%M")
  end

  def solar_edge_last_updated(_), do: "n/a"
end
