defmodule SolarEdge do
  def get_site_list() do
    action = url("/sites/list.json")
    case Req.get(action) do
      {:error, reason} -> {:error, reason}
      {:ok, %{body: body}} -> {:ok, body}
      {:ok, _} -> {:error, :no_json_body}
    end 
  end

  def get_main_site() do
    case get_site_list() do
      {:ok, %{"sites" => %{"site" => [site | _]}}} -> {:ok, site}
      {:error, reason} -> {:error, reason}
      {:ok, _} -> {:error, :no_json_body}
    end
  end

  def get_site_details(site_id) do
    action = url("/sites/#{site_id}/details.json")
    case Req.get(action) do
      {:error, reason} -> {:error, reason}
      {:ok, %{body: body}} -> body
      {:ok, _} -> {:error, :no_json_body}
    end
  end

  defp url(action), do: api_endpoint() <> action <> "?api_key=" <> api_key()

  defp conf(), do: Application.get_env(:homelab_mon, :solar_edge)
  defp api_endpoint(), do: conf()[:api_endpoint]
  defp api_key(), do: conf()[:api_key]
end
