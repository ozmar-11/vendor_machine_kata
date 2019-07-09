# This class save the product and its data to make it easy to handle

class Product
	attr_accessor :name, :code, :price

	def initialize(product_attributes)
		@name = product_attributes.fetch('Item name', 'N/A')
		@code = product_attributes.fetch('Code', 'N/A')
		@price = convert_price_to_number(product_attributes.fetch('Cost', 'N/A'))
	end

	def to_s
		"code: #{code} name: #{name} cost: $#{price}"
	end

	private

	def convert_price_to_number(formatted_price)
		return 0 if formatted_price == 'N/A'
		formatted_price.split('$').last.to_f
	end
end