defmodule HangmanWeb.ModalComponent do
  use HangmanWeb, :live_component
  use Phoenix.HTML

  @valid_letters "abcdefghijklmnopqrstuvwxyz"

  def render(assigns) do
    ~L"""
    <div class="backrop w-full h-full fixed z-10 left-0 top-0 bg-black bg-opacity-80 flex justify-center items-center">
      <div class="fixed z-50 bg-white w-9/12 max-w-2xl min-h-300">
        <div class="bg-white w-full h-full p-8">

        <p class="alert alert-info" role="alert"
          phx-click="lv:clear-flash"
          phx-value-key="info"><%= live_flash(@parent_flash, :info) %></p>

        <p class="alert alert-danger" role="alert"
          phx-click="lv:clear-flash"
          phx-value-key="error"><%= live_flash(@parent_flash, :error) %></p>

          <%= if @status == :waiting do %>
            <h2 class="font-bold text-3xl">Waiting</h2>
            <p>Waiting for 2nd player to join room: <span class="font-bold"><%= @room_code %></span></p>

          <% else %>


          <%= if @user.picked_word do %>
            <div class="w-full h-full">
            <h2 class="font-bold text-3xl">Pick a word</h2>
            <p>Come up with a word for your opponent to guess on </p>

            <%= form_for :word, "#", [phx_submit: :start_game, phx_change: :validate, phx_target: @myself, class: "mt-8 flex flex-col justify-between"], fn f -> %>
              <%= label f, :word %>
              <div class="relative input-wrapper">
                <div class="button-icon-wrapper absolute top-0 left-0 h-full border border-gray-400 border-solid hover:bg-gray-500">
                  <button type="button" phx-click="generate_word" phx-target="<%= @myself %>" class="border-0 w-14 text-center flex justify-center items-center hover:bg-gray-500">
                    <svg version="1.1" viewBox="0 0 50.344 50.344" class="svg-icon svg-fill c:txt:primary" style="width: 18px; height: 18px;"><path fill="currentColor" _stroke="none" pid="0" d="M19.6 21.844H3.4a3.404 3.404 0 0 0-3.4 3.4v16.199c0 1.875 1.525 3.4 3.4 3.4h16.2c1.875 0 3.4-1.525 3.4-3.4V25.245a3.404 3.404 0 0 0-3.4-3.401zm1.4 19.6c0 .772-.628 1.4-1.4 1.4H3.4c-.772 0-1.4-.628-1.4-1.4V25.245c0-.772.628-1.4 1.4-1.4h16.2c.772 0 1.4.628 1.4 1.4v16.199z"></path><circle fill="currentColor" _stroke="none" pid="1" cx="6" cy="27.844" r="2"></circle><circle fill="currentColor" _stroke="none" pid="2" cx="17" cy="27.844" r="2"></circle><circle fill="currentColor" _stroke="none" pid="3" cx="6" cy="38.844" r="2"></circle><circle fill="currentColor" _stroke="none" pid="4" cx="17" cy="38.844" r="2"></circle><path fill="currentColor" _stroke="none" pid="5" d="M50.155 23.081L44.828 7.782a3.404 3.404 0 0 0-4.329-2.093l-15.3 5.327a3.404 3.404 0 0 0-2.092 4.329l5.327 15.3a3.379 3.379 0 0 0 1.73 1.942 3.384 3.384 0 0 0 2.599.15l15.299-5.327a3.404 3.404 0 0 0 2.093-4.329zm-2.75 2.44l-15.3 5.327a1.379 1.379 0 0 1-1.069-.062 1.388 1.388 0 0 1-.713-.8l-5.327-15.3a1.401 1.401 0 0 1 .861-1.782l15.3-5.327a1.403 1.403 0 0 1 1.782.863l5.327 15.298a1.4 1.4 0 0 1-.861 1.783z"></path><circle fill="currentColor" _stroke="none" pid="6" cx="29.628" cy="15.828" r="2"></circle><circle fill="currentColor" _stroke="none" pid="7" cx="40.016" cy="12.211" r="2"></circle><circle fill="currentColor" _stroke="none" pid="8" cx="33.246" cy="26.216" r="2"></circle><circle fill="currentColor" _stroke="none" pid="9" cx="11.5" cy="33.678" r="2"></circle><circle fill="currentColor" _stroke="none" pid="10" cx="43.634" cy="22.599" r="2"></circle></svg>
                  </button>
                </div>
                <%= text_input f, :word, value: @word, autocomplete: "off", class: "pl-20" %>
              </div>

              <%= if not @word_validation.valid do %>
                <span class="invalid-feedback"><%= @word_validation.reason %></span>
              <% end %>

              <%= submit "Start game", class: "mt-2" %>
            <% end %>

            </div>

          <% else %>
            <div class="w-full h-full">
              <h2 class="font-bold text-3xl">Waiting</h2>
              <p>Waiting for 2nd player to pick a word</p>
              <div class="hourglass-wrapper">
                <svg class="hourglass" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 206" preserveAspectRatio="none">
                  <path class="middle" d="M120 0H0v206h120V0zM77.1 133.2C87.5 140.9 92 145 92 152.6V178H28v-25.4c0-7.6 4.5-11.7 14.9-19.4 6-4.5 13-9.6 17.1-17 4.1 7.4 11.1 12.6 17.1 17zM60 89.7c-4.1-7.3-11.1-12.5-17.1-17C32.5 65.1 28 61 28 53.4V28h64v25.4c0 7.6-4.5 11.7-14.9 19.4-6 4.4-13 9.6-17.1 16.9z"/>
                  <path class="outer" d="M93.7 95.3c10.5-7.7 26.3-19.4 26.3-41.9V0H0v53.4c0 22.5 15.8 34.2 26.3 41.9 3 2.2 7.9 5.8 9 7.7-1.1 1.9-6 5.5-9 7.7C15.8 118.4 0 130.1 0 152.6V206h120v-53.4c0-22.5-15.8-34.2-26.3-41.9-3-2.2-7.9-5.8-9-7.7 1.1-2 6-5.5 9-7.7zM70.6 103c0 18 35.4 21.8 35.4 49.6V192H14v-39.4c0-27.9 35.4-31.6 35.4-49.6S14 81.2 14 53.4V14h92v39.4C106 81.2 70.6 85 70.6 103z"/>
                </svg>
              </div>
            </div>
          <% end %>

          <% end %>

        </div>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    IO.inspect(socket, label: "socket")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:word, "")
     |> assign(:word_validation, %{valid: false, reason: ""})}
  end

  def handle_event("validate", _params, %{assigns: %{word_validation: %{valid: false}}} = socket) do
    {:noreply, assign(socket, :word_validation, %{valid: false, reason: ""})}
  end

  def handle_event("validate", _, socket), do: {:noreply, socket}

  def handle_event("generate_word", _params, socket) do
    {:noreply, assign(socket, :word, Hangman.Helpers.random_word())}
  end

  def handle_event("start_game", %{"word" => %{"word" => word}}, socket) do
    case validate_word(word) do
      {:invalid, reason} ->
        {:noreply,
         socket
         |> assign(:word_validation, %{valid: false, reason: reason})
         |> assign(:word, word)}

      word ->
        send_word_to_parent_liveview(word)
        {:noreply, socket}
    end
  end

  def send_word_to_parent_liveview(word) do
    send(self(), {:updated_word, %{word: String.downcase(word)}})
  end

  def validate_word(word) do
    word
    |> String.trim()
    |> validate_min_length(2)
    |> validate_max_length(12)
    |> is_one_word
    |> has_only_valid_letters(@valid_letters)
  end

  def is_one_word(word) when is_binary(word) do
    word_to_list_length = word |> String.trim() |> String.split() |> Enum.count()

    case word_to_list_length do
      1 -> word
      _ -> {:invalid, "Can only be one word"}
    end
  end

  def is_one_word({:invalid, _} = invalid_word), do: invalid_word

  def validate_min_length(word, min_length) when is_binary(word) do
    word_length = word |> String.trim() |> String.length()

    case word_length < min_length do
      false -> word
      true -> {:invalid, "Too short. A minimun of #{min_length} letters is required"}
    end
  end

  def validate_min_length({:invalid, _} = invalid_word, _length), do: invalid_word

  def validate_max_length(word, max_length) when is_binary(word) do
    word_length = word |> String.trim() |> String.length()

    case word_length > max_length do
      false -> word
      true -> {:invalid, "Too long. A maximum of #{max_length} letters is required"}
    end
  end

  def validate_max_length({:invalid, _} = invalid_word, _length), do: invalid_word

  def has_only_valid_letters(word, valid_letters) when is_binary(word) do
    valid_letters = valid_letters |> String.downcase() |> String.split("")

    amount_of_invalid_letters =
      word
      |> String.downcase()
      |> String.split("")
      |> Enum.filter(fn letter -> !Enum.member?(valid_letters, letter) end)
      |> Enum.count()

    case amount_of_invalid_letters do
      0 -> word
      _ -> {:invalid, "Contains invalid characters"}
    end
  end

  def has_only_valid_letters({:invalid, _} = invalid_word, _length), do: invalid_word
end
