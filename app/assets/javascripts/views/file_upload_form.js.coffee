class App.Views.FileUploadForm extends Backbone.View
  events:
    'change input[type=file]': 'uploadFile'

  render: =>
    $(@el).html JST['file_upload_form']([])
    @

  uploadFile: (event) =>
    form = $(@el).find 'form'
    form.addClass 'uploading'

    iframeId = "file-upload-#{new Date().getTime()}"
    iframe = $('<iframe></iframe>')
    iframe.attr 'id', iframeId
    iframe.addClass 'file-upload-target'

    $(@el).append iframe
    form.attr 'target', iframeId
    form.submit()

    iframe.load =>
      form.attr 'target', null
      form.removeClass 'uploading'

      try
        response = JSON.parse($(iframe.contents()).text())

        if response.error?
          @showMessage JSON.parse(response.error), 'error'
        else
          window.segments.add response.segments
          @showMessage 'File uploaded successfully.', 'success'
      catch error
        @showMessage 'An error occurred while processing the file. Please try again.', 'error'

      iframe.remove()

  showMessage: (message, style) =>
    form = $(@el).find 'form'
    form.addClass style
    form.find('.response-message').html(message)
    form.find('.response-message').delay(4000).fadeOut(100, () =>
      form.removeClass style
    )
