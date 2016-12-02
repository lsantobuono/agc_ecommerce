require 'rails_helper'

RSpec.describe Spree::User do
  let(:user) { create :user }

  context 'al crear un user' do
    it 'se persiste en la db' do
      expect(user).to be_persisted
    end
  end

  context 'al crear un admin' do
    let(:user) { create :user, :admin}
    
    it 'se persiste en la db' do
      expect(user.spree_roles.count).to eq 1
    end
    it 'se persiste en la db' do
      expect(user).to be_admin
    end
    it 'se persiste en la db' do
      expect(user).to be_persisted
    end
  end
end
