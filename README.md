Limit the number of allowed values on a variant to 1 at most
by using the [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rule
[`Review.VariantValueCount.zeroOrOne`](https://package.elm-lang.org/packages/lue-bird/elm-review-variant-value-count/1.0.1/Review-VariantValueCount/#zeroOrOne)

## try it

```bash
elm-review --template lue-bird/elm-review-variant-value-count/example
```

## add it to your config

```elm
module ReviewConfig exposing (config)

import Review.VariantValueCount
import Review.Rule

config : List Review.Rule.Rule
config =
    [ Review.VariantValueCount.zeroOrOne
    ]
```

## why

A variant with multiple arguments is very similar to automatic record type alias constructor functions and arbitrary-size tuples
in that its parts can only be differentiated by position.

All three share the same problem: This position is usually neither obvious nor descriptive.
A missed chance to let the code be self-documenting!

Even when you think it's clear, there are likely implicit roles of the variant values:
```elm
type Msg
    = MessageReceived User Message
```
turns out in this case it was supposed to have been
```elm
type Msg
    = MessageReceived { recipient : User, message : Message }
```

One valid criticism is that `case` patterns now can't be nested
and so casing becomes more verbose.
And I will never disagree with you on that.
Pattern matching on records is just a missing feature in elm.
