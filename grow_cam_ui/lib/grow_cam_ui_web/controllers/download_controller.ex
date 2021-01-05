defmodule GrowCamUiWeb.DownloadController do
  use GrowCamUiWeb, :controller
  alias GrowCamFirmware.Camera

  def video(conn, %{"id" => id}) do
    IO.inspect(id)

    {parsed_id, _} = Integer.parse(id)

    timelapse = Camera.get_time_lapse(parsed_id)

    case is_nil(timelapse) do
      false ->
        conn
        |> put_resp_content_type("video/mp4")
        |> put_resp_header("content-disposition", "attachment; filename=#{timelapse.video_file}")
        |> send_file(200, "#{timelapse.folder}/#{timelapse.video_file}")
      true ->
        conn
        |> put_flash(:error, gettext("Export failed."))
        |> redirect(to: NavigationHistory.last_path(conn, 1))
    end

  end
end
