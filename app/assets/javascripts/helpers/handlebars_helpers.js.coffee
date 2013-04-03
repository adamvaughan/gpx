Handlebars.registerHelper 'formatDistance', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(App.Helpers.metersToMiles(value), 1, ',')

Handlebars.registerHelper 'formatDuration', (value) ->
  if _.isUndefined(value)
    '--'
  else
    App.Helpers.formatTime(value)

Handlebars.registerHelper 'formatSpeed', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(App.Helpers.metersPerSecondToMilesPerHour(value), 1, ',')

Handlebars.registerHelper 'formatPace', (value) ->
  if _.isUndefined(value)
    '--'
  else
    App.Helpers.formatTime(App.Helpers.secondsPerMeterToSecondsPerMile(value))

Handlebars.registerHelper 'formatElevation', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(App.Helpers.metersToFeet(value), 0, ',')

Handlebars.registerHelper 'formatHeartRate', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(value, 0, ',')

Handlebars.registerHelper 'formatCadence', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(value, 0, ',')

Handlebars.registerHelper 'formatDateTime', (value) ->
  if _.isUndefined(value)
    ''
  else
    value = new Date(value * 1000)
    value.toString('MMMM d, yyyy - h:mm ') + value.toString('tt').toLowerCase()

Handlebars.registerHelper 'formatDate', (value) ->
  if _.isUndefined(value)
    ''
  else
    value = new Date(value * 1000)
    value.toString('MMMM d, yyyy')

Handlebars.registerHelper 'formatShortDate', (date) ->
  if date.getFullYear() == Date.today().getFullYear()
    date.toString("MMM d")
  else
    date.toString("MMM d, yyyy")

Handlebars.registerHelper 'formatNumber', (value) ->
  if _.isUndefined(value)
    '--'
  else
    accounting.formatNumber(value, 0, ',')

Handlebars.registerHelper 'formatRideCount', (value) ->
  if value == 1
    "#{value} Ride"
  else
    "#{value} Rides"
