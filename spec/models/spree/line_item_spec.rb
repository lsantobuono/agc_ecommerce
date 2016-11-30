require 'rails_helper'

RSpec.describe Spree::LineItem do
  let(:order) { create :order }
  let(:line_item) { create :line_item, order: order }
  
  context 'al crear un line_item' do
    it 'se persiste en la db' do
      expect(line_item).to be_persisted
    end
  end
end
