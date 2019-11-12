# frozen_string_literal: true

require 'rails_helper'

module DiscoursePatrons
  RSpec.describe CustomersController do
    describe "create" do
      describe "authenticated" do
        let(:user) { Fabricate(:user, email: 'hello.2@example.com') }

        before do
          sign_in(user)
        end

        it "creates a stripe customer" do
          ::Stripe::Customer.expects(:create).with(
            email: 'hello.2@example.com',
            source: 'tok_interesting'
          )

          post "/patrons/customers.json", params: { source: 'tok_interesting' }
        end

        it "saves the customer" do
          ::Stripe::Customer.expects(:create).returns(id: 'cus_id23456')

          expect {
            post "/patrons/customers.json", params: { source: 'tok_interesting' }
          }.to change { DiscoursePatrons::Customer.count }
        end
      end
    end
  end
end