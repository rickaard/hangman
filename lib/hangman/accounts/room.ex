defmodule Hangman.Room do
  require Amnesia
  require Amnesia.Helper
  require Exquisite
  require Database.Room

  alias Database.Room

  def create_room(room_code, users, word) do
    # dont allow to create record with same room_code at the same time
    case get_room_by_code(room_code) do
      %{} ->
        IO.puts "** ROOM EXISTS ** "
        {:error, "Room already exists"}

      _ ->
        room = Amnesia.transaction do
          %Room{room_code: room_code, current_user: users, correct_word: word}
          |> Room.write()
        end
        IO.inspect(room, label: "** ROOM CREATED: **")
        {:ok, room}
    end
  end

  def get_all_rooms() do
    Amnesia.transaction do
      Room.last()
    end
  end

  def get_all_rooms_by_code(code) do
    Amnesia.transaction do
      Room.where room_code == code
    end
  end

  # just for debugging..
  def get_amount_of_records_in_table do
    Amnesia.transaction do
      Room.count
    end
  end


  def get_room_id_by_code(code) do
    Amnesia.transaction do
      Room.where(room_code == code, select: id) |> Amnesia.Selection.values |> List.first
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
    |> remove_room_by_id
  end
end
