defmodule GrowCamUiWeb.ScheduleFormComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div phx-hook="ScheduleForm" id="new-form">
    <form phx-submit="<%= @submit_action %>">
        <div class="field">
          <label class="label">Start Date</label>
          <div class="control">
              <input type="date" name="start-date" placeholder="start-date" value="<%= if !is_nil(@selected_timelapse.start_date) do @selected_timelapse.start_date |> NaiveDateTime.to_date end %>">
          </div>
        </div>
        <div class="field">
          <label>End Date</label>
          <input type="date"  name="end-date" placeholder="end-date" value="<%= if !is_nil(@selected_timelapse.end_date) do @selected_timelapse.end_date |> NaiveDateTime.to_date end %>">
        </div>
        <div class="field">
          <label>Folder</label>
          <input type="text" class="input" name="folder" placeholder="folder" value="<%= @selected_timelapse.folder %>">
        </div>
        <div class="six wide field">
          <label>Interval</label>
          <input type="number" class="input" name="interval" placeholder="interval" value="<%= @selected_timelapse.interval %>">
        </div>
      <div class="control">
        <button type="submit" class="button is-link">Save</button>
     </div>
    </form>
    <%= if @live_action == :edit do %>
      <button type="button" phx-click="make-movie">Make movie</button>
    <% end %>
    </div>
    """
  end
end
