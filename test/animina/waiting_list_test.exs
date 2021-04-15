defmodule Animina.WaitingListTest do
  use Animina.DataCase

  alias Animina.WaitingList

  describe "slots" do
    alias Animina.WaitingList.Slot

    @invalid_attrs %{team_id: nil, package_id: nil}

    test "list_slots/0 returns all slots" do
      Repo.delete_all(Slot)
      slot_with_associations = insert(:slot)
      slot = WaitingList.get_slot!(slot_with_associations.id)
      assert WaitingList.list_slots() == [slot]
    end

    test "get_slot!/1 returns the slot with given id" do
      # TODO: This tests should unload the loaded associations first.
      slot_with_associations = insert(:slot)
      slot = WaitingList.get_slot!(slot_with_associations.id)
      assert WaitingList.get_slot!(slot.id) == slot
    end

    test "create_slot/1 with valid data creates a slot" do
      slot =
        insert(:slot, %{
          finished_at: ~N[2030-04-17 14:06:00],
          started_at: ~N[2030-04-17 14:05:00]
        })

      assert slot.finished_at == ~N[2030-04-17 14:06:00]
      assert slot.started_at == ~N[2030-04-17 14:05:00]
    end

    test "create_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WaitingList.create_slot(@invalid_attrs)
    end

    test "update_slot/2 with valid data updates the slot" do
      slot =
        insert(:slot, %{
          finished_at: ~N[2030-04-17 14:06:00],
          started_at: ~N[2030-04-17 14:05:00]
        })

      assert {:ok, %Slot{} = slot} =
               WaitingList.update_slot(slot, %{finished_at: ~N[2030-04-17 14:07:00]})

      assert slot.finished_at == ~N[2030-04-17 14:07:00]
      assert slot.started_at == ~N[2030-04-17 14:05:00]
    end

    test "update_slot/2 with invalid data returns error changeset" do
      slot = insert(:slot)
      assert {:error, %Ecto.Changeset{}} = WaitingList.update_slot(slot, @invalid_attrs)
    end

    test "delete_slot/1 deletes the slot" do
      slot = insert(:slot)
      assert {:ok, %Slot{}} = WaitingList.delete_slot(slot)
      assert_raise Ecto.NoResultsError, fn -> WaitingList.get_slot!(slot.id) end
    end

    test "change_slot/1 returns a slot changeset" do
      slot = insert(:slot)
      assert %Ecto.Changeset{} = WaitingList.change_slot(slot)
    end
  end
end
