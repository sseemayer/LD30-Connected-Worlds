mod = darlingjs.m "debug"

mod.$c 'debugPosition', {}


mod.$s 'debugPosition',
  $require: ['debugPosition', 'ng2D']
  $update: ['$entity', ($entity) ->
    ng2D = $entity.ng2D

    if $entity.movingCelestial
      speed = $entity.movingCelestial.speed
      console.log "#{$entity.$name}: x=#{ng2D.x} y=#{ng2D.y} dx=#{speed.x} dy=#{speed.y}"
    else
      console.log "#{$entity.$name}: x=#{ng2D.x} y=#{ng2D.y}"

  ]
