defmodule HangmanWeb.GameLive do
  use HangmanWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, word: [])
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div>test</div>
    """
  end

end
