module Review.VariantValueCount exposing (zeroOrOne)

{-| Limit the number of values allowed on a variant

@docs zeroOrOne

-}

import Elm.Syntax.Declaration
import Elm.Syntax.Node
import Review.Rule


type alias Context =
    ()


initialContextCreator : Review.Rule.ContextCreator () Context
initialContextCreator =
    Review.Rule.initContextCreator
        (\() ->
            ()
        )


{-| Reports variant definitions that have multiple attached values

    config =
        [ Review.VariantValueCount.zeroOrOne
        ]


## reported

    type User
        = User String Time.Posix


## not reported

    type User
        = User { name : String, registrationTime : Time.Posix }

dependency variants with multiple arguments are also ok

    import List.NonEmpty exposing (NonEmpty(..))

    notReported =
        List.NonEmpty.NonEmpty 'H' [ 'e', 'l', 'l', 'o' ]

-}
zeroOrOne : Review.Rule.Rule
zeroOrOne =
    Review.Rule.newModuleRuleSchemaUsingContextCreator "Review.VariantValueCount" initialContextCreator
        |> Review.Rule.withDeclarationEnterVisitor
            (\(Elm.Syntax.Node.Node _ declaration) () ->
                ( case declaration of
                    Elm.Syntax.Declaration.CustomTypeDeclaration choiceType ->
                        choiceType.constructors
                            |> List.filterMap
                                (\(Elm.Syntax.Node.Node _ variant) ->
                                    case variant.arguments of
                                        [] ->
                                            Nothing

                                        [ _ ] ->
                                            Nothing

                                        _ :: _ :: _ ->
                                            Just
                                                (Review.Rule.error
                                                    { message = "Too many variant values"
                                                    , details = [ "Keeping track which position is which value with which role is hard. Give them some nice names by putting the values into a record!" ]
                                                    }
                                                    (variant.name |> Elm.Syntax.Node.range)
                                                )
                                )

                    _ ->
                        []
                , ()
                )
            )
        |> Review.Rule.fromModuleRuleSchema
