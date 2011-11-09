class App.Views.FileUploadForm extends Backbone.View
  render: =>
    $(@el).html JST['file_upload_form']([])
    @
