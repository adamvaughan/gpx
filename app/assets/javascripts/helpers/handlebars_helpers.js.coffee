Handlebars.registerHelper 'formatAmount', (value) ->
  App.Helpers.formatAmount(value)

Handlebars.registerHelper 'formatLongTime', (value) ->
  App.Helpers.formatLongTime(value)

Handlebars.registerHelper 'formatTime', (value) ->
  App.Helpers.formatTime(value)

Handlebars.registerHelper 'metersToMiles', (value) ->
  App.Helpers.formatAmount(App.Helpers.metersToMiles(value))

Handlebars.registerHelper 'metersToFeet', (value) ->
  App.Helpers.formatAmount(App.Helpers.metersToFeet(value))

Handlebars.registerHelper 'secondsPerMeterToMinutesPerMile', (value) ->
  App.Helpers.formatTime(App.Helpers.secondsPerMeterToSecondsPerMile(value))

Handlebars.registerHelper 'metersPerSecondToMilesPerHour', (value) ->
  App.Helpers.formatAmount(App.Helpers.metersPerSecondToMilesPerHour(value))
