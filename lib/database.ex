use Amnesia

defdatabase Database do
  deftable(
    Room,
    [{:id, autoincrement}, :room_code, :current_users, :correct_word],
    index: [:room_code]
  )
end
