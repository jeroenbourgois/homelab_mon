defmodule SolarEdge do
  def get_site_list() do
    action = url("/sites/list.json")

    case Req.get(action, [retry: :never]) do
      {:error, reason} -> {:error, reason}
      {:ok, %{body: body}} when is_map(body) -> {:ok, body}
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

  def get_main_site_overview() do
    case get_site_list() do
      {:error, reason} -> {:error, reason}
      {:ok, %{"sites" => %{"site" => [%{"id" => site_id} | _]}}} -> get_site_overview(site_id)
      {:ok, _} -> {:error, :no_json_body}
    end
  end

  def get_site_details(site_id) do
    action = url("/site/#{site_id}/details.json")
    case Req.get(action, retry: :never) do
      {:error, reason} -> {:error, reason}
      {:ok, %{body: body}} when is_map(body)-> body
      {:ok, _} -> {:error, :no_json_body}
    end
  end

  def get_site_overview(site_id) do
    action = url("/site/#{site_id}/overview.json")
    case Req.get(action, retry: :never) do
      {:error, reason} -> {:error, reason}
      {:ok, %{body: body}} when is_map(body)-> body
      {:ok, _} -> {:error, :no_json_body}
    end
  end

  defp url(action), do: api_endpoint() <> action <> "?api_key=" <> api_key()

  defp conf(), do: Application.get_env(:homelab_mon, :solar_edge)
  defp api_endpoint(), do: conf()[:api_endpoint]
  defp api_key(), do: conf()[:api_key]

  defp main_site_list_dev() do
    %{
      "sites" => %{
        "count" => 1,
        "site" => [
          %{
            "id" => 1358356,
            "name" => "Jeroen Bourgois",
            "accountId" => 52655,
            "status" => "Active",
            "peakPower" => 3.33,
            "lastUpdateTime" => "2022-09-20",
            "installationDate" => "2019-11-07",
            "ptoDate" => nil,
            "notes" => "",
            "type" => "Optimizers & Inverters",
            "location" => %{
              "country" => "Belgium",
              "city" => "Zwevegem",
              "address" => "Daeleweg 2B",
              "address2" => "",
              "zip" => "8554",
              "timeZone" => "Europe/Brussels",
              "countryCode" => "BE"
            },
            "primaryModule" => %{
              "manufacturerName" => "LG Electronics Inc.",
              "modelName" => "LG370Q1C-V5 (Neon R)",
              "maximumPower" => 370,
              "temperatureCoef" => -0.3
            },
            "uris" => %{
              "SITE_IMAGE" => "/site/1358356/siteImage/IMG_9297.jpg",
              "DATA_PERIOD" => "/site/1358356/dataPeriod",
              "DETAILS" => "/site/1358356/details",
              "OVERVIEW" => "/site/1358356/overview"
            },
            "publicSettings" => %{
              "isPublic" => false
            }
          }
        ]
      }
    }
  end
end
