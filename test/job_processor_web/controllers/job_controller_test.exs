defmodule JobProcessorWeb.JobControllerTest do
  use JobProcessorWeb.ConnCase

  @attrs %{
    tasks: [
      %{
        name: "task-1",
        command: "touch /tmp/file1"
      },
      %{
        name: "task-2",
        command: "cat /tmp/file1",
        requires: ["task-3"]
      },
      %{
        name: "task-3",
        command: "echo 'Hello World!' > /tmp/file1",
        requires: ["task-1"]
      },
      %{
        name: "task-4",
        command: "rm /tmp/file1",
        requires: ["task-2", "task-3"]
      }
    ]
  }

  @expected_json_response [
    %{"command" => "touch /tmp/file1", "name" => "task-1"},
    %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
    %{"command" => "cat /tmp/file1", "name" => "task-2"},
    %{"command" => "rm /tmp/file1", "name" => "task-4"}
  ]

  @expected_bash_response "#!/usr/bin/env bash\n\ntouch /tmp/file1\necho 'Hello World!' > /tmp/file1\ncat /tmp/file1\nrm /tmp/file1"

  test "POST /sort", %{conn: conn} do
    conn = post(conn, ~p"/api/jobs/sort", @attrs)
    assert @expected_json_response = json_response(conn, 200)
  end

  test "POST /sort with output format set to bash", %{conn: conn} do
    conn = post(conn, ~p"/api/jobs/sort?format=bash", @attrs)
    assert @expected_bash_response = text_response(conn, 200)
  end
end
