defmodule GrowCamUiWeb.PageLive do
  use GrowCamUiWeb, :live_view
  alias GrowCamUi.Helpers
  alias GrowCamFirmware.Camera
  @impl true
  def mount(_params, _session, socket) do
    picture =  if Application.get_env(:grow_cam_firmware, :target) != :host do
      get_latest_picture()
    else
      Helpers.monkey
    end

    {:ok, assign(socket, query: "", results: %{}, image: picture)}
  end

  def get_latest_picture do
    timelapse = Camera.get_last_updated_timelapse
    {status, image} = File.read("#{timelapse.folder}/#{timelapse.frame_count}.jpg")
    if(status == :ok) do
      image |> IO.iodata_to_binary |> Base.encode64()
    else
      Helpers.monkey
    end
  end

  def take_and_read_picture() do
    Picam.Camera.start_link
   # IO.puts("link started")
    #Picam.set_size(760, 0)
    Picam.set_quality(60)
   # IO.puts("set size")
    Picam.next_frame
    |> Base.encode64()
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not GrowCamUiWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
