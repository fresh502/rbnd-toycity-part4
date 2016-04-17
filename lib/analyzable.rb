module Analyzable
	def average_price(products)
		(products.map(&:price).map(&:to_f).reduce { |total_price, price| total_price + price } / products.length).round(2)
	end

	def count_by_brand(products)
		result = {}
		products.each do |product|
			if result.keys.include? product.brand
				result[product.brand] += 1
			else
				result[product.brand] = 1
			end
		end
		return result
	end

	def count_by_name(products)
		result = {}
		products.each do |product|
			if result.keys.include? product.name
				result[product.name] += 1
			else
				result[product.name] = 1
			end
		end
		return result
	end

	def print_report(products)
		average_price_result = average_price(products)
		puts "====Inventory by Brand===="
		count_by_brand(products).each do |key, value|
			puts "#{key} : #{value}"
		end
		puts "====Inventory by name===="
		count_by_name(products).each do |key, value|
			puts "#{key} : #{value}"
		end
		puts "====Average_price===="
		puts "$#{average_price_result}"
		return average_price_result.to_s
	end
end
