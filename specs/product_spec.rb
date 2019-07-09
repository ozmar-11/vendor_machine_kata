require_relative '../src/product'

RSpec.describe Product do
	let(:product_attributes) { {'Item name' => 'Chocolate', 'Code' => 'L5','Cost' => '$2.5'} }
	let(:product) do
	  Product.new(product_attributes)
	end

	it 'Return its properties formatted' do
		product_attributes.values.each do |value|
			expect(product.to_s).to include(value)
		end
	end
end
