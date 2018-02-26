defmodule TaskTracker2Web.SlotView do
  use TaskTracker2Web, :view
  alias TaskTracker2Web.SlotView

  def render("index.json", %{slots: slots}) do
    %{data: render_many(slots, SlotView, "slot.json")}
  end

  def render("show.json", %{slot: slot}) do
    %{data: render_one(slot, SlotView, "slot.json")}
  end

  def render("slot.json", %{slot: slot}) do
    %{id: slot.id,
      start_time: slot.start_time,
      end_time: slot.end_time}
  end
end
