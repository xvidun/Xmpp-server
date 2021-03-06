# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :spotlight_api,
  namespace: Spotlight,
  ecto_repos: [Spotlight.Repo],
  #vidhun
  #authy_api_token: "Sdb4XUOTj72PrVGqh79L7rvz4R8oSQ1T"
  authy_api_token: "jRUFkX6S1HVjFmx4LJaBCCfVYRx4LmoD",
  fcm_key: "AIzaSyASuRqvCZT1jgt4oQtHkNXyEkw_FbAWN90",
  PAYMENT_KEY: "rjQUPktU",
  PAYMENT_SALT: "e5iIg1jwi8"

# Configures the endpoint
config :spotlight_api, Spotlight.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eXaRQiIxTa+KmdHLm+e5wIE4eiML1Yii5hHZSjNfa9Wks7RGgPCY8qSmB52pmhf7",
  render_errors: [view: Spotlight.ErrorView, accepts: ~w(json)],
  pubsub: [name: Spotlight.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
#  allowed_algos: ["HS512"],
#  verify_module: Guardian.JWT
  issuer: "Spotlight",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "hsobcypdhgdoeihlakvujssgrt",
  serializer: Spotlight.GuardianSerializer

config :ejabberd,
  file: "config/ejabberd.yml",
  log_path: 'logs/ejabberd.log'

config :mnesia,
  dir: 'mnesiadb/'

config :arc,
  bucket: "spotlight.test",
  virtual_host: true,
  version_timeout: 30_000

config :ex_aws,
  access_key_id: "AKIAJSPRHDKMGBXSDMZQ",
  secret_access_key: "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",
  region: "s3.ap-south-1.amazonaws.com",
  host: "ap-south-1",
  s3: [
    scheme: "https://",
    host: "s3.ap-south-1.amazonaws.com",
    region: "ap-south-1"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
