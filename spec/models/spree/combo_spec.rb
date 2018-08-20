require 'rails_helper'

RSpec.describe Combo do
  let(:combo) { create :combo }

  context 'al crear un combo' do
    it 'se persiste en la db' do
      expect(combo).to be_persisted
    end

    it 'no tiene lineas' do
      expect(combo.combo_lines.count).to eq 0
    end

    context 'con lineas' do
      let(:combo) { create :combo, :with_lines }

      it 'tiene lineas' do
        expect(combo.combo_lines.count).to be > 0
      end
    end
  end
end
