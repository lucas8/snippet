defmodule SnippetWeb.LiveComponent.PublishLive do
  use Phoenix.LiveComponent

  @defaults %{
    secondary_button: "Cancel",
    secondary_button_action: nil,
    primary_button: "Submit",
    primary_button_action: nil,
  }

  def module(socket) do
    {:ok, socket}
  end

  def update(%{id: _id} = assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def handle_event("primary-button-click", _params, %{assigns: %{ primary_button_action: primary_button_action}} = socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: primary_button_action}})
    {:noreply, socket}
  end

  def handle_event("secondary-button-click", _params,%{assigns: %{secondary_button_action: secondary_button_action}} = socket) do
    send(self(),{__MODULE__, :button_clicked, %{action: secondary_button_action}})
    {:noreply, socket}
  end
end
