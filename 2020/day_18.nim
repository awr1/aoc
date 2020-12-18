import macros, strutils, math

# WARNING: A "sensible" way to implement this would be to use PEGs and a stack.
# I instead chose an extremely cursed way for the fun of it, exploiting Nim's
# macro capabilities and operator precedence rules ;)

func `^+`(a, b :int) :int = a + b
func `^-`(a, b :int) :int = a - b
func `/+`(a, b :int) :int = a + b
func `/-`(a, b :int) :int = a - b
func `/`(a, b :int)  :int = a div b

const input = "sum [" & "day_18_input.txt".slurp.replace('\n', ',') & ']'
macro deprecedented() :int =
  parseExpr(input.multiReplace(("+", "/+"), ("-", "/-")))
macro precedented() :int =
  parseExpr(input.multiReplace(("+", "^+"), ("-", "^-")))

echo deprecedented()
echo precedented()
