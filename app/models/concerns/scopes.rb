module Scopes
  extend ActiveSupport::Concern
  RANGE_MAP = {
    Consts::PeriodEnum::DAY => ->(ref) { ref.beginning_of_day..ref.end_of_day },
    Consts::PeriodEnum::WEEK => ->(ref) { ref.beginning_of_week..ref.end_of_week },
    Consts::PeriodEnum::MONTH => ->(ref) { ref.beginning_of_month..ref.end_of_month },
    Consts::PeriodEnum::QUARTER => ->(ref) { ref.beginning_of_quarter..ref.end_of_quarter },
    Consts::PeriodEnum::YEAR => ->(ref) { ref.beginning_of_year..ref.end_of_year }
  }.freeze
  PREVIOUS_MAP = {
    Consts::PeriodEnum::DAY => ->(ref) { ref - 1.day },
    Consts::PeriodEnum::WEEK => ->(ref) { ref - 1.week },
    Consts::PeriodEnum::MONTH => ->(ref) { ref - 1.month },
    Consts::PeriodEnum::QUARTER => ->(ref) { ref - 3.months },
    Consts::PeriodEnum::YEAR => ->(ref) { ref - 1.year }
  }.freeze
  DATE_FORMAT = {
    Consts::PeriodEnum::DAY     => "%H:00",
    Consts::PeriodEnum::WEEK    => "%a %d",
    Consts::PeriodEnum::MONTH   => "%d %b",
    Consts::PeriodEnum::QUARTER => "%x-W%v",
    Consts::PeriodEnum::YEAR    => "%b"
  }.freeze


  included do
    scope :count_current, ->(range) {
      where(:created_at => range).count
    }
    scope :count_before, ->(range) {
      where(:created_at => range).count
    }
    scope :growth, ->(relation, period) {  relation.call(period)  }
    scope :chart, ->(relation, period) {  relation.time_series(period)  }
  end

  class_methods do
    Growth = Struct.new(:title, :percent_growth, :total, :current, keyword_init: true)
    TimeSeries = Struct.new(:title, :from, :to, :max, :min, :data, keyword_init: true)
    Series =  Struct.new(:labels, :values, keyword_init: true)
    def time_series(period, from = nil, to = nil)
      format = DATE_FORMAT[period]
      range = from && to ? Time.zone.parse(from)..Time.zone.parse(to) : self.current(period)
      grouped = relation
        .where(:created_at => range)
        .group(Arel.sql("DATE_FORMAT(created_at, '#{format}')"))
        .order(Arel.sql("MIN(created_at)"))
        .count

      labels = grouped.keys
      values = grouped.values

      TimeSeries.new(
        title: "Title",
        from: range.first.iso8601,
        to: range.last.iso8601,
        max: max_point(labels, values),
        min: min_point(labels, values),
        data: Series.new(labels: labels, values: values)
      )
    rescue StandardError => e
      Rails.logger.error("ChartStat error: #{e.message}")
      TimeSeries.new(title: "Title", data: Series.new(labels: [], values: []))
    end
    def call(period)
      current_count = self.count_current(self.current(period))
      before_count  = self.count_current(self.previous(period))
      percent_growth = before_count.zero? ? 100.0 : ((current_count - before_count).to_f / before_count) * 100
      Growth.new(
        title: "Growth",
        percent_growth: percent_growth.round(2),
        total: current_count + before_count,
        current: current_count
      )
    rescue StandardError => e
      Rails.logger.error("GrowthStat error: #{e.message}")
      Growth.new(title: "Growth", percent_growth: 0, total: 0, current: 0)
    end

    private
    def current(period, reference_time = Time.current)
      raise BusinessException.new("400|Invalid period: #{period}") unless Consts::PeriodEnum.valid?(period)

      RANGE_MAP[period].call(reference_time)
    end
    def previous(period, reference_time = Time.current)
      raise BusinessException.new("400|Invalid period: #{period}") unless Consts::PeriodEnum.valid?(period)

      previous_ref = PREVIOUS_MAP[period].call(reference_time)
      RANGE_MAP[period].call(previous_ref)
    end
    def max_point(labels, values)
      return nil if values.empty?
      idx = values.each_with_index.max_by { |v, _| v }[1]
      { label: labels[idx], value: values[idx] }
    end
    def min_point(labels, values)
      return nil if values.empty?
      idx = values.each_with_index.min_by { |v, _| v }[1]
      { label: labels[idx], value: values[idx] }
    end
  end
end