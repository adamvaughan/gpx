class Report < ActiveRecord::Base
  def self.current
    today = Date.today
    report = Report.first || Report.create(:year => today.year, :month => today.month, :week => today.cweek)
    report.year = today.year
    report.month = today.month
    report.week = today.cweek
    report
  end

  def year=(year)
    if read_attribute(:year) != year
      write_attribute(:year, year)
      self.segment_count = 0
      self.year_distance = 0
      self.year_duration = 0
    end
  end

  def month=(month)
    if read_attribute(:month) != month
      write_attribute(:month, month)
      self.month_distance = 0
      self.month_duration = 0
    end
  end

  def week=(week)
    if read_attribute(:week) != week
      write_attribute(:week, week)
      self.week_distance = 0
      self.week_duration = 0
    end
  end
end
