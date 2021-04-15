defmodule AniminaWeb.ActiveSlotPanelComponent do
  use AniminaWeb, :live_component
  import Gettext, only: [with_locale: 2]

  def minutes(seconds) do
    trunc(Float.floor(seconds / 60, 0))
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  def seconds(seconds) do
    remainder = seconds - trunc(Float.floor(seconds / 60, 0)) * 60

    remainder
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  def available_routes(loco, track_routes) do
    Enum.filter(track_routes, fn x -> x.start_track == loco.track end)
  end

  def available_locos(slot, locos) do
    package = Animina.Offers.get_package!(slot.package_id)

    case package.locos do
      1 -> Enum.filter(locos, fn x -> Enum.member?(["BR 216 059-6"], x.name) end)
      2 -> Enum.filter(locos, fn x -> Enum.member?(["BR 216 059-6", "212 097-0 DBG"], x.name) end)
      _ -> locos
    end
  end

  def loco_active?(loco) do
    case loco.speed do
      0 -> false
      _ -> true
    end
  end

  def render(assigns) do
    ~L"""
    <%= with_locale(@locale, fn -> %>
      <%= if @active_slot && @active_slot.team && Enum.member?(@active_slot.team.users, @current_user) do %>
        <div class="bg-indigo-700 rounded-lg">
          <div class="max-w-2xl mx-auto py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
            <div class="bg-white shadow overflow-hidden sm:rounded-md">
              <ul class="divide-y divide-gray-200">
                <%= for loco <- available_locos(@active_slot, @locos) do %>
                <li>
                  <div class="flex items-center px-4 py-4 sm:px-6">
                    <div class="min-w-0 flex-1 flex items-top">
                      <div class="flex-shrink-0">
                      <img src="<%= Routes.static_path(@socket, "/images/locos/#{String.replace(loco.name, " ", "_")}.jpg") %>" class="h-20 w-20 rounded-full" alt="<%= loco.name %>">
                      </div>
                      <div class="min-w-0 flex-1 px-4 md:grid md:grid-cols-2 md:gap-4">
                        <div>
                          <p class="text-sm font-medium text-indigo-600 truncate"><%= loco.name %></p>
                          <p class="mt-2 flex items-center text-sm text-gray-500">
                            <span class="truncate"></span>
                          </p>
                        </div>
                        <%= if loco_active?(loco) do %>
                          <div class=" md:block">
                            <div>
                              <p class="text-sm text-gray-900">
                                <%= gettext("This train is moving or about to move. Please check the video stream.") %>
                              </p>
                            </div>
                          </div>
                        <% else %>
                          <%= if available_routes(loco, @track_routes) == [] do %>
                            <div class=" md:block">
                              <div>
                                <p class="text-sm text-gray-900">
                                  <%= gettext("No route available.") %>
                                </p>
                              </div>
                            </div>
                          <% else %>
                            <div class=" md:block">
                              <div>
                                <p class="text-sm text-gray-900">
                                  <%= gettext("Next available destinations") %>:
                                </p>
                                <div class="pt-4 space-y-2">
                                  <%= for route <- available_routes(loco, @track_routes) do %>
                                    <button phx-click="add_route_to_schedule" phx-value-track_route_id="<%= route.id %>" phx-value-loco_id="<%= loco.id %>" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do>
                                      <%= String.split(route.name, " -> ") |> Enum.reverse |> hd()  %>
                                    </button>
                                  <% end %>
                                </div>
                              </div>
                            </div>
                          <% end %>
                        <% end %>
                      </div>
                    </div>
                  </div>
                </li>
                <% end %>
              </ul>
            </div>

            <%= unless minutes(@remaining_lifetime) == "00" && seconds(@remaining_lifetime) == "00" do %>
              <div class="min-w-screen  flex items-center justify-center px-5 py-5">
                <div class="text-yellow-100">
                  <div class="text-4xl text-center flex w-full items-center justify-center">
                      <div class="w-24 mx-1 p-2 bg-white text-blue-500 rounded-lg">
                          <div class="font-mono leading-none"><%= minutes(@remaining_lifetime) %></div>
                          <div class="font-mono uppercase text-sm leading-none"><%= gettext("Minutes") %></div>
                      </div>
                      <div class="w-24 mx-1 p-2 bg-white text-blue-500 rounded-lg">
                          <div class="font-mono leading-none"><%= seconds(@remaining_lifetime) %></div>
                          <div class="font-mono uppercase text-sm leading-none"><%= gettext("Seconds") %></div>
                      </div>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    <% end) %>
    """
  end
end
