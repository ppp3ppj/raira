defmodule Raira.TestingTest do
  use Raira.DataCase

  alias Raira.Testing

  describe "suites" do
    alias Raira.Testing.Suite

    import Raira.AccountsFixtures, only: [user_scope_fixture: 0]
    import Raira.TestingFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_suites/1 returns all scoped suites" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      suite = suite_fixture(scope)
      other_suite = suite_fixture(other_scope)
      assert Testing.list_suites(scope) == [suite]
      assert Testing.list_suites(other_scope) == [other_suite]
    end

    test "get_suite!/2 returns the suite with given id" do
      scope = user_scope_fixture()
      suite = suite_fixture(scope)
      other_scope = user_scope_fixture()
      assert Testing.get_suite!(scope, suite.id) == suite
      assert_raise Ecto.NoResultsError, fn -> Testing.get_suite!(other_scope, suite.id) end
    end

    test "create_suite/2 with valid data creates a suite" do
      valid_attrs = %{name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Suite{} = suite} = Testing.create_suite(scope, valid_attrs)
      assert suite.name == "some name"
      assert suite.description == "some description"
      assert suite.user_id == scope.user.id
    end

    test "create_suite/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Testing.create_suite(scope, @invalid_attrs)
    end

    test "update_suite/3 with valid data updates the suite" do
      scope = user_scope_fixture()
      suite = suite_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Suite{} = suite} = Testing.update_suite(scope, suite, update_attrs)
      assert suite.name == "some updated name"
      assert suite.description == "some updated description"
    end

    test "update_suite/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      suite = suite_fixture(scope)

      assert_raise MatchError, fn ->
        Testing.update_suite(other_scope, suite, %{})
      end
    end

    test "update_suite/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      suite = suite_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Testing.update_suite(scope, suite, @invalid_attrs)
      assert suite == Testing.get_suite!(scope, suite.id)
    end

    test "delete_suite/2 deletes the suite" do
      scope = user_scope_fixture()
      suite = suite_fixture(scope)
      assert {:ok, %Suite{}} = Testing.delete_suite(scope, suite)
      assert_raise Ecto.NoResultsError, fn -> Testing.get_suite!(scope, suite.id) end
    end

    test "delete_suite/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      suite = suite_fixture(scope)
      assert_raise MatchError, fn -> Testing.delete_suite(other_scope, suite) end
    end

    test "change_suite/2 returns a suite changeset" do
      scope = user_scope_fixture()
      suite = suite_fixture(scope)
      assert %Ecto.Changeset{} = Testing.change_suite(scope, suite)
    end
  end
end
