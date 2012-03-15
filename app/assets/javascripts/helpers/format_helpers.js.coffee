App.Helpers.formatTime = (seconds) ->
  hours = 0
  minutes = 0
  seconds ||= 0

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

  if hours > 0
    "#{hours}:#{pad(minutes)}:#{pad(Math.floor(seconds))}"
  else
    "#{minutes}:#{pad(Math.floor(seconds))}"
