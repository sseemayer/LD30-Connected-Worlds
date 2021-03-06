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
  attachedTime: 1000
  pullForce: 1e28

mod.$c 'turretShoot', {}
mod.$c 'turretShooting', {}

mod.$c 'turretAttached',
  target: null
  time: 0

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

    if not theirSprite then return

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

mod.$s 'turretTarget',
  targets: []
  $require: ['celestial', 'pos']
  $addEntity: ($entity) ->
    @targets.push $entity

  $removeEntity: ($entity) ->
    @targets.splice @targets.indexOf($entity), 1


mod.$s 'turretImpact',
  $require: ['turretShooting', 'pos']
  $update: ['$entity', 'turretTarget', ($entity, turretTarget) ->
    myPos = $entity.pos

    for target in turretTarget.targets
      theirPos = target.pos

      dx = myPos.x - theirPos.x
      dy = myPos.y - theirPos.y
      dist_squared = dx * dx + dy * dy
      dist = Math.sqrt(dist_squared)

      if dist < target.celestial.radius
        # collided with target
        $entity.$remove "turretShooting"
        $entity.$add "turretAttached",
          target: target
          time: $entity.turret.attachedTime

  ]

mod.$s 'turretPull',
  $require: ['turretAttached', 'pos', 'turret']
  $update: ['$entity', '$time', ($entity, $time) ->

    force = $entity.turret.pullForce
    turretAttached = $entity.turretAttached
    target = turretAttached.target

    planet = $entity.attach.entity.attach.entity

    turretAttached.time -= $time
    if turretAttached.time <= 0
      $entity.$remove 'turretAttached'

    console.log("Pull #{planet.$name} towards #{target.$name}")

    myPos = $entity.pos
    theirPos = target.pos

    dx = theirPos.x - myPos.x
    dy = theirPos.y - myPos.y
    dist = Math.sqrt(dx * dx + dy * dy)

    mySpeed = planet.movingCelestial.speed
    myMass = planet.celestial.mass
    mySpeed.x += dx / dist * force / myMass * $time
    mySpeed.y += dy / dist * force / myMass * $time

    if target.movingCelestial
      theirSpeed = target.movingCelestial.speed
      theirMass = target.celestial.mass
      theirSpeed.x -= dx / dist * force / theirMass * $time
      theirSpeed.y -= dy / dist * force / theirMass * $time

  ]
