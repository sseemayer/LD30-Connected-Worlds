mod = darlingjs.m("camera")

mod.$c 'cameraTarget', {}

mod.$c 'pos',
  x: 0
  y: 0

mod.$s 'cameraLookAt',
  $require: ['ng2D', 'cameraTarget']
  $update: ['$entity', 'ng2DViewPort', ($entity, ng2DViewPort) ->
    ng2DViewPort.lookAt.x = $entity.ng2D.x
    ng2DViewPort.lookAt.y = $entity.ng2D.y
  ]

mod.$s 'cameraWorldToScreen',
  zoom: 0.8
  _origScale: {}

  $require: ['pos', 'ngPixijsSprite']

  $addEntity: ($entity) ->
    $entity.$add 'ng2D'


    s = $entity.ngPixijsSprite
    if s.sprite
      s.origSize = x: s.sprite.width, y: s.sprite.height

  $update: ['$entity', ($entity) ->
    ng2D = $entity.ng2D
    pos = $entity.pos
    sprite = $entity.ngPixijsSprite.sprite

    ng2D.x = @zoom * $entity.pos.x / LD.const.scale
    ng2D.y = @zoom * $entity.pos.y / LD.const.scale

    if $entity.celestial and $entity.ngPixijsSprite.origSize
      radius = $entity.celestial.radius

      origWidth = $entity.ngPixijsSprite.origSize.x
      scale = @zoom * (radius / LD.const.scale) / (origWidth / 2)
      sprite.scale.x = scale
      sprite.scale.y = scale

  ]

