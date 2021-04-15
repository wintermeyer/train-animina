defmodule AniminaWeb.FooterComponent do
  use AniminaWeb, :live_component

  def render(assigns) do
    ~L"""
    <footer>
      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 lg:max-w-7xl">
        <div class="border-t border-gray-200 py-8 text-sm text-gray-500 text-center sm:text-left"><span class="block sm:inline">&copy; 2021 <a href="https://www.wintermeyer-consulting.de">Wintermeyer Consulting</a>.</span> <span class="block sm:inline">All rights reserved.</span> - <a href="https://www.wintermeyer-consulting.de/impressum.html">Impressum</a></span> - <span class="block sm:inline"><a href="https://www.wintermeyer-consulting.de/datenschutzerklaerung.html">Datenschutzerklärung</a></span></div>
      </div>
    </footer>
    """
  end
end
