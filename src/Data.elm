module Data exposing (Language(..), slides)

import DomainTypes exposing (Item(..), Slide, Slides)


type Language
    = De
    | En


type alias I18nTranslations =
    { advantages : String
    , architecture : String
    , compilerMessages : String
    , content : String
    , disadvantages : String
    , encouragesDdd : String
    , funToWork : String
    , history : String
    , immutable : String
    , influencedByHaskell : String
    , influencedRedux : String
    , languageFeatures : String
    , learningCurve : String
    , nestedRecordUpdates : String
    , noRuntimeErrors : String
    , purelyFunctional : String
    , releaseInfo : String
    , smallEcosystem : String
    , staticallyTyped : String
    , typeSystem : String
    , webLanguage : String
    }


type alias Translations =
    { de : I18nTranslations
    , en : I18nTranslations
    }


type alias Translation =
    (I18nTranslations -> String) -> String


translations : Translations
translations =
    { de =
        { advantages = "Vorteile"
        , architecture = "Architektur"
        , compilerMessages = "Compiler-Nachrichten"
        , content = "Inhalt"
        , disadvantages = "Nachteile"
        , encouragesDdd = "    ▸ Regt zum nachdenken über die Domäne an"
        , funToWork = "    ▸ Spaßiges Arbeiten, oft ohne Browser-Interaktion"
        , history = "Geschichte"
        , immutable = "Immutable"
        , influencedByHaskell = "Wurde von Haskell beeinflusst"
        , influencedRedux = "Hat Redux beeinflusst"
        , languageFeatures = "Spracheigenschaften"
        , learningCurve = "Lernkurve ist vorhanden"
        , nestedRecordUpdates = "Updates von verschachtelten records"
        , noRuntimeErrors = "    ▸ Keine Fehler bei Laufzeit"
        , purelyFunctional = "Rein Funktional"
        , releaseInfo = "2012 von Evan Czaplicki veröffentlicht"
        , smallEcosystem = "Package-Ökosystem ist klein"
        , staticallyTyped = "Statisch typisiert"
        , typeSystem = "Typsystem"
        , webLanguage = "Sprache für Web Interfaces"
        }
    , en =
        { advantages = "Advantages"
        , architecture = "Architecture"
        , compilerMessages = "Compiler messages"
        , content = "Content"
        , disadvantages = "Disadvantages"
        , encouragesDdd = "    ▸ Encourages thinking about domain"
        , funToWork = "    ▸ Fun to work with, often w/o browser interaction"
        , history = "History"
        , immutable = "Immutable"
        , influencedByHaskell = "Influenced by Haskell"
        , influencedRedux = "Influenced Redux"
        , languageFeatures = "Language Features"
        , learningCurve = "Learning curve"
        , nestedRecordUpdates = "Nested records update"
        , noRuntimeErrors = "    ▸ No runtime errors"
        , purelyFunctional = "Purely Functional"
        , releaseInfo = "First released in 2012 by Evan Czaplicki"
        , smallEcosystem = "Small package ecosystem"
        , staticallyTyped = "Statically typed"
        , typeSystem = "Typesystem"
        , webLanguage = "Language for Web Interfaces"
        }
    }


translate : Language -> Translation
translate language get =
    let
        i18nTranslations =
            case language of
                De ->
                    translations.de

                En ->
                    translations.en
    in
    i18nTranslations |> get


exampleElmFunction : String
exampleElmFunction =
    """functionName : TypeA -> TypeB
functionName thingOfTypeA =
  createThingOfTypeB thingOfTypeA"""


elmArchitectureFunctionTypeDefs : String
elmArchitectureFunctionTypeDefs =
    """model : Model

view : Model -> Html Msg

update : Msg -> Model -> Model"""


contentSlide : Translation -> Slide
contentSlide t =
    { title = t .content
    , items =
        [ Paragraph (t .history)
        , Paragraph (t .languageFeatures)
        , Paragraph (t .architecture)
        , Paragraph (t .advantages ++ " & " ++ t .disadvantages)
        ]
    }


historySlide : Translation -> Slide
historySlide t =
    { title = t .history
    , items =
        [ Paragraph (t .releaseInfo)
        , Paragraph (t .webLanguage)
        , Paragraph (t .influencedRedux)
        , Paragraph (t .influencedByHaskell)
        ]
    }


languageFeaturesSlide : Translation -> Slide
languageFeaturesSlide t =
    { title = t .languageFeatures
    , items =
        [ Paragraph (t .purelyFunctional)
        , Paragraph (t .staticallyTyped)
        , Paragraph (t .immutable)
        , CodeBlock exampleElmFunction
        ]
    }


architectureSlide : Translation -> Slide
architectureSlide t =
    { title = t .architecture
    , items = [ CodeBlock elmArchitectureFunctionTypeDefs ]
    }


advantagesSlide : Translation -> Slide
advantagesSlide t =
    { title = t .advantages
    , items =
        [ Paragraph (t .typeSystem)
        , Paragraph (t .encouragesDdd)
        , Paragraph (t .noRuntimeErrors)
        , Paragraph (t .compilerMessages)
        , Paragraph (t .funToWork)
        ]
    }


disadvantagesSlide : Translation -> Slide
disadvantagesSlide t =
    { title = t .disadvantages
    , items =
        [ Paragraph (t .learningCurve)
        , Paragraph (t .nestedRecordUpdates)
        , Paragraph (t .smallEcosystem)
        ]
    }


slides : Language -> Slides
slides language =
    let
        t =
            translate language
    in
    [ { title = "Elm", items = [] }
    , contentSlide t
    , historySlide t
    , languageFeaturesSlide t
    , architectureSlide t
    , advantagesSlide t
    , disadvantagesSlide t
    , { title = "Live Coding", items = [] }
    ]
