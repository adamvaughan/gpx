class App.Views.DistanceSummaryView extends Backbone.View
  tagName: 'div'

  className: 'distance-summary-view'

  render: =>
    $(@el).html JST['distance_summary_view']([])

    fileUploadForm = new App.Views.FileUploadForm
    $(@el).find('.upload').append fileUploadForm.render().el

    @totalsView = new App.Views.TotalsView(collection: @collection)
    $(@el).find('.totals').append @totalsView.render().el
    @totalsView.displayDistanceTotals()

    @recordView = new App.Views.RecordView(collection: @collection)
    $(@el).find('.records').append @recordView.render().el
    @recordView.displayDistanceRecords()

    chartView = new App.Views.MonthlyDistanceChartView(collection: @collection)
    chartView.render()

    segmentListView = new App.Views.SegmentListView(collection: @collection)
    $(@el).find('.segments').append segmentListView.render().el

    $(@el).find('.tabs a').click @changeRecordView
    $(@el).find('.pills a').click @changeChartView

    @

  changeRecordView: (event) =>
    event.preventDefault()
    selectedRecordView = $(event.target).closest('a').attr('rel')

    if selectedRecordView == 'duration'
      window.location.hash = '/duration-summary'

  changeChartView: (event) =>
    event.preventDefault()
    activeChartView = $(@el).find('.pills a.active').attr('rel')
    selectedChartView = $(event.target).closest('a').attr('rel')

    if activeChartView != selectedChartView
      $(@el).find('.pills li.active').removeClass('active')
      $(event.target).closest('li').addClass('active')

      if selectedChartView == 'year'
        chartView = new App.Views.AnnualDistanceChartView(collection: @collection)
        chartView.render()
      else
        chartView = new App.Views.MonthlyDistanceChartView(collection: @collection)
        chartView.render()
