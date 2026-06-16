---@meta bint

---Small portable arbitrary-precision integer arithmetic library in pure Lua.
---
---The module returned by `require('bint')` is a factory function that creates
---a bint module configured for a fixed integer size.
---
---```lua
---local bint = require('bint')(256) -- 256-bit integers
---local x = bint.new('12345678901234567890')
---```
---@class bintlib
---@field bits integer Number of bits representing a bint instance.
local bintlib = {}

---A bint instance: an arbitrary-precision fixed-width integer.
---@class bint
---@field [integer] integer Internal words are exposed as numeric array entries.
local bint = {}

--#region Factory / module creation

---Create a new bint module representing integers of the desired bit size.
---This is the returned function when `require('bint')` is called.
---@param bits integer Number of bits for the integer representation, must be multiple of wordbits and at least 64.
---@param wordbits? integer Number of bits for the internal word, defaults to half of Lua's integer size.
---@return bintlib bintmodule
function bintlib.newmodule(bits, wordbits) end

--#endregion

--#region Constructors

---Create a new bint with 0 value.
---@return bint
function bintlib.zero() end

---Create a new bint with 1 value.
---@return bint
function bintlib.one() end

---Create a new bint with the maximum possible integer value.
---@return bint
function bintlib.maxinteger() end

---Create a new bint with the minimum possible integer value.
---@return bint
function bintlib.mininteger() end

---Create a bint from an unsigned integer.
---Treats signed integers as an unsigned integer.
---@param x integer A value to initialize from convertible to a Lua integer.
---@return bint? bint nil if the input cannot be represented by an integer.
function bintlib.fromuinteger(x) end

---Create a bint from a signed integer.
---@param x integer A value to initialize from convertible to a Lua integer.
---@return bint? bint nil if the input cannot be represented by an integer.
function bintlib.frominteger(x) end

---Create a bint from a string of the desired base.
---@param s string The string to be converted from, must have only alphanumeric and '+-' characters.
---@param base? integer Base that the number is represented, defaults to 10. Must be at least 2 and at most 36.
---@return bint? bint nil if the conversion failed.
function bintlib.frombase(s, base) end

---Create a new bint from a string.
---The string can be a decimal number, binary number prefixed with '0b' or hexadecimal number prefixed with '0x'.
---@param s string A string convertible to a bint.
---@return bint? bint nil if the conversion failed.
function bintlib.fromstring(s) end

---Create a new bint from a buffer of little-endian bytes.
---Extra bytes are trimmed from the right, missing bytes are padded to the right.
---@param buffer string Buffer of bytes.
---@return bint
function bintlib.fromle(buffer) end

---Create a new bint from a buffer of big-endian bytes.
---Extra bytes are trimmed from the left, missing bytes are padded to the left.
---@param buffer string Buffer of bytes.
---@return bint
function bintlib.frombe(buffer) end

---Create a new bint from a value.
---@param x bint|number|string A value convertible to a bint (string, number or another bint).
---@return bint bint
function bintlib.new(x) end

---Convert a value to a bint if possible.
---@param x bint|number|string A value to be converted (string, number or another bint).
---@param clone? boolean If true, a new bint reference is returned. Defaults to false.
---@return bint? bint nil if the conversion failed.
function bintlib.tobint(x, clone) end

---Convert a value to a bint if possible otherwise to a Lua number.
---@param x bint|number|string A value to be converted (string, number or another bint).
---@param clone? boolean If true, a new bint reference is returned. Defaults to false.
---@return bint|number|nil value A bint, Lua number or nil if the conversion failed.
function bintlib.parse(x, clone) end

---Truncate a number to a bint.
---Floats are truncated, that is, the fractional part is discarded.
---@param x number A number to truncate.
---@return bint? bint nil if the input does not fit in a bint or is not a number.
function bintlib.trunc(x) end

--#endregion

--#region Conversions

---Convert a bint to an unsigned integer.
---Note that large unsigned integers may be represented as negatives in Lua integers.
---@param x bint|number A bint or a number to be converted into an unsigned integer.
---@return integer? integer nil if the input cannot be represented by an integer.
function bintlib.touinteger(x) end

---Convert a bint to a signed integer.
---It works by taking absolute values then applying the sign bit in case needed.
---@param x bint|number A bint or value to be converted into a signed integer.
---@return integer? integer nil if the input cannot be represented by an integer.
function bintlib.tointeger(x) end

---Convert a bint to a Lua float in case integer would wrap around or Lua integer otherwise.
---@param x bint|number A bint or value to be converted into a Lua number.
---@return number? number nil if the input cannot be represented by a number.
function bintlib.tonumber(x) end

---Convert a bint to a string in the desired base.
---@param x bint The bint to be converted from.
---@param base? integer Base to be represented, defaults to 10. Must be at least 2 and at most 36.
---@param unsigned? boolean Whether to output as an unsigned integer. Defaults to false for base 10 and true for others.
---@return string?
function bintlib.tobase(x, base, unsigned) end

---Convert a bint to a buffer of little-endian bytes.
---@param x bint|integer A bint or Lua integer.
---@param trim? boolean If true, zero bytes on the right are trimmed.
---@return string buffer
function bintlib.tole(x, trim) end

---Convert a bint to a buffer of big-endian bytes.
---@param x bint|integer A bint or Lua integer.
---@param trim? boolean If true, zero bytes on the left are trimmed.
---@return string buffer
function bintlib.tobe(x, trim) end

---Convert a bint to a string on base 10.
---@return string
function bint:__tostring() end

--#endregion

--#region Type predicates

---Check if a number is 0 considering bints.
---@param x bint|number
---@return boolean
function bintlib.iszero(x) end

---Check if a number is 1 considering bints.
---@param x bint|number
---@return boolean
function bintlib.isone(x) end

---Check if a number is -1 considering bints.
---@param x bint|number
---@return boolean
function bintlib.isminusone(x) end

---Check if the input is a bint.
---@param x any
---@return boolean
function bintlib.isbint(x) end

---Check if the input is a Lua integer or a bint.
---@param x any
---@return boolean
function bintlib.isintegral(x) end

---Check if the input is a bint or a Lua number.
---@param x any
---@return boolean
function bintlib.isnumeric(x) end

---Get the number type of the input (bint, integer or float).
---@param x any
---@return 'bint'|'integer'|'float'|nil type
function bintlib.type(x) end

---Check if a number is negative considering bints.
---@param x bint|number
---@return boolean
function bintlib.isneg(x) end

---Check if a number is positive considering bints.
---@param x bint|number
---@return boolean
function bintlib.ispos(x) end

---Check if a number is even considering bints.
---@param x bint|number
---@return boolean
function bintlib.iseven(x) end

---Check if a number is odd considering bints.
---@param x bint|number
---@return boolean
function bintlib.isodd(x) end

--#endregion

--#region In-place mutating methods

---Bitwise left shift a bint in one bit (in-place).
---@return bint self
function bint:_shlone() end

---Bitwise right shift a bint in one bit (in-place).
---@return bint self
function bint:_shrone() end

---Increment a bint by one (in-place).
---@return bint self
function bint:_inc() end

---Decrement a bint by one (in-place).
---@return bint self
function bint:_dec() end

---Assign a bint to a new value (in-place).
---@param y bint|integer A value to be copied from.
---@return bint self
function bint:_assign(y) end

---Take absolute of a bint (in-place).
---@return bint self
function bint:_abs() end

---Add an integer to a bint (in-place).
---@param y bint|integer An integer to be added.
---@return bint self
function bint:_add(y) end

---Subtract an integer from a bint (in-place).
---@param y bint|integer An integer to subtract.
---@return bint self
function bint:_sub(y) end

---Bitwise AND bints (in-place).
---@param y bint|integer
---@return bint self
function bint:_band(y) end

---Bitwise OR bints (in-place).
---@param y bint|integer
---@return bint self
function bint:_bor(y) end

---Bitwise XOR bints (in-place).
---@param y bint|integer
---@return bint self
function bint:_bxor(y) end

---Bitwise NOT a bint (in-place).
---@return bint self
function bint:_bnot() end

---Negate a bint (in-place). This effectively applies two's complements.
---@return bint self
function bint:_unm() end

--#endregion

--#region Arithmetic / bitwise functions

---Increment a number by one considering bints.
---@param x bint|number A bint or a Lua number to increment.
---@return bint|number
function bintlib.inc(x) end

---Decrement a number by one considering bints.
---@param x bint|number A bint or a Lua number to decrement.
---@return bint|number
function bintlib.dec(x) end

---Take absolute of a number considering bints.
---@param x bint|number A bint or a Lua number to take the absolute.
---@return bint|number
function bintlib.abs(x) end

---Take the floor of a number considering bints.
---@param x bint|number A bint or a Lua number to perform the floor operation.
---@return bint
function bintlib.floor(x) end

---Take ceil of a number considering bints.
---@param x bint|number A bint or a Lua number to perform the ceil operation.
---@return bint
function bintlib.ceil(x) end

---Wrap around bits of an integer (discarding left bits) considering bints.
---@param x bint|integer A bint or a Lua integer.
---@param y integer Number of right bits to preserve.
---@return bint
function bintlib.bwrap(x, y) end

---Rotate left integer x by y bits considering bints.
---@param x bint|integer A bint or a Lua integer.
---@param y integer Number of bits to rotate.
---@return bint
function bintlib.brol(x, y) end

---Rotate right integer x by y bits considering bints.
---@param x bint|integer A bint or a Lua integer.
---@param y integer Number of bits to rotate.
---@return bint
function bintlib.bror(x, y) end

---Take maximum between two numbers considering bints.
---@param x bint|number A bint or Lua number to compare.
---@param y bint|number A bint or Lua number to compare.
---@return bint|number
function bintlib.max(x, y) end

---Take minimum between two numbers considering bints.
---@param x bint|number A bint or Lua number to compare.
---@param y bint|number A bint or Lua number to compare.
---@return bint|number
function bintlib.min(x, y) end

--#endregion

--#region Division / modulo

