RSpec.describe StanfordMenus::Menus do
  describe '#for' do
    before do
      allow(StanfordMenus).to receive(:restaurant_class_map).and_return(
        'GSB' => 'StanfordMenus::Menus::GSB'
      )
    end

    context 'when the restaurant is registered' do
      it 'returns the registered restaurant menu' do
        expect(described_class.for('GSB')).to be_a StanfordMenus::Menus::GSB
      end
    end

    context 'when the restaurant is not registered' do
      it 'raises an ArgumentError' do
        expect do
          described_class.for('BADLOC')
        end.to raise_error(ArgumentError)
      end
    end

    context 'when the registered restaurant references a class that cannot be loaded' do
      before do
        allow(StanfordMenus).to receive(:restaurant_class_map).and_return(
          'GSB' => 'StanfordMenus::Menus::NotExistant'
        )
      end

      it 'raises an ArgumentError' do
        expect do
          described_class.for('GSB')
        end.to raise_error(ArgumentError)
      end
    end
  end
end
