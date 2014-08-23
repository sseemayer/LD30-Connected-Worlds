mod = darlingjs.m("camera")

mod.$c 'cameraTarget', {}

mod.$s 'camera',
    $require: ['ng2D', 'cameraTarget']
    $update: ['$entity', 'ng2DViewPort', ($entity, ng2DViewPort) ->
      ng2DViewPort.lookAt.x = $entity.ng2D.x
      ng2DViewPort.lookAt.y = $entity.ng2D.y
    ]
