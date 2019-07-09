# Kata description
You will design a vending machine with the following requirements

-	Must accept money in the following denominations 1, 5, 10, 25, 50 cents, 1 and 2 dollar notes
-	Allow user to select from a list of products that are uploaded via a CSV with the following format:

```
Item name, code, cost
Nuts, L5, $0.50
```

## Features
-	Allow a user to add money to the machine, but selecting from a list of denominations and then select a product from a list provided by submitting the code. Via a command line interface
-	If the user hasn’t added enough money provide a message indicating they need to add x more cents.
-	If the user has enough money, ask the user if they would like to purchase anything else, or collect items, and change.
-	Provide a message stating what products were vended, and how much change was returned.
-	All the use to cancel selections and take refund.
-	All of a new set of products can be added CSV upload.


# Manual testing

Steps:
- Download the repo
- Install the required gem and ruby version especified in the Gemfile
- run `ruby src/main.rb`
- Follow the instructions

# Testing
- Run the specs using `bundle exec rspec specs/`
