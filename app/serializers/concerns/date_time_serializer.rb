module DateTimeSerializer
  extend ActiveSupport::Concern
  included do
    attributes :created_at, :updated_at

    def created_at
      datetime(object.created_at)
    end

    def updated_at
      datetime(object.updated_at)
    end
  end

  def datetime(val)
    val.in_time_zone("Hanoi").strftime("%Y-%m-%d %H:%M:%S") if val.present?
  end
end
