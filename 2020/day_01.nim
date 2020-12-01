import strutils, sequtils

func multiply(expenses :openArray[int]; degrees :static[int]) :int =
  var tally :array[degrees, int]
  template loop(input :openArray[int]; level :static[int]) =
    for idx, ele in input:
      tally[level] = ele
      when level == 0:
        if tally.foldl(a + b) == 2020: return tally.foldl(a * b)
      else:
        input[idx + 1 .. input.high].loop(level - 1)
  expenses.loop(degrees - 1)

var (line, expenses) = ("", newSeq[int]())
while stdin.readLine(line) and line != "": expenses &= line.parseInt
echo expenses.multiply(degrees = 2)
echo expenses.multiply(degrees = 3)
