defmodule TimeapiWeb.Router do
  use TimeapiWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:4000"
    plug :accepts, ["json"]
  end

  scope "/api", TimeapiWeb do
    pipe_through :api
    resources "/users", UserController
    get "/workingtimes/:userid/:workingid", WorkingtimeController, :index
#    get "/workingtimes/:userid", WorkingtimeController, :index
    resources "/clocks", ClockController, only: [:show, :create] 
    resources "/workingtimes", WorkingtimeController, only: [:index, :show, :create, :update, :delete]
   
  end
end
