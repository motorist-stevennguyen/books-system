module Consts
  module PeriodEnum
    DAY     = "day"
    WEEK    = "week"
    MONTH   = "month"
    QUARTER = "quarter"
    YEAR    = "year"

    ALL = [ DAY, WEEK, MONTH, QUARTER, YEAR ].freeze

    def self.valid?(value)
      ALL.include?(value)
    end
  end
  module SortedEnum
        ASC = "asc"
        DESC = "desc"

        ALL = [ ASC, DESC ].freeze

        def self.valid?(value)
          ALL.include?(value)
        end
  end
  module OrderBy
        CREATED_AT = "created_at"
        UPDATED_AT = "updated_at"
        ID = "id"

        ALL = [ CREATED_AT, UPDATED_AT, ID ].freeze

        def self.valid?(value)
          ALL.include?(value)
        end
  end

  module ConfigData
    REDIS_CONFIG = {
      url: ENV.fetch("REDIS_URL", "redis://localhost:6379"),

      connect_timeout: 5,
      read_timeout: 1,
      write_timeout: 1,

      reconnect_attempts: 3
    }.freeze

    REDIS_POOL = ConnectionPool.new(
      size: ENV.fetch("REDIS_POOL_SIZE", 10).to_i,
      timeout: 5
    ) do
      Redis.new(REDIS_CONFIG)
    end
  end
end
