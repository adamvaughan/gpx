class App.Views.Segments.SegmentView extends Backbone.View
  id: 'segment'

  render: =>
    $(@el).html JST['templates/segments/segment_view'](@model.toJSON())
    @prepareExpandingSections()
    @

  prepareExpandingSections: =>
    $(@el).find('section header h1').click (event) =>
      section = $(event.target).closest('section')
      section.toggleClass('active')

    $(@el).find('section').addClass('active')
