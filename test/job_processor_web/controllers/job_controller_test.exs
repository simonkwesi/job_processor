defmodule JobProcessorWeb.JobControllerTest do
  use JobProcessorWeb.ConnCase

   @attrs %{
    tasks:
      [
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
          requires: ["task-2","task-3"]
        }
      ]
    }
  test "POST /", %{conn: conn} do
    conn = post(conn, ~p"/api/jobs", @attrs)
    assert json_response(conn, 200) =~ {}
  end
end
