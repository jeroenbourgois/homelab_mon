defmodule HomelabMon.Daemon do
  use GenServer 

  # alias HomelabMon.Mailer
  # alias HomelabMon.Emails

  require Logger

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    state = %{solar_edge: nil}

    # setup hourly run
    schedule()

    # run on startup
    Kernel.send(__MODULE__, :run)  

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:run, state) do
    Logger.info("Update SolarEdge status")
    now = DateTime.utc_now() |> DateTime.shift_zone!("Europe/Brussels")

    solar_edge = 
      case SolarEdge.get_main_site() do 
        {:ok, data} -> 
          last_update_time =  
            SolarEdge.get_main_site_overview()
            |> Map.get("overview")
            |> Map.get("lastUpdateTime")
            |> parse_lut()

          data
          |> Map.put("updatedAt", now)
          |> Map.put("lastUpdateTime", last_update_time)

        {:error, reason} -> 
          Logger.error(inspect(reason))
          %{"updatedAt" => now, "status" => "error"}
      end

    schedule()

    error? = Map.get(solar_edge, "status") == "error"
    outdated? = lut_outdated?(solar_edge["lastUpdateTime"])

    if error? || outdated? do
      # Mailer.deliver!(Emails.solar_edge_down())
    end

    solar_edge = Map.put(solar_edge, "isOutdated", outdated?)

    {:noreply, %{state | solar_edge: solar_edge}}
  end

  def schedule() do
    Process.send_after(__MODULE__, :run, interval())
  end

  # 1h
  defp interval(), do: 60_000 * 60

  # we know we are in +2 UTC... we get the lut in Europe/Brussels time from the API
  defp parse_lut(lut) do
    case NaiveDateTime.from_iso8601(lut) do
      {:ok, parsed_lut} -> parsed_lut
      {:error, _reason} -> nil
    end
  end

  def lut_outdated?(lut) do
    six_hours_from_now = NaiveDateTime.utc_now() |> NaiveDateTime.add(6, :hour)
    NaiveDateTime.compare(lut, six_hours_from_now) == :lt
  end
end
