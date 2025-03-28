defmodule ExESDB.EventStreamReader do
  @moduledoc false

  import ExESDB.Khepri.Conditions

  def get_current_version!(store, stream_id) do
    case store
         |> get_current_version(stream_id) do
      {:ok, count} -> count
      _ -> 0
    end
  end

  def get_current_version(store, stream_id),
    do:
      store
      |> :khepri.count([
        :streams,
        stream_id,
        if_node_exists(exists: true)
      ])

  def read_events(store, stream_id, start_version, count) do
    start_version..(start_version + count - 1)
    |> Enum.map(fn version ->
      padded_version = ExESDB.VersionFormatter.pad_version(version, 6)

      store
      |> :khepri.get!([:streams, stream_id, padded_version])
    end)
    |> Enum.reject(&is_nil/1)
  end


  def get_streams(store) do
    store
    |> :khepri.get!([:streams])
    |> Enum.reduce([], fn {stream_id, _stream}, acc -> stream_id ++ acc end)
  end


end
