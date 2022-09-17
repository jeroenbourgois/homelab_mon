defmodule HomelabMonWeb.PageController do
  use HomelabMonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
