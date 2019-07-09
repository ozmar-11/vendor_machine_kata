# This class represents the vendor machine and its internal mechanism
# such as dispatch products, refound money, check product existence, etc.

require 'csv'
require_relative 'product'
require_relative 'vendor_machine_interface'

class VendorMachine
	attr_reader :client_balance, :products, :product_codes
	VALID_DENOMINATIONS = [0.1, 0.5, 0.10, 0.25, 0.50, 1, 2]
	DEFAULT_CSV_FILE = 'CSVs/products.csv'

	def initialize
		@products = []
		@product_codes = []
		@client_balance = 0
		load_products_from_csv
	end

	def load_products_from_csv(csv_path = DEFAULT_CSV_FILE)
		products_table = CSV.read(csv_path, headers: true)

		products_table.each do |product_row|
			current_product = Product.new(product_row)
			@products.push(current_product)
			product_codes.push(current_product.code)
		end
	end

	def refound_product(product_price)
		@client_balance += product_price
	end

	def insert_money(inserted_amount)
		@client_balance += inserted_amount if valid_denomination?(inserted_amount)
	end

	def product_exists?(product_code)
		product_codes.include?(product_code)
	end

	def find_product_by_code(product_code)
		products.find { |current_product| current_product.code == product_code }
	end

	def sell_product(product_code)
		product_to_sell = find_product_by_code(product_code)
		return false unless product_to_sell
		if product_to_sell.price <= client_balance
			@client_balance -= product_to_sell.price
			return true
		end
		false
	end

	def reset_client_balance
		@client_balance = 0
	end

	private

	attr_writer :products, :product_codes

	def valid_denomination?(denomination)
		VALID_DENOMINATIONS.include?(denomination)
	end
end