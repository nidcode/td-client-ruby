
module TreasureData

  class ScheduleCollection < ModelCollection
    def [](name)
      Schedule.new(@client, name)
    end

    def to_a
      @client.get_schedules
    end

    def create(name, cron, opts)
      self[name].create!(cron, opts)
    end
  end

  class Schedule < Model
    def initialize(client, name, data={})
      super(client)
      @name = name
      @cron = data['cron']
      @delay = data['delay']
      @type = data['type']

      database = data['database']
      @database = database ? Database.new(database) : nil
      @query = data['query']
    end

    attr_reader :name, :cron, :delay, :type
    attr_reader :database, :query

    def create!(cron, opts)
      sched = @client.create_schedule(@name, cron, opts)
      @cron = sched.cron
      @delay = sched.delay
      @type = sched.type
      @database = sched.database
      @query = sched.query
      self
    end

    def delete!
      @client.delete_schedule(name)
    end

    def exists?
      @client.schedule_exists?(name)
    end
    alias exist? exists?

    def history
      ScheduledJobPager.new(@client, @name)
    end

    def get_history(*args)
      history[*args]
    end

    #def last_job
    #  # TODO
    #end
  end

  class ScheduledJobPager < ModelPager
    def initialize(client, schedule_name)
      super(client)
      @schedule_name = schedule_name
    end

    protected
    def get_page(from, to=nil, max=nil)
      entries = @client.get_history(@schedule_name, from, to, max)
      return nil if entries.empty?
      return entries, entries.last.job_id
    end
  end

  class ScheduledJob < Job
    def initialize(client, name, scheduled_at, data={})
      super(client, name, data)
      @scheduled_at = scheduled_at
    end

    attr_reader :scheduled_at
  end

end

