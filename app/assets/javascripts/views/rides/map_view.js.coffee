class App.Views.Rides.MapView extends Backbone.View
  initialize: (options) ->
    @points = options.points

  render: =>
    maximumLatitude = Number.NaN
    minimumLatitude = Number.NaN
    maximumLongitude = Number.NaN
    minimumLongitude = Number.NaN

    mapPoints = @points.map (point) =>
      latitude = parseFloat(point.get('latitude'))
      longitude = parseFloat(point.get('longitude'))

      maximumLatitude = latitude if _.isNaN(maximumLatitude) or maximumLatitude < latitude
      minimumLatitude = latitude if _.isNaN(minimumLatitude) or minimumLatitude > latitude
      maximumLongitude = longitude if _.isNaN(maximumLongitude) or maximumLongitude < longitude
      minimumLongitude = longitude if _.isNaN(minimumLongitude) or minimumLongitude > longitude

      new google.maps.LatLng(latitude, longitude)

    centerLatitude = (maximumLatitude + minimumLatitude) / 2
    centerLongitude = (maximumLongitude + minimumLongitude) / 2

    bounds = new google.maps.LatLngBounds(new google.maps.LatLng(minimumLatitude, minimumLongitude), new google.maps.LatLng(maximumLatitude, maximumLongitude))

    mapOptions =
      zoom: 4
      center: new google.maps.LatLng(centerLatitude, centerLongitude)
      mapTypeId: google.maps.MapTypeId.TERRAIN
      keyboardShortcuts: false

    map = new google.maps.Map(document.getElementById('map'), mapOptions)
    map.fitBounds(bounds)

    lineOptions =
      clickable: false
      map: map
      path: mapPoints
      strokeColor: '#b94a48'

    line = new google.maps.Polyline(lineOptions)

    startMarkerOptions =
      clickable: false
      flat: true
      map: map
      position: _.first(mapPoints)
      icon: 'http://maps.google.com/mapfiles/dd-start.png'

    startMarker = new google.maps.Marker(startMarkerOptions)

    stopMarkerOptions =
      clickable: false
      flat: true
      map: map
      position: _.last(mapPoints)
      icon: 'http://maps.google.com/mapfiles/dd-end.png'

    stopMarker = new google.maps.Marker(stopMarkerOptions)

    @
