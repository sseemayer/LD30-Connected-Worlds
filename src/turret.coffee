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
  speed: 2
  flightDistance: 1000

mod.$c 'turretShoot', {}
mod.$c 'turretShooting', {}

mod.$s 'attachPosition',
  $require: ['attach', 'attachPosition', 'ng2D']
  $update: ['$entity', ($entity) ->

    if $entity.turretShooting then return

    myNg2D = $entity.ng2D
    theirNg2D = $entity.attach.entity.ng2D

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
  $require: ['ng2D', 'ng2DRotation', 'turret', 'turretShoot']
  $addEntity: ($entity) ->
    $entity.$add 'turretShooting'

mod.$s 'turretShooting',
  $require: ['ng2D', 'ng2DRotation', 'turret', 'turretShooting']
  $addEntity: ($entity) ->
    console.log "SHOOT"

    planetSpeed = $entity.attach.entity.attach.entity.movingCelestial.speed || {x: 0, y: 0}

    $entity.turretShooting._speed =
      x: planetSpeed.x * 0.1 + $entity.turret.speed * Math.cos($entity.ng2DRotation.rotation)
      y: planetSpeed.y * 0.1 + $entity.turret.speed * Math.sin($entity.ng2DRotation.rotation)

    $entity.turretShooting._life = $entity.turret.flightDistance

  $update: ['$entity', '$time', ($entity, $time) ->
    turretShooting = $entity.turretShooting
    turretShooting._life -= $time
    if turretShooting._life <= 0
      console.log "END-SHOOT"
      $entity.$remove "turretShooting"
    else
      ng2D = $entity.ng2D
      ng2DRotation = $entity.ng2DRotation

      speed = $entity.turretShooting._speed

      ng2D.x += speed.x * $time
      ng2D.y += speed.y * $time

  ]

mod.$s 'turretBoom',
  $require: ['attach', 'turretShoot']
  $addEntity: ($entity) ->

    switchSprite = (entity, newSprite) ->
      entity.$remove 'ngSprite'
      entity.$add 'ngSprite', 
        name: newSprite
        spriteSheetUrl: 'assets/spritesheets/main.json'

    console.log "BOOM"
    turret = $entity.attach.entity

    switchSprite(turret, "gun_boom.png")

    window.setTimeout (()->
      switchSprite(turret, "gun.png")
      console.log "UNBOOM"
    ), 100
