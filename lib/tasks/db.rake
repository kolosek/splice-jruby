namespace :db do
  namespace :splice do
    task :create => :environment do
      ['development', 'test'].each do |environment|
        db_config = Rails.configuration.database_configuration[environment].dup
        schema_name = db_config['schema']
        migration_table_command = "CREATE TABLE #{schema_name}.schema_migrations (
          version varchar(255) NOT NULL PRIMARY KEY
        )"

        db_config['schema'] = 'splice'
        ActiveRecord::Base.establish_connection(db_config).with_connection do |connection|
          tables = connection.execute("SELECT tablename FROM SYS.SYSTABLES JOIN SYS.SYSSCHEMAS ON SYS.SYSTABLES.schemaid = SYS.SYSSCHEMAS.schemaid WHERE SYS.SYSSCHEMAS.schemaname = '#{schema_name.upcase}'").map {|t| t['tablename']}
          tables.each do |table|
            connection.execute("DROP TABLE IF EXISTS #{schema_name}.#{table}")
          end
          schema_exists = connection.execute("SELECT schemaname FROM SYS.SYSSCHEMAS WHERE SYS.SYSSCHEMAS.schemaname = '#{schema_name.upcase}'").present?
          connection.execute("DROP SCHEMA #{schema_name} RESTRICT") if schema_exists
          connection.execute("CREATE SCHEMA #{schema_name}")
          connection.execute(migration_table_command)
        end
      end
    end


    task :prepare => :environment do
      ['development', 'test'].each do |environment|
        db_config = Rails.configuration.database_configuration[environment].dup

        ActiveRecord::Base.establish_connection(db_config).with_connection do |connection|
          # connection.execute("CREATE SCHEMA #{db_config['database']}")
          # connection.execute("CREATE TABLE #{db_config['database']}.schema_migrations(version varchar(255) NOT NULL PRIMARY KEY)")

          connection.execute("CREATE TABLE schema_migrations(version varchar(255) NOT NULL PRIMARY KEY)")
        end

      end
    end


    task :destroy_all => :environment do
      ['development'].each do |environment|
        db_config = Rails.configuration.database_configuration[environment].dup
        schema_name = db_config['schema']

        ActiveRecord::Base.establish_connection.with_connection do |connection|
          schemas = connection.execute("SELECT ssc.schemaname FROM SYS.SYSSCHEMAS ssc where ssc.schemaname not in (SELECT sc.schemaname FROM SYS.SYSSCHEMAS sc where sc.schemaname like 'SYS%' OR sc.schemaname like 'SQL%')
").map {|t| t['schemaname']}

          schemas.each do |schema|
            puts "Schema: #{schema}"
            tables = connection.execute("select ts.tablename from sys.systables ts where ts.tablename not in (select t.tablename from sys.systables t where t.tablename like 'SYS%')").map {|t| t['tablename']}

            tables.each do |table|
              begin
                connection.execute("DROP TABLE #{schema}.#{table}")
                puts "#{table} dropped."
              rescue => e
                puts "#{table} skipped."
              end
            end
          end
        end
      end
    end


  end
end
