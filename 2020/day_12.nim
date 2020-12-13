import strutils, sequtils, math

type ActionKind = enum N, E, S, W, L, R, F
let (dirs, actions) = ([N, E, S, W], stdin.readAll.splitLines
  .filterIt(not it.isEmptyOrWhitespace)
  .mapIt((kind  : parseEnum[ActionKind]($it[0]),
          value : parseInt(it[1 .. ^1]))))

proc calculate(relative :bool) :int =
  var (face, pos, way) = (dirs.find(E), (x : 0, y : 0), (x : 10, y : 1))
  proc move(vec :var pos.type; cardinal :range[N .. W]; by :int) =
    case cardinal
    of N: vec.y += by
    of E: vec.x += by
    of S: vec.y -= by
    of W: vec.x -= by
  proc turn(value :int) =
    var newFace = (face + value div 90) mod dirs.len
    if newFace < 0: newFace += dirs.len
    if relative:
      let delta = newFace - face
      for i in 0 ..< delta.abs:
        let old = way # see nim compiler issue #16331
        way     = if delta < 0: (x : -old.y, y : old.x)
                  else:         (x : old.y,  y : -old.x)
    face = newFace
  for act in actions:
    case act.kind
    of N .. W: (if relative: way.move(act.kind, act.value)
                else:        pos.move(act.kind, act.value))
    of F:      (if relative: pos = (x : pos.x + (way.x * act.value),
                                    y : pos.y + (way.y * act.value))
                else:        pos.move(dirs[face], act.value))
    of L:      turn(-act.value)
    of R:      turn(act.value)
  pos.x.abs + pos.y.abs

echo calculate(relative = false)
echo calculate(relative = true)
