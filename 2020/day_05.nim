import sequtils, strutils, intsets

func seatID(input :string) :int =
  var (rows, columns) = (0 .. 127, 0 .. 7)
  for ele in input:
    case ele
    of 'F': rows.b    -= rows.len    div 2
    of 'B': rows.a    += rows.len    div 2
    of 'L': columns.b -= columns.len div 2
    of 'R': columns.a += columns.len div 2
    else: discard
  rows.a * 8 + columns.a

let ids = stdin.readAll.splitLines.toSeq.map(seatID)
echo ids.max
echo (0 .. ids.max).toSeq.toIntSet - ids.toIntSet
