defmodule HangmanWeb.ModalComponent do
  use HangmanWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="backrop w-full h-full fixed z-10 left-0 top-0 bg-black bg-opacity-80 flex justify-center items-center">
      <div class="fixed z-50 bg-white w-9/12 max-w-2xl min-h-300">
        <div class="bg-white w-full h-full p-8">

          <%= if @status == :waiting do %>
            <h2 class="font-bold text-3xl">Waiting</h2>
            <p>Waiting for 2nd player to join room: <span class="font-bold"><%= @room_code %></span></p>

          <% else %>

            <div class="w-full h-full">
              <h2 class="font-bold text-3xl">Pick a word</h2>
              <p>Come up with a word for your opponent to guess on </p>

              <%= form_for :word, "#", [phx_submit: :start_game, phx_target: @myself, class: "mt-8 flex flex-col justify-between"], fn f -> %>
                <%= label f, :word %>
                <%= text_input f, :word, value: "", autocomplete: "off" %>


                <%= submit "Start game", class: "mt-2" %>
              <% end %>
            </div>

          <% end %>

        </div>
      </div>
    </div>
    """
  end

  def handle_event("start_game", %{"word" => %{"word" => word}}, socket) do
    send_word_to_parent_liveview(word)
    {:noreply, socket}
  end

  def send_word_to_parent_liveview(word) do
    send(self(), {:updated_word, %{word: word}})
  end
end
