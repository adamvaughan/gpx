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

App.Helpers.smoothData = (data) ->
  reducedData = App.Helpers.reduceData(data)
  result = []

  for i in [0..reducedData.length]
    if i == 0 or i > reducedData.length - 2
      result.push reducedData[i]
    else
      x = (reducedData[i - 1][0] + (2 * reducedData[i][0]) + reducedData[i + 1][0]) / 4
      y = (reducedData[i - 1][1] + (2 * reducedData[i][1]) + reducedData[i + 1][1]) / 4
      result.push [x, y]

  result
