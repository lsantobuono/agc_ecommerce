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

      context 'cuando tiene complementos' do
        let(:line_item_1) { build :line_item }
        let(:line_item_2) { build :line_item }
        let(:order) { create :order, line_items: [line_item_1, line_item_2] }

        let(:complement_1) { create :complement }
        let(:complement_2) { create :complement }
        let(:complement_3) { create :complement }
        let(:taxon_1) { create :taxon, applied_complements: [
          build(:applied_complement, complement_id: complement_1.id, quantity: 3),
          build(:applied_complement, complement_id: complement_3.id, quantity: 4)
        ] }
        let(:taxon_2) { create :taxon, applied_complements: [
          build(:applied_complement, complement_id: complement_2.id, quantity: 5),
          build(:applied_complement, complement_id: complement_3.id, quantity: 6)
        ] }

        before do
          create_list(:applied_complement, rand(1..20))
          Spree::Classification.create(product_id: line_item_1.variant.product.id, taxon_id: create(:taxon, parent_id: taxon_1.id).id)
          Spree::Classification.create(product_id: line_item_2.variant.product.id, taxon_id: create(:taxon, parent_id: taxon_2.id).id)
        end

        it 'la cantidad de complementos es correcta' do
          expect(order.complementos_para_mostrar.count).to eq 3
        end
        it 'la cantidad de complement_1 es correcta' do
          cantidad = line_item_1.quantity * 3
          expect(order.complementos_para_mostrar.find { |c| c.complement_id == complement_1.id }.quantity ).to eq cantidad
        end
        it 'la cantidad de complement_2 es correcta' do
          cantidad = line_item_2.quantity * 5
          expect(order.complementos_para_mostrar.find { |c| c.complement_id == complement_2.id }.quantity ).to eq cantidad
        end
        it 'la cantidad de complement_3 es correcta' do
          cantidad = line_item_1.quantity * 4 + line_item_2.quantity * 6
          expect(order.complementos_para_mostrar.find { |c| c.complement_id == complement_3.id }.quantity ).to eq cantidad
        end
      end

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

    #   context 'al pasar de estado' do
    #     before do
    #       order.email = Faker::Internet.email
    #       order.next
    #     end

    #     it 'el estado es address' do
    #       expect(order.state).to eq 'address'
    #     end

    #     context 'al pasar de estado' do
    #       before do
    #         order.next
    #       end

    #       it 'el estado es confirmar' do
    #         expect(order.state).to eq 'confirmar'
    #       end

    #       context 'no se decrementa el stock' do
    #         it do
    #           expect { order.next }.not_to change { order.line_items.first.variant.stock_items.first.count_on_hand }
    #         end
    #       end

    #       context 'al pasar de estado' do
    #         before do
    #           order.next
    #         end

    #         it 'el estado es complete' do
    #           expect(order.state).to eq 'complete'
    #         end
    #         it 'tiene un shipment' do
    #           expect(order.shipments.count).to eq 4
    #         end
    #         it 'el estado es complete' do
    #           expect(order).to be_completed
    #         end
    #         it 'no esta aprobada' do
    #           expect(order).not_to be_approved
    #         end

    #         context 'al pasar de estado' do
    #           before do
    #             order.next
    #           end

    #           it 'el estado sigue siendo complete' do
    #             expect(order.state).to eq 'complete'
    #           end
    #         end
    #       end
    #     end
    #   end
    end
  end

  
end
