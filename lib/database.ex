use Amnesia

defdatabase Database do
  deftable(
    Room,
    [{:id, autoincrement}, :room_code, :current_user, :correct_word],
    index: [:room_code]
  )
end
