require 'rails_helper'

RSpec.describe "WaitingList", type: :request do
  describe "GET /waiting_list/new" do
    it "renders the join form without authentication" do
      get new_waiting_list_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Join the waiting list")
    end
  end

  describe "POST /waiting_list" do
    it "adds an email to the waiting list" do
      expect do
        post waiting_list_path, params: { waiting_list_log: { email: "join@example.com" } }
      end.to change(WaitingListLog, :count).by(1)

      expect(WaitingListLog.last).to have_attributes(email: "join@example.com", status: "pending")
      expect(response).to redirect_to(root_path)
    end

    it "rejects an invalid email" do
      expect do
        post waiting_list_path, params: { waiting_list_log: { email: "nope" } }
      end.not_to change(WaitingListLog, :count)

      expect(response).to have_http_status(:success)
    end
  end
end