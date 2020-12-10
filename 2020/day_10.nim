import strutils, sequtils, algorithm, tables

var diffs = newCountTable[int]()
let
  adapters = stdin.readAll.splitLines
    .filterIt(not it.isEmptyOrWhitespace).map(parseInt).sorted
  jolts = @[0] & adapters & @[adapters.max + 3]
for i in 0 ..< jolts.high: diffs.inc(jolts[i + 1] -  jolts[i])
echo diffs[3] * diffs[1]

var memo = newTable[int, int]()
proc arrangements(x = 0) :int =
  if x == jolts.high:
    return 1
  else:
    for y in x + 1 .. min(x + 3, jolts.high):
      if jolts[y] - jolts[x] in 1 .. 3 and jolts[y] <= jolts[jolts.high]:
        if y in memo:
          result += memo[y]
        else:
          let z   = arrangements(y)
          memo[y] = z
          result += z
echo arrangements()
