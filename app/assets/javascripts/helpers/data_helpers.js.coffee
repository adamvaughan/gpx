App.Helpers.reduceData = (data) =>
  threshold = 0.5
  result = []

  for i in [0..data.length]
    if i < data.length - 1
      point = data[i]
      nextPoint = data[i + 1]
      distance = Math.sqrt(Math.pow(nextPoint[0] - point[0], 2) + Math.pow(nextPoint[1] - point[1], 2))
      result.push point if distance > threshold

  result