defmodule SnippetWeb.SnippetLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  def render(assigns) do
    ~L"""
    <h1>LiveView!</h1>
    <input name="value" value="<%= @value %>" phx-blur="field-blur" />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, value: nil)}
  end

  def handle_event("field-blur", %{"value" => value}, socket) do
    # This returns the value of the input after it has been unfocused (blur)
    IO.puts(value)
    {:noreply, socket}
  end
end
