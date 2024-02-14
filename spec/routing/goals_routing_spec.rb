# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemindersController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/reminders/new").to route_to("reminders#new")
    end

    it "routes to #show" do
      expect(get: "/reminders/1").to route_to("reminders#show", id_token: "1")
    end

    it "routes to #create" do
      expect(post: "/reminders").to route_to("reminders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/reminders/1").to route_to("reminders#update", id_token: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/reminders/1").to route_to("reminders#update", id_token: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/reminders/1").to route_to("reminders#destroy", id_token: "1")
    end
  end
end
