mod = darlingjs.m("celestialSize")

mod.$s 'celestialSize',
  $require: ['celestial', 'ngPixijsSprite']
  $addEntity: ($entity) ->
    scale = LD.const.scale
    sprite = $entity.ngPixijsSprite.sprite
    texWidth = sprite.width

    eScale = ($entity.celestial.radius / scale) / (texWidth / 2)
    sprite.scale.x = eScale
    sprite.scale.y = eScale


    console.log "Scaling #{$entity.$name} (#{texWidth} px) to #{texWidth * eScale} px"
