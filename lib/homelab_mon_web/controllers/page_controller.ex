defmodule HomelabMonWeb.PageController do
  use HomelabMonWeb, :controller

  def index(conn, _) do
    solar_edge = SolarEdge.get_main_site()
    render(conn, :index, solar_edge: solar_edge)
  end

  def health(conn, _) do
    solar_edge = SolarEdge.get_main_site()
    status = Map.get(solar_edge, "status", false)

    if status == "Active" do
      conn
      |> put_status(200)
      |> json(%{status: %{solar_edge: "up"}})
    else 
      conn
      |> put_status(503)
      |> json(%{status: %{solar_edge: "down"}})
    end
  end
end
