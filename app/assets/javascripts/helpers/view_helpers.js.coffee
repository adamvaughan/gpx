App.Helpers.followLink = (event) ->
  event.preventDefault()
  link = $(event.target).closest('a')
  App.router.navigate link.attr('href'), trigger: true

App.Helpers.prepareExpandingSections = (parent) ->
  $(parent).find('section header h1').click (event) ->
    section = $(event.target).closest('section')
    section.toggleClass('active')

  $(parent).find('section').addClass('active')
