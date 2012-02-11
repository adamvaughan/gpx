App.Helpers.formatAmount = (value) ->
  return '--' if _.isUndefined(value) or _.isNaN(value)
  originalValue = value
  value = Math.abs(value) + ''
  start = value.indexOf('.', 0) + 1

  addCommas = (value) ->
    expression = /(\d+)(\d{3})/
    value = value.replace(expression, '$1' + ',' + '$2') while expression.test(value)
    value

  parts = value.split('.');
  parts[0] = '0' if parts[0].length == 0

  if parts.length == 2
    parts[1] = parts[1] + '0' while parts[1].length < 2
    parts[1] = parts[1].substr(0, 2) if parts[1].length > 2

    value = addCommas(parts[0]) + '.' + parts[1]
  else
    value = addCommas(parts[0]) + '.00'

  if originalValue < 0
    "-#{value})"
  else
    value

App.Helpers.formatLongTime = (seconds) ->
  return '--' if _.isUndefined(seconds) or _.isNaN(seconds)

  time = new Date(seconds * 1000)
  time.addMinutes(time.getTimezoneOffset())
  time.toString('M/d/yyyy h:mm tt').toLowerCase()

App.Helpers.formatTime = (seconds) ->
  return '--' if _.isUndefined(seconds) or _.isNaN(seconds)

  hours = 0
  minutes = 0

  if seconds > 3600
    hours = Math.floor(seconds / 3600)
    seconds = seconds % 3600

  if seconds > 60
    minutes = Math.floor(seconds / 60)
    seconds = seconds % 60

  pad = (value) ->
    value = value + ''
    value = "0#{value}" while value.length < 2
    value

  "#{hours}:#{pad(minutes)}:#{pad(Math.floor(seconds))}"
