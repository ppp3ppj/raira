defmodule RairaWeb.SuiteLiveTest do
  use RairaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Raira.TestingFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  setup :register_and_log_in_user

  defp create_suite(%{scope: scope}) do
    suite = suite_fixture(scope)

    %{suite: suite}
  end

  describe "Index" do
    setup [:create_suite]

    test "lists all suites", %{conn: conn, suite: suite} do
      {:ok, _index_live, html} = live(conn, ~p"/suites")

      assert html =~ "Listing Suites"
      assert html =~ suite.name
    end

    test "saves new suite", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/suites")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Suite")
               |> render_click()
               |> follow_redirect(conn, ~p"/suites/new")

      assert render(form_live) =~ "New Suite"

      assert form_live
             |> form("#suite-form", suite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#suite-form", suite: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/suites")

      html = render(index_live)
      assert html =~ "Suite created successfully"
      assert html =~ "some name"
    end

    test "updates suite in listing", %{conn: conn, suite: suite} do
      {:ok, index_live, _html} = live(conn, ~p"/suites")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#suites-#{suite.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/suites/#{suite}/edit")

      assert render(form_live) =~ "Edit Suite"

      assert form_live
             |> form("#suite-form", suite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#suite-form", suite: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/suites")

      html = render(index_live)
      assert html =~ "Suite updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes suite in listing", %{conn: conn, suite: suite} do
      {:ok, index_live, _html} = live(conn, ~p"/suites")

      assert index_live |> element("#suites-#{suite.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#suites-#{suite.id}")
    end
  end

  describe "Show" do
    setup [:create_suite]

    test "displays suite", %{conn: conn, suite: suite} do
      {:ok, _show_live, html} = live(conn, ~p"/suites/#{suite}")

      assert html =~ "Show Suite"
      assert html =~ suite.name
    end

    test "updates suite and returns to show", %{conn: conn, suite: suite} do
      {:ok, show_live, _html} = live(conn, ~p"/suites/#{suite}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/suites/#{suite}/edit?return_to=show")

      assert render(form_live) =~ "Edit Suite"

      assert form_live
             |> form("#suite-form", suite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#suite-form", suite: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/suites/#{suite}")

      html = render(show_live)
      assert html =~ "Suite updated successfully"
      assert html =~ "some updated name"
    end
  end
end
