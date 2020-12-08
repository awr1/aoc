import strutils, strscans, sequtils

type Kind = enum acc, jmp, nop

var ops = stdin.readAll.splitLines.filterIt(not it.isEmptyOrWhitespace).mapIt(
  (let x = it.split; (kind : parseEnum[Kind](x[0]), arg : parseInt(x[1]))))

proc run() :auto =
  var
    exec = newSeq[bool](ops.len)
    regs = (acc : 0, pc : 0)
  while regs.pc in ops.low .. ops.high:
    if exec[regs.pc]:
      return (terminates : false, acc : regs.acc)
    exec[regs.pc] = true
    case ops[regs.pc].kind
    of acc:
      regs.acc += ops[regs.pc].arg
      regs.pc  += 1
    of jmp:
      regs.pc += ops[regs.pc].arg
    of nop:
      regs.pc += 1
  return (terminates : true, acc : regs.acc)

echo run().acc
for idx, op in ops.mpairs:
  proc switch() :bool =
    if   op.kind == nop: op.kind = jmp; return true
    elif op.kind == jmp: op.kind = nop; return true

  if switch():
    if (let pass = run(); pass.terminates):
      echo pass.acc; break
    else:
      discard switch()
