class App.Views.FileUploadView extends Backbone.View
  events:
    'change input[type=file]': 'uploadFile'

  render: =>
    $(@el).html JST['templates/file_upload_view']([])
    @

  uploadFile: (event) =>
    form = $(@el).find 'form'
    form.addClass 'uploading'

    iframe = $(@el).find 'iframe'
    iframeId = iframe.attr 'id'

    form.attr 'target', iframeId
    form.submit()

    iframe.load =>
      form.attr 'target', null
      form.removeClass 'uploading'

      try
        response = JSON.parse($(iframe.contents()).find('textarea').val())

        if response.error?
          @showError JSON.parse(response.error)
        else
          App.segments.add response.segments
          App.router.navigate '/', trigger: true
      catch error
        @showError 'An error occurred while processing the file. Please try again.'

  showError: (message) =>
    form = $(@el).find 'form'
    form.addClass 'error'
    form.find('.response-message').html(message)
    form.find('.response-message').delay(4000).fadeOut(100, @render)
