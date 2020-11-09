defmodule GrowCamFirmware.Camera do
  alias GrowCamFirmware.TimeLapse
  alias GrowCamFirmware.Repo

  def new_time_lapse() do
    %TimeLapse{}
    |> TimeLapse.changeset(%{folder: "/root/test", start_time: NaiveDateTime.local_now(), end_time: NaiveDateTime.local_now(),
    frame_count: 0, interval: 1
    })
    |> Repo.insert()
  end

  def get_time_lapses() do
    TimeLapse
    |> Repo.all()
  end
end
