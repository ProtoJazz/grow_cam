defmodule GrowCamFirmware.TimeLapse do
  use Ecto.Schema
  import Ecto.Changeset
  schema "time_lapses" do
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime
    field :folder, :string
    field :frame_count, :integer
    field :interval, :integer


  end

  @doc false
  def changeset(time_lapse, attrs) do
    time_lapse
    |> cast(attrs, [:start_date, :end_date, :folder, :frame_count, :interval])
    |> unique_constraint(:folder)
  end
end
