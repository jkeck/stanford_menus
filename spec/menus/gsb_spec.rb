RSpec.describe StanfordMenus::Menus::GSB do
  subject(:menu) { described_class.new }

  let(:json) do
    {
      '1' => {
        'station' => '<strong>free market grill</strong>',
        'label' => 'Grill Special 1',
        'description' => 'A tasty treat',
        'special' => 1,
        'sizes' => [
          { 'size' => 'small', 'price' => '$1.00' },
          { 'size' => 'large', 'price' => '$4.00' }
        ]
      },
      '2' => {
        'station' => '<strong>free market grill</strong>',
        'label' => 'Grill Special 2',
        'description' => 'Another tasty treat',
        'special' => 1,
        'price' => '$10.00'
      },
      '3' => {
        'station' => '<strong>free market grill</strong>',
        'label' => 'Extra Ranch',
        'special' => 0,
        'price' => '$0.40'
      },
      '4' => {
        'station' => 'sushi',
        'label' => 'Sushi Special',
        'description' => 'A special sushi roll',
        'special' => 1,
        'price' => '$11.99'
      }
    }
  end

  before do
    allow(menu).to receive(:json).and_return(json)
  end

  describe '#all' do
    it 'is all of the menu items' do
      expect(menu.all.length).to eq 2
      expect(menu.all).to be_all do |m|
        !(m.station.empty? || m.items.empty?)
      end
    end

    it 'excludes non-special items' do
      expect(menu.all.first.station).to eq 'free market grill'
      expect(menu.all.first.items.length).to eq 2
      expect(menu.all.first.items.map(&:label)).not_to include('Extra Ranch')
    end
  end

  describe '#filtered_by_catergory' do
    it 'only returns items where a word matches' do
      expect(menu.filtered_by_category('grill').length).to eq 1
      expect(menu.filtered_by_category('grill').map(&:station)).to eq(['free market grill'])
    end

    it 'handles string matches across space/punctuation boundries' do
      expect(menu.filtered_by_category('marketgrill').length).to eq 1
    end
  end

  describe '#filtered_by_price' do
    it 'only returns menu items where the prices is lower or equal to the requested price' do
      expect(menu.filtered_by_price('$2.00').length).to eq 1
      expect(menu.filtered_by_price('$2.00').first.items.length).to eq 1
      expect(menu.filtered_by_price('$2.00').first.items.first.label).to eq 'Grill Special 1'
    end
  end
end
