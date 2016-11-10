if  RbConfig::CONFIG['ruby_install_name'] == 'jruby'
 ArJdbc::Derby.class_eval do
    # @override
    def add_index(table_name, column_name, options = {})
    end

    # @override
    def remove_index(table_name, options = {})
    end
  end

  ActiveRecord::ConnectionAdapters::AbstractAdapter::SchemaCreation.class_eval do
    # @override
    def visit_AddForeignKey(o)
    end
  end

  ActiveRecord::ConnectionAdapters::SchemaStatements.class_eval do
    # @override
    def add_foreign_key(from_table, to_table, options = {})

    end
    def remove_foreign_key(from_table, options_or_to_table = {})

    end
  end

 end