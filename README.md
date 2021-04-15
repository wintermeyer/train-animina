# Developer documentation

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Sent emails will be available at http://localhost:4001

# Translations

- `mix gettext.extract --merge`
- `mix gettext.merge priv/gettext --locale de`

More info about I18n:

- https://phrase.com/blog/posts/i18n-for-phoenix-applications-with-gettext/
- http://blog.plataformatec.com.br/2016/03/using-gettext-to-internationalize-a-phoenix-application/
