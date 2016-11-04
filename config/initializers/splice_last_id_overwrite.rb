ActiveRecord::ConnectionAdapters::JdbcAdapter.class_eval do
    def exec_insert(sql, name, binds, pk = nil, sequence_name = nil)
      if sql.respond_to?(:to_sql)
        sql = to_sql(sql, binds); to_sql = true
      end

      val = nil
      if prepared_statements?
        val = log(sql, name || 'SQL', binds) { @connection.execute_insert(sql, binds) }
      else
        sql = suble_binds(sql, binds) unless to_sql # deprecated behavior
        val = log(sql, name || 'SQL') { @connection.execute_insert(sql) }
      end

      if val.nil? && pk
        unless sequence_name
          table_ref = extract_table_ref_from_insert_sql(sql)
          sequence_name = default_sequence_name(table_ref, pk)
          return val unless sequence_name
        end
        last_insert_id_result(sequence_name)
      else
        val
      end
    end

    private
    def extract_table_ref_from_insert_sql(sql) # :nodoc:
      sql[/into\s+([^\(]*).*values\s*\(/im]
      $1.strip if $1
    end

    def last_insert_id_result(sequence_name) #:nodoc:
      exec_query("SELECT IDENTITY_VAL_LOCAL() FROM #{sequence_name}", 'SQL')
    end

    def default_sequence_name(table, column)
      "#{table}"
    end
end