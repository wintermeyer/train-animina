defmodule AniminaWeb.HeaderComponent do
  use AniminaWeb, :live_component
  import Gettext, only: [with_locale: 2]

  alias AniminaWeb.BellComponent

  def render(assigns) do
    ~L"""
      <header class="pb-24 bg-gradient-to-r from-light-blue-800 to-cyan-600" x-data="{mobileMenuShow: false}">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:max-w-7xl lg:px-8">
          <div class="relative flex flex-wrap items-center justify-center lg:justify-between">
            <!-- Logo -->
            <div class="absolute left-0 py-5 flex-shrink-0 lg:static">
              <a href="/" class="text-white text-sm font-medium rounded-md bg-white bg-opacity-0 px-3 py-2">
              animina (v<%= ViewHelpers.version() %><%= if ViewHelpers.version() |> String.split(".") |> hd == "0", do: " beta! 😱" %>)</a>
            </div>

            <!-- Right section on desktop -->
            <div class="hidden lg:ml-4 lg:flex lg:items-center lg:py-5 lg:pr-0.5">

              <%= if @current_user do %>
                <%= live_component @socket, BellComponent, current_user: @current_user, id: 1 %>

                <%= with_locale(@locale, fn -> %>
                  <!-- Profile dropdown -->
                  <div class="ml-4 relative flex-shrink-0" @click.away="open = false" x-data="{ open: false }">
                    <div>
                      <button type="button" class="max-w-xs rounded-full px-3.5 py-2 flex items-center text-sm hover:bg-gray-200 hover:bg-opacity-10 focus:outline-none focus:ring-2 focus:ring-white lg:p-2 lg:rounded-md" id="user-menu" aria-expanded="false" aria-haspopup="true" @click="open = !open" id="user-menu" aria-haspopup="true" x-bind:aria-expanded="open">
                          <div class="flex items-center">
                            <div>
                              <img class="inline-block h-9 w-9 rounded-full" src="<%= UserHelper.avatar_src(@current_user) %>" alt="Avatar">
                            </div>
                            <div class="ml-3">
                              <p class="text-sm font-medium text-white group-hover:text-black">
                                @<%= @current_user.username %>
                              </p>
                              <p class="text-xs font-medium text-gray-300 group-hover:text-black">
                                <%= gettext("Points") %>: <%= Formater.humanize_number(@current_user.points) %>
                              </p>
                            </div>
                          </div>

                        <!-- Heroicon name: solid/selector -->
                          <svg class="hidden flex-shrink-0 ml-1 h-5 w-5 text-white lg:block" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd" d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                      </button>
                    </div>

                    <!--
                      Dropdown menu, show/hide based on menu state.

                      Entering: ""
                        From: ""
                        To: ""
                      Leaving: "transition ease-in duration-75"
                        From: "transform opacity-100 scale-100"
                        To: "transform opacity-0 scale-95"
                    -->
                    <div x-show="open" x-description="Profile dropdown panel, show/hide based on dropdown state." x-transition:leave="transition ease-in duration-75" x-transition:leave-start="transform opacity-100 scale-100" x-transition:leave-end="transform opacity-0 scale-95" class="origin-top-right z-40 absolute -right-2 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5" role="menu" aria-orientation="vertical" aria-labelledby="user-menu" style="display: none;">
                      <!-- LiveDashboard -->
                      <%= if function_exported?(Routes, :live_dashboard_path, 2) && @current_user && @current_user.username == "wintermeyer" do %>
                        <%= link "LiveDashboard", to: Routes.live_dashboard_path(@socket, :home), class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" %>
                      <% end %>
                      <%= link gettext("Settings"), to: Routes.user_settings_path(@socket, :edit), class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100", role: "menuitem" %>
                      <%= link gettext("Log out"), to: Routes.user_session_path(@socket, :delete), method: :delete, class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100", role: "menuitem" %>
                    </div>
                  </div>
                <% end) %>
              <% else %>
                <%= with_locale(@locale, fn -> %>
                  <%= link gettext("Register"), to: Routes.user_registration_path(@socket, :new), class: "text-white text-sm font-medium rounded-md bg-white bg-opacity-0 px-3 py-2 hover:bg-opacity-10" %>
                  <%= link gettext("Log in"), to: Routes.user_session_path(@socket, :new), class: "text-white text-sm font-medium rounded-md bg-white bg-opacity-0 px-3 py-2 hover:bg-opacity-10" %>
                <% end) %>
              <% end %>
            </div>

            <%= with_locale(@locale, fn -> %>
              <div class="w-full py-5 lg:border-t lg:border-white lg:border-opacity-20">
                <div class="lg:grid lg:grid-cols-3 lg:gap-8 lg:items-center">
                </div>
              </div>

              <!-- Menu button -->
              <div class="absolute right-0 flex-shrink-0 lg:hidden">
                <!-- Mobile menu button -->
                <button type="button" class="bg-transparent p-2 rounded-md inline-flex items-center justify-center text-cyan-200 hover:text-white hover:bg-white hover:bg-opacity-10 focus:outline-none focus:ring-2 focus:ring-white" aria-expanded="false" x-on:click="mobileMenuShow = true">
                  <span class="sr-only">Open main menu</span>
                  <!--
                    Heroicon name: outline/menu

                    Menu open: "hidden", Menu closed: "block"
                  -->
                  <svg class="block h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                  <!--
                    Heroicon name: outline/x

                    Menu open: "block", Menu closed: "hidden"
                  -->
                  <svg class="hidden h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            <% end) %>
          </div>
        </div>

        <!-- Mobile menu, show/hide based on mobile menu state. -->
        <div class="lg:hidden" x-show="mobileMenuShow">
          <!--
            Mobile menu overlay, show/hide based on mobile menu state.

            Entering: "duration-150 ease-out"
              From: "opacity-0"
              To: "opacity-100"
            Leaving: "duration-150 ease-in"
              From: "opacity-100"
              To: "opacity-0"
          -->
          <div class="z-20 fixed inset-0 bg-black bg-opacity-25" aria-hidden="true"></div>

          <!--
            Mobile menu, show/hide based on mobile menu state.

            Entering: "duration-150 ease-out"
              From: "opacity-0 scale-95"
              To: "opacity-100 scale-100"
            Leaving: "duration-150 ease-in"
              From: "opacity-100 scale-100"
              To: "opacity-0 scale-95"
          -->
          <div class="z-30 absolute top-0 inset-x-0 max-w-3xl mx-auto w-full p-2 transition transform origin-top" x-on:click.away="mobileMenuShow = false">
            <div class="rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 bg-white divide-y divide-gray-200">
              <div class="pt-3 pb-2">
                <div class="flex items-center justify-between px-4">
                  <div>
                    <a href="/" class="text-gray-900 text-sm font-medium rounded-md bg-white bg-opacity-0 px-3 py-2">
                  animina (v<%= ViewHelpers.version() %><%= if ViewHelpers.version() |> String.split(".") |> hd == "0", do: " beta! 😱" %>)</a>
                  </div>
                  <div class="-mr-2">
                    <button type="button" class="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-cyan-500" x-on:click="mobileMenuShow = false">
                      <span class="sr-only">Close menu</span>
                      <!-- Heroicon name: outline/x -->
                      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
              <div class="pt-4 pb-2">
                <div class="flex items-center px-5">
                  <div class="flex-shrink-0">
                    <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1550525811-e5869dd03032?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=facearea&amp;facepad=2&amp;w=256&amp;h=256&amp;q=80" alt="">
                  </div>
                  <div class="ml-3 min-w-0 flex-1">
                    <div class="text-base font-medium text-gray-800 truncate">Rebecca Nicholas</div>
                    <div class="text-sm font-medium text-gray-500 truncate">rebecca.nicholas@example.com</div>
                  </div>
                  <button class="ml-auto flex-shrink-0 bg-white p-1 text-gray-400 rounded-full hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-cyan-500">
                    <span class="sr-only">View notifications</span>
                    <!-- Heroicon name: outline/bell -->
                    <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                  </button>
                </div>
                <div class="mt-3 px-2 space-y-1">
                  <a href="#" class="block rounded-md px-3 py-2 text-base text-gray-900 font-medium hover:bg-gray-100 hover:text-gray-800">Your Profile</a>
                  <a href="#" class="block rounded-md px-3 py-2 text-base text-gray-900 font-medium hover:bg-gray-100 hover:text-gray-800">Settings</a>
                  <a href="#" class="block rounded-md px-3 py-2 text-base text-gray-900 font-medium hover:bg-gray-100 hover:text-gray-800">Sign out</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>
    """
  end
end
