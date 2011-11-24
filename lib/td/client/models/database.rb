
module TreasureData

  class DatabaseCollection < ModelCollection
    def [](name)
      Database.new(@client, name)
    end

    def to_a
      names = api.database_list
      names.map {|name|
        Database.new(@client, name)
      }
    end
  end

  class Database < Model
    def initialize(client, name)
      super(client)
      @name = name
    end

    attr_reader :name

    def create!
      api.database_create(@name)
      self
    end

    def delete!
      api.database_delete(@name)
      nil
    end

    def exists?
      names = api.database_list
      names.include?(@name)
    end
    alias exist? exists?

    def tables
      TableCollection.new(@client, @name)
    end

    def get_tables
      tables.to_a
    end

    def query(sql)
      job_id = api.hive_query(sql, @name)
      Job.new(@client, job_id)
    end
  end

end

