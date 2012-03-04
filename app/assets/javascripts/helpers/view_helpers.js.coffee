App.Helpers.followLink = (event) ->
  event.preventDefault()
  link = $(event.target).closest('a')
  App.router.navigate link.attr('href'), trigger: true
