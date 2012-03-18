App.Helpers.followLink = (event) ->
  return true if event.which == 2 or event.metaKey or event.ctrlKey
  event.preventDefault()
  link = $(event.target).closest('a')
  App.router.navigate link.attr('href'), trigger: true
  $('html, body').scrollTop 0

App.Helpers.prepareExpandingSections = (parent) ->
  $(parent).find('section header h1').live 'click', (event) ->
    section = $(event.target).closest('section')
    section.toggleClass('collapsed')
