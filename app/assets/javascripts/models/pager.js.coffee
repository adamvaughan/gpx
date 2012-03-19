class App.Models.Pager
  constructor: (collection, attributes) ->
    @collection = collection

    @currentPage = attributes.current_page
    @totalPages = attributes.total_pages
    @perPage = attributes.per_page
    @totalEntries = attributes.total_entries
    @url = attributes.url

    @isFirstPage = @currentPage is 1
    @isLastPage = @currentPage is @totalPages
    @previousPath = @buildPath(@currentPage - 1)
    @nextPath = @buildPath(@currentPage + 1)

    @pages = @visiblePageNumbers().map (page) =>
      page: page
      path: @buildPath page
      createLink: page isnt @currentPage and page isnt '...'

  visiblePageNumbers: =>
    innerWindow = 3
    outerWindow = 0
    windowFrom = @currentPage - innerWindow
    windowTo = @currentPage + innerWindow

    if windowTo > @totalPages
      windowFrom -= windowTo - @totalPages
      windowTo = @totalPages

    if windowFrom < 1
      windowTo += 1 - windowFrom
      windowFrom = 1
      windowTo = @totalPages if windowTo > @totalPages

    visible = [1..@totalPages]
    leftGap = [Math.min(2 + outerWindow, windowFrom)...windowFrom]
    rightGap = [Math.min(windowTo + 1, @totalPages - outerWindow)...(@totalPages - outerWindow)]

    if leftGap.length > 1
      visible = _.reject visible, (page) -> _.include(leftGap, page)
      visible.splice(outerWindow + 1, 0, '...')

    if rightGap.length > 1
      visible = _.reject visible, (page) -> _.include(rightGap, page)
      visible.splice(visible.length - outerWindow - 1, 0, '...')

    visible

  buildPath: (page) =>
    "#{@url}/page/#{page}"
