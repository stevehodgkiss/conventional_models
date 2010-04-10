class ActiveRecord::Base
  def self.model_code
    ::ConventionalModels.model_code_for(table_name)
  end
end