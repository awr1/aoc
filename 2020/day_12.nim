import strutils, sequtils, math

type ActionKind = enum N, E, S, W, L, R, F
let
  dirs = [N, E, S, W]
  actions = stdin.readAll.splitLines
    .filterIt(not it.isEmptyOrWhitespace)
    .mapIt((kind  : parseEnum[ActionKind]($it[0]),
            value : parseInt(it[1 .. ^1])))

proc calculate(waypointed :bool) :int =
  var
    face                 = dirs.find(E)
    (position, waypoint) = ((x : 0, y : 0), (x : 10, y : 1))

  proc move(vec :var tuple[x, y :int]; cardinal :range[N .. W]; by :int) =
    case cardinal
    of N: vec.y += by
    of E: vec.x += by
    of S: vec.y -= by
    of W: vec.x -= by

  proc turn(value :int) =
    var newFace = (face + value div 90) mod dirs.len
    if newFace < 0: newFace += dirs.len
    if waypointed:
      let delta = newFace - face
      for i in 0 ..< delta.abs:
        let old  = waypoint # see nim compiler issue #16331
        waypoint = if delta < 0: (x : -old.y, y : old.x)
                   else:         (x : old.y,  y : -old.x)
    face = newFace

  for action in actions:
    if waypointed:
      case action.kind
      of N .. W: waypoint.move(action.kind, action.value)
      of F:
        position = (x : position.x + (waypoint.x * action.value),
                    y : position.y + (waypoint.y * action.value))
      of L:      turn(-action.value)
      of R:      turn(action.value)
    else:
      case action.kind
      of N .. W: position.move(action.kind, action.value)
      of F:      position.move(dirs[face],  action.value)
      of L:      turn(-action.value)
      of R:      turn(action.value)
  position.x.abs + position.y.abs

echo calculate(waypointed = false)
echo calculate(waypointed = true)
