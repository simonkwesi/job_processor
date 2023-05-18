defmodule JobProcessor.TaskTest do
  use ExUnit.Case

  alias JobProcessor.Task

  describe "sort_tasks" do
    test "sorts tasks so that any task is always executed after all of its required tasks are executed" do
      tasks = [
        %{
          "name" => "task-1",
          "command" => "touch /tmp/file1"
        },
        %{
          "name" => "task-2",
          "command" => "cat /tmp/file1",
          "requires" => ["task-3"]
        },
        %{
          "name" => "task-3",
          "command" => "echo 'Hello World!' > /tmp/file1",
          "requires" => ["task-1"]
        },
        %{
          "name" => "task-4",
          "command" => "rm /tmp/file1",
          "requires" => ["task-2", "task-3"]
        }
      ]

      expected_sorted_tasks = [
        %{command: "touch /tmp/file1", name: "task-1"},
        %{command: "echo 'Hello World!' > /tmp/file1", name: "task-3"},
        %{command: "cat /tmp/file1", name: "task-2"},
        %{command: "rm /tmp/file1", name: "task-4"}
      ]

      assert expected_sorted_tasks == Task.sort_tasks(tasks)
    end

    test "when some tasks are not required by any other task (disconnected requirements graph) it sorts tasks correctly" do
      tasks = [
        %{
          "name" => "task-1",
          "command" => "touch /tmp/file1"
        },
        %{
          "name" => "task-2",
          "command" => "cat /tmp/file1",
          "requires" => ["task-3"]
        },
        %{
          "name" => "task-3",
          "command" => "echo 'Hello World!' > /tmp/file1",
          "requires" => ["task-1"]
        },
        %{
          "name" => "task-4",
          "command" => "rm /tmp/file1",
          "requires" => ["task-2", "task-3"]
        },
        %{
          "name" => "task-5",
          "command" => "touch /tmp/file2"
        }
      ]

      expected_sorted_tasks = [
        %{command: "touch /tmp/file1", name: "task-1"},
        %{command: "touch /tmp/file2", name: "task-5"},
        %{command: "echo 'Hello World!' > /tmp/file1", name: "task-3"},
        %{command: "cat /tmp/file1", name: "task-2"},
        %{command: "rm /tmp/file1", name: "task-4"}
      ]

      assert expected_sorted_tasks == Task.sort_tasks(tasks)
    end
  end
end
