defmodule Scarab.Storage do
  @moduledoc false

  alias Scarab.Config

  def wait_for_event_store(timeout \\ 5_000) when is_integer(timeout) do
    task = Task.async(&scarab_check/0)

    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, result} ->
        result

      nil ->
        {:error, :timeout}
    end
  end

  defp scarab_check do
    case Scarab.System.start(Config.get()) do
      {:ok, state} ->
        :timer.sleep(1_000)
        :ok

      _ ->
        :timer.sleep(1_000)
        scarab_check()
    end
  end

  def store do
    Scarab.Config.store()
  end
end
