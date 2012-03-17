class Api::ReportsController < Api::BaseController
  def totals
    @report = Report.current
    fresh_when @report
  end
end
