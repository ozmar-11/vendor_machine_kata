# This class represents the vendor machine keyboard and money input
# which is the interface that allow clients interact with the vendor machine

require_relative 'vendor_machine'

class VendorMachineInterface
	attr_reader :vendor_machine, :finished_transaction
	attr_accessor :products_bought

	OPTIONS_AMOUNT = {
		'1' => 0.1,
		'2' => 0.5,
		'3' => 0.10,
		'4' => 0.25,
		'5' => 0.50,
		'6' => 1,
		'7' => 2
	}

	def initialize
		@vendor_machine = VendorMachine.new
		@finished_transaction = false
		@products_bought = []
		transaction_loop
	end

	def transaction_loop
		while !finished_transaction
			insert_money_menu
			select_product_menu
		end
	end

	private

	def get_input_from_keyboard
		gets.chomp
	end

	def insert_money_menu
		clear_screen
		puts "Inserted amount: #{vendor_machine.client_balance} Select amount to insert: "
		puts '1) 0.1, 2) 0.5, 3) 0.10, 4) 0.25, 5) 0.50, 6) 1, 7) 2'
		puts 'any other key to continue: '
		selected_option = gets.chomp
		selected_value = OPTIONS_AMOUNT.fetch(selected_option, false)
		if selected_value
			vendor_machine.insert_money(selected_value)
			clear_screen
			insert_money_menu
		end
	end

	def offer_another_product
		clear_screen
		puts "You still have $#{vendor_machine.client_balance}, you want something else?"
		puts '1) Yes, any other key no'
		selected_option = gets.chomp
		selected_option == '1' ? select_product_menu : finish_transaction
	end

	def thanks_message
		clear_screen
		puts 'Thanks for your purchase please pick your products:'
		puts products_bought.map(&:name).join(', ')
	end

	def select_product_menu
		clear_screen
		puts "Remaining money: $#{vendor_machine.client_balance}"
		puts 'Select the product you want writing its code'

		vendor_machine.products.each do |product|
			puts product.to_s
		end

		selected_product_code = gets.chomp
		selected_product = vendor_machine.find_product_by_code(selected_product_code)
		return if selected_product.nil?

		if vendor_machine.sell_product(selected_product_code)
			products_bought.push(selected_product)
			if vendor_machine.client_balance > 0
				offer_another_product
			else
				finish_transaction
			end
		else
			needed_money = selected_product.price - vendor_machine.client_balance
			puts "You need $#{needed_money} more"
			puts '1) Go to insert money menu, any other key Cancel'
			selected_option = gets.chomp
			selected_option == '1' ? insert_money_menu : cancel_or_finish_sell
		end
	end

	def cancel_or_finish_sell
		products_bought.length > 0 ? finish_transaction : cancel_sell
	end

	def return_bought_products
		products_bought.each do |current_product|
			vendor_machine.refound_product(current_product.price)
		end
	end

	def reset_products_bought_and_client_balance
		products_bought = []
		vendor_machine.reset_client_balance
		@finished_transaction = true
	end

	def cancel_sell
		clear_screen
		puts "Please pick your money $#{vendor_machine.client_balance}"
		return_bought_products
		reset_products_bought_and_client_balance
	end

	def finish_transaction
		clear_screen
		client_balance = vendor_machine.client_balance
		puts "Please pick your products: #{print_products_bought}"

		if client_balance
			puts "Pick your change: $#{client_balance}"
		end

		reset_products_bought_and_client_balance
	end

	def print_products_bought
		products_bought.join(', ')
	end

	def clear_screen
		system('clear') || system('cls')
	end
end
