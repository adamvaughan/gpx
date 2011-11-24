class App.Views.SegmentDetailView extends Backbone.View
  tagName: 'div'

  className: 'segment-detail-view loading'

  events:
    'click a[rel=back]': 'back'
    'click a[rel=edit]': 'edit'
    'click a[rel=delete]': 'delete'
    'click .delete-confirmation input[rel=confirm]': 'confirmDelete'
    'click .delete-confirmation input[rel=cancel]': 'cancelDelete'
    'keypress input[type=text]': 'save'
    'blur input[type=text]': 'cancel'
    'click ul.tabs a': 'selectPlotFor'
    'click ul.pills a': 'selectPlotBy'

  initialize: ->
    $(document).bind 'keydown', @cancel
    $(document).bind 'keydown', @cancelDeleteOnKeydown
    @loadPoints()

  render: =>
    $(@el).html JST['segment_detail_view'](@model.toJSON())
    @

  back: (event) =>
    event.preventDefault()
    window.location.hash = ''

  edit: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'
    $(@el).removeClass 'deleting'
    @toggleEditInPlace()

  delete: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'
    $(@el).addClass 'deleting'

  confirmDelete: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'

    window.busy(true)
    @model.destroy
      success: =>
        window.busy(false)
        window.location.hash = ''
      error: =>
        window.busy(false)
        $(@el).addClass 'error'
        $(@el).find('div.error-message').html('An unknown error has occurred. Please try again.')

  cancelDelete: (event) =>
    event.preventDefault() unless event.which?
    $(@el).removeClass 'deleting'
    $(@el).removeClass 'error'

  cancelDeleteOnKeydown: (event) =>
    if (not event.which? or event.which == 27) and @isDeleting()
      $(@el).removeClass 'deleting'
      $(@el).removeClass 'error'

  save: (event) =>
    if event.which == 13 and @isEditing()
      event.preventDefault()
      value = $.trim $(@el).find('h1 input[type=text]').val()

      if value == @model.get('name')
        @toggleEditInPlace()
      else
        window.busy(true)
        @model.save { name: value },
          success: =>
            window.busy(false)
            $(@el).find('h1 p').html(value)
            @toggleEditInPlace()
          error: (model, error) =>
            window.busy(false)
            if @isEditing()
              $(@el).addClass 'error'

              if _.isString error
                $(@el).find('div.error-message').html(error)
              else
                $(@el).find('div.error-message').html('An unknown error has occurred. Please try again.')

  cancel: (event) =>
    if (not event.which? or event.which == 27) and @isEditing()
      @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).toggleClass 'editing'
    $(@el).removeClass 'error'

    if $(@el).is('.editing')
      p = $(@el).find('h1 p')
      input = $(@el).find('h1 input[type=text]')

      input.val $.trim(p.text())
      input.focus().select()

  isEditing: =>
    $(@el).is('.editing')

  isDeleting: =>
    $(@el).is('.deleting')

  loadPoints: =>
    window.busy(true)
    @points = new App.Collections.PointCollection(href: @model.get('points_href'))
    @points.bind 'reset', @showChart
    @points.fetch
      error: =>
        window.busy(false)
        $(@el).find('#chart').show().html('<p class="error-message">Unable to load the chart data. Please try again.</p>')
      success: =>
        window.busy(false)

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
    plotFor = $(@el).find('ul.tabs li.active a').attr('rel')
    plotBy = $(@el).find('ul.pills li.active a').attr('rel')
    $(@el).removeClass 'loading'
    $(@el).find('#chart').empty()
    $(@el).find('.pills').show()

    chartView = switch plotFor
      when 'map'
        $(@el).find('.pills').hide()
        new App.Views.MapView(points: @points)
      when 'elevation'
        switch plotBy
          when 'distance' then new App.Views.ElevationDistanceChartView(points: @points)
          when 'active-time' then new App.Views.ElevationActiveTimeChartView(points: @points)
          else new App.Views.ElevationTimeChartView(points: @points)
      when 'speed'
        switch plotBy
          when 'distance' then new App.Views.SpeedDistanceChartView(points: @points)
          when 'active-time' then new App.Views.SpeedActiveTimeChartView(points: @points)
          else new App.Views.SpeedTimeChartView(points: @points)
      when 'pace'
        switch plotBy
          when 'distance' then new App.Views.PaceDistanceChartView(points: @points)
          when 'active-time' then new App.Views.PaceActiveTimeChartView(points: @points)
          else new App.Views.PaceTimeChartView(points: @points)

    chartView.render()
