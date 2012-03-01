class SummaryView
  constructor: ->
    @drawSparklines()

  drawSparklines: ->
    options =
      spotRadius: 0
      fillColor: '#a9d5de'
      lineColor: '#439aab'
      width: '250px'
      height: '36px'

    @drawSparkline 'speed', options
    @drawSparkline 'pace', options
    @drawSparkline 'elevation', options
    @drawSparkline 'heart-rate', options

  drawSparkline: (measurement, options) ->
    sparkline = $(".summary.#{measurement} .sparkline")
    values = sparkline.data 'values'
    sparkline.removeAttr 'data-values'
    sparkline.sparkline values, options

$ ->
  if $('body.summary.index').length > 0
    new SummaryView()
