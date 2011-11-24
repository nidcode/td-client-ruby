
module TreasureData

  class JobPager < ModelPager
    protected
    def get_page(from, to=nil, max=nil)
      array = api.job_list(from, to)  # TODO
      entries = array.map {|(job_id,type,status,start_at,end_at)|
        Job.new(@client, job_id, {'status'=>status, 'start_at'=>start_at ? Time.at(start_at) : nil, 'end_at'=>end_at ? Time.at(end_at) : nil})
      }
      return nil if entries.empty?
      return entries, entries.last.job_id
    end

    def get_one(name)
      @client.get_job_one(name)
    end
  end

  class Job < Model
    STATUS_QUEUED = "queued"
    STATUS_BOOTING = "booting"
    STATUS_RUNNING = "running"
    STATUS_SUCCESS = "success"
    STATUS_ERROR = "error"
    STATUS_KILLED = "killed"
    FINISHED_STATUS = [STATUS_SUCCESS, STATUS_ERROR, STATUS_KILLED]

    def initialize(client, job_id, data={})
      super(client)
      @job_id = job_id
      @status = data['status']
      @type = data['type']
      @query = data['query']
      @start_at = data['start_at']
      @end_at = data['end_at']
      @url = data['url']
      @debug = data['debug']
    end

    attr_reader :job_id

    def reload!
      job = @client.get_job(@job_id)
      @status = job.status
      @type = job.type
      @query = job.query
      @start_at && !job.start_at
      @end_at && !job.end_at
      @url && !job.url
      @debug && !job.debug
      self
    end

    def type
      reload! unless @type
      @type
    end

    def query
      reload! unless @query
      @query
    end

    def status
      reload! unless @status
      @status
    end

    def finished?
      FINISHED_STATUS.include?(status)
    end

    def running?
      !finished?
    end

    def success?
      status == "success"
    end

    def error?
      status == "error"
    end

    def killed?
      status == "killed"
    end

    def kill
      @client.kill_job(@job_id)
    end
  end

end
