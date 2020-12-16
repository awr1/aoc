proc game(target :int) :int =
  let starting = [20, 9, 11, 0, 1, 2]
  var ages     = newSeq[int](target)
  for round in 1 ..< target:
    # Technically this branching in the main loop is unnecessary (and a little
    # unoptimal) as the problem will never ask for one of the starting numbers
    # but for the sake of technical accuracy...
    if round - 1 in 0 .. starting.high:
      result = starting[round - 1]; ages[result] = round
    else:
      if round - 1 == starting.high + 1: result = 0
      let prior    = ages[result]
      ages[result] = round
      result       = if prior == 0: 0 else: (round - prior)

echo game(2020)
echo game(30000000)