---Perform unsigned division and modulo operation between two integers considering bints.
---@param x bint|integer The numerator.
---@param y bint|integer The denominator.
---@return bint quotient
---@return bint remainder
function bintlib.udivmod(x, y) end

---Perform unsigned division between two integers considering bints.
---@param x bint|integer The numerator.
---@param y bint|integer The denominator.
---@return bint quotient
function bintlib.udiv(x, y) end

---Perform unsigned integer modulo operation between two integers considering bints.
---@param x bint|integer The numerator.
---@param y bint|integer The denominator.
---@return bint remainder
function bintlib.umod(x, y) end

---Perform integer truncate division and modulo operation between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number quotient
---@return bint|number remainder
function bintlib.tdivmod(x, y) end

---Perform truncate division between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number quotient
function bintlib.tdiv(x, y) end

---Perform integer truncate modulo operation between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number remainder
function bintlib.tmod(x, y) end

---Perform integer floor division and modulo operation between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number quotient
---@return bint|number remainder
function bintlib.idivmod(x, y) end

--#endregion

--#region Operators

---Add two numbers considering bints.
---@param x bint|number
---@param y bint|number
---@return bint|number
function bintlib.__add(x, y) end

---Subtract two numbers considering bints.
---@param x bint|number
---@param y bint|number
---@return bint|number
function bintlib.__sub(x, y) end

---Multiply two numbers considering bints.
---@param x bint|number
---@param y bint|number
---@return bint|number
function bintlib.__mul(x, y) end

---Check if bints are equal.
---@param x bint
---@param y bint
---@return boolean
function bintlib.__eq(x, y) end

---Check if numbers are equal considering bints.
---@param x bint|number
---@param y bint|number
---@return boolean
function bintlib.eq(x, y) end

---Perform floor division between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number quotient
function bintlib.__idiv(x, y) end

---Perform division between two numbers considering bints.
---This always casts inputs to floats.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return number quotient
function bintlib.__div(x, y) end

---Perform integer floor modulo operation between two numbers considering bints.
---@param x bint|number The numerator.
---@param y bint|number The denominator.
---@return bint|number remainder
function bintlib.__mod(x, y) end

---Perform integer power between two integers considering bints.
---If y is negative then pow is performed as an unsigned integer.
---@param x bint|integer The base.
---@param y bint|integer The exponent.
---@return bint result
function bintlib.ipow(x, y) end

---Perform integer power between two unsigned integers over a modulus considering bints.
---@param x bint|integer The base.
---@param y bint|integer The exponent.
---@param m bint|integer The modulus.
---@return bint result
function bintlib.upowmod(x, y, m) end

---Perform numeric power between two numbers considering bints.
---This always casts inputs to floats.
---@param x bint|number The base.
---@param y bint|number The exponent.
---@return number result
function bintlib.__pow(x, y) end

---Bitwise left shift integers considering bints.
---@param x bint|integer An integer to perform the bitwise shift.
---@param y integer An integer with the number of bits to shift.
---@return bint result
function bintlib.__shl(x, y) end

---Bitwise right shift integers considering bints.
---@param x bint|integer An integer to perform the bitwise shift.
---@param y integer An integer with the number of bits to shift.
---@return bint result
function bintlib.__shr(x, y) end

---Bitwise AND two integers considering bints.
---@param x bint|integer An integer to perform bitwise AND.
---@param y bint|integer An integer to perform bitwise AND.
---@return bint result
function bintlib.__band(x, y) end

---Bitwise OR two integers considering bints.
---@param x bint|integer An integer to perform bitwise OR.
---@param y bint|integer An integer to perform bitwise OR.
---@return bint result
function bintlib.__bor(x, y) end

---Bitwise XOR two integers considering bints.
---@param x bint|integer An integer to perform bitwise XOR.
---@param y bint|integer An integer to perform bitwise XOR.
---@return bint result
function bintlib.__bxor(x, y) end

---Bitwise NOT a bint.
---@param x bint|integer An integer to perform bitwise NOT.
---@return bint result
function bintlib.__bnot(x) end

---Negate a bint. This effectively applies two's complements.
---@param x bint A bint to perform negation.
---@return bint result
function bintlib.__unm(x) end

---Compare if integer x is less than y considering bints (unsigned version).
---@param x bint|integer Left integer to compare.
---@param y bint|integer Right integer to compare.
---@return boolean
function bintlib.ult(x, y) end

---Compare if bint x is less or equal than y considering bints (unsigned version).
---@param x bint|integer Left integer to compare.
---@param y bint|integer Right integer to compare.
---@return boolean
function bintlib.ule(x, y) end

---Compare if number x is less than y considering bints and signs.
---@param x bint|number Left value to compare.
---@param y bint|number Right value to compare.
---@return boolean
function bintlib.__lt(x, y) end

---Compare if number x is less or equal than y considering bints and signs.
---@param x bint|number Left value to compare.
---@param y bint|number Right value to compare.
---@return boolean
function bintlib.__le(x, y) end

--#endregion

---Allow creating bints by calling the module itself (`bint(...)` is an alias for `bint.new(...)`).
---@param x bint|number|string A value convertible to a bint.
---@return bint
function bintlib.__call(x) end

return bintlib
