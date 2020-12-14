import bitops, tables, strscans, sequtils, strutils

var
  line       = ""
  mem1, mem2 = newTable[int, int]()
  mask       = (x : 0, overwrite : 0)

while stdin.readLine(line) and line != "":
  var memAddr, memValue = 0
  if line.startsWith("mask = "):
    line.removePrefix("mask = "); mask.reset
    for idx, ele in line:
      let bit = 35 - idx
      if   ele == 'X': mask.x.setBit(bit)
      elif ele == '1': mask.overwrite.setBit(bit)
      elif ele == '0': mask.overwrite.clearBit(bit)
  elif line.scanf("mem[$i] = $i", memAddr, memValue):
    mem1[memAddr] = bitor(bitand(memValue,       mask.x),
                          bitand(mask.overwrite, bitnot(mask.x)))
    func nthSetBit(x, n :int) :int =
      var xx = x # params are constant in Nim, so a new variable is needed
      for i in 0 ..< n: result += xx.firstSetBit; xx = xx shr xx.firstSetBit
    let pc = 0 ..< popcount(mask.x)
    for counter in 0 .. toMask[int64](pc):
      var adjustedAddr = memAddr
      for maskBit in pc:
        let addrBit = mask.x.nthSetBit(maskBit + 1) - 1
        if counter.testBit(maskBit): adjustedAddr.setBit(addrBit)
        else:                        adjustedAddr.clearBit(addrBit)
      mem2[bitor(mask.overwrite, adjustedAddr)] = memValue

echo toSeq(mem1.values).foldl(a + b)
echo toSeq(mem2.values).foldl(a + b)
