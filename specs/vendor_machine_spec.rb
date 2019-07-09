require_relative '../src/vendor_machine'
require 'csv'

DEFAULT_CSV_FILE = './CSVs/products.csv'

RSpec.describe do
	let(:vendor_machine) { VendorMachine.new }
	let(:product) do
		Product.new({
			'Item name' => 'Chocolate',
			'Code' => 'L5',
			'Cost' => '$2.5'})
	end

	context 'When a vendor machine is created' do
		it 'Load products from the default CSV file' do
			csv_table = CSV.read(DEFAULT_CSV_FILE, headers: true)
			expect(vendor_machine.products.size).to eq(csv_table.count)
		end
	end

	context 'When a client refund a product' do
		it 'Increase the client balance as the product price' do
			expect {vendor_machine.client_balance}.to change{vendor_machine.refound_product(product.price)}.by(product.price)
		end
	end

	context 'When a client inser money' do
		it 'Increase the client balance if valid amount' do
			expect {vendor_machine.client_balance}.to change{vendor_machine.insert_money(1)}.by(1)
		end

		it 'Not increase client balance if invalid amount' do
			expect {vendor_machine.client_balance}.not_to change{vendor_machine.insert_money(0.75)}
		end
	end

	context 'When search a product' do
		it 'Return true if provided product code exists in the machine' do
			expect(vendor_machine.product_exists?(vendor_machine.products.first.code)).to be_truthy
		end

		it 'Return the product with the code provided' do
			first_product = vendor_machine.products.first
			expect(vendor_machine.find_product_by_code(first_product.code)).to eq(first_product)
		end
	end

	context 'When the client buy a product' do
		it 'Return true if the client balance can affort it' do
			vendor_machine.insert_money(2)
			vendor_machine.insert_money(1)
			expect(vendor_machine.sell_product('L1')).to be_truthy
		end

		it 'Return true if the client balance can not affort it' do
			vendor_machine.insert_money(2)
			vendor_machine.insert_money(1)
			expect(vendor_machine.sell_product('L1')).to be_truthy
		end
	end

	context 'When reset client balance' do
		it 'Make client balance to 0' do
			vendor_machine.insert_money(2)
			vendor_machine.reset_client_balance

			expect(vendor_machine.client_balance).to eq(0)
		end
	end
end