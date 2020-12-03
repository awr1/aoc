import bitops, sequtils

var (line, rows, cycle) = ("", newSeq[int](), 0)
while stdin.readLine(line) and line != "":
  cycle = line.len
  rows &= 0
  for idx, ele in line:
    if ele == '#': rows[^1].setBit(idx)

proc countTrees(right, down :int) :int =
  var x = 0
  for y in countup(0, rows.high, down):
    if rows[y].testBit(x): result += 1
    x = (x + right) mod cycle

echo countTrees(3, 1)
echo [countTrees(1, 1),
      countTrees(3, 1),
      countTrees(5, 1),
      countTrees(7, 1),
      countTrees(1, 2)].foldl(a * b)
