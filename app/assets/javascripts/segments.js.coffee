# class SegmentsView
#   constructor: ->
#     @prepareExpandingSections()
#
#   prepareExpandingSections: ->
#     $('section header h1').click (event) ->
#       section = $(event.target).closest('section')
#
#       if section.is('.active')
#         $('section').removeClass('active')
#       else
#         $('section').removeClass('active')
#         section.addClass('active')
#
#     $('section#distance').addClass('active')
#
# $ ->
#   if $('body.segments.show').length > 0
#     new SegmentsView()
