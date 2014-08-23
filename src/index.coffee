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
LD.world.$add 'turretShoot'
LD.world.$add 'turretShooting'
LD.world.$add 'turretBoom'

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


makePlanet = (name, distanceFromSun, radius, mass, speed) ->
  LD.world.$e name, 
    ng2D:
      x: width * 0.5 + distanceFromSun / LD.const.scale
      y: height * 0.5
    ngSprite:
      name: "#{name}.png"
      spriteSheetUrl: 'assets/spritesheets/main.json'
    celestial:
      radius: radius
      mass: mass
    movingCelestial:
      speed: speed

makePlanet 'mercury', 4e7, 3.4e6, 2.0e20, x: 0, y: 4e6 / LD.const.scale
makePlanet 'venus', 6e7, 5.4e6, 2.0e21, x: 0, y: 4e6 / LD.const.scale

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

  movingCelestial:
    speed:
      x: 0
      y: 2e6 / LD.const.scale

earthTurret = LD.world.$e 'earthTurret',

  attach:
    entity: earth

  attachPosition: {}
  attachScale: factor: 2.3

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

earthTurretHook = LD.world.$e 'earthTurretHook',
  attach:
    entity: earthTurret

  attachPosition:
    rotArm: 10

  ng2D: {}          # will be set by attaching
  ng2DRotation: {}  # will be set by attaching

  ngSprite:
    name: 'hook.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  controllable:
    keyBindings:
      32: 'turretShoot'

  turret: {}


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

  movingCelestial:
    speed:
      x: 0
      y: (3e6 - 5.0e5) / LD.const.scale

#  debugPosition: {}

makePlanet 'mars', 1.4e8, 3.4e6, 2.0e20, x: 0, y: 4e6 / LD.const.scale
makePlanet 'jupiter', 2.9e8, 3.4e7, 2.0e20, x: 0, y: 4e6 / LD.const.scale
makePlanet 'saturn', 4.0e8, 3.4e7, 2.0e20, x: 0, y: 4e6 / LD.const.scale
makePlanet 'uranus', 7.4e8, 1.2e7, 2.0e20, x: 0, y: 4e6 / LD.const.scale
makePlanet 'neptune', 1.4e9, 1.2e7, 2.0e20, x: 0, y: 4e6 / LD.const.scale


LD.world.$start()

