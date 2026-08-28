module Scopes
  extend ActiveSupport::Concern
  RANGE_MAP = {
    Consts::PeriodEnum::DAY => ->(date_val) { date_val.beginning_of_day..date_val.end_of_day },
    Consts::PeriodEnum::WEEK => ->(date_val) { date_val.beginning_of_week..date_val.end_of_week },
    Consts::PeriodEnum::MONTH => ->(date_val) { date_val.beginning_of_month..date_val.end_of_month },
    Consts::PeriodEnum::QUARTER => ->(date_val) { date_val.beginning_of_quarter..date_val.end_of_quarter },
    Consts::PeriodEnum::YEAR => ->(date_val) { date_val.beginning_of_year..date_val.end_of_year }
  }.freeze
  PREVIOUS_MAP = {
    Consts::PeriodEnum::DAY => ->(from_date) { from_date - 1.day },
    Consts::PeriodEnum::WEEK => ->(from_date) { from_date - 1.week },
    Consts::PeriodEnum::MONTH => ->(from_date) { from_date - 1.month },
    Consts::PeriodEnum::QUARTER => ->(from_date) { from_date - 3.months },
    Consts::PeriodEnum::YEAR => ->(from_date) { from_date - 1.year }
  }.freeze
  DATE_FORMAT = {
    Consts::PeriodEnum::DAY     => "%H:00", # 00
    Consts::PeriodEnum::WEEK    => "%a-%d", # Fri-01
    Consts::PeriodEnum::MONTH   => "%d-%m", # 01-01
    Consts::PeriodEnum::QUARTER => "%x-Week%v", # 01-Week01
    Consts::PeriodEnum::YEAR    => "%b" # 2026
  }.freeze


  included do
    scope :growth, ->(relation, period) {  relation.stats_growth(period)  }
    scope :chart, ->(relation, period) {  relation.time_series(period)  }
    scope :destroy_many, ->(ids) { where(id: ids).destroy_all }
    scope :count_current, ->(range) {
      where(created_at: range).count
    }
    scope :count_before, ->(range) {
      where(created_at: range).count
    }
  end

  class_methods do
    Growth = Struct.new(:title, :percent_growth, :total, :current, keyword_init: true)
    TimeSeries = Struct.new(:title, :from, :to, :max, :min, :data, keyword_init: true)
    Series =  Struct.new(:labels, :values, keyword_init: true)

    def time_series(period)
      format = DATE_FORMAT[period]
      range = current(period)
      grouped = relation
        .where(created_at: range)
        .group("DATE_FORMAT(created_at, '#{format}')")
        .order("MIN(created_at)")
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

    def stats_growth(period)
      current_count = count_current(current(period))
      before_count  = count_current(previous(period))
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
    def current(period)
      raise BusinessException.new("400|Invalid period: #{period}") unless Consts::PeriodEnum.valid?(period)

      RANGE_MAP[period].call(Time.now)
    end
    def previous(period)
      raise BusinessException.new("400|Invalid period: #{period}") unless Consts::PeriodEnum.valid?(period)

      previous_from = PREVIOUS_MAP[period].call(Time.now)
      RANGE_MAP[period].call(previous_from)
    end
    def max_point(labels, values)
      return nil if values.empty?
      max_point_index = values.each_with_index.max_by { |idx, _| idx }[1]
      { label: labels[max_point_index], value: values[max_point_index] }
    end
    def min_point(labels, values)
      return nil if values.empty?
      min_point_index = values.each_with_index.min_by { |idx, _| idx }[1]
      { label: labels[min_point_index], value: values[min_point_index] }
    end
  end
end
