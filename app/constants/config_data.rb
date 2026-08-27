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
end
