defmodule HangmanWeb.Enter_GameLive do
  use HangmanWeb, :live_view
  alias Hangman.Accounts.User


  def mount(_params, _session, socket) do
    changeset = User.changeset(%User{}, %{})
    {:ok, assign(socket, name: "", room_id: "", changeset: changeset)}
  end

  def handle_event("enter_room", %{"user" => %{"name" => name, "room_id" => room_id}} = _params, socket) do
    # IO.inspect params, label: "** params | enter-room **"
    # IO.inspect socket, label: "** params | enter-room **"
    socket = assign(socket, name: name, room_id: room_id)
    {:noreply, redirect(socket, to: "/game/#{room_id}?name=#{name}")}
    # {:noreply, socket}
  end

  def handle_event("validate", %{"user" => user_params} = _user_params, socket) do
    # IO.inspect user_params, label: "validate params"
    changeset = %User{}
    |> User.changeset(user_params)
    |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
