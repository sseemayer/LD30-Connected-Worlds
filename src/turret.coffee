mod = darlingjs.m("turret")

mod.$c 'attach',
  entity: null

mod.$c 'attachPosition', {}
mod.$c 'attachScale', {}

mod.$s 'attachPosition',
  $require: ['attach', 'attachPosition', 'ng2D']
  $update: ['$entity', ($entity) ->
    myNg2D = $entity.ng2D
    theirNg2D = $entity.attach.entity.ng2D

    myNg2D.x = theirNg2D.x
    myNg2D.y = theirNg2D.y

  ]

mod.$s 'attachScale',
  $require: ['attach', 'attachScale', 'ngPixijsSprite']
  $update: ['$entity', ($entity) ->
    mySprite = $entity.ngPixijsSprite.sprite
    theirSprite = $entity.attach.entity.ngPixijsSprite.sprite

    mySprite.scale.x = theirSprite.scale.x
    mySprite.scale.y = theirSprite.scale.y
  ]

