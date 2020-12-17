import strutils, strscans, sequtils, sets, math, sugar

var
  line            = ""
  slices          = newSeq[tuple[name :string; ranges :array[2, Slice[int]]]]()
  (your, nearby)  = (newSeq[int](), newSeq[seq[int]]())

while stdin.readLine(line):
  var (name, pair) = ("", [0 .. 0, 0 .. 0])
  if line.scanf("$+: $i-$i or $i-$i",
                name, pair[0].a, pair[0].b, pair[1].a, pair[1].b):
    slices &= (name, pair)
  elif line == "your ticket:":
    discard stdin.readLine(line); your = line.split(',').map(parseInt)
  elif line == "nearby tickets:":
    while stdin.readLine(line): nearby &= line.split(',').map(parseInt)

func validates(slice :slices[0].type; x :int) :bool =
  x in slice.ranges[0] or x in slice.ranges[1]

var sliceSets = collect newSeq:
  for yourIdx, _ in your:
    let nums = nearby.filter(x => x.all(y => slices.anyIt(it.validates(y))))
      .mapIt(it[yourIdx])
    collect initHashSet:
      for sliceIdx, slice in slices:
        if nums.allIt(slice.validates(it)): {sliceIdx}

for idxA, a in sliceSets.mpairs:
  for idxB, b in sliceSets.pairs:
    if idxA != idxB and (let c = a - b; c.card > 0): a = c

echo nearby.map(x => x.filter(y => not slices.anyIt(it.validates(y))).sum).sum
echo zip(your, sliceSets.mapIt(slices[it.toSeq[0]]))
  .filterIt(it[1].name.startsWith("departure"))
  .mapIt(it[0]).prod
