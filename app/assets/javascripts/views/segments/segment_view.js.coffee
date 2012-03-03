class App.Views.Segments.SegmentView extends Backbone.View
  id: 'segment'

  render: =>
    $(@el).html JST['templates/segments/segment_view'](@model.toJSON())
    @prepareExpandingSections()
    @

  prepareExpandingSections: =>
    $(@el).find('section header h1').click (event) =>
      section = $(event.target).closest('section')

      if section.is('.active')
        $(@el).find('section').removeClass('active')
      else
        $(@el).find('section').removeClass('active')
        section.addClass('active')

    $(@el).find('section#distance').addClass('active')
