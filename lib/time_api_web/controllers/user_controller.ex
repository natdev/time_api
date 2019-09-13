defmodule TimeapiWeb.UserController do
  use TimeapiWeb, :controller

  alias Timeapi.Auth
  alias Timeapi.Auth.User

  action_fallback TimeapiWeb.FallbackController

  def index(conn, users) do


    username = users["username"]
    email = users["email"]


#    cond do
#      !is_nil(username) && !is_nil(email) && username != "" && email != "" ->
#        user = Auth.find_user_by_username_and_email(username, email)
#        render(conn, "show.json", user: user)
#      !is_nil(username) && username != "" ->
#        user = Auth.find_user_by_username(username)
#        render(conn, "show.json", user: user)
#      !is_nil(email) && email != "" ->
#        user = Auth.find_user_by_email(email)
#        render(conn, "show.json", user: user)
#      true ->
        users = Auth.list_users()
        render(conn, "index.json", users: users)
#    end
  end

  

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
