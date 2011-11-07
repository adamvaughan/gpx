$ ->
  if $('form.file-upload').length > 0
    $('form.file-upload input[type=file]').change ->
      $('form.file-upload').addClass('uploading')
      iframeId = 'file-upload' + new Date().getTime()

      iframe = $('<iframe></iframe>')
      iframe.attr('id', iframeId)
      iframe.addClass('file-upload-target')

      $('body').append(iframe)
      $('form.file-upload').attr('target', iframeId).submit()

      iframe.load ->
        $('form.file-upload').attr('target', null)

        iframeBody = iframe.contents().find('body')

        message = iframeBody.find('.alert-message')
        message.hide()

        $('body .container').prepend(message)

        if message.is('.success')
          if $('table').length > 0
            $('table tbody').replaceWith(iframeBody.find('table tbody'))
          else
            $('body .container').append(iframeBody.find('table'))

        message.slideDown().delay(2000).slideUp()
        $('form.file-upload').removeClass('uploading')
        iframe.remove()
