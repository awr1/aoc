import bitops, tables, strscans, sequtils, strutils

var
  line       = ""
  mem1, mem2 = newTable[int, int]()
  mask       = (x : 0, overwrite : 0)

while stdin.readLine(line) and line != "":
  var memAddr, memValue = 0
  if line.startsWith("mask = "):
    echo(line)
    line.removePrefix("mask = ")
    mask.reset
    for idx, ele in line:
      let bitidx = 35 - idx
      if   ele == 'X': mask.x.setBit(bitidx)
      elif ele == '1': mask.overwrite.setBit(bitidx)
      elif ele == '0': mask.overwrite.clearBit(bitidx)
  elif line.scanf("mem[$i] = $i", memAddr, memValue):
    mem1[memAddr] = bitor(bitand(memValue,       mask.x),
                          bitand(mask.overwrite, bitnot(mask.x)))
    func nthSetBit(x, n :int) :int =
      var xx = x
      for i in 0 ..< n:
        result += xx.firstSetBit
        xx      = xx shr xx.firstSetBit
    let pc = 0 ..< popcount(mask.x)
    for i in 0 .. toMask[int64](pc):
      var adjustedAddr = memAddr
      for j in pc:
        let n = mask.x.nthSetBit(j + 1) - 1
        if i.testBit(j): adjustedAddr.setBit(n)
        else:            adjustedAddr.clearBit(n)
      mem2[bitOr(mask.overwrite, adjustedAddr)] = memValue

echo toSeq(mem1.values).foldl(a + b)
echo toSeq(mem2.values).foldl(a + b)
