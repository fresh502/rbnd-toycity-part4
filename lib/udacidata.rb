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
		data = CSV.read(@@data_path).select { |data| data.first.to_i == id }.first
		self.new(columns.zip(data).to_h)
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
end
