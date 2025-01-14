
maplists
=====

An OTP library which implements the `lists:(u)key...` functions but for lists of maps.
Instead of comparing values of the Nth element of tuples these functions compare values associated with the given key in maps.

Some minor difference in semantics:

- whenever a function in the `lists` module has `(Key, N...)` in its parameters, the similar function in this library has (Key, Value, ...) where `Key` is the name of the key to look up and `Value` is the value to compare with, so they kind of changed places for readability.
- the `keyreplace` and `keystore` functions in this library won't crash if the `NewTuple` is not map, unlike they do in the `lists` for not tuples.
- `(u)keysort` are just wrappers for `lists:(u)sort`

The following functions are implemented:
- `keydelete`
- `keyfind`
- `keymap`
- `keymember`
- `keymerge`
- `keyreplace`
- `keysearch`
- `keysort`
- `keystore`
- `keytake`
- `ukeymerge`
- `ukeysort`


