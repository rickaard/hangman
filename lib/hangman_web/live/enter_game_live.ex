defmodule HangmanWeb.Enter_GameLive do
  use HangmanWeb, :live_view
  alias Hangman.Accounts.User

  alias Hangman.Helpers

  def mount(_params, _session, socket) do
    changeset = User.changeset(%User{}, %{})
    {:ok, assign(socket, name: "", room_id: "", is_creating: false, changeset: changeset)}
  end

  def handle_event(
        "enter_room",
        %{"user" => %{"name" => name, "room_id" => room_id}} = _params,
        socket
      ) do
    socket = assign(socket, name: name, room_id: room_id)
    {:noreply, redirect(socket, to: "/game/#{room_id}?name=#{name}")}
  end

  def handle_event("validate", %{"user" => user_params} = _user_params, socket) do
    IO.inspect user_params
    changeset =
      %User{}
      |> User.changeset(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end


  ###
  # MAKE SURE TO PERSIST NAME WHEN SWITCHING TAB
  ###
  def handle_event("change-tab", %{"type" => "joining"}, socket) do
    changeset =
      %User{}
      |> User.changeset(%{room_id: ""})
      # |> Map.put(:action, :update)
    {:noreply, assign(socket, is_creating: false, changeset: changeset)}
  end

  def handle_event("change-tab", %{"type" => "creating"}, socket) do
    changeset =
      %User{}
      |> User.changeset(%{room_id: Helpers.generate_random_code(4)})
      # |> Map.put(:action, :insert)

    {:noreply, assign(socket, is_creating: true, changeset: changeset)}
  end
end
