defmodule GraphqlServerDemoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :graphql_server_demo
  use Absinthe.Phoenix.Endpoint

  socket "/socket", GraphqlServerDemoWeb.UserSocket,
    websocket: true,
    longpoll: false


  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug GraphqlServerDemoWeb.Router
end
