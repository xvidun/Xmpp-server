defmodule Spotlight.LocationController do
  use Spotlight.Web, :controller
  require Logger
  import Ecto.Query

  alias Spotlight.Location
  alias Spotlight.User

  plug Guardian.Plug.EnsureAuthenticated, [handler: Spotlight.GuardianErrorHandler] when action in [:update, :get_nearby_people, :delete]

  def update(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    user = Guardian.Plug.current_resource(conn)
    case insert_or_update(user, %{"latitude"=> latitude, "longitude"=> longitude}) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render(Spotlight.AppView, "status.json", %{message: "Location Updated", status: "success"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Spotlight.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def get_nearby_people(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    user1 = Guardian.Plug.current_resource(conn)
    case insert_or_update(user1, %{"latitude"=> latitude, "longitude"=> longitude}) do
      {:ok, user} ->
        query = from l in Location,
          inner_join: u in User, on: l.user_id == u.id,
          order_by: fragment("d asc"),
          where: u.id != ^user1.id,
          select: %{distance: fragment("distance(?,?,?,?)*1.60934 AS d", l.latitude, l.longitude, ^latitude, ^longitude), latitude: l.latitude, longitude: l.longitude, user: u}
        conn
          |> put_status(200)
          |> render("show_nearby.json", %{nearby: Repo.all(query)})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Spotlight.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{}) do
    user = Guardian.Plug.current_resource(conn)
    Repo.get_by(Location, [user_id: user.id]) |> Repo.delete
    conn
    |> put_status(:ok)
    |> render(Spotlight.AppView, "status.json", %{message: "Location Updated", status: "success"})
  end

  defp insert_or_update(user, %{"latitude"=> latitude, "longitude"=> longitude}) do
    user = user |> Repo.preload(:location)
    if(is_nil(user.location)) do
      changeset = user |> Ecto.build_assoc(:location) |> Location.changeset(%{"latitude"=> latitude, "longitude"=> longitude})
      Repo.insert(changeset)
    else
      changeset = user.location |> Location.changeset(%{"latitude"=> latitude, "longitude"=> longitude})
      Repo.update(changeset)
    end
  end
end
