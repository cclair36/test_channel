defmodule TestChannel.Repo do
  use Ecto.Repo,
    otp_app: :test_channel,
    adapter: Ecto.Adapters.Postgres
end
