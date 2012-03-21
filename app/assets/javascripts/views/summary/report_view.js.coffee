class App.Views.Summary.ReportView extends Backbone.View
  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html JST['templates/summary/report_view'](_.extend(@model.toJSON(), { week_start_time: @weekStartTime(), week_end_time: @weekEndTime() }))
    @

  weekStartTime: =>
    startDate = if Date.today().getDay() == 1
                  Date.today()
                else
                  Date.today().moveToDayOfWeek(1, -1)

    startDate.clearTime().getTime() / 1000

  weekEndTime: =>
    endDate = if Date.today().getDay() == 0
                Date.today
              else
                Date.today().moveToDayOfWeek(0, 1)

    endDate.clearTime().getTime() / 1000
