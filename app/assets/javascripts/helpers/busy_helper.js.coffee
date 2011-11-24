class App.Helpers.BusyHelper
  constructor: ->
    @busyCount = 0

  increment: =>
    @busyCount += 1
    $('body').addClass('busy')

  decrement: =>
    @busyCount -= 1
    @busyCount = 0 if @busyCount < 0
    $('body').removeClass('busy') if @busyCount == 0
