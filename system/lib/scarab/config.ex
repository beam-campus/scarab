defmodule Scarab.Config do
  @moduledoc """
  This module is responsible for loading the configuration for the application.
  """
  def data_dir(config),
    do:
      config
      |> Keyword.get(:data_dir) || "scarab_data"

  def store_id(config) when is_map(config),
    do:
      config
      |> Map.get(:store_id) || :scarab

  def store_id(config) when is_list(config),
    do:
      config
      |> Keyword.get(:store_id) || :scarab

  def timeout(config),
    do:
      config
      |> Keyword.get(:timeout) || 5_000

  def db_type(config),
    do:
      config
      |> Keyword.get(:db_type) || :node

  def fetch_env!(app) do
    case Application.fetch_env!(app, :scarab) do
      nil -> raise(ArgumentError, "no config for #{inspect(app)}")
      config -> Map.new(config)
    end
  end
end
