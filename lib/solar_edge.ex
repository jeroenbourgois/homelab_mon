defmodule SolarEdge do
  @conf Application.compile_env(:homelab_mon, :solar_edge)

  def get_site_list() do
    action = url("/sites/list.json")
    Req.get!(action).body
  end

  def get_main_site() do
    %{"sites" => %{"site" => [site | _]}} = get_site_list() 
    site
  end

  def get_site_details(site_id) do
    action = url("/sites/#{site_id}/details.json")
    Req.get!(action).body
  end

  defp url(action), do: api_endpoint() <> action <> "?api_key=" <> api_key()

  defp api_endpoint(), do: @conf[:api_endpoint]
  defp api_key(), do: @conf[:api_key]
end
