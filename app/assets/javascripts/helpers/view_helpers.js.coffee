App.Helpers.followLink = (event) ->
  return true if event.which == 2 or event.metaKey or event.ctrlKey
  event.preventDefault()
  link = $(event.target).closest('a')
  App.router.navigate link.attr('href'), trigger: true

App.Helpers.prepareExpandingSections = (parent) ->
  $(parent).on 'click', 'section header h1', (event) ->
    section = $(event.target).closest('section')
    section.toggleClass('collapsed')
