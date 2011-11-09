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

    # TODO handle errors here

    iframe.load ->
      form.attr 'target', null
      response = JSON.parse($(iframe.contents()).text())

      if response.errors?
        # TODO show the error message
      else
        # TODO show success message
        # TODO highlight the new row(s)?
        window.segments.add response.segments

      form.removeClass 'uploading'
      iframe.remove()
