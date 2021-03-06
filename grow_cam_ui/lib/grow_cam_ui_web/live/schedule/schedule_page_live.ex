defmodule GrowCamUiWeb.SchedulePageLive do
  use GrowCamUiWeb, :live_view
  alias GrowCamFirmware.TimeLapse
  alias GrowCamFirmware.Repo
  alias GrowCamFirmware.Camera

  def mount(params, session, socket) do
    timelapses = get_lapses()

    id = if(params["id"]) do
      {id, _} = Integer.parse(params["id"])
      id
    else
      nil
    end
    selected_timelapse = Enum.find(timelapses, fn l -> l.id == id end )

    {:ok, assign(socket, query: "", results: %{}, timelapses: timelapses, selected_timelapse: selected_timelapse, empty_timelapse: Camera.empty_time_lapse)}
  end

  def handle_event("timelapse-updated", params, socket) do
    IO.inspect(params)

    socket.assigns.selected_timelapse
    |> TimeLapse.changeset(params)
    |> Repo.update

    {:noreply, socket}
  end

  def handle_event("timelapse-create", params, socket) do
    now = NaiveDateTime.local_now()
    IO.inspect(params)
    {_, start_date} = NaiveDateTime.new(Date.from_iso8601!(params["start-date"]), NaiveDateTime.local_now() |> NaiveDateTime.to_time)
    {_, end_date} = NaiveDateTime.new(Date.from_iso8601!(params["end-date"]), NaiveDateTime.local_now() |> NaiveDateTime.to_time)

    %{folder: params["folder"], active: true, last_frame: now, start_date: start_date, end_date: end_date,
    frame_count: 0, interval: params["interval"]
    }
    |> Camera.new_time_lapse()
    socket = socket
    |> push_redirect(to: "/schedule")
    #{:noreply, socket}

    {:noreply, socket}
  end

  def handle_event("delete-timelapse", %{"id" => id}, socket) do
    {parsed_id, _} = Integer.parse(id)
    timelapse = Camera.get_time_lapse(parsed_id)
    Camera.delete_timelapse(timelapse)

    socket =
      socket
      |> assign(timelapses: get_lapses())

    {:noreply, socket}
  end

  def handle_event("make-movie", _, socket) do
    Camera.make_movie(socket.assigns.selected_timelapse)
    {:noreply, socket}
  end

  def get_lapses() do
    IO.puts("Getting lapses")
    TimeLapse
    |>Repo.all()
  end

end
