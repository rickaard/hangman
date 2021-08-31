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

            <div class="w-full h-full">
              <h2 class="font-bold text-3xl">Pick a word</h2>
              <p>Come up with a word for your opponent to guess on </p>

              <%= form_for :word, "#", [phx_submit: :start_game, phx_change: :validate, phx_target: @myself, class: "mt-8 flex flex-col justify-between"], fn f -> %>
                <%= label f, :word %>
                <%= text_input f, :word, value: @word, autocomplete: "off" %>

                <%= if not @word_validation.valid do %>
                  <span class="invalid-feedback"><%= @word_validation.reason %></span>
                <% end %>

                <%= submit "Start game", class: "mt-2" %>
              <% end %>

            </div>

          <% end %>

        </div>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    IO.inspect socket, label: "socket"
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
    send(self(), {:updated_word, %{word: word}})
  end

  def validate_word(word) do
    word
    |> String.trim()
    |> validate_min_length(2)
    |> validate_max_length(8)
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
      true -> {:invalid, "Too short. A minimun of #{min_length} letter is required"}
    end
  end

  def validate_min_length({:invalid, _} = invalid_word, _length), do: invalid_word

  def validate_max_length(word, max_length) when is_binary(word) do
    word_length = word |> String.trim() |> String.length()

    case word_length > max_length do
      false -> word
      true -> {:invalid, "Too long. A maximum of #{max_length} letter is required"}
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
