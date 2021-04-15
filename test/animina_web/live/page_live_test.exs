defmodule AniminaWeb.PageLiveTest do
  use AniminaWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "animina"
    assert render(page_live) =~ "animina"
  end
end
