defmodule GrowCamFirmware.Camera do
  alias GrowCamFirmware.TimeLapse
  alias GrowCamFirmware.Repo
  import Ecto.Query
  def new_time_lapse(args) do
    %TimeLapse{}
    |> TimeLapse.changeset(args)
    |> IO.inspect()
    |> Repo.insert()
  end

  def get_active_time_lapses() do
    IO.puts("Getting lapses")
    TimeLapse
    |>where(active: true)
    |>Repo.all()
  end

  def generate_host_test_lapse() do
    now = NaiveDateTime.local_now()
    later = NaiveDateTime.add(now, 60, :seconds)
    %{folder: "test_data/test", active: true, last_frame: now, start_date: now, end_date: later,
    frame_count: 0, interval: 1
    }
    |> new_time_lapse()
  end

  def generate_target_test_lapse() do
    now = NaiveDateTime.local_now()
    later = NaiveDateTime.add(now, 3 * 60 * 60, :seconds)
    %{folder: "/root/agent_simpson", active: true, last_frame: now, start_date: now, end_date: later,
    frame_count: 0, interval: 1
    }
    |> new_time_lapse()
  end

  def delete_all_time_lapses do
    Repo.delete_all(TimeLapse)
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

    if Application.get_env(:grow_cam_firmware, :target) != :host do
      System.cmd("raspistill", ["-n", "-q", "75", "-o", file_path], stderr_to_stdout: true)
    end
    snap_time = NaiveDateTime.local_now()

    timelapse
    |> TimeLapse.changeset(%{frame_count: currentFrame, last_frame: snap_time, active: NaiveDateTime.compare(snap_time, timelapse.end_date) != :gt})
    |> Repo.update()
  end
end

# GrowCamFirmware.Camera.get_time_lapses
# List.first(GrowCamFirmware.Camera.get_time_lapses) |> GrowCamFirmware.Camera.take_photo
# GrowCamFirmware.Camera.generate_host_test_lapse
# GrowCamFirmware.Camera.delete_all_time_lapses
