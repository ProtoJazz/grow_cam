defmodule GrowCamFirmware.JobScheduler do
  use GenServer
  alias GrowCamFirmware.Camera
  def start_link(_data) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    IO.inspect("STARTING SCHEDULED STUFF")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts("WORKING")
    time_lapses = Camera.get_active_time_lapses()
    IO.puts("Checking this many time lapses")
    IO.inspect(Enum.count(time_lapses))
    Enum.each(time_lapses, fn time_lapse ->
      interval_time = NaiveDateTime.add(time_lapse.last_frame, time_lapse.interval * 3600, :second)
      now = NaiveDateTime.local_now()
      passed_interval = NaiveDateTime.compare(interval_time, now)
      future_check = NaiveDateTime.compare(time_lapse.last_frame, now)
      IO.puts("CHECKING TIME BOY")
      if(passed_interval == :lt or future_check == :gt) do
        Camera.take_photo(time_lapse)
        IO.puts("TOOK PHOTO")
      end
    end)

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    IO.puts("SCHEDULING")
    Process.send_after(self(), :work, 1800000) # In 1/2 hours
  end
end
