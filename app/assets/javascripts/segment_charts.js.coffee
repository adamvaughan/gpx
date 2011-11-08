$ ->
  if $('body.segments.show').length > 0
    request = $.get("#{window.location.href}/points")
    request.success (points) =>
      elevationTimeData = []
      elevationDistanceData = []
      speedTimeData = []
      speedDistanceData = []
      paceTimeData = []
      paceDistanceData = []
      timezoneOffset = (new Date()).getTimezoneOffset() * 60000

      _.each points, (point) =>
        # convert seconds to milliseconds
        time = point.duration * 1000

        # convert meters to miles
        distance = point.distance * 0.000621371192

        # convert meters to feet
        elevation = point.elevation * 3.2808399

        # convert meters/second to miles/hour
        speed = point.speed * 2.23693629

        # convert second/meter to minute/mile
        pace = point.pace * 26.8224

        elevationTimeData.push [time, elevation]
        elevationDistanceData.push [distance, elevation]
        speedTimeData.push [time, speed]
        speedDistanceData.push [distance, speed]
        paceTimeData.push [time, pace]
        paceDistanceData.push [distance, pace]

      reduceData = (data) ->
        threshold = 0.5
        result = []

        for i in [0..data.length]
          if i < data.length - 1
            point = data[i]
            nextPoint = data[i + 1]
            distance = Math.sqrt(Math.pow(nextPoint[0] - point[0], 2) + Math.pow(nextPoint[1] - point[1], 2))
            result.push point if distance > threshold

        result

      smoothData = (data) ->
        reducedData = reduceData(data)
        result = []

        for i in [0..reducedData.length]
          if i == 0 or i > reducedData.length - 2
            result.push reducedData[i]
          else
            x = (reducedData[i - 1][0] + (2 * reducedData[i][0]) + reducedData[i + 1][0]) / 4
            y = (reducedData[i - 1][1] + (2 * reducedData[i][1]) + reducedData[i + 1][1]) / 4
            result.push [x, y]

        result

      Highcharts.setOptions({
        plotOptions:
          series:
            animation: false
        chart:
          renderTo: 'chart'
          type: 'spline'
          width: 900
          height: 300
        legend:
          enabled: false
        credits:
          enabled: false
        title:
          text: ''
      })

      elevationTimeChartOptions =
        xAxis:
          title:
            text: 'Time'
          type: 'datetime'
          dateTimeLabelFormats:
            hour: '%H:%M'
            minute: '%H:%M'
        yAxis:
          title:
            text: 'Elevation (ft)'
        tooltip:
          formatter: ->
            "<strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Elevation'
          data: elevationTimeData
        }]

      elevationDistanceChartOptions =
        xAxis:
          title:
            text: 'Distance (miles)'
        yAxis:
          title:
            text: 'Elevation (ft)'
        tooltip:
          formatter: ->
            "<strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Elevation'
          data: elevationDistanceData
        }]

      speedTimeChartOptions =
        xAxis:
          title:
            text: 'Time'
          type: 'datetime'
          dateTimeLabelFormats:
            hour: '%H:%M'
            minute: '%H:%M'
        yAxis:
          title:
            text: 'Speed (mph)'
        tooltip:
          formatter: ->
            "<strong>Speed:</strong>#{Highcharts.numberFormat(this.y, 1)} mph"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Speed'
          data: smoothData(speedTimeData, 1)
        }]

      speedDistanceChartOptions =
        xAxis:
          title:
            text: 'Distance (miles)'
        yAxis:
          title:
            text: 'Speed (mph)'
        tooltip:
          formatter: ->
            "<strong>Speed:</strong>#{Highcharts.numberFormat(this.y, 1)} mph"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Speed'
          data: smoothData(speedDistanceData, 1)
        }]

      paceTimeChartOptions =
        xAxis:
          title:
            text: 'Time'
          type: 'datetime'
          dateTimeLabelFormats:
            hour: '%H:%M'
            minute: '%H:%M'
        yAxis:
          title:
            text: 'Pace (min/mile)'
        tooltip:
          formatter: ->
            "<strong>Pace:</strong>#{Highcharts.numberFormat(this.y, 1)} min/mile"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Pace'
          data: smoothData(paceTimeData, 1)
        }]

      paceDistanceChartOptions =
        xAxis:
          title:
            text: 'Distance (miles)'
        yAxis:
          title:
            text: 'Pace (min/mile)'
        tooltip:
          formatter: ->
            "<strong>Pace:</strong>#{Highcharts.numberFormat(this.y, 1)} min/mile"
        series: [{
          marker:
            enabled: false
            fillColor: '#444'
            symbol: 'circle'
            radius: 4
            lineWidth: 2
            states:
              hover:
                enabled: true
          lineWidth: 3
          shadow: false
          states:
            hover:
              lineWidth: 3
          name: 'Pace'
          data: smoothData(paceDistanceData, 1)
        }]

      showChart = () =>
        plotBy = if $('.pills .active a').is('.distance') then 'distance' else 'time'

        if $('.tabs .active a').is('.elevation')
          if plotBy == 'distance'
            chart = new Highcharts.Chart(elevationDistanceChartOptions)
          else
            chart = new Highcharts.Chart(elevationTimeChartOptions)
        else if $('.tabs .active a').is('.speed')
          if plotBy == 'distance'
            chart = new Highcharts.Chart(speedDistanceChartOptions)
          else
            chart = new Highcharts.Chart(speedTimeChartOptions)
        else if $('.tabs .active a').is('.pace')
          if plotBy == 'distance'
            chart = new Highcharts.Chart(paceDistanceChartOptions)
          else
            chart = new Highcharts.Chart(paceTimeChartOptions)

      showChart()

      $('ul.tabs a').click (event) =>
        event.preventDefault()
        $('ul.tabs li.active').removeClass('active')
        $(event.target).closest('li').addClass('active')

        $('ul.pills li.active').removeClass('active')
        $('ul.pills a.distance').closest('li').addClass('active')
        showChart()


      $('ul.pills a').click (event) =>
        event.preventDefault()
        $('ul.pills li.active').removeClass('active')
        $(event.target).closest('li').addClass('active')
        showChart()
