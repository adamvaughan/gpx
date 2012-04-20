class App.Views.Rides.ElevationChartView extends Backbone.View
  events:
    'click .menu a': 'selectChart'

  initialize: (options) ->
    @points = options.points

  render: =>
    @renderChart 'distance'
    @

  renderChart: (type) =>
    $(@el).find('.menu a.selected').removeClass 'selected'
    $(@el).find(".menu a[rel='#{type}']").addClass 'selected'

    chartContainer = $(@el).find '.chart-container'
    margin = top: 0, bottom: 40, left: 60, right: 20
    width = chartContainer.width() - margin.left - margin.right
    height = chartContainer.height() - margin.top - margin.bottom

    container = chartContainer.get(0)

    switch type
      when 'distance' then data = @distanceDataPoints()
      when 'elapsedTime' then data = @elapsedTimeDataPoints()

    chart = @createChart container, width, height, margin
    x = @createXScale data, type, width
    y = @createYScale data, height

    @createXAxis chart, type, x, height
    @createYAxis chart, y, width
    @createArea chart, data, x, y, height
    @createLine chart, data, x, y

  createChart: (container, width, height, margin) =>
    svg = d3.select(container).select('svg')

    if svg.empty()
      svg = d3.select(container).append('svg:svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)

    chart = svg.select('.line-chart')

    if chart.empty()
      chart = svg.append('svg:g')
        .attr('class', 'line-chart')
        .attr('transform', "translate(#{margin.left}, #{margin.top})")

    chart

  createXScale: (data, type, width) =>
    maxX = d3.max data, (d) -> d[0]
    minX = d3.min data, (d) -> d[0]

    if type == 'elapsedTime'
      d3.time.scale()
        .domain([minX, maxX])
        .range([0, width])
    else
      d3.scale.linear()
        .domain([minX, maxX])
        .range([0, width])

  createYScale: (data, height) =>
    maxY = d3.max(data, (d) -> d[1]) + 200
    minY = d3.min(data, (d) -> d[1]) - 200
    minY = 0 if minY < 0

    d3.scale.linear()
      .domain([minY, maxY])
      .range([height, 0])

  createXAxis: (chart, type, x, height) =>
    xAxisGroup = chart.select('.x.axis')

    xAxis = d3.svg.axis()
      .scale(x)
      .tickPadding(10)

    xAxis.tickFormat(d3.time.format('%H:%M')) if type == 'elapsedTime'

    if xAxisGroup.empty()
      chart.append('svg:g')
        .attr('class', 'x axis')
        .attr('transform', "translate(0, #{height})")
        .call(xAxis)
    else
      xAxisGroup.call(xAxis)

  createYAxis: (chart, y, width) =>
    yAxisGroup = chart.select('.y.axis')

    if yAxisGroup.empty()
      yAxis = d3.svg.axis()
        .scale(y)
        .orient('left')
        .tickSize(-width)
        .tickPadding(10)
        .ticks(7)

      chart.append('svg:g')
        .attr('class', 'y axis')
        .call(yAxis)

  createArea: (chart, data, x, y, height) =>
    areaPath = chart.select('.area')

    area = d3.svg.area()
      .x((d) -> x(d[0]))
      .y0(height)
      .y1((d) -> y(d[1]))
      .interpolate('cardinal')

    if areaPath.empty()
      chart.append('svg:path')
        .attr('class', 'area')
        .attr('d', area(data))
    else
      chart.select('.area')
        .attr('d', area(data))

  createLine: (chart, data, x, y) =>
    linePath = chart.select('.line')

    line = d3.svg.line()
      .x((d) -> x(d[0]))
      .y((d) -> y(d[1]))
      .interpolate('cardinal')

    if linePath.empty()
      chart.append('svg:path')
        .attr('class', 'line')
        .attr('d', line(data))
    else
      chart.select('.line')
        .attr('d', line(data))

  selectChart: (event) =>
    event.preventDefault()
    @renderChart $(event.target).closest('a').attr('rel')

  distanceDataPoints: =>
    return @pointsByDistance if @pointsByDistance?
    distances = []
    elevations = []

    @points.each (point) =>
      if point.isActive()
        distances.push App.Helpers.metersToMiles(point.get('distance'))
        elevations.push App.Helpers.metersToFeet(point.get('elevation'))

    @pointsByDistance = _.zip distances, elevations

  elapsedTimeDataPoints: =>
    return @pointsByElapsedTime if @pointsByElapsedTime?
    times = []
    elevations = []

    @points.each (point) =>
      if point.isActive()
        time = point.get('active_duration') * 1000
        date = new Date(1970, 0, 1).add(milliseconds: time)

        if time > 0
          times.push date
          elevations.push App.Helpers.metersToFeet(point.get('elevation'))

    @pointsByElapsedTime = _.zip times, elevations
