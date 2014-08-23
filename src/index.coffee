window.LD = window.LD || {}
LD = window.LD

width = 800
height = 600

LD.world = darlingjs.w 'ld30', [
  'ngResources'
  'ngFlatland'
  'ngPixijsAdapter'
  'ngStats'
  'camera'
  'spacePhysics'
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

LD.world.$add 'control'

LD.world.$add 'attachScale'
LD.world.$add 'attachPosition'
LD.world.$add 'turretShoot'
LD.world.$add 'turretShooting'
LD.world.$add 'turretBoom'
LD.world.$add 'turretTarget'
LD.world.$add 'turretImpact'
LD.world.$add 'turretPull'


LD.world.$add 'debugPosition'
LD.world.$add 'gravity'
LD.world.$add 'carControlRotateCCW'
LD.world.$add 'carControlRotateCW'
LD.world.$add 'carControlForward'
LD.world.$add 'carControlReverse'


LD.world.$add 'ngPixijsSpriteFactory'
LD.world.$add 'ngPixijsPositionUpdateCycleWithViewPort'
LD.world.$add 'ngPixijsRotationUpdateCycle'
LD.world.$add 'ngPixijsViewPortUpdateCycle'

LD.world.$add 'cameraLookAt'
LD.world.$add 'cameraWorldToScreen'
LD.world.$add 'cameraZoomControl'

LD.world.$add 'ngStatsEnd', domId: 'main'

ngResourceLoader = LD.world.$add 'ngResourceLoader'
ngResourceLoader.on 'progress', () ->
  console.log "#{ngResourceLoader.availableCount} / #{ngResourceLoader.totalCount}"

ngPixijsResources = LD.world.$add 'ngPixijsResources'
ngPixijsResources.load 'assets/spritesheets/main.json', ngResourceLoader

zoomEntity = LD.world.$e 'zoom',
  cameraZoomControl: {}
  controllable:
    keyBindings:
      38: 'cameraZoomIn'
      40: 'cameraZoomOut'

console.log zoomEntity

sun = LD.world.$e 'sun',
  pos:
    x: 0
    y: 0

  ngSprite:
    name: 'sun.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'


  celestial:
    radius: 2.0e7
    mass: 2.0e31


#  movingCelestial: {}


makePlanet = (name, distanceFromSun, radius, mass, speed) ->
  LD.world.$e name, 
    pos:
      x: distanceFromSun
      y: 0
    ngSprite:
      name: "#{name}.png"
      spriteSheetUrl: 'assets/spritesheets/main.json'
    celestial:
      radius: radius
      mass: mass
    movingCelestial:
      speed: speed

mercury = makePlanet 'mercury', 8e7, 3.4e6, 2.0e24, x: 0, y: 5.5e6
venus = makePlanet 'venus', 1e8, 5.4e6, 2.0e24, x: 0, y: 5e6

earth = LD.world.$e 'earth',
  pos:
    x: 1.5e8
    y: 0

  ngSprite:
    name: 'earth.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  celestial:
    radius: 6.4e6
    mass: 5.9e24


  movingCelestial:
    speed:
      x: 0
      y: 4.5e6

  cameraTarget: {}

earthTurret = LD.world.$e 'earthTurret',

  attach:
    entity: earth

  attachPosition: {}
  attachScale: factor: 2.3

  pos: {} # will be done by attaching
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
    rotArm: 6e6
  attachScale: {}

  pos: {}          # will be set by attaching
  ng2DRotation: {}  # will be set by attaching

  ngSprite:
    name: 'hook.png'
    spriteSheetUrl: 'assets/spritesheets/main.json'

  controllable:
    keyBindings:
      32: 'turretShoot'

  turret: {}


#moon = LD.world.$e 'moon',
#  pos:
#    x: 1.2e8 + 7e6
#    y: 0
#
#  ng2DRotation: {}
#
#  ngSprite:
#    name: 'moon.png'
#    spriteSheetUrl: 'assets/spritesheets/main.json'
#
#  celestial:
#    radius: 8e5
#    mass: 5.0e15
#
#  movingCelestial:
#    speed:
#      x: 0
#      y: 3e6 - 5.0e5
#
##  debugPosition: {}

mars = makePlanet 'mars', 2.0e8, 3.4e6, 2.0e24, x: 0, y: 4e6
jupiter = makePlanet 'jupiter', 2.9e8, 3.4e7, 2.0e24, x: 0, y: 3.2e6
saturn = makePlanet 'saturn', 4.0e8, 3.4e7, 2.0e24, x: 0, y: 2.6e6
uranus = makePlanet 'uranus', 7.4e8, 1.2e7, 2.0e24, x: 0, y: 1.8e6
neptune = makePlanet 'neptune', 9.0e8, 1.2e7, 2.0e24, x: 0, y: 1.6e6

ngResourceLoader.on 'complete', () ->
  console.log "Finished loading"
  LD.world.$start()

