module DomainTypes exposing (..)


type Item
    = Paragraph String
    | CodeBlock String


type alias Items =
    List Item


type alias Slide =
    { title : String
    , items : Items
    }


type alias Slides =
    List Slide


type alias Positions =
    { slide : Int
    , item : Int
    }
