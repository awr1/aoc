import strutils, sequtils, sugar

type Tile = enum Floor, Empty, Occupied

let rows = stdin.readAll.splitLines
  .filterIt(not it.isEmptyOrWhitespace)
  .map(x => x.map(y => (if y == '.': Floor else: Empty)))

proc simulate(input :seq[seq[Tile]], visibility :bool) :seq[seq[Tile]] =
  result = input
  for y, row in input:
    for x, tile in row:
      if tile != Floor:
        var adjacents = 0
        for dY in [-1, 0, +1]:
          for dX in [-1, 0, +1]:
            if (dX, dY) != (0, 0):
              var i = 1
              while (let (xx, yy) = (x + (dX * i), y + (dY * i));
                     xx in row.low .. row.high and yy in input.low .. input.high):
                if   input[yy][xx] == Occupied: adjacents += 1; break
                elif input[yy][xx] == Empty or not visibility:  break
                i += 1
        if adjacents >= (if visibility: 5 else: 4) and tile == Occupied:
          result[y][x] = Empty
        elif adjacents == 0 and tile == Empty:
          result[y][x] = Occupied

proc equilibrium(visibility :bool) :int =
  var (a, b) = (rows, rows.simulate(visibility))
  while a != b: a = b.simulate(visibility); swap(a, b)
  a.mapIt(it.count(Occupied)).foldl(a + b)

echo equilibrium(visibility = false)
echo equilibrium(visibility = true)
