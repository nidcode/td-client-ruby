
module TreasureData

  class Model
    def initialize(client)
      @client = client
    end

    attr_reader :client

    def api
      @client.api
    end
  end

  class ModelCollection < Model
    include Enumerable

    def initialize(client)
      @client = client
    end

    #def [](name)
    #end

    def create(name)
      self[name].create!
    end

    def delete(name)
      self[name].delete!
    end

    def exists?(name)
      self[name].exists?
    end
    alias exist? exists?

    #def to_a
    #end

    def each(&block)
      to_a.each(&block)
    end
  end

  class ModelPager < Model
    def initialize(client)
      @client = client
    end

    def [](*args)
      case args.length
      when 1
        arg = args[0]
        if arg.is_a?(Range)
          # from..to
          get_range(arg.first, arg.last)
        else
          # name
          get_one(name)
        end
      when 2
        # from, num
        get_range(args[0], nil, args[1])
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)"
      end
    end

    def each_page(from=nil, &block)
      while true
        entries, from = get_page(from, nil, nil)
        break unless entries
        yield entries
      end
      nil
    end

    protected
    def get_range(first, last)
      result = []
      from = first
      while true
        entries, from = get_page(from, last, nil)
        break unless entries
        result.concat entries
        break if from <= last
      end
      result
    end

    #def get_page(from, to=nil, max=nil)
    #end

    def get_one(name)
      entries, last = get_page(name, name, 1)
      entries ? entries[0] : nil
    end
  end

end

