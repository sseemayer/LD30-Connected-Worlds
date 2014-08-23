mod = darlingjs.m "debug"

mod.$c 'debugPosition', {}


mod.$s 'debugPosition',
  $require: ['debugPosition', 'pos']
  $update: ['$entity', ($entity) ->
    pos = $entity.pos

    if $entity.movingCelestial
      speed = $entity.movingCelestial.speed
      console.log "#{$entity.$name}: x=#{pos.x} y=#{pos.y} dx=#{speed.x} dy=#{speed.y}"
    else
      console.log "#{$entity.$name}: x=#{pos.x} y=#{pos.y}"

  ]
