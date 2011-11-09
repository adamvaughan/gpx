App.Helpers.metersToFeet = (meters) ->
  meters * 3.2808399

App.Helpers.feetToMiles = (feet) ->
  feet / 5280

App.Helpers.metersToMiles = (meters) ->
  App.Helpers.feetToMiles(App.Helpers.metersToFeet(meters))

App.Helpers.secondsPerMeterToSecondsPerMile = (secondsPerMeter) ->
  secondsPerMeter * 1609.344

App.Helpers.metersPerSecondToMilesPerHour = (metersPerSecond) ->
  metersPerSecond * 2.23693629
