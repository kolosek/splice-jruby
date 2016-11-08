if  RbConfig::CONFIG['ruby_install_name'] == 'jruby'
  Arel::Visitors::ToSql.class_eval do
    def visit_Arel_Nodes_Offset o, collector
      collector << "OFFSET "
      visit o.expr, collector
      collector << " ROWS"
    end

    def visit_Arel_Nodes_Limit o, collector
      collector << "FETCH FIRST "
      visit o.expr, collector
      collector << " ROWS ONLY"
    end
  end
end