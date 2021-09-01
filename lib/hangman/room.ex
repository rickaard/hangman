defmodule Hangman.Room do
  require Amnesia
  require Amnesia.Helper
  require Exquisite
  require Database.Room

  alias Database.Room

  def create_room(room_code, user, word) do
    # dont allow to create record with same room_code at the same time
    case get_room_by_code(room_code) do
      %{} ->
        IO.puts("** ROOM EXISTS ** ")
        {:error, "Room already exists"}

      _ ->
        room =
          Amnesia.transaction do
            %Room{room_code: room_code, current_users: [user], correct_word: word}
            |> Room.write()
          end

        IO.inspect(room, label: "** ROOM CREATED: **")
        {:ok, room}
    end
  end

  def create_empty_room(room_code) do
    case get_room_by_code(room_code) do
      %{} ->
        {:error, "Room already exists"}

      _ ->
        room =
          Amnesia.transaction do
            %Room{room_code: room_code, current_users: [], correct_word: ""}
            |> Room.write()
          end

        {:ok, room}
    end
  end

  def add_user_to_room(code, user) do
    room_id = get_room_id_by_code(code)

    Amnesia.transaction do
      room = Room.read(room_id)

      # Don't add the user to the DB if the room allready has the name
      # inside the record. This will prevent the room.current_users map to grow as hell
      # if the user refreshes the page etc
      case Enum.member?(room.current_users, user) do
        true ->
          {:ok, room}

        false ->
          new_users_list = room.current_users ++ [user]

          updated_room =
            %{room | current_users: new_users_list}
            |> Room.write()

          {:ok, updated_room}
      end
    end
  end

  def get_last_room() do
    Amnesia.transaction do
      Room.last()
    end
  end

  def get_user_from_room(code, user) do
    Amnesia.transaction do
      Room.where(room_code == code, select: current_users)
      |> Amnesia.Selection.values()
      |> List.first()
      |> Enum.find(nil, fn %{name: name} = _user -> String.trim(name) == String.trim(user) end)
    end
  end

  def get_all_users_from_room(code) do
    Amnesia.transaction do
      Room.where(room_code == code, select: current_users)
      |> Amnesia.Selection.values()
      |> List.first()
    end
  end

  def update_word(room_code, word) do
    room_id = get_room_id_by_code(room_code)

    Amnesia.transaction do
      room = Room.read(room_id)

      %{room | correct_word: word}
      |> Room.write()
    end
  end

  def get_all_rooms_by_code(code) do
    Amnesia.transaction do
      Room.where(room_code == code)
    end
  end

  # just for debugging..
  def get_amount_of_records_in_table do
    Amnesia.transaction do
      Room.count()
    end
  end

  def get_room_id_by_code(code) do
    Amnesia.transaction do
      Room.where(room_code == code, select: id) |> Amnesia.Selection.values() |> List.first()
    end
  end

  def get_room_by_code(code) do
    code
    |> get_room_id_by_code
    |> get_room_by_id
  end

  def get_room_by_id(id) do
    Amnesia.transaction do
      Room.read(id)
    end
  end

  def remove_room_by_id(id) do
    Amnesia.transaction do
      Room.read(id) |> Room.delete()
    end
  end

  def remove_room_by_code(code) do
    code
    |> get_room_id_by_code

    case get_room_id_by_code(code) do
      nil ->
        {:error, "no room with that code"}

      id ->
        remove_room_by_id(id)
    end
  end
end
