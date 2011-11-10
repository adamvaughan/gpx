class App.Views.SegmentDetailView extends Backbone.View
  tagName: 'div'

  className: 'segment-detail-view loading'

  events:
    'click a[rel=back]': 'back'
    'click a[rel=edit]': 'edit'
    'keypress input': 'save'
    'blur input': 'cancel'
    'click ul.tabs a': 'selectPlotFor'
    'click ul.pills a': 'selectPlotBy'

  initialize: ->
    $(document).bind 'keydown', @cancel
    @loadPoints()

  render: =>
    $(@el).html JST['segment_detail_view'](@model.toJSON())
    @

  back: (event) =>
    event.preventDefault()
    window.location.hash = ''

  edit: (event) =>
    event.preventDefault()
    @toggleEditInPlace()

  save: (event) =>
    if event.which == 13 and @isEditing()
      event.preventDefault()
      value = $.trim $(@el).find('h1 input').val()

      if value == @model.get('name')
        @toggleEditInPlace()
      else
        # TODO handle errors
        @model.save { name: value },
          success: =>
            $(@el).find('h1 p').html(value)
            @toggleEditInPlace()

  cancel: (event) =>
    if (not event.which? or event.which == 27) and @isEditing()
      @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).toggleClass 'editing'

    if $(@el).is('.editing')
      p = $(@el).find('h1 p')
      input = $(@el).find('h1 input')

      input.val $.trim(p.text())
      input.focus().select()

  isEditing: =>
    $(@el).is('.editing')

  loadPoints: =>
    @points = new App.Collections.PointCollection(href: @model.get('points_href'))
    @points.bind 'reset', @showChart
    @points.fetch()

  selectPlotFor: (event) =>
    event.preventDefault()
    $(@el).find('ul.tabs li.active').removeClass('active')
    $(event.target).closest('li').addClass('active')

    $(@el).find('ul.pills li.active').removeClass('active')
    $(@el).find('ul.pills a[rel=distance]').closest('li').addClass('active')
    @showChart()

  selectPlotBy: (event) =>
    event.preventDefault()
    $(@el).find('ul.pills li.active').removeClass('active')
    $(event.target).closest('li').addClass('active')
    @showChart()

  showChart: =>
    plotBy = if $(@el).find('ul.pills .active a').is('[rel=distance]') then 'distance' else 'time'
    $(@el).removeClass 'loading'
    $(@el).find('#chart').empty()

    if $(@el).find('ul.tabs li.active a').is('[rel=elevation]')
      if plotBy == 'distance'
        chartView = new App.Views.ElevationDistanceChartView(points: @points)
      else
        chartView = new App.Views.ElevationTimeChartView(points: @points)
    else if $(@el).find('ul.tabs li.active a').is('[rel=speed]')
      if plotBy == 'distance'
        chartView = new App.Views.SpeedDistanceChartView(points: @points)
      else
        chartView = new App.Views.SpeedTimeChartView(points: @points)
    else if $(@el).find('ul.tabs li.active a').is('[rel=pace]')
      if plotBy == 'distance'
        chartView = new App.Views.PaceDistanceChartView(points: @points)
      else
        chartView = new App.Views.PaceTimeChartView(points: @points)

    chartView.render()
