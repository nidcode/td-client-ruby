
module TreasureData
  autoload :Model,               'td/client/model'
  autoload :ModelCollection,     'td/client/model'
  autoload :ModelPager,          'td/client/model'

  autoload :DatabaseCollection,  'td/client/models/database'
  autoload :Database,            'td/client/models/database'

  autoload :TableCollection,     'td/client/models/client/table'
  autoload :Table,               'td/client/models/client/table'
  autoload :Schema,              'td/client/models/client/table'

  autoload :ResultSet,           'td/client/models/client/result_set'
  autoload :ResultSetCollection, 'td/client/models/client/result_set'

  autoload :JobPager,            'td/client/models/client/job'
  autoload :Job,                 'td/client/models/client/job'

  autoload :ScheduleCollection,  'td/client/models/client/schedule'
  autoload :Schedule,            'td/client/models/client/schedule'
  autoload :ScheduledJobPager,   'td/client/models/client/schedule'
  autoload :ScheduledJob,        'td/client/models/client/schedule'
end

