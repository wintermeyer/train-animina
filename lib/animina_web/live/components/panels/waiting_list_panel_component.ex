defmodule AniminaWeb.WaitingListPanelComponent do
  use AniminaWeb, :live_component
  import Gettext, only: [with_locale: 2]

  def render(assigns) do
    ~L"""
    <%= if @current_user && length(@waiting_list_slots) > 0 do %>
    <%= with_locale(@locale, fn -> %>
      <div class="bg-white shadow overflow-hidden sm:rounded-md">
        <div class="p-6">
          <h2 class="text-2xl font-medium text-gray-900"><%= gettext("Waiting list") %></h2>
          <%= if length(@waiting_list_slots) > length(@waiting_list_slots) do %><p class="mt-1 text-sm text-gray-600 line-clamp-2"><%= length(@waiting_list_slots) %>/<%= @waiting_list_slots_count %></p><% end %>
          <ul class="divide-y divide-gray-200">
          <%= for slot <- @waiting_list_slots do %>
            <li>
              <div class="py-4 flex items-center">
                <div class="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
                  <div class="truncate">
                    <div class="flex text-sm">
                    <p class="font-medium text-indigo-600 truncate">
                      <%= slot.package.name %>
                      </p>
                      <p class="ml-1 flex-shrink-0 font-normal text-gray-500">
                        -> <%= gettext("%{seconds} seconds", seconds: slot.package.seconds) %>
                      </p>
                    </div>
                    <div class="mt-2 flex">
                      <div class="flex items-top text-sm text-gray-500">
                        <!-- Heroicon name: solid/calendar -->
                        <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                        </svg>
                        <p>
                          <%= gettext("Estimated start time") %>: <%= UserHelper.hh_mm_dd_mm_yy(Animina.WaitingList.slot_start_eta(slot), @current_user) %><br/>
                          <%= if slot.team.owner == @current_user do %>=> <% end %><a href="/u/<%= slot.team.owner.username %>">@<%= slot.team.owner.username %></a> <%= if slot.team.owner == @current_user do %> 🎉<% end %>
                        </p>
                      </div>
                    </div>
                  </div>
                  <div class="mt-4 flex-shrink-0 sm:mt-0 sm:ml-5">
                    <div class="flex overflow-hidden -space-x-1">
                    <%= for user <- slot.team.users do %>
                      <a href="/u/<%= user.username %>"><img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="<%= UserHelper.avatar_src(user) %>" alt="Avatar"></a>
                    <% end %>
                    </div>
                  </div>
                </div>
              </div>
            </li>
          <% end %>
          </ul>
          </div>
        </div>
      </div>
    <% end) %>
    <% end %>
    """
  end
end
