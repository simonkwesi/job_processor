defmodule JobProcessorWeb.JobController do
  use JobProcessorWeb, :controller

  def sort(conn, _params) do
    require IEx
    IEx.pry
    json(conn, %{"message" => "Hello world!"})
  end
end
