module Configs
  module Redis
    module_function
    def with_redis(&block)
      Consts::ConfigData::REDIS_POOL.with(&block)
    end

    def available?
      with_redis do |redis|
        redis.ping == "PONG"
      end
    rescue StandardError => e
      false
    end

    def info
      with_redis { |redis| redis.info }
    end
  end
end
