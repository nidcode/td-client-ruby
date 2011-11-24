
module TreasureData

  class ResultSetCollection < ModelCollection
    def [](name)
      ResultSet.new(name)
    end

    def to_a
      @client.get_result_sets
    end
  end

  class ResultSet < Model
    def initialize(client, name)
      super(client)
      @name = name
    end

    attr_reader :name

    def create!
      @client.create_result_set(@name)
      self
    end

    def delete!
      @client.delete_result_set(@name)
      nil
    end

    def exists?
      @client.result_set_exists?(@name)
    end
    alias exist? exists?
  end

end
