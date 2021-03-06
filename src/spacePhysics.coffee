mod = darlingjs.m("spacePhysics")

mod.$c 'celestial',
  radius: 1 # in m
  mass: 1 # in kgs

mod.$c 'movingCelestial',
  speed:
    x: 0
    y: 0

mod.$s 'gravity',
  $require: ['celestial', 'pos']
  _celestials: []

  $addEntity: ($entity) ->
    @_celestials.push $entity

  $removeEntity: ($entity) ->
    index = @_celestials.indexOf($entity)
    @_celestials.splice index, 1

  $update: ['$entity', '$time', ($entity, $time) ->

    time = $time / 60   # frame time to real seconds

    cel1 = $entity.celestial
    pos1 = $entity.pos

    if $entity.movingCelestial
      speed = $entity.movingCelestial.speed

      pos1.x += speed.x * time
      pos1.y += speed.y * time

    for other_entity in @_celestials
      if other_entity != $entity

        cel2 = other_entity.celestial
        pos2 = other_entity.pos

        # compute distance (in m)
        dx = (pos1.x - pos2.x)
        dy = (pos1.y - pos2.y)
        dist_squared = dx * dx + dy * dy
        dist = Math.sqrt(dist_squared)

        # gravity = G * (m1 * m2) / (d*d)
        gravity = LD.const.gravity * (cel1.mass * cel2.mass) / dist_squared
        #console.log("grav = #{gravity}")

        if other_entity.movingCelestial
          speed = other_entity.movingCelestial.speed
          speed.x += (dx/dist) * gravity / cel2.mass * time
          speed.y += (dy/dist) * gravity / cel2.mass * time

        if $entity.movingCelestial
          speed = $entity.movingCelestial.speed
          speed.x -= (dx/dist) * gravity / cel1.mass * time
          speed.y -= (dy/dist) * gravity / cel1.mass * time
  ]

mod.$s 'collisions',
  $require: ['celestial', 'movingCelestial', 'pos']
  $update: ['$entity', 'gravity', '$world', ($entity, gravity, $world) ->
    if not $entity then return

    cel1 = $entity.celestial
    pos1 = $entity.pos

    for other_entity in gravity._celestials
      if other_entity != $entity
        if not other_entity then return

        cel2 = other_entity.celestial
        pos2 = other_entity.pos

        # compute distance (in m)
        dx = (pos1.x - pos2.x)
        dy = (pos1.y - pos2.y)
        dist_squared = dx * dx + dy * dy
        dist = Math.sqrt(dist_squared)

        if dist < cel1.radius + cel2.radius
          console.log "#{$entity.$name} collided with #{other_entity.$name}"
          console.log $world

          if $entity.celestial.mass > other_entity.celestial.mass
            $world.$remove other_entity
          else
            $world.$remove $entity
  ]
