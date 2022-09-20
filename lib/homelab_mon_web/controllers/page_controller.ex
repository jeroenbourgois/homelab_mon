defmodule HomelabMonWeb.PageController do
  use HomelabMonWeb, :controller
  alias HomelabMon.Daemon

  def index(conn, _) do
    %{solar_edge: solar_edge} = Daemon.get_state()
    render(conn, :index, solar_edge: solar_edge)
  end

  def health(conn, _) do
    %{solar_edge: solar_edge} = Daemon.get_state()
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

  def solar_edge(conn, _) do
    %{solar_edge: solar_edge} = Daemon.get_state()
    render(conn, :solar_edge, solar_edge: solar_edge)
  end
end
