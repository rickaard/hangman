defmodule HangmanWeb.GameLive do
  use HangmanWeb, :live_view

  alias Hangman.Helpers
  alias HangmanWeb.Presence

  alias Hangman.Room

  ## TODO:
  ## IN "presence_diff" - MAKE SURE TO UPDATE RECORD WHEN USER(s) LEAVE ROOM
  ## DELETE RECORD IF NO USER LEFT IN ROOM

  def get_room(room_id), do: "game:#{room_id}"

  def mount(%{"id" => room_id, "name" => name}, _session, socket) do
    channel_amount = Presence.list(get_room(room_id)) |> map_size

    if channel_amount >= 2 do
      socket = put_flash(socket, :error, "Sorry, this room is full 😢")
      {:ok, redirect(socket, to: "/game/")}
    else
      socket = add_user_to_room(room_id, name, socket)

      {:ok, socket}
    end
  end

  def mount(_params, _session, socket) do
    socket = put_flash(socket, :error, "No name provided...")
    {:ok, redirect(socket, to: "/game/")}
  end

  def add_user_to_room(room_code, name, socket) do
    HangmanWeb.Endpoint.subscribe(get_room(room_code))
    HangmanWeb.Presence.track(self(), get_room(room_code), socket.id, %{name: name, points: 0})

    case Room.get_room_by_code(room_code) do
      %{correct_word: correct_word} ->
        case Room.get_user_from_room(room_code, name) do
          nil ->
            new_user = %{name: name, points: 0, picked_word: false}
            Room.add_user_to_room(room_code, new_user)

            socket
            |> starting_state(room_code, correct_word)

          _user ->
            socket
            |> starting_state(room_code, correct_word)
        end

      nil ->
        correct_word = Helpers.random_word()
        new_user = %{name: name, points: 0, picked_word: true}

        Room.create_room(room_code, new_user, correct_word)

        socket
        |> starting_state(room_code, correct_word)
    end
  end

  def handle_event("add", _params, %{assigns: %{game_status: status}} = socket)
      when status == :over do
    {:noreply, socket}
  end

  def handle_event("add", %{"letter" => letter}, %{assigns: %{room_id: room_id}} = socket) do
    socket =
      socket
      |> add_to_correct_or_wrong_list(letter)
      |> check_if_win()
      |> check_if_dead()

    HangmanWeb.Endpoint.broadcast_from(self(), get_room(room_id), "add_event", socket.assigns)
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, %{assigns: %{room_id: room_id}} = socket) do
    users_in_room =
      Presence.list(get_room(room_id))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    if Enum.count(users_in_room) == 0 do
      Room.remove_room_by_code(room_id)
    end

    IO.inspect(users_in_room, label: "*****")
    {:noreply, assign(socket, users: users_in_room)}
  end

  def handle_info(%{event: "add_event", payload: state}, socket) do
    {:noreply,
     assign(
       socket,
       correctly_guessed_characters: state.correctly_guessed_characters,
       game_status: state.game_status,
       word: state.word,
       wrong_steps: state.wrong_steps,
       wrongly_guessed_characters: state.wrongly_guessed_characters
     )}
  end

  defp add_points_to_user(%{assigns: %{users: users}} = socket) do
    IO.inspect(users, label: "add_points_to_user")
    # {:noreply, socket}
    socket
  end

  defp check_if_win(
         %{assigns: %{correctly_guessed_characters: correct_list, word: word}} = socket
       ) do
    case Helpers.is_correct_word?(correct_list, word) do
      true ->
        socket
        |> put_flash(:info, "You won! ✔✔✔")
        |> assign(game_status: :over)
        |> add_points_to_user

      false ->
        socket
    end
  end

  defp check_if_dead(%{assigns: %{wrong_steps: wrong_steps}} = socket) do
    case wrong_steps do
      11 ->
        loosing_message = "You lost 💀💀💀 The word was \"#{String.upcase(socket.assigns.word)}\""

        socket
        |> put_flash(:error, loosing_message)
        |> assign(game_status: :over)

      _ ->
        socket
    end
  end

  defp add_to_correct_or_wrong_list(
         %{assigns: %{correctly_guessed_characters: correct_list}} = socket,
         letter
       ) do
    case String.contains?(socket.assigns.word, letter) do
      true ->
        socket
        |> assign(socket, correctly_guessed_characters: correct_list ++ [letter])

      false ->
        socket
        |> increase_wrong_steps
        |> assign(
          wrongly_guessed_characters: socket.assigns.wrongly_guessed_characters ++ [letter]
        )
    end
  end

  defp increase_wrong_steps(%{assigns: %{wrong_steps: wrong_steps}} = socket) do
    socket
    |> assign(socket, wrong_steps: wrong_steps + 1)
  end

  defp is_letter_taken?(wrong_letters, correct_letters, current_letter) do
    cond do
      Enum.member?(wrong_letters, current_letter) -> true
      Enum.member?(correct_letters, current_letter) -> true
      true -> false
    end
  end

  defp starting_state(socket, room_id, word) do
    socket
    |> assign(:room_id, room_id)
    |> assign(:game_status, :active)
    |> assign(:word, word)
    |> assign(:correctly_guessed_characters, [])
    |> assign(:wrongly_guessed_characters, [])
    |> assign(:wrong_steps, 1)
    |> assign(:alphabet, Helpers.get_alphabet())
    |> assign(:users, [])
  end

  defp path_components(step_number) do
    case step_number do
      1 ->
        raw(
          '<path class="show" d="M2.6344 282.906C2.6344 279.408 1.28915 271.226 3.1173 267.936C4.37491 265.672 4.1746 260.233 6.0147 258.761C10.9279 254.83 10.2844 244.721 15.6727 240.41C17.4703 238.972 19.0863 236.272 20.77 234.401C23.2772 231.615 26.1977 229.832 28.9257 227.104C31.5011 224.528 34.6215 222.481 37.1886 219.914C39.767 217.336 43.3396 216.406 45.8809 214.119C51.6169 208.957 60.8628 209.799 66.431 205.159C69.2631 202.798 75.5975 204.122 78.8791 202.208C82.3188 200.201 86.5191 200.354 90.0395 198.398C97.1886 194.426 106.312 194.675 113.916 192.335C118.42 190.949 124.412 191.154 129.154 191.154C133.283 191.154 137.369 190.189 141.71 190.189C159.85 190.189 178.603 188.863 196.224 192.067C201.672 193.057 207.599 193.27 212.965 194.803C215.409 195.502 219.565 195.923 222.086 195.983C225.419 196.063 228.163 197.794 231.315 197.915C241.466 198.306 249.879 204.007 257.821 209.505C272.391 219.592 278.488 235.477 286.58 249.639C287.791 251.757 291.286 257.626 291.409 259.726C291.59 262.801 294.939 264.789 295.272 267.453C295.641 270.401 297.68 273.353 298.921 276.145C300.274 279.19 300.497 282.731 302.033 285.803" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      2 ->
        raw(
          '<path class="show" d="M146.539 190.189C148.252 181.408 146.618 172.208 148.524 163.629C150.126 156.421 149.436 148.456 149.436 140.933C149.436 133.738 151.368 126.005 151.368 119.202C151.368 110.832 151.368 102.462 151.368 94.0914C151.368 78.3166 151.368 62.5418 151.368 46.7671C151.368 31.5917 154.265 17.7338 154.265 2.82309" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      3 ->
        raw(
          '<path class="show" d="M153.299 3.7889C165.547 1.39912 178.996 2.8231 191.449 2.8231C202.387 2.8231 213.216 3.7889 224.34 3.7889C234.75 3.7889 245.58 4.7547 255.675 4.7547C263.971 4.7547 278.409 2.11765 285.614 5.72051" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      4 ->
        raw(
          '<path class="show" d="M152.334 26.0023C159.808 24.5439 169.477 22.1989 174.547 15.8614C178.587 10.8119 188.744 11.1301 191.932 4.7547" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      5 ->
        raw(
          '<path class="show" d="M284.649 6.68631V27.934" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      6 ->
        raw(
          '<path class="show" d="M299.136 39.5236C296.672 35.3153 292.061 29.8655 286.58 29.8655C282.133 29.8655 275.221 28.2729 272.844 32.763C269.513 39.0565 267.043 55.5723 273.542 60.7712C277.504 63.941 281.607 65.6002 287.063 65.6002C290.998 65.6002 297.204 65.7326 297.204 60.2883C297.204 55.932 300.101 51.231 300.101 46.7671C300.101 41.6336 299.634 36.6262 293.341 36.6262" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      7 ->
        raw(
          '<path class="show" d="M284.649 67.5318C284.649 83.2759 283.683 99.4222 283.683 114.856" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      8 ->
        raw(
          '<path class="show" d="M284.649 114.856C282.104 120.993 278.443 121.648 274.991 125.963C273.482 127.848 271.054 131.311 269.196 132.241" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      9 ->
        raw(
          '<path class="show" d="M282.717 116.788C285.329 120.379 286.608 124.113 289.692 127.197C291.636 129.141 293.162 131.883 294.307 134.172" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      10 ->
        raw(
          '<path class="show" d="M283.683 67.5318C278.178 74.5779 270.955 77.9312 266.298 84.9163" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )

      11 ->
        raw(
          '<path class="show" d="M283.683 68.4976C285.836 71.4584 287.205 74.4875 289.692 76.9752C291.198 78.4808 293.032 79.3495 294.521 80.8384C296.365 82.6821 299.974 85.628 301.067 87.8137" stroke="black" stroke-width="3" stroke-linecap="round"/>'
        )
    end
  end
end
