defmodule JobProcessor.Task do
  @doc """
  Sorts the tasks so that any task is always executed after all of its required tasks are executed.
  First, it builds a directed graph of the tasks and their requirements.
  Then, it uses a breadth-first search to output the graph as a list of sorted tasks.
  """
  def sort_tasks(tasks) do
    sorted_task_names = build_tasks_graph(tasks) |> bfs()

    sorted_tasks(hash_from_tasks(tasks), sorted_task_names)
  end

  defp build_tasks_graph(tasks) do
    build_tasks_graph(Graph.new(type: :directed), tasks)
  end

  defp build_tasks_graph(graph, [task | tasks]) do
    graph
    |> Graph.add_vertex(task["name"])
    |> add_edges(task["name"], task["requires"])
    |> build_tasks_graph(tasks)
  end

  defp build_tasks_graph(graph, []) do
    graph
  end

  defp add_edges(graph, task, [requirement | requirements]) do
    graph = Graph.add_edge(graph, requirement, task)
    add_edges(graph, task, requirements)
  end

  defp add_edges(graph, _task, []) do
    graph
  end

  defp add_edges(graph, _task, nil) do
    graph
  end

  defp bfs(graph) do
    Graph.Reducers.Bfs.map(graph, fn v -> v end)
  end

  defp hash_from_tasks(tasks) do
    Enum.reduce(tasks, %{}, fn task, acc ->
      Map.put(acc, task["name"], task)
    end)
  end

  defp sorted_tasks(tasks_hash, [task_name | task_names]) do
    task = Map.get(tasks_hash, task_name)
    task_json = %{name: task["name"], command: task["command"]}
    [task_json | sorted_tasks(tasks_hash, task_names)]
  end

  defp sorted_tasks(_tasks_hash, []) do
    []
  end
end
