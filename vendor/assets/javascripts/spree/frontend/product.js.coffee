Spree.ready ($) ->
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')
    ($ '#main-image').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'
    thumbnails.find('a').on 'click', (event) ->
      ($ '#main-image').data 'selectedThumb', ($ event.currentTarget).attr('href')
      ($ '#main-image').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      thumbnails.find('li').removeClass 'selected'
      ($ event.currentTarget).parent('li').addClass 'selected'
      false

    thumbnails.find('li').on 'mouseenter', (event) ->
      ($ '#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

    thumbnails.find('li').on 'mouseleave', (event) ->
      ($ '#main-image img').attr 'src', ($ '#main-image').data('selectedThumb')


  Spree.showVariantImages = (variantId) ->
    ($ 'li.vtmb').hide()
    ($ 'li.tmb-' + variantId).show()
    currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = ($ ($ '#product-images ul.thumbnails li:visible.vtmb').eq(0))
      thumb = ($ ($ '#product-images ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      ($ '#product-images ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      ($ '#main-image img').attr 'src', newImg
      ($ '#main-image').data 'selectedThumb', newImg
      ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    ($ '.price.selling').text(variantPrice) if variantPrice

  Spree.disableCartForm = (variant) ->
    inStock = variant.data('in-stock')
    $('#add-to-cart-button').attr('disabled', !inStock)

  Spree.showVariantRangePricesAndFiles = (variantId) ->
    $('.variant-table-prices').hide()
    $('.variant-file').hide()
    $('#variant-table-'+variantId).show()
    $('#variant-file-'+variantId).show()

  Spree.showVariantImagesHome = (variantId,productId) ->
    originalDiv = ($ "#product-images-#{productId}").parent().parent()
    originalDiv.find("ul.thumbnails li.vtmb").hide()
    originalDiv.find("ul.thumbnails li.tmb-" + variantId).show()
    currentThumb = ($ '#' + ($ "#main-image-#{productId}").data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = originalDiv.find("ul.thumbnails li:visible.vtmb").eq(0)
      thumb = originalDiv.find("ul.thumbnails li:visible").eq(0) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')

      ($ "#product-images-#{productId} ul.thumbnails li").removeClass 'selected'
      thumb.addClass 'selected'
      ($ "#main-image-#{productId} img").attr 'src', newImg
      ($ "#main-image-#{productId}").data 'selectedThumb', newImg
      ($ "#main-image-#{productId}").data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPriceHome = (variant) ->
    variantPrice = variant.data('price')
    ($ variant).parent().parent().parent().parent().parent().parent().parent().find('.price.selling').text(variantPrice) if variantPrice

  Spree.disableCartFormHome = (variant) ->
    inStock = variant.data('in-stock')
    ($ variant).parent().parent().parent().find('#add-to-cart-button').attr('disabled', !inStock)


  radios = ($ '#product-variants input[type="radio"]')
  home = false
  if radios.length == 0
    radios = ($ '#variant_id option')
    if radios.length > 0
      home = true

  if radios.length > 0 && !home
    selectedRadio = ($ '#product-variants input[type="radio"][checked="checked"]')

    Spree.showVariantImages selectedRadio.attr('value')
    Spree.updateVariantPrice selectedRadio
    Spree.disableCartForm selectedRadio
    Spree.showVariantRangePricesAndFiles selectedRadio.attr('value')

    radios.click (event) ->
      console.log(this)
      Spree.showVariantImages @value
      Spree.updateVariantPrice ($ this)
      Spree.disableCartForm ($ this)
      Spree.showVariantRangePricesAndFiles @value

  else if home
    selected = ($ '#variant_id option:selected')

    Spree.showVariantImagesHome(selected.attr('value'), selected.data('producto-id'))
    Spree.updateVariantPriceHome selected
    Spree.disableCartFormHome selected
  
    ($ '.home-select').on "change", ->
      radios = ($ this).find(":selected")[0]

      producto_id= $(radios).data('producto-id')
      Spree.showVariantImagesHome(radios.value,producto_id)
      Spree.updateVariantPriceHome ($ radios)
      Spree.disableCartFormHome ($ radios)


  Spree.addImageHandlers()
