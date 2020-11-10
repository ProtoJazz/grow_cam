defmodule GrowCamFirmware.Camera do
  alias GrowCamFirmware.TimeLapse
  alias GrowCamFirmware.Repo

  def new_time_lapse() do
    %TimeLapse{}
    |> TimeLapse.changeset(%{folder: "/root/test", start_date: NaiveDateTime.local_now(), end_date: NaiveDateTime.local_now(),
    frame_count: 0, interval: 1
    })
    |> IO.inspect()
    |> Repo.insert()
  end

  def get_time_lapses() do
    TimeLapse
    |> Repo.all()
  end

  def take_photo(timelapse) do
    currentFrame = timelapse.frame_count + 1
    file_path = "#{timelapse.folder}/#{currentFrame}.jpg"

    if !File.exists?(timelapse.folder) do
      File.mkdir!(timelapse.folder)
    end

    System.cmd("raspistill", ["-n", "-q", "75", "-o", file_path], stderr_to_stdout: true)

    timelapse
    |> TimeLapse.changeset(%{frame_count: currentFrame})
    |> Repo.update()
  end
end

# GrowCamFirmware.Camera.get_time_lapses
