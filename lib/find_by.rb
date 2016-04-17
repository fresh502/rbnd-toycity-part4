class Module
  def create_finder_methods(*attributes)
    attributes.first.each do |attribute|
    	new_method = %Q{
    		def self.find_by_#{attribute}(val)
    			columns = self.new.instance_variables.map { |column| column.to_s.delete!('@').to_sym }
    			row = CSV.read(@@data_path, headers: true).select { |data| data['#{attribute}'] == val }.first
    			self.new(columns.zip(row.fields).to_h)
    		end
    	}
    	class_eval(new_method)
    end
  end
end
