
module TreasureData
  require 'td/client/api'
  require 'td/client/models'

  class Client
    def initialize(apikey)
      @apikey = apikey
      @api = API.new(apikey)
    end

    attr_reader :apikey

    def self.authenticate(user, password)
      apikey = API.new(nil).authenticate(user, password)
      new(apikey)
    end

    def databases
      DatabaseCollection.new(self)
    end

    def get_databases
      databases.to_a
    end

    def create_database(name)
      databases[name].create!
    end

    def delete_database(name)
      databases[name].delete!
    end

    def database_exists?
      databases[name].exists?
    end

    def tables(dbname)
      TableCollection.new(self, dbname)
    end

    def get_tables(dbname)
      tables(dbname).to_a
    end

    def create_table(dbname, tblname)
      tables(dbname)[tblname].create!
    end

    def delete_table(dbname, tblname)
      tables(dbname)[tblname].delete!
    end

    def table_exists?(dbname, tblname)
      tables(dbname)[tblname].exists?
    end

    def get_table_count(dbname, tblname)
      tables(dbname)[tblname].count
    end

    def get_table_schema(dbname, tblname)
      tables(dbname)[tblname].schema
    end

    def set_table_schema(dbname, tblname, schema)
      tables(dbname)[tblname].set_schema(schema)
    end

    def import(dbname, tblname, format, stream, size)
      tables(dbname)[tblname].import(format, stream, size)
    end

    ## TODO
    #def tail
    #end

    def result_sets
      ResultSetCollection.new(self)
    end

    def get_result_sets
      result_sets.to_a
    end

    def create_result_set(name)
      result_sets[name].create!
    end

    def delete_result_set(name)
      result_sets[name].delete!
    end

    def result_set_exists?
      result_sets[name].exists?
    end

    def query(dbname, sql)
      # TODO => Job
    end

    def jobs
      JobCollection.new(self)
    end

    def get_jobs(*args)
      jobs[*args].to_a
    end

    def get_job(job_id)
      jobs[job_id]
    end

    def kill_job(job_id)
      jobs[job_id].kill
    end

    def schedules
      ScheduleCollection.new(self)
    end

    def get_schedules
      schedules.to_a
    end

    def create_schedule(name, cron, opts)
      schedules[name].create!(cron, opts)
    end

    def delete_schedule(name)
      schedules[name].delete!
    end

    def schedule_exists?(name)
      schedules[name].exists?
    end

    def history(schedule_name, *args)
      schedules[name].history[*args]
    end

    def get_history(schedule_name, *args)
      get_history.to_a
    end
  end
end

