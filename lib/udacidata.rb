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
		columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
		CSV.read(@@data_path).drop(1).map { |data| self.new(columns.zip(data).to_h) }
	end

	def self.first(range=1)
		columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
		datas = CSV.read(@@data_path).drop(1).first(range).map { |data| self.new(columns.zip(data).to_h) }
		datas.length == 1 ? datas[0] : datas
	end

	def self.last(range=1)
		columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
		datas = CSV.read(@@data_path).last(range).map { |data| self.new(columns.zip(data).to_h) }
		datas.length == 1 ? datas[0] : datas
	end

	def self.find(id)
		columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
		data = CSV.read(@@data_path, headers: true).select { |data| data["id"].to_i == id }.first
		self.new(columns.zip(data.fields).to_h)
	end

	def self.destroy(id)
		data = self.find(id)
		datas_remained = CSV.read(@@data_path).delete_if { |row| row.first.to_i == data.id }
		CSV.open(@@data_path, "wb") do |csv|
			datas_remained.each do |data|
				csv << data
			end
		end
		return data
	end

	def self.method_missing(method_name, argument)
		if method_name.to_s.start_with? "find_by_"
			attributes = self.new.instance_variables.map { |variable| variable.to_s.delete!('@').to_sym }
			create_finder_methods(attributes)
			send(method_name, argument)
		else
			super
		end
	end

	def self.where(options={})
		columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
		datas = []
		if (options.keys - columns).empty?
			datas = CSV.read(@@data_path, headers: true).select do |data|
				check_value = true
				options.each do |key, value|
					check_value = false unless data[key.to_s] == value
				end
				check_value
			end
		else
			# handle exception
		end
		datas.map { |data| self.new(columns.zip(data.fields).to_h) }
	end
end
