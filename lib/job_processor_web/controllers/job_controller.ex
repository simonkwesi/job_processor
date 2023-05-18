defmodule JobProcessorWeb.JobController do
  use JobProcessorWeb, :controller
  alias JobProcessor.Task

  def sort(conn, _params = %{"tasks" => tasks, "format" => "bash"}) do
    sorted_tasks = Task.sort_tasks(tasks)
    text(conn, tasks_as_bash(sorted_tasks))
  end

  def sort(conn, _params = %{"tasks" => tasks_list}) do
    sorted_tasks = Task.sort_tasks(tasks_list)

    json(conn, sorted_tasks)
  end

  def tasks_as_bash(tasks) do
    task_commands =
      tasks
      |> Enum.map_join(
        "\n",
        fn task ->
          task[:command] <> "\n"
        end
      )

    res =
      "#!/usr/bin/env bash" <>
        "\n\n" <>
        task_commands
  end
end
