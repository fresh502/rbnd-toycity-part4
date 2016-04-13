require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
	def self.create(opts={})
		data = self.new(opts)
		@data_path = File.dirname(__FILE__) + "/../data/data.csv"

		CSV.open(@data_path, "a+") do |csv|
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
end
