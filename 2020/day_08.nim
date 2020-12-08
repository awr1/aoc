import strutils, strscans, sequtils

type Kind = enum acc, nop, jmp

var ops = stdin.readAll.splitLines.filterIt(not it.isEmptyOrWhitespace).mapIt(
  (let x = it.split; (kind : parseEnum[Kind](x[0]), arg : parseInt(x[1]))))

proc solve() :tuple[part1, part2 :int] =
  var (stack, terminates) = (newSeq[int](), false)
  proc switch(x :int) =
    if   ops[x].kind == jmp: ops[x].kind = nop
    elif ops[x].kind == nop: ops[x].kind = jmp
  proc run(pushing = true) :int =
    var (pc, exec) = (0, newSeq[bool](ops.len))
    while pc in ops.low .. ops.high:
      if exec[pc]: return
      exec[pc] = true
      case ops[pc].kind
      of acc: result += ops[pc].arg;     pc += 1
      of nop: (if pushing: stack &= pc); pc += 1
      of jmp: (if pushing: stack &= pc); pc += ops[pc].arg
    terminates = true
  result.part1 = run()
  for i in stack:
    i.switch; defer: i.switch # preserve code on fail
    if (let x = run(pushing = false); terminates): result.part2 = x; return

echo solve()
