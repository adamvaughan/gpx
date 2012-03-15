Handlebars.registerHelper 'formatDistance', (value) ->
  accounting.formatNumber(App.Helpers.metersToMiles(value), 1, ',')

Handlebars.registerHelper 'formatDuration', (value) ->
  App.Helpers.formatTime(value)

Handlebars.registerHelper 'formatSpeed', (value) ->
  accounting.formatNumber(App.Helpers.metersPerSecondToMilesPerHour(value), 1, ',')

Handlebars.registerHelper 'formatPace', (value) ->
  App.Helpers.formatTime(App.Helpers.secondsPerMeterToSecondsPerMile(value))

Handlebars.registerHelper 'formatElevation', (value) ->
  accounting.formatNumber(App.Helpers.metersToFeet(value), 0, ',')

Handlebars.registerHelper 'formatHeartRate', (value) ->
  accounting.formatNumber(value, 0, ',')

Handlebars.registerHelper 'formatDateTime', (value) ->
  value = new Date(value * 1000)
  value.toString('MMMM d, yyyy - h:mm ') + value.toString('tt').toLowerCase()

Handlebars.registerHelper 'formatNumber', (value) ->
  accounting.formatNumber(value, 0, ',')
