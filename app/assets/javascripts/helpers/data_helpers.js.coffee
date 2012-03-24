App.Helpers.movingAverage = (data) =>
  points = []
  window = []
  total = 0

  _.each data, (point) ->
    window.push point
    total += point
    total -= window.shift() if window.length > 10
    points.push (total / window.length)

  points
