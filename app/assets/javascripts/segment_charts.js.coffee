$ ->
  if $('body.segments.show').length > 0
    request = $.get("#{window.location.href}/points")
    request.success (points) ->
      data = []
      timezoneOffset = (new Date()).getTimezoneOffset() * 60000

      _.each points, (point) ->
        date = point.epoch_time * 1000
        elevation = point.elevation * 3.2808399
        data.push [date, elevation]

      window.elevationChart = new Highcharts.Chart
        chart:
          renderTo: 'elevation_chart'
          type: 'spline'
          width: 900
          height: 300
        legend:
          enabled: false
        credits:
          enabled: false
        title:
          text: ''
        xAxis:
          title:
            text: 'Time'
          type: 'datetime'
          dateTimeLabelFormats:
            hour: '%l:%M %P'
            minute: '%l:%M %P'
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
          data: data
        }]
