defmodule GrowCamFirmware.Repo.Migrations.AddActiveAndLastFrame do
  use Ecto.Migration

  def change do
    alter table(:time_lapses) do
      add :last_frame, :naive_datetime
      add :active, :boolean

    end
  end
end
