# JobProcessor

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Sorting of Tasks
A directed Graph is first generated where every edge A -> B represents task B requiring task A before it can be run. The graph
is then converted into a list using breadth first search. 
# Deployment

A Dockerfile has been generated with `mix phx.gen.release --docker` and can be used to run the application in production.
