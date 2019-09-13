defmodule TimeapiWeb.ClockController do
  use TimeapiWeb, :controller

  alias Timeapi.Check
  alias Timeapi.Check.Clock

  action_fallback TimeapiWeb.FallbackController

  def index(conn, _params) do
    clocks = Check.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Check.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Check.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Check.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Check.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Check.get_clock!(id)

    with {:ok, %Clock{}} <- Check.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
