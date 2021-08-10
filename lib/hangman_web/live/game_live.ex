defmodule HangmanWeb.GameLive do
  use HangmanWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, word: [])
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1 class="text-red-500 text-5xl font-bold text-center">Tailwind CSS</h1>
    """
  end

end
