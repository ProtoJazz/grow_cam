defmodule GrowCamFirmware.MixProject do
  use Mix.Project

  @app :grow_cam_firmware
  @version "0.1.0"
  @all_targets [:ff_rpi0]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GrowCamFirmware.Application, []},
      extra_applications: [:logger, :runtime_tools, :ecto_mnesia]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.0", runtime: false},
      {:shoehorn, "~> 0.7.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:grow_cam_ui, path: "../grow_cam_ui"},
      {:ecto_mnesia, git: "https://github.com/Nebo15/ecto_mnesia"},
      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.11.3", targets: @all_targets},
      {:nerves_pack, "~> 0.4.0", targets: @all_targets},

      # Dependencies for specific targets
     # {:nerves_system_rpi, "~> 1.13", runtime: false, targets: :rpi},
     # {:nerves_system_rpi0, "~> 1.13", runtime: false, targets: :rpi0},
      {:ffmpeg_nerves_system_rpi0, path: "../../../ffmpeg_nerves_system_rpi0", runtime: false, targets: :ff_rpi0, nerves: [compile: true]},
     # {:nerves_system_rpi2, "~> 1.13", runtime: false, targets: :rpi2},
     # {:nerves_system_rpi3, "~> 1.13", runtime: false, targets: :rpi3},
     # {:nerves_system_rpi3a, "~> 1.13", runtime: false, targets: :rpi3a},
     # {:nerves_system_rpi4, "~> 1.13", runtime: false, targets: :rpi4},
     # {:nerves_system_bbb, "~> 2.8", runtime: false, targets: :bbb},
     # {:nerves_system_osd32mp1, "~> 0.4", runtime: false, targets: :osd32mp1},
      #{:nerves_system_x86_64, "~> 1.13", runtime: false, targets: :x86_64}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :dev
    ]
  end
end
