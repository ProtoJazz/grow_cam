# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :grow_cam_ui, GrowCamUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eeFqRKP8KGj/LQ1l+zMOe5vlp81guHsokCEGpuUrt11Xt9NCpG27Ms+M9vcX3xzc",
  render_errors: [view: GrowCamUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GrowCamUi.PubSub,
  live_view: [signing_salt: "VBGySzKa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
