import strscans, sequtils

type Entry = object
  bounds    :Slice[int]
  character :char
  password  :string

var (line, entries) = ("", newSeq[Entry]())
while stdin.readLine(line) and line != "":
  var (entry, boundString) = (Entry(), "")
  discard line.scanf(
    "$i-$i $w: $w",
    entry.bounds.a, entry.bounds.b, boundString, entry.password)
  entry.character = boundString[boundString.low]
  entries &= entry

echo entries.countIt(it.password.count(it.character) in it.bounds)
echo entries.countIt(it.password[it.bounds.a - 1] == it.character xor
                     it.password[it.bounds.b - 1] == it.character)
