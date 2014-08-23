mod = darlingjs.m("carControl")

mod.$c 'carControl',
  speed: 0.2
  rotSpeed: Math.PI/2 / 1000

mod.$c 'carControlRotateCCW'
mod.$c 'carControlRotateCW'
mod.$c 'carControlForward'
mod.$c 'carControlReverse'

mod.$s 'carControlRotateCCW',
  $require: ['ng2DRotation', 'carControl', 'carControlRotateCCW']

  $update: ['$entity', '$time', ($entity, $time) ->
    ng2DRotation = $entity.ng2DRotation
    carControl = $entity.carControl

    ng2DRotation.rotation -= $time * carControl.rotSpeed
  ]


mod.$s 'carControlRotateCW',
  $require: ['ng2DRotation', 'carControl', 'carControlRotateCW']

  $update: ['$entity', '$time', ($entity, $time) ->
    ng2DRotation = $entity.ng2DRotation
    carControl = $entity.carControl

    ng2DRotation.rotation += $time * carControl.rotSpeed
  ]


mod.$s 'carControlForward',
  $require: ['ng2DRotation', 'pos', 'carControl', 'carControlForward']

  $update: ['$entity', '$time', ($entity, $time) ->
    pos = $entity.pos
    ng2DRotation = $entity.ng2DRotation
    carControl = $entity.carControl

    pos.x += Math.cos(ng2DRotation.rotation) * carControl.speed * $time
    pos.y += Math.sin(ng2DRotation.rotation) * carControl.speed * $time
  ]

mod.$s 'carControlReverse',
  $require: ['ng2DRotation', 'pos', 'carControl', 'carControlReverse']

  $update: ['$entity', '$time', ($entity, $time) ->
    pos = $entity.pos
    ng2DRotation = $entity.ng2DRotation
    carControl = $entity.carControl

    pos.x -= Math.cos(ng2DRotation.rotation) * carControl.speed * $time
    pos.y -= Math.sin(ng2DRotation.rotation) * carControl.speed * $time
  ]
