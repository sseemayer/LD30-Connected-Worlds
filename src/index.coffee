window.LD = window.LD || {}
LD = window.LD

width = 800
height = 600

LD.world = darlingjs.w 'ld30', [
  'ngFlatland'
  'ngPixijsAdapter'
  'ngStats'
  'camera'
  'spacePhysics'
  'celestialSize'
  'control'
  'carControl'
  'turret'
  'debug'
]

LD.world.$add 'ngStatsBegin'


LD.viewport = LD.world.$add 'ng2DViewPort',
  lookAt:
    x: width / 2
    y: height / 2

  width: width
  height: height

LD.stage = LD.world.$add 'ngPixijsStage',
  domId: 'main'
  width: width
  height: height

LD.world.$add 'ngPixijsSpriteFactory'
LD.world.$add 'ngPixijsPositionUpdateCycleWithViewPort'
LD.world.$add 'ngPixijsRotationUpdateCycle'
LD.world.$add 'ngPixijsViewPortUpdateCycle'

LD.world.$add 'ngStatsEnd', domId: 'main'

LD.world.$add 'attachScale'
LD.world.$add 'attachPosition'

LD.world.$add 'camera'
LD.world.$add 'control'
LD.world.$add 'debugPosition'
LD.world.$add 'gravity'
LD.world.$add 'celestialSize'
LD.world.$add 'carControlRotateCCW'
LD.world.$add 'carControlRotateCW'
LD.world.$add 'carControlForward'
LD.world.$add 'carControlReverse'



sun = LD.world.$e 'sun',
  ng2D:
    x: width * 0.5
    y: height * 0.5

  ngSprite:
    name: 'sun.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'


  celestial:
    radius: 2.0e7
    mass: 2.0e25


  movingCelestial: {}


earth = LD.world.$e 'earth',
  ng2D:
    x: width * 0.5 + 1.2e8 / LD.const.scale
    y: height * 0.5

  ngSprite:
    name: 'earth.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  celestial:
    radius: 6.4e6
    mass: 3.0e22

  cameraTarget: {}

#  movingCelestial:
#    speed:
#      x: 0
#      y: 3e6 / LD.const.scale

#  debugPosition: {}

earthTurret = LD.world.$e 'earthTurret',

  attach:
    entity: earth

  attachPosition: {}
  attachScale: {}

  ng2D: {} # will be done by attaching
  ng2DRotation: {}

  ngSprite:
    name: 'gun.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  carControl: {}
  controllable:
    keyBindings:
      37: 'carControlRotateCCW'
      39: 'carControlRotateCW'


moon = LD.world.$e 'moon',
  ng2D:
    x: width * 0.50 + (1.2e8 + 7e6) / LD.const.scale
    y: height * 0.5

  ng2DRotation: {}

  ngSprite:
    name: 'moon.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  celestial:
    radius: 8e5
    mass: 5.0e15

#  movingCelestial:
#    speed:
#      x: 0
#      y: (3e6 - 5.5e5) / LD.const.scale

#  debugPosition: {}

console.log earthTurret

LD.world.$start()

