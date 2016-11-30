require 'rails_helper'

RSpec.describe Spree::Order do
  let(:order) { create :order }
  
  context 'al crear una orden' do
    it 'se persiste en la db' do
      expect(order).to be_persisted
    end

    it 'el estado es cart' do
      expect(order.state).to eq 'cart'
    end

    it 'no pertenece a un store' do
      expect(order.store).to be_nil
    end

    it 'no tiene line_items' do
      expect(order.line_items.count).to eq 0
    end

    context 'con line_items' do
      let(:order) { create :order, :with_line_items }

      it 'tiene line_items' do
        expect(order.line_items.count).to be > 0
      end
    end
  end

  
end
