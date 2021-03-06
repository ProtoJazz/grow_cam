# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config
import_config "../../grow_cam_ui/config/config.exs"
#import_config "../../grow_cam_ui/config/prod.exs"
# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :grow_cam_firmware, target: Mix.target()

config :grow_cam_firmware, GrowCamFirmware.Repo,
  adapter: EctoMnesia.Adapter

config :grow_cam_firmware, ecto_repos: [GrowCamFirmware.Repo]

config :grow_cam_ui, GrowCamUiWeb.Endpoint,
  # Nerves root filesystem is read-only, so disable the code reloader
  code_reloader: false,
  http: [port: 4000],
  # Use compile-time Mix config instead of runtime environment variables
  load_from_system_env: false,
  # Start the server since we're running in a release instead of through `mix`
  server: true,
  url: [host: nil, port: 4000]

config :ecto_mnesia,
  host: {:system, :atom, "MNESIA_HOST", Kernel.node()},
  storage_type: {:system, :atom, "MNESIA_STORAGE_TYPE", :disc_copies}

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1604762681"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mnesia, :dir, 'priv/data/mnesia'

if Mix.target() != :host do
  import_config "target.exs"
end
