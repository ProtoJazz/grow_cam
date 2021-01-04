defmodule GrowCamFirmware.Repo.Migrations.CreateTimeLapse do
  use Ecto.Migration

  def change do
    create table(:time_lapses) do
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :folder, :string
      add :frame_count, :integer
      add :interval, :integer

    end
  end
end
