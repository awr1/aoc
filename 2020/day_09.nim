import strutils, sequtils, deques

let nums = stdin.readAll.splitLines
  .filterIt(not it.isEmptyOrWhitespace)
  .mapIt(it.parseInt)

proc invalid() :int =
  var dnums = nums.toDeque
  while true:
    block validity:
      for a in 0 ..< 25:
        for b in a ..< 25:
          if dnums[a] + dnums[b] == dnums[25]:
            discard dnums.popFirst; break validity
      return dnums[25]

proc weakness(target = invalid()) :int =
  for start, _ in nums.pairs:
    var sum = 0
    for offset in start .. nums.high:
      sum += nums[offset]
      if sum == target:
        return nums[start .. offset].min + nums[start .. offset].max
      elif sum > target:
        break

echo invalid()
echo weakness()
