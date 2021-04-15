defmodule AniminaWeb.UsersListPanelComponent do
  use AniminaWeb, :live_component
  import Gettext, only: [with_locale: 2]
  import Ecto.Query, warn: false
  alias Animina.Accounts.User
  alias Animina.Repo

  def top_users() do
    from(u in User,
      where: not is_nil(u.confirmed_at),
      where: u.lifetime_points > 0,
      order_by: [desc: :lifetime_points, asc: :confirmed_at],
      limit: 10
    )
    |> Repo.all()
  end

  def render(assigns) do
    ~L"""
    <%= if length(top_users()) > 0 do %>
    <%= with_locale(@locale, fn -> %>
      <section aria-labelledby="top-users">
        <div class="rounded-lg bg-white overflow-hidden shadow">
          <div class="p-6">
            <h2 class="text-base font-medium text-gray-900" id="top-users"><%= gettext("Top Users") %></h2>
            <div class="flow-root mt-6">
              <ul class="-my-5 divide-y divide-gray-200">
              <%= for user <- top_users() do %>

                <li class="py-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                    <a href="/u/<%= user.username %>"><img class="h-8 w-8 rounded-full" src="<%= UserHelper.avatar_src(user) %>" alt="Avatar"></a>
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900 truncate">
                        @<%= user.username %>
                      </p>
                      <p class="text-sm text-gray-500 truncate">
                      <%= gettext("Points") %>: <%= Formater.humanize_number(user.lifetime_points) %>
                      </p>
                    </div>
                    <div>
                      <a href="/u/<%= user.username %>" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                        <%= gettext("View") %>
                      </a>
                    </div>
                  </div>
                </li>
                <% end %>
              </ul>
            </div>
          </div>
        </div>
      </section>
    <% end) %>
    <% end %>
    """
  end
end
