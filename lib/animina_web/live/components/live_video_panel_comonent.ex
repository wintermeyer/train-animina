defmodule AniminaWeb.LiveVideoComponent do
  use AniminaWeb, :live_component

  def render(assigns) do
    ~L"""
    <section aria-labelledby="Live-Stream Video">
      <!-- Add a placeholder for the Twitch embed -->
      <div id="twitch-embed" phx-update="ignore"></div>

        <!-- Load the Twitch embed script -->
        <script src="https://player.twitch.tv/js/embed/v1.js"></script>

        <!-- Create a Twitch.Player object. This will render within the placeholder div -->
        <script type="text/javascript">
          new Twitch.Player("twitch-embed", {
            channel: "wintermeyer",
            width: "100%",
            height: "100%",
            autoplay: "true"
          });
        </script>
      </div>
    </section>
    """
  end
end
