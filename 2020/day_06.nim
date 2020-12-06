import sequtils, strutils, tables

proc group(s :string; everyone :bool) :set[char] =
  proc toSet(x :string) :set[char] =
    for i in x: result.incl(i)
  let people = s.splitLines.filterIt(not it.isEmptyOrWhitespace).mapIt(it.toSet)
  people.foldl(if everyone: a * b else: a + b)

let queries = stdin.readAll.split("\n\n").toSeq
echo queries.mapIt(it.group(everyone = false).card).foldl(a + b)
echo queries.mapIt(it.group(everyone = true).card).foldl(a + b)
