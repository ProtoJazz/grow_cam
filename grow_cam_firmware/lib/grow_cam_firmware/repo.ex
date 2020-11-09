defmodule GrowCamFirmware.Repo do
  use Ecto.Repo,
    otp_app: :grow_cam_firmware,
    adapter: Sqlite.Ecto2
end
