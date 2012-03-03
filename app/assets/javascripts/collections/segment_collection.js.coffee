class App.Collections.SegmentCollection extends Backbone.Collection
  model: App.Models.Segment

  comparator: (segment) ->
    segment.get('start_time') * -1
