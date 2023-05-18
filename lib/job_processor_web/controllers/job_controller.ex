defmodule JobProcessorWeb.JobController do
  use JobProcessorWeb, :controller

  def sort(conn, params) do
    sorted_tasks =
      build_tasks_graph(params["tasks"])
      |> bfs()

    json(conn, sorted_tasks_json(hash_from_tasks(params["tasks"]), sorted_tasks))
  end

  def bash(conn, params) do
    sorted_tasks =
      build_tasks_graph(params["tasks"])
      |> bfs()

    bash =
      Enum.reduce(sorted_tasks, "", fn task, acc ->
        acc <> task <> "\n"
      end)

    json(conn, %{bash: bash})
  end

  defp hash_from_tasks(tasks) do
    Enum.reduce(tasks, %{}, fn task, acc ->
      Map.put(acc, task["name"], task)
    end)
  end

  defp bfs(graph) do
    Graph.Reducers.Bfs.map(graph, fn v -> v end)
  end

  defp sorted_tasks_json(tasks_hash, [task_name | task_names]) do
    task = Map.get(tasks_hash, task_name)
    task_json = %{name: task["name"], command: task["command"]}
    [task_json | sorted_tasks_json(tasks_hash, task_names)]
  end

  defp sorted_tasks_json(tasks_hash, []) do
    []
  end

  defp build_tasks_graph(graph \\ Graph.new(type: :directed), [task | tasks]) do
    graph =
      graph
      |> Graph.add_vertex(task["name"])
      |> add_edges(task["name"], task["requires"])

    build_tasks_graph(graph, tasks)
  end

  defp build_tasks_graph(graph, []) do
    graph
  end

  defp add_edges(graph, task, [requirement | requirements]) do
    graph = Graph.add_edge(graph, requirement, task)
    add_edges(graph, task, requirements)
  end

  defp add_edges(graph, task, []) do
    graph
  end

  defp add_edges(graph, task, nil) do
    graph
  end
end
