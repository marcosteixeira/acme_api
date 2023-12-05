# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: current_user.id }
    end
  end

  let(:current_user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe '#user_quota' do
    it 'creates the hit' do
      expect { get :index }.to change(Hit, :count).by(1)
    end

    it 'creates the hit with an endpoint' do
      get :index
      expect(current_user.hits.last.endpoint).to eq('/anonymous')
    end

    it 'increases the hits count' do
      expect { get :index }.to change(current_user, :count_hits).by(1)
    end

    it 'does not render an error' do
      get :index
      expect(response.body).to eq({ message: current_user.id }.to_json)
    end

    context 'when user is over quota' do
      before do
        allow(current_user).to receive(:count_hits).and_return(10_000)
      end

      it 'renders an error' do
        get :index
        expect(response.body).to eq({ error: 'over quota' }.to_json)
      end
    end
  end
end
