# todo: document module and functions
# todo: write tests
defmodule Accio.Wormhole do
  def capture(supervisor, callback, timeout_ms \\ 5000) do
    task = Task.Supervisor.async_nolink(supervisor, callback)

    task
    |> Task.yield(timeout_ms)
    |> task_demonitor(task)
  end

  defp task_demonitor(response, task) do
    Map.get(task, :ref) |> Process.demonitor([:flush])
    response
  end
end
