class App.Views.Summary.WeeklySummaryView extends Backbone.View
  initialize: ->
    @calendar = {}

  render: =>
    $(@el).html JST['templates/summary/weekly_summary_view'](@calendar)
    @loadRides() unless @calendar.weeks?
    @

  loadRides: =>
    endDate = Date.today()
    endDate = endDate.add(days: 6 - endDate.getDay()) unless endDate.getDay() == 6
    startDate = endDate.clone().add(days: -28)

    rides = new App.Collections.RideCollection(from: startDate, to: endDate)
    rides.fetch
      success: =>
        @generateCalendar(rides)

  generateCalendar: (rides) =>
    @calendar = weeks: []
    date = new Date()

    for week in [0..3]
      @calendar.weeks.push
        days: []
        totals:
          distance: 0
          duration: 0

      weekData = @calendar.weeks[week]

      for day in [0..6]
        currentDate = date.clone().add(days: ((week * -7) + day) - date.getDay())
        ridesOnDate = rides.getByDate(currentDate)

        weekData.days.push
          class: ''
          date: currentDate

        dayData = weekData.days[day]

        if ridesOnDate.length > 0
          dayData.class = 'ride'
          dayData.distance = _.reduce ridesOnDate, ((sum, ride) ->
            sum + parseFloat(ride.get('distance'))), 0
          dayData.duration = _.reduce ridesOnDate, ((sum, ride) ->
            sum + parseFloat(ride.get('active_duration'))), 0

          weekData.totals.distance += dayData.distance
          weekData.totals.duration += dayData.duration

    @render()
