module Consts
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
  module PeriodEnum
    DAY     = "day"
    WEEK    = "week"
    MONTH   = "month"
    QUARTER = "quarter"
    YEAR    = "year"

    ALL = [DAY, WEEK, MONTH, QUARTER, YEAR].freeze

    def self.valid?(value)
      ALL.include?(value)
    end
  end
end