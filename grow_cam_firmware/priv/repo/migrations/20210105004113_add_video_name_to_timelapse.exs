defmodule GrowCamFirmware.Repo.Migrations.AddVideoNameToTimelapse do
  use Ecto.Migration

  def change do
    alter table(:time_lapses) do
      add :video_file, :string
    end
  end
end
