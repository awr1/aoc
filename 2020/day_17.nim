import algorithm, sequtils, strutils, sets, sugar

let starting = collect initHashSet:
  for xIdx, x in stdin.readAll.splitLines.map(x => x.mapIt(it == '#')):
    for yIdx, y in x:
      if y: {@[xIdx, yIdx]}

proc conway(dims :int) :auto =
  let offsets = product(@[-1, 0, +1].repeat(dims))
  var field   = collect initHashSet:
    for i in starting: (var j = i; j.setLen(dims); {j})
  proc near(point :seq[int]) :auto =
    collect initHashSet:
      for offset in offsets:
        if not offset.allIt(it == 0): {zip(point, offset).mapIt(it[0] + it[1])}
  for cycle in 1 .. 6:
    var next = initHashSet[seq[int]]()
    for active in field:
      let neighbors = active.near
      if (neighbors * field).card in [2, 3]: next.incl(active)
      for neighbor in neighbors:
        if neighbor notin field and (neighbor.near * field).card == 3:
          next.incl(neighbor)
    field = next
  field.card

# NOTE: This is not fast, just concise! Will take a minute or so
echo conway(3)
echo conway(4)
