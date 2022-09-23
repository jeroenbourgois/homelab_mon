defmodule HomelabMon.Daemon do
  use GenServer 

  alias HomelabMon.Mailer
  alias HomelabMon.Emails

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
    now = NaiveDateTime.utc_now()

    solar_edge = 
      case SolarEdge.get_main_site() do 
        {:ok, data} -> 
          Map.put(data, "updated_at", now)
        {:error, reason} -> 
          Logger.error(inspect(reason))
          %{"updated_at" => now, "status" => "error"}
      end

    schedule()

    if Map.get(solar_edge, "status") == "error" do
      Mailer.deliver!(Emails.solar_edge_down())
    end

    {:noreply, %{state | solar_edge: solar_edge}}
  end

  def schedule() do
    Process.send_after(__MODULE__, :run, interval())
  end

  # 1h
  defp interval(), do: 60_000 * 60
end
