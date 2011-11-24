
module TreasureData

  class TableCollection < ModelCollection
    def initialize(client, database)
      super(client)
      @database = database
    end

    def [](name)
      Table.new(@client, @database, name)
    end

    def to_a
      begin
        array = api.table_list(@database.name)
        array.map {|(name,count,schema)|
          schema = Schema.load(schema)
          Table.new(@client, @database, name, {'count'=>count, 'schema'=>schema})
        }
      rescue NotFoundError
        []
      end
    end
  end

  class Table < Model
    def initialize(client, database, name, data={})
      super(client)
      @database = database
      @name = name
      @count = data['count']
      @schema = data['schema']
    end

    attr_reader :name
    attr_reader :database

    def create!
      api.table_create(@database.name, @name)
      self
    end

    def delete!
      api.table_delete(@database.name, @name)
      nil
    end

    def exists?
      begin
        realod!
        return true
      rescue NotFoundError
        return false
      end
    end
    alias exist? exists?

    def reload!
      array = api.table_list(@database.name, @name)
      array.map {|(name,count,schema)|
        if name == @name
          @count = count
          @schema = Schema.load(schema)
          return self
        end
      }
      raise NotFoundError, "table not exists"
    end

    def count
      reload! unless @count
      @count
    end

    def get_count
      reload!
      @count
    end

    def schema
      reload! unless @schema
      @schema
    end

    def get_schema
      reload!
      @schema
    end

    def set_schema(schema)
      schema = Schema.dump(schema)
      api.table_update_schema(@database.name, @name, schema)
      @schema = schema
      self
    end

    def import(format, stream, size)
      api.table_import(@database.name, @table.name, format, stream, size)
    end

    ## TODO
    #def tail()
    #end
  end

  class Schema < Hash
    # TODO
    def self.load(array)
      m = new
      array.each {|(name,type)|
        m[name] = type
      }
      m
    end

    def dump(schema)
      schema.each_pair {|name,type|
      }
    end
  end

end
