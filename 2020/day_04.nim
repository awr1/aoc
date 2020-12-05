import sequtils, strutils

type PResult = enum KeysValid, ValuesValid

proc initPassport(str :string) :set[PResult] =
  type PField = enum byr, iyr, eyr, hgt, hcl, ecl, pid, cid
  var pKeys, pValues :set[PField]
  defer:
    echo pValues
    if {byr, iyr, eyr, hgt, hcl, ecl, pid} <= pKeys: result.incl(KeysValid)
    if pValues == pKeys:                             result.incl(ValuesValid)

  for line in str.splitLines:
    if not line.isEmptyOrWhiteSpace:
      for field in line.split(seps = Whitespace):
        let
          sPair        = field.split(seps = {':'})
          (key, value) = (parseEnum[PField](sPair[0]), sPair[1])
        pKeys.incl(key)

        template rangeIncl(sNumber :string; slice :Slice[int]) =
          try:
            let number = sNumber.parseInt
            if number in slice: pValues.incl(key)
          except ValueError:
            discard

        case key
        of byr: value.rangeIncl(1920 .. 2002)
        of iyr: value.rangeIncl(2010 .. 2020)
        of eyr: value.rangeIncl(2020 .. 2030)
        of hgt:
          try:
            let num = value[0 ..< ^2]
            if   value.endsWith("cm"): num.rangeIncl(150 .. 193)
            elif value.endsWith("in"): num.rangeIncl(59 .. 76)
          except ValueError:
            discard
        of hcl:
          if value.startsWith('#') and
             value.len == 6 + 1    and
             value[1 .. ^1].allCharsInSet(HexDigits):
            pValues.incl(key)
        of ecl:
          if value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]:
            pValues.incl(key)
        of pid:
          if value.len == 9 and value.allCharsInSet(Digits):
            pValues.incl(key)
        of cid:
          pValues.incl(key)

var (text, passports) = (stdin.readAll, newSeq[set[PResult]]())
for chunk in text.split("\n\n"): passports &= chunk.initPassport()
echo passports.countIt(KeysValid in it)
echo passports.countIt(it == {KeysValid, ValuesValid})
