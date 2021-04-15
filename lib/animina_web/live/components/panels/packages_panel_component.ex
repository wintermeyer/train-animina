defmodule AniminaWeb.PackagesPanelComponent do
  use AniminaWeb, :live_component
  import Gettext, only: [with_locale: 2]

  def render(assigns) do
    ~L"""
    <%= if @current_user && length(@available_packages) > 0 && length(@current_user_future_slots) == 0 do %>
    <%= unless @active_slot && Enum.member?(@active_slot.team.users, @current_user) do %>
    <%= with_locale(@locale, fn -> %>
      <div class="bg-gray-900 rounded-lg">
        <div class="pt-12 px-4 sm:px-6 lg:px-8 lg:pt-20">
          <div class="text-center">
            <p class="mt-2 text-3xl font-extrabold text-white sm:text-4xl lg:text-5xl">
              <%= gettext("Control the Model Railway") %>
            </p>
            <p class="mt-3 max-w-4xl mx-auto text-xl text-gray-300 sm:mt-5 sm:text-2xl">
              <%= gettext("Invite your friends and receive 100 points for every new user who redeems the 100 points coupon code %{coupon}.", coupon: @current_user.coupon_code) %>
            </p>
          </div>
        </div>

        <div class="mt-8 pb-12 bg-gray-50 sm:mt-12 sm:pb-16 lg:mt-16 lg:pb-24">
          <div class="relative">
            <div class="absolute inset-0 h-3/4 bg-gray-900"></div>
            <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
              <div class="max-w-md mx-auto space-y-4 lg:max-w-5xl lg:grid lg:grid-cols-2 lg:gap-5 lg:space-y-0">
                <%= for package <- @available_packages do %>
                  <div class="flex flex-col rounded-lg shadow-lg overflow-hidden">
                    <div class="px-6 py-8 bg-white sm:p-10 sm:pb-6">
                      <div>
                        <h3 class="inline-flex px-4 py-1 rounded-full text-sm font-semibold tracking-wide uppercase bg-indigo-100 text-indigo-600" id="tier-standard">
                          <%= package.name %>
                        </h3>
                      </div>
                      <div class="mt-4 flex items-baseline text-6xl font-extrabold">
                        <%= package.points %>
                        <span class="ml-1 text-2xl font-medium text-gray-500">
                          <%= gettext("points") %>
                        </span>
                      </div>
                      <%= if package.description do %>
                      <p class="mt-5 text-lg text-gray-500">
                        <%= package.description %>
                      </p>
                      <% end %>
                    </div>
                    <div class="flex-1 flex flex-col justify-between px-6 pt-6 pb-8 bg-gray-50 space-y-6 sm:p-10 sm:pt-6">
                      <ul class="space-y-4">
                        <li class="flex items-start">
                          <div class="flex-shrink-0">
                            <!-- Heroicon name: outline/check -->
                            <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                          <p class="ml-3 text-base text-gray-700">
                            <%= gettext("%{count} locomotives to control", count: package.locos) %> 🚆
                          </p>
                        </li>

                        <li class="flex items-start">
                          <div class="flex-shrink-0">
                            <!-- Heroicon name: outline/check -->
                            <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                          <p class="ml-3 text-base text-gray-700">
                            <%= gettext("%{count} stations to use", count: package.stations) %> 🚉
                          </p>
                        </li>

                        <li class="flex items-start">
                          <div class="flex-shrink-0">
                            <!-- Heroicon name: outline/check -->
                            <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                          <p class="ml-3 text-base text-gray-700">
                            <%= gettext("%{seconds} seconds of playtime", seconds: package.seconds) %>
                          </p>
                        </li>

                        <%= if package.includes_appointment do %>
                          <li class="flex items-start">
                            <div class="flex-shrink-0">
                              <!-- Heroicon name: outline/check -->
                              <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                              </svg>
                            </div>
                            <p class="ml-3 text-base text-gray-700">
                              <%= gettext("Set up a fixed time to play") %> 📆
                            </p>
                          </li>
                        <% else %>
                          <li class="flex items-start">
                            <div class="flex-shrink-0">
                              <!-- Heroicon name: outline/check -->
                              <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                              </svg>
                            </div>
                            <p class="ml-3 text-base text-gray-700">
                              <%= gettext("Waiting list position for the next available slot") %>
                            </p>
                          </li>
                        <% end %>

                        <%= if package.players > 1 do %>
                          <li class="flex items-start">
                            <div class="flex-shrink-0">
                              <!-- Heroicon name: outline/check -->
                              <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                              </svg>
                            </div>
                            <p class="ml-3 text-base text-gray-700">
                              <%= gettext("Play together with up to %{players} of your friends.", players: package.players) %> 🎉
                            </p>
                          </li>
                        <% end %>
                      </ul>
                      <%= if @current_user.points >= package.points do %>
                        <button phx-click="create_slot" phx-value-package_id="<%= package.id %>" class="rounded-md shadow flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-gray-800 hover:bg-gray-900">
                          <%= gettext("All aboard!") %>
                        </button>
                      <% end %>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
          <div class="mt-4 relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 lg:mt-5">
            <div class="max-w-md mx-auto lg:max-w-5xl">
              <div class="rounded-lg bg-gray-100 px-6 py-8 sm:p-10 lg:flex lg:items-center">
                <div class="flex-1">
                  <div class="mt-4 text-lg text-gray-600">
                    <%= gettext("Invite your friends and receive 100 points for every new user who redeems the 100 points coupon code %{coupon}.", coupon: @current_user.coupon_code) %>
                  </div>
                </div>
                <div class="mt-6 rounded-md shadow lg:mt-0 lg:ml-10 lg:flex-shrink-0">
                  <a href="#" class="flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-gray-900 bg-white hover:bg-gray-50">
                    <%= @current_user.coupon_code %>
                  </a>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    <% end) %>
    <% end %>
    <% end %>
    """
  end
end
