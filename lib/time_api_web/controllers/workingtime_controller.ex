defmodule TimeapiWeb.WorkingtimeController do
  use TimeapiWeb, :controller

  alias Timeapi.Manager
  alias Timeapi.Manager.Workingtime

  action_fallback TimeapiWeb.FallbackController

  def index(conn, params) do

    userid = params["userid"]
    workingid = params["workingid"]


    cond do
      !is_nil(userid) && !is_nil(workingid) && userid != "" && workingid != "" ->
        workingtime = Manager.userworking_by_userid_workingid(userid, workingid)
        render(conn, "show.json", workingtime: workingtime)
      true ->
          workingtimes = Manager.list_workingtimes()
          render(conn, "index.json", workingtimes: workingtimes)
    end
  end


  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Manager.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end


  def show(conn, %{"id" => id}) do
    workingtime = Manager.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Manager.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Manager.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Manager.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Manager.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
