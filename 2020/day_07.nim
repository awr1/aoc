import sets, tables, sequtils, strutils, strscans

type Sub = tuple[count :int; kind :string]
var bags = newTable[string, seq[Sub]]()
proc subs(containing :string) :seq[Sub] =
  if containing != "no other bags":
    proc subEntry(sub :string) :Sub =
      discard sub.scanf("$i $+ bag", result.count, result.kind)
    return containing.split(", ").map(subEntry)

for line in stdin.readAll.splitLines:
  var name, containing = ""
  if line.scanf("$+ bags contain $+.", name, containing):
    bags[name] = containing.subs

proc canContain(color :string) :HashSet[string] =
  var colorSet = initHashSet[string]()
  proc impl(iColor :string) =
    for name, subs in bags:
      if subs.anyIt(it.kind == iColor):
        colorSet.incl(name)
        name.impl
  color.impl
  colorSet

proc bagsNeeded(color :string) :int =
  for name, subs in bags:
    if name == color:
      for sub in subs:
        result += sub.count + (sub.count * sub.kind.bagsNeeded)

echo canContain("shiny gold").card
echo bagsNeeded("shiny gold")
