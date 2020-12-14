import strutils, sequtils, algorithm

let
  input   = stdin.readAll.splitLines
  arrival = input[0].parseInt
  buses   = toSeq(pairs(input[1].split(','))).filterIt(it.val != "x")
    .mapIt((key : it.key, val : it.val.parseInt))
  target = buses.mapIt((bus : it.val, wait : it.val - arrival mod it.val))
    .sortedByIt(it.wait)[0]
echo target.bus * target.wait

var time, increment = buses[0].val
for bus in buses[1 .. ^1]:
  while (time + bus.key) mod bus.val != 0: time += increment
  increment *= bus.val
echo time
