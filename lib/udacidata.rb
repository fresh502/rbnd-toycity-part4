require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
	@@data_path = File.dirname(__FILE__) + "/../data/data.csv"

	def self.create(opts={})
		data = self.new(opts)
		CSV.open(@@data_path, "a+") do |csv|
			duplication = false
			unless opts[:allow_duplicates]
				csv.each do |row|
					if (data.instance_variables.map { |instance_variable| self.instance_variable_get(instance_variable) } - row).empty?
						duplication = true
						break
					end
				end
			end
			csv << data.instance_variables.map { |instance_variable| data.instance_variable_get(instance_variable).to_s } unless duplication
		end
		return data
	end

	def self.all
		columns = CSV.read(@@data_path).first.map { |column| column.to_sym }
		CSV.read(@@data_path).drop(1).map { |row| self.new(columns.zip(row).to_h) }
	end

	# def self.first
	# 	first_data = CSV.read(@@data_path)[1]
	# 	self.new(id:
	# end
end
