defmodule HangmanWeb.Enter_GameLive do
  use HangmanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
