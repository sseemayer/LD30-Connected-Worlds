mod = darlingjs.m("turret")

mod.$c 'attach',
  entity: null

mod.$c 'attachPosition',
  offset:
    x: 0
    y: 0

  rotArm: 0

mod.$c 'attachScale',
  factor: 1.0


mod.$c 'turret',
  speed: 1e6
  flightDistance: 1000

mod.$c 'turretShoot', {}
mod.$c 'turretShooting', {}

mod.$s 'attachPosition',
  $require: ['attach', 'attachPosition', 'pos']
  $update: ['$entity', ($entity) ->

    if $entity.turretShooting then return

    myNg2D = $entity.pos
    theirNg2D = $entity.attach.entity.pos

    attachPosition = $entity.attachPosition

    if $entity.attach.entity.ng2DRotation
      theirNg2DRotation = $entity.attach.entity.ng2DRotation
      myNg2D.x = theirNg2D.x + attachPosition.offset.x + attachPosition.rotArm * Math.cos(theirNg2DRotation.rotation)
      myNg2D.y = theirNg2D.y + attachPosition.offset.y + attachPosition.rotArm * Math.sin(theirNg2DRotation.rotation)

      if $entity.ng2DRotation
        $entity.ng2DRotation.rotation = theirNg2DRotation.rotation

    else
      myNg2D.x = theirNg2D.x + attachPosition.offset.x
      myNg2D.y = theirNg2D.y + attachPosition.offset.y

  ]

mod.$s 'attachScale',
  $require: ['attach', 'attachScale', 'ngPixijsSprite']
  $update: ['$entity', ($entity) ->
    mySprite = $entity.ngPixijsSprite.sprite
    theirSprite = $entity.attach.entity.ngPixijsSprite.sprite

    mySprite.scale.x = theirSprite.scale.x * $entity.attachScale.factor
    mySprite.scale.y = theirSprite.scale.y * $entity.attachScale.factor
  ]

mod.$s 'turretShoot',
  $require: ['pos', 'ng2DRotation', 'turret', 'turretShoot']
  $addEntity: ($entity) ->
    $entity.$add 'turretShooting'

mod.$s 'turretShooting',
  $require: ['pos', 'ng2DRotation', 'turret', 'turretShooting']
  $addEntity: ($entity) ->

    planetSpeed = $entity.attach.entity.attach.entity.movingCelestial.speed || {x: 0, y: 0}

    $entity.turretShooting._speed =
      x: planetSpeed.x * 0.01 + $entity.turret.speed * Math.cos($entity.ng2DRotation.rotation)
      y: planetSpeed.y * 0.01 + $entity.turret.speed * Math.sin($entity.ng2DRotation.rotation)

    $entity.turretShooting._life = $entity.turret.flightDistance

  $update: ['$entity', '$time', ($entity, $time) ->
    turretShooting = $entity.turretShooting
    turretShooting._life -= $time
    if turretShooting._life <= 0
      $entity.$remove "turretShooting"
    else
      pos = $entity.pos
      ng2DRotation = $entity.ng2DRotation

      speed = $entity.turretShooting._speed

      pos.x += speed.x * $time
      pos.y += speed.y * $time

  ]

mod.$s 'turretBoom',
  $require: ['attach', 'turretShoot']
  $addEntity: ['$entity', "$world", ($entity, $world) ->
    turret = $entity.attach.entity

    boom = $world.$e 'boom',
      attach:
        entity: turret

      attachPosition: {}
      attachScale: {}

      pos: {}          # will be set by attaching
      ng2DRotation: {}  # will be set by attaching

      ngSprite:
        name: 'gun_boom.png'
        spriteSheetUrl: 'assets/spritesheets/main.json'


    window.setTimeout (()->
      $world.$remove boom
    ), 100
  ]
