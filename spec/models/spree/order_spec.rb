require 'rails_helper'

RSpec.describe Spree::Order do
  let(:order) { create :order }

  before do
    create :stock_location
  end
  
  context 'al crear una orden' do
    it 'se persiste en la db' do
      expect(order).to be_persisted
    end

    it 'el estado es cart' do
      expect(order.state).to eq 'cart'
    end

    it 'tiene number' do
      expect(order.number).not_to be_nil
    end

    it 'no pertenece a un store' do
      expect(order.store).to be_nil
    end

    it 'no tiene line_items' do
      expect(order.line_items.count).to eq 0
    end

    it 'no tiene email' do
      expect(order.email).to be_nil
    end

    it 'no tiene usuario' do
      expect(order.user).to be_nil
    end


    context 'con line_items' do
      let(:order) { create :order, :with_line_items }

      it 'tiene line_items' do
        expect(order.line_items.count).to be > 0
      end

      it 'el item_total no esta calculado' do
        expect(order.item_total).to eq 0
      end

      context 'cuando updateo los totales' do
        before do
          Spree::OrderUpdater.new(order).update
        end

        it 'el item_total es mayor a cero' do
          expect(order.item_total).to be > 0
        end
      end

      context 'al pasar al estado address' do
        before do
          order.next
        end

        it 'el estado es address' do
          expect(order.state).to eq 'address'
        end

        # context 'al pasar al estado' do
        #   before do
        #     order.next
        #   end

        #   it 'el estado es cart' do
        #     expect(order.state).to eq 'delivery'
        #   end
        # end
      end
    end
  end

  
end
