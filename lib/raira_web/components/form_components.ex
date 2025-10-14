defmodule RairaWeb.FormComponents do
  use Phoenix.Component

  import RairaWeb.CoreComponents

  alias Phoenix.LiveView.JS

  @doc """
  Renders a text input with label and error messages.
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :errors, :list, default: []
  attr :field, Phoenix.HTML.FormField, doc: "a form field struct retrieved from the form"
  attr :help, :string, default: nil
  attr :type, :string, default: "text"
  attr :class, :string, default: nil
  attr :outer_prefix, :string, default: nil

  attr :rest, :global, include: ~w(autocomplete readonly disabled step min max)

  def text_field(assigns) do
    assigns = assigns_from_field(assigns)

    ~H"""
    <.field_wrapper id={@id} name={@name} label={@label} errors={@errors} help={@help}>
      <%= if @outer_prefix do %>
        <div class={outer_prefixed_input_wrapper_classes(@errors)}>
          <span class="inline-flex items-center rounded-l-lg bg-gray-100 px-3 text-sm text-gray-400 opacity-70 border-r border-gray-200">
            {@outer_prefix}
          </span>

          <input
            type={@type}
            name={@name}
            id={@id || @name}
            value={Phoenix.HTML.Form.normalize_value("text", @value)}
            class={[
              outer_prefixed_input_classes(@errors),
              @class
            ]}
            {@rest}
          />
        </div>
      <% else %>
        <input
          type={@type}
          name={@name}
          id={@id || @name}
          value={Phoenix.HTML.Form.normalize_value("text", @value)}
          class={[input_classes(@errors), @class]}
          {@rest}
        />
      <% end %>
    </.field_wrapper>
    """
  end

  @doc """
  Renders a hex color input with label and error messages.
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :errors, :list, default: []
  attr :field, Phoenix.HTML.FormField, doc: "a form field struct retrieved from the form"
  attr :help, :string, default: nil

  attr :randomize, JS, default: %JS{}
  attr :rest, :global

  def hex_color_field(assigns) do
    assigns = assigns_from_field(assigns)

    ~H"""
    <.field_wrapper id={@id} name={@name} label={@label} errors={@errors} help={@help}>
      <div class="flex space-x-4 items-center">
        <div
          class="border-[3px] rounded-lg p-1 flex justify-center items-center"
          style={"border-color: #{@value}"}
        >
          <div class="rounded h-5 w-5" style={"background-color: #{@value}"}></div>
        </div>
        <div class="relative grow">
          <input
            type="text"
            name={@name}
            id={@id || @name}
            value={@value}
            class={input_classes(@errors)}
            spellcheck="false"
            maxlength="7"
            {@rest}
          />
          <div class="absolute right-2 top-1">
            <.icon_button type="button" phx-click={@randomize}>
              <.icon name="ri-arrow-path" />
            </.icon_button>
          </div>
        </div>
      </div>
    </.field_wrapper>
    """
  end

  defp outer_prefixed_input_wrapper_classes(errors) do
    [
      "relative flex items-stretch rounded-lg border focus-within:border-blue-600",
      if errors == [] do
        "border-gray-200"
      else
        "border-red-600"
      end
    ]
  end

  defp input_classes(errors) do
    [
      base_input_classes(),
      "border rounded-lg focus:border-blue-600",
      error_color_classes(errors),
      if(errors != [], do: "border-red-600"),
      "invalid:bg-red-50 invalid:border-red-600 invalid:text-red-600"
    ]
  end

  defp outer_prefixed_input_classes(errors) do
    [
      base_input_classes(),
      "border-0 rounded-none rounded-r-lg focus:ring-0 focus:outline-none",
      error_color_classes(errors),
      "invalid:text-red-600"
    ]
  end

  defp base_input_classes do
    "w-full px-3 py-2 text-sm font-normal placeholder-gray-400 disabled:opacity-70 disabled:cursor-not-allowed focus-visible:outline-none"
  end

  defp error_color_classes(errors) do
    if errors == [] do
      "bg-gray-50 text-gray-600"
    else
      "bg-red-50 text-red-600"
    end
  end

  defp assigns_from_field(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
  end

  defp assigns_from_field(assigns), do: assigns

  attr :id, :any, required: true
  attr :name, :any, required: true
  attr :label, :string, required: true
  attr :errors, :list, required: true
  attr :help, :string, required: true
  slot :inner_block, required: true

  defp field_wrapper(assigns) do
    ~H"""
    <div>
      <.label :if={@label} for={@id} help={@help}>{@label}</.label>
      {render_slot(@inner_block)}
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :help, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="mb-1 flex items-center gap-1 text-sm text-gray-800 font-medium">
      {render_slot(@inner_block)}
      <.help :if={@help} text={@help} />
    </label>
    """
  end

  def error(assigns) do
    ~H"""
    <p class="mt-0.5 text-red-600 text-sm">
      {render_slot(@inner_block)}
    </p>
    """
  end

  defp help(assigns) do
    ~H"""
    <span class="cursor-pointer tooltip right" data-tooltip={@text}>
      <!--
      <.remix_icon icon="question-line" class="text-sm leading-none" />
      -->
      <.icon name="ri-home" class="text-sm leading-none" />
    </span>
    """
  end
end
