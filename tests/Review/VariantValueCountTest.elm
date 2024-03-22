module Review.VariantValueCountTest exposing (all)

import Review.Test
import Review.VariantValueCount
import Test exposing (Test, describe, test)


all : Test
all =
    describe "Review.VariantValueCount"
        [ test "should not report an error when variant has 0 values" <|
            \() ->
                """module A exposing (..)
type A
    = AVariant
"""
                    |> Review.Test.run Review.VariantValueCount.zeroOrOne
                    |> Review.Test.expectNoErrors
        , test "should not report an error when variant has 1 value" <|
            \() ->
                """module A exposing (..)
type A
    = AVariant Int
"""
                    |> Review.Test.run Review.VariantValueCount.zeroOrOne
                    |> Review.Test.expectNoErrors
        , test "should report an error when variant has 2 values" <|
            \() ->
                """module A exposing (..)
type A
    = AVariant Int Int
"""
                    |> Review.Test.run Review.VariantValueCount.zeroOrOne
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Too many variant values"
                            , details = [ "Keeping track which position is which value with which role is hard. Give them some nice names by putting the values into a record!" ]
                            , under = "AVariant"
                            }
                        ]
        , test "should report an error when variant has 3 values" <|
            \() ->
                """module A exposing (..)
type A
    = AVariant Int Int Int
"""
                    |> Review.Test.run Review.VariantValueCount.zeroOrOne
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Too many variant values"
                            , details = [ "Keeping track which position is which value with which role is hard. Give them some nice names by putting the values into a record!" ]
                            , under = "AVariant"
                            }
                        ]
        , test "should report multiple errors at the same time when variant has 2 values" <|
            \() ->
                """module A exposing (..)
type A
    = AVariant Int Int
    | BVariant Int Int Int
"""
                    |> Review.Test.run Review.VariantValueCount.zeroOrOne
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Too many variant values"
                            , details = [ "Keeping track which position is which value with which role is hard. Give them some nice names by putting the values into a record!" ]
                            , under = "AVariant"
                            }
                        , Review.Test.error
                            { message = "Too many variant values"
                            , details = [ "Keeping track which position is which value with which role is hard. Give them some nice names by putting the values into a record!" ]
                            , under = "BVariant"
                            }
                        ]
        ]
