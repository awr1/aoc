import algorithm, sequtils, strutils, sets, sugar

let starting = collect initHashSet:
  for xIdx, x in stdin.readAll.splitLines.map(x => x.mapIt(it == '#')):
    for yIdx, y in x:
      if y: {@[xIdx, yIdx]}

proc conway(dims, cycles :int) :auto =
  let offsets = product(@[-1, 0, +1].repeat(dims))
  var field   = collect initHashSet:
    for i in starting: (var j = i; j.setLen(dims); {j})
  proc near(p :seq[int]) :auto =
    collect initHashSet:
      for i in offsets:
        if not i.allIt(it == 0): {zip(p, i).mapIt(it[0] + it[1])}
  for cycle in 1 .. cycles:
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
echo conway(3, 6)
echo conway(4, 6)
