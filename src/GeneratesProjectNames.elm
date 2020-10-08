module GeneratesProjectNames exposing
    ( DelimiterType(..)
    , GeneratedName
    , applyCasing
    , defaultDelimiterType
    , randomName
    , randomNameData
    , randomNameWithDelimiter
    )

{-| Generates Random Project Names

Nouns and Adjectives list taken from
<https://github.com/aceakash/project-name-generator>

-}

import Random
import Random.List
import String.Extra


type GeneratedName
    = GeneratedName { adjectiveList : List String, noun : String }


type DelimiterType
    = PascalCase
    | CamelCase
    | StringDelimiter String


defaultDelimiterType : DelimiterType
defaultDelimiterType =
    StringDelimiter defaultStringDelimiter


defaultStringDelimiter : String
defaultStringDelimiter =
    "-"


{-| Produces a name of the form, adjective-adject-noun, by randomly choosing `length - 1` adjectives from a list and concatenating it with a random noun.

This function returns a `Cmd msg`. You must provide this in the form `(String -> msg)`, where the `String` is the generated name.

randomName 2 GeneratedName == "boring-authority"
randomName 3 GeneratedName == "funny-dirty-cone"

-}
randomName : Int -> (String -> msg) -> Cmd msg
randomName =
    randomNameWithDelimiter defaultDelimiterType


randomNameWithDelimiter : DelimiterType -> Int -> (String -> msg) -> Cmd msg
randomNameWithDelimiter delimiterType length msg =
    Random.map2
        (combineAdjectivesAndNounIntoName delimiterType)
        (Random.list (length - 1) (Random.List.choose adjectives))
        (Random.List.choose nouns)
        |> Random.generate msg


randomNameData : Int -> (GeneratedName -> msg) -> Cmd msg
randomNameData length msg =
    Random.map2
        createNameData
        (Random.list (length - 1) (Random.List.choose adjectives))
        (Random.List.choose nouns)
        |> Random.generate msg


createNameData : List ( Maybe String, List String ) -> ( Maybe String, List String ) -> GeneratedName
createNameData generatedAdjectives generatedNoun =
    let
        adjectivesForName =
            List.filterMap Tuple.first generatedAdjectives

        noun =
            Tuple.first generatedNoun |> Maybe.withDefault "NoNounFound"
    in
    GeneratedName { adjectiveList = adjectivesForName, noun = noun }


combineAdjectivesAndNounIntoName : DelimiterType -> List ( Maybe String, List String ) -> ( Maybe String, List String ) -> String
combineAdjectivesAndNounIntoName delimiterType generatedAdjectives generatedNoun =
    let
        wordList =
            (generatedNoun :: generatedAdjectives)
                |> List.filterMap Tuple.first
                |> List.reverse
    in
    wordList
        |> applyDelimiterType delimiterType
        |> String.concat


applyCasing : DelimiterType -> GeneratedName -> String
applyCasing casing (GeneratedName { adjectiveList, noun }) =
    (noun :: adjectiveList)
        |> List.reverse
        |> applyDelimiterType casing
        |> String.concat


applyDelimiterType : DelimiterType -> List String -> List String
applyDelimiterType delimiterType wordList =
    case delimiterType of
        PascalCase ->
            List.map String.Extra.toSentenceCase wordList

        CamelCase ->
            case wordList of
                [] ->
                    wordList

                h :: t ->
                    h :: List.map String.Extra.toSentenceCase t

        StringDelimiter delimiter ->
            List.intersperse delimiter wordList


adjectives : List String
adjectives =
    [ "abandoned"
    , "abashed"
    , "aberrant"
    , "abhorrent"
    , "abiding"
    , "abject"
    , "ablaze"
    , "able"
    , "abnormal"
    , "aboriginal"
    , "abortive"
    , "abounding"
    , "abrasive"
    , "abrupt"
    , "absent"
    , "absorbed"
    , "absorbing"
    , "abstracted"
    , "absurd"
    , "abundant"
    , "abusive"
    , "acceptable"
    , "accessible"
    , "accidental"
    , "accurate"
    , "acidic"
    , "acoustic"
    , "acrid"
    , "actionable"
    , "active"
    , "actual"
    , "adamant"
    , "adaptable"
    , "addicted"
    , "addictive"
    , "adept"
    , "adhesive"
    , "adjoining"
    , "adorable"
    , "adroit"
    , "adventurous"
    , "affable"
    , "affectionate"
    , "afraid"
    , "aggressive"
    , "agile"
    , "agonizing"
    , "agreeable"
    , "airy"
    , "alcoholic"
    , "alert"
    , "alive"
    , "alleged"
    , "alluring"
    , "aloof"
    , "amazing"
    , "ambiguous"
    , "ambitious"
    , "amiable"
    , "ample"
    , "amused"
    , "amusing"
    , "ancient"
    , "angry"
    , "animated"
    , "annoyed"
    , "annoying"
    , "anxious"
    , "apathetic"
    , "apt"
    , "aquatic"
    , "ardent"
    , "aromatic"
    , "arrogant"
    , "ashamed"
    , "aspiring"
    , "assorted"
    , "astonishing"
    , "astute"
    , "attractive"
    , "august"
    , "auspicious"
    , "automatic"
    , "available"
    , "average"
    , "avid"
    , "aware"
    , "awesome"
    , "awful"
    , "axiomatic"
    , "bad"
    , "balmy"
    , "barbarous"
    , "bashful"
    , "bawdy"
    , "beautiful"
    , "beefy"
    , "befitting"
    , "belligerent"
    , "beneficial"
    , "benevolent"
    , "bent"
    , "berserk"
    , "best"
    , "better"
    , "bewildered"
    , "big"
    , "billowing"
    , "billowy"
    , "bitter"
    , "bizarre"
    , "blessed"
    , "bloody"
    , "blue"
    , "blushing"
    , "boiling"
    , "bold"
    , "boorish"
    , "bored"
    , "boring"
    , "boss"
    , "bouncy"
    , "boundless"
    , "brainy"
    , "brash"
    , "brave"
    , "brawny"
    , "breakable"
    , "breezy"
    , "brief"
    , "bright"
    , "brisk"
    , "broad"
    , "broken"
    , "bumpy"
    , "burly"
    , "bustling"
    , "busy"
    , "cagey"
    , "calculating"
    , "callous"
    , "calm"
    , "can"
    , "canny"
    , "capable"
    , "capricious"
    , "cared"
    , "careful"
    , "careless"
    , "caring"
    , "casual"
    , "cautious"
    , "ceaseless"
    , "celestial"
    , "certain"
    , "changeable"
    , "charming"
    , "cheap"
    , "cheerful"
    , "chemical"
    , "chic"
    , "chief"
    , "childlike"
    , "chilly"
    , "chivalrous"
    , "choice"
    , "chosen"
    , "chubby"
    , "chummy"
    , "chunky"
    , "civic"
    , "civil"
    , "clammy"
    , "classy"
    , "clean"
    , "clear"
    , "clever"
    , "cloistered"
    , "close"
    , "closed"
    , "cloudy"
    , "clumsy"
    , "cluttered"
    , "cogent"
    , "coherent"
    , "cold"
    , "colorful"
    , "colossal"
    , "combative"
    , "comfortable"
    , "common"
    , "complete"
    , "complex"
    , "composed"
    , "concerned"
    , "condemned"
    , "confused"
    , "conscious"
    , "cooing"
    , "cool"
    , "cooperative"
    , "coordinated"
    , "cosmic"
    , "courageous"
    , "cowardly"
    , "cozy"
    , "crabby"
    , "craven"
    , "crazy"
    , "creepy"
    , "crooked"
    , "crowded"
    , "cruel"
    , "cuddly"
    , "cultured"
    , "cumbersome"
    , "curious"
    , "curly"
    , "curved"
    , "curvy"
    , "cut"
    , "cute"
    , "cynical"
    , "daffy"
    , "daily"
    , "dainty"
    , "damaged"
    , "damaging"
    , "damp"
    , "dandy"
    , "dangerous"
    , "dapper"
    , "daring"
    , "dark"
    , "dashing"
    , "dazzling"
    , "dead"
    , "deadpan"
    , "deafening"
    , "dear"
    , "debonair"
    , "decent"
    , "decisive"
    , "decorous"
    , "deep"
    , "deeply"
    , "defeated"
    , "defective"
    , "defiant"
    , "deft"
    , "delicate"
    , "delicious"
    , "delightful"
    , "delirious"
    , "deluxe"
    , "demonic"
    , "dependent"
    , "depressed"
    , "deranged"
    , "descriptive"
    , "deserted"
    , "detailed"
    , "determined"
    , "devilish"
    , "devout"
    , "didactic"
    , "different"
    , "difficult"
    , "diligent"
    , "direct"
    , "direful"
    , "dirty"
    , "disagreeable"
    , "disastrous"
    , "discreet"
    , "disgusted"
    , "disgusting"
    , "disillusioned"
    , "dispensable"
    , "distinct"
    , "disturbed"
    , "divergent"
    , "divine"
    , "dizzy"
    , "domineering"
    , "doted"
    , "doting"
    , "doubtful"
    , "drab"
    , "draconian"
    , "dramatic"
    , "dreamy"
    , "dreary"
    , "driven"
    , "drunk"
    , "dry"
    , "dull"
    , "dusty"
    , "dynamic"
    , "dysfunctional"
    , "eager"
    , "early"
    , "earsplitting"
    , "earthy"
    , "easy"
    , "eatable"
    , "economic"
    , "educated"
    , "efficacious"
    , "efficient"
    , "eight"
    , "elastic"
    , "elated"
    , "elderly"
    , "electric"
    , "elegant"
    , "elfin"
    , "elite"
    , "embarrassed"
    , "eminent"
    , "empty"
    , "enchanted"
    , "enchanting"
    , "encouraging"
    , "end"
    , "endurable"
    , "energetic"
    , "energized"
    , "enigmatic"
    , "enormous"
    , "entertaining"
    , "enthusiastic"
    , "envious"
    , "equable"
    , "equal"
    , "erect"
    , "erratic"
    , "ethereal"
    , "evanescent"
    , "evasive"
    , "even"
    , "evil"
    , "exact"
    , "excellent"
    , "excited"
    , "exciting"
    , "exclusive"
    , "exotic"
    , "expensive"
    , "expert"
    , "exuberant"
    , "exultant"
    , "fabulous"
    , "faded"
    , "faint"
    , "fair"
    , "faithful"
    , "fallacious"
    , "false"
    , "famed"
    , "familiar"
    , "famous"
    , "fanatical"
    , "fancy"
    , "fantastic"
    , "far"
    , "fascinated"
    , "fast"
    , "fat"
    , "faulty"
    , "fearful"
    , "fearless"
    , "feeble"
    , "feigned"
    , "female"
    , "fertile"
    , "festive"
    , "few"
    , "fierce"
    , "fiery"
    , "filthy"
    , "fine"
    , "finicky"
    , "first"
    , "fit"
    , "fixed"
    , "flagrant"
    , "flaky"
    , "flashy"
    , "flat"
    , "flawless"
    , "fleet"
    , "flimsy"
    , "flippant"
    , "flowery"
    , "flowing"
    , "fluent"
    , "fluffy"
    , "fluttering"
    , "flying"
    , "foamy"
    , "fond"
    , "foolish"
    , "for"
    , "foregoing"
    , "forgetful"
    , "forlorn"
    , "fortunate"
    , "fragile"
    , "frail"
    , "frank"
    , "frantic"
    , "free"
    , "freezing"
    , "frequent"
    , "fresh"
    , "fretful"
    , "friendly"
    , "frightened"
    , "frightening"
    , "full"
    , "fumbling"
    , "fun"
    , "functional"
    , "funny"
    , "furry"
    , "furtive"
    , "fuscia"
    , "future"
    , "futuristic"
    , "fuzzy"
    , "gabby"
    , "gainful"
    , "gamy"
    , "gaping"
    , "garrulous"
    , "gas"
    , "gaudy"
    , "general"
    , "genial"
    , "gentle"
    , "giant"
    , "giddy"
    , "gifted"
    , "gigantic"
    , "giving"
    , "glad"
    , "glamorous"
    , "gleaming"
    , "glib"
    , "glistening"
    , "glorious"
    , "glossy"
    , "gnarly"
    , "godly"
    , "gold"
    , "golden"
    , "good"
    , "goodly"
    , "goofy"
    , "gorgeous"
    , "graceful"
    , "grand"
    , "grandiose"
    , "grateful"
    , "gratis"
    , "gray"
    , "greasy"
    , "great"
    , "greedy"
    , "green"
    , "grey"
    , "grieving"
    , "groovy"
    , "grotesque"
    , "grouchy"
    , "grubby"
    , "gruesome"
    , "grumpy"
    , "guarded"
    , "guided"
    , "guiltless"
    , "gullible"
    , "gusty"
    , "gutsy"
    , "guttural"
    , "habitual"
    , "half"
    , "hallowed"
    , "haloed"
    , "halting"
    , "handsome"
    , "handsomely"
    , "handy"
    , "hanging"
    , "hapless"
    , "happy"
    , "hard"
    , "hardy"
    , "harmonious"
    , "harsh"
    , "hateful"
    , "heady"
    , "healthy"
    , "heartbreaking"
    , "hearty"
    , "heavenly"
    , "heavy"
    , "hellish"
    , "helpful"
    , "helpless"
    , "heroic"
    , "hesitant"
    , "hideous"
    , "high"
    , "highfalutin"
    , "hilarious"
    , "hip"
    , "hissing"
    , "historical"
    , "holistic"
    , "hollow"
    , "holy"
    , "homeless"
    , "homely"
    , "honest"
    , "honorable"
    , "horrible"
    , "hospitable"
    , "hot"
    , "huge"
    , "hulking"
    , "human"
    , "humane"
    , "humble"
    , "humdrum"
    , "humorous"
    , "hungry"
    , "hunky"
    , "hurried"
    , "hurt"
    , "hushed"
    , "husky"
    , "hypnotic"
    , "hysterical"
    , "icky"
    , "icy"
    , "ideal"
    , "idiotic"
    , "ignorant"
    , "ill"
    , "illegal"
    , "illustrious"
    , "imaginary"
    , "immense"
    , "imminent"
    , "immune"
    , "impartial"
    , "imperfect"
    , "impolite"
    , "important"
    , "imported"
    , "impossible"
    , "incandescent"
    , "incompetent"
    , "inconclusive"
    , "incredible"
    , "indigo"
    , "industrious"
    , "inexpensive"
    , "infamous"
    , "innate"
    , "innocent"
    , "inquisitive"
    , "insidious"
    , "instinctive"
    , "intelligent"
    , "interesting"
    , "internal"
    , "invincible"
    , "irate"
    , "irritating"
    , "itchy"
    , "jaded"
    , "jagged"
    , "jazzed"
    , "jazzy"
    , "jealous"
    , "jittery"
    , "jobless"
    , "jolly"
    , "jovial"
    , "joyful"
    , "joyous"
    , "jubilant"
    , "judicious"
    , "juicy"
    , "jumbled"
    , "jumpy"
    , "just"
    , "juvenile"
    , "kaput"
    , "keen"
    , "khaki"
    , "kind"
    , "kindhearted"
    , "kindly"
    , "kingly"
    , "knotty"
    , "knowing"
    , "knowledgeable"
    , "known"
    , "labored"
    , "lackadaisical"
    , "lacking"
    , "lame"
    , "lamentable"
    , "languid"
    , "large"
    , "last"
    , "late"
    , "laughable"
    , "lavish"
    , "lawful"
    , "lazy"
    , "lean"
    , "learned"
    , "legal"
    , "legit"
    , "lethal"
    , "level"
    , "lewd"
    , "light"
    , "like"
    , "likeable"
    , "likely"
    , "limber"
    , "limitless"
    , "limping"
    , "literate"
    , "little"
    , "lively"
    , "living"
    , "lonely"
    , "long"
    , "longing"
    , "loose"
    , "lopsided"
    , "loud"
    , "lousy"
    , "loutish"
    , "loved"
    , "lovely"
    , "loving"
    , "low"
    , "lowly"
    , "loyal"
    , "lucid"
    , "lucky"
    , "ludicrous"
    , "lumpy"
    , "lush"
    , "luxuriant"
    , "lying"
    , "lyrical"
    , "macabre"
    , "macho"
    , "maddening"
    , "madly"
    , "magenta"
    , "magical"
    , "magnificent"
    , "main"
    , "majestic"
    , "major"
    , "makeshift"
    , "male"
    , "malicious"
    , "mammoth"
    , "maniacal"
    , "many"
    , "marked"
    , "married"
    , "marvelous"
    , "massive"
    , "master"
    , "material"
    , "materialistic"
    , "mature"
    , "max"
    , "maxed"
    , "mean"
    , "measly"
    , "meaty"
    , "medical"
    , "meek"
    , "mellow"
    , "melodic"
    , "melted"
    , "merciful"
    , "mere"
    , "merry"
    , "messy"
    , "mighty"
    , "military"
    , "milky"
    , "mindless"
    , "miniature"
    , "minor"
    , "mint"
    , "mirthful"
    , "miscreant"
    , "misty"
    , "mixed"
    , "moaning"
    , "modern"
    , "modest"
    , "moldy"
    , "momentous"
    , "money"
    , "moonlit"
    , "moral"
    , "motionless"
    , "mountainous"
    , "moving"
    , "mucho"
    , "muddled"
    , "mundane"
    , "murky"
    , "mushy"
    , "mute"
    , "mutual"
    , "mysterious"
    , "naive"
    , "nappy"
    , "narrow"
    , "nasty"
    , "native"
    , "natural"
    , "naughty"
    , "nauseating"
    , "near"
    , "neat"
    , "nebulous"
    , "necessary"
    , "needed"
    , "needless"
    , "needy"
    , "neighborly"
    , "nervous"
    , "new"
    , "next"
    , "nice"
    , "nifty"
    , "nimble"
    , "nippy"
    , "noble"
    , "noiseless"
    , "noisy"
    , "nonchalant"
    , "nondescript"
    , "nonstop"
    , "normal"
    , "nostalgic"
    , "nosy"
    , "noted"
    , "novel"
    , "noxious"
    , "null"
    , "numberless"
    , "numero"
    , "numerous"
    , "nutritious"
    , "nutty"
    , "oafish"
    , "obedient"
    , "obeisant"
    , "obese"
    , "obnoxious"
    , "obscene"
    , "obsequious"
    , "observant"
    , "obsolete"
    , "obtainable"
    , "oceanic"
    , "odd"
    , "offbeat"
    , "okay"
    , "old"
    , "omniscient"
    , "onerous"
    , "open"
    , "opposite"
    , "optimal"
    , "orange"
    , "ordinary"
    , "organic"
    , "ossified"
    , "outgoing"
    , "outrageous"
    , "outstanding"
    , "oval"
    , "overconfident"
    , "overjoyed"
    , "overrated"
    , "overt"
    , "overwrought"
    , "pacific"
    , "painful"
    , "painstaking"
    , "pale"
    , "paltry"
    , "panicky"
    , "panoramic"
    , "parallel"
    , "parched"
    , "parsimonious"
    , "past"
    , "pastoral"
    , "pathetic"
    , "peaceful"
    , "peachy"
    , "penitent"
    , "peppy"
    , "perfect"
    , "periodic"
    , "permissible"
    , "perpetual"
    , "petite"
    , "phobic"
    , "physical"
    , "picayune"
    , "pink"
    , "piquant"
    , "pithy"
    , "placid"
    , "plain"
    , "plant"
    , "plastic"
    , "plausible"
    , "pleasant"
    , "plucky"
    , "plum"
    , "poetic"
    , "pointless"
    , "poised"
    , "polite"
    , "political"
    , "poor"
    , "posh"
    , "possessive"
    , "possible"
    , "potent"
    , "powerful"
    , "precious"
    , "premium"
    , "present"
    , "pretty"
    , "previous"
    , "pricey"
    , "prickly"
    , "prime"
    , "primo"
    , "private"
    , "prized"
    , "pro"
    , "probable"
    , "productive"
    , "profuse"
    , "prompt"
    , "proper"
    , "protective"
    , "proud"
    , "psychedelic"
    , "psychotic"
    , "public"
    , "puffy"
    , "pumped"
    , "punchy"
    , "puny"
    , "pure"
    , "purple"
    , "purring"
    , "pushy"
    , "puzzled"
    , "puzzling"
    , "quack"
    , "quaint"
    , "quarrelsome"
    , "questionable"
    , "quick"
    , "quickest"
    , "quiet"
    , "quirky"
    , "quixotic"
    , "quizzical"
    , "rabid"
    , "racial"
    , "rad"
    , "radioactive"
    , "ragged"
    , "rainy"
    , "rambunctious"
    , "rampant"
    , "rapid"
    , "rare"
    , "raspy"
    , "ratty"
    , "reach"
    , "ready"
    , "real"
    , "rebel"
    , "receptive"
    , "recondite"
    , "red"
    , "redundant"
    , "reflective"
    , "regal"
    , "regular"
    , "relieved"
    , "remarkable"
    , "reminiscent"
    , "repulsive"
    , "resilient"
    , "resolute"
    , "resonant"
    , "responsible"
    , "rhetorical"
    , "rich"
    , "right"
    , "righteous"
    , "rightful"
    , "rigid"
    , "ripe"
    , "ritzy"
    , "roasted"
    , "robust"
    , "romantic"
    , "roomy"
    , "rooted"
    , "rosy"
    , "rotten"
    , "rough"
    , "round"
    , "royal"
    , "ruddy"
    , "rude"
    , "rugged"
    , "rural"
    , "rustic"
    , "ruthless"
    , "sable"
    , "sad"
    , "safe"
    , "salty"
    , "same"
    , "sassy"
    , "satisfying"
    , "saucy"
    , "savory"
    , "savvy"
    , "scandalous"
    , "scarce"
    , "scared"
    , "scary"
    , "scattered"
    , "scenic"
    , "scientific"
    , "scintillating"
    , "scrawny"
    , "screeching"
    , "second"
    , "secret"
    , "secretive"
    , "sedate"
    , "seemly"
    , "selective"
    , "selfish"
    , "sensitive"
    , "separate"
    , "serene"
    , "serious"
    , "shaggy"
    , "shaky"
    , "shallow"
    , "sharp"
    , "shiny"
    , "shivering"
    , "shocking"
    , "short"
    , "showy"
    , "shrewd"
    , "shrill"
    , "shut"
    , "shy"
    , "sick"
    , "silent"
    , "silky"
    , "silly"
    , "simple"
    , "simplistic"
    , "sincere"
    , "skillful"
    , "skinny"
    , "sleek"
    , "sleepy"
    , "slick"
    , "slim"
    , "slimy"
    , "slippery"
    , "sloppy"
    , "slow"
    , "small"
    , "smart"
    , "smelly"
    , "smiley"
    , "smiling"
    , "smoggy"
    , "smooth"
    , "snappy"
    , "snazzy"
    , "sneaky"
    , "snobbish"
    , "snotty"
    , "snowy"
    , "snugly"
    , "social"
    , "soft"
    , "soggy"
    , "sole"
    , "solid"
    , "solitary"
    , "somber"
    , "sophisticated"
    , "sordid"
    , "sore"
    , "sound"
    , "sour"
    , "spacial"
    , "sparkling"
    , "special"
    , "spectacular"
    , "spicy"
    , "spiffy"
    , "spiky"
    , "spiritual"
    , "spiteful"
    , "splendid"
    , "spooky"
    , "spotless"
    , "spotted"
    , "spotty"
    , "spry"
    , "spurious"
    , "squalid"
    , "square"
    , "squealing"
    , "squeamish"
    , "stable"
    , "staking"
    , "stale"
    , "standing"
    , "star"
    , "stark"
    , "statuesque"
    , "steadfast"
    , "steady"
    , "steep"
    , "stereotyped"
    , "sticky"
    , "stiff"
    , "stimulating"
    , "stingy"
    , "stoic"
    , "stormy"
    , "straight"
    , "strange"
    , "striped"
    , "strong"
    , "stunning"
    , "stupendous"
    , "stupid"
    , "sturdy"
    , "suave"
    , "subdued"
    , "subsequent"
    , "substantial"
    , "subtle"
    , "successful"
    , "succinct"
    , "sudden"
    , "sulky"
    , "sunny"
    , "sunset"
    , "super"
    , "superb"
    , "superficial"
    , "supreme"
    , "sure"
    , "swank"
    , "swanky"
    , "sweet"
    , "swell"
    , "sweltering"
    , "swift"
    , "symptomatic"
    , "synonymous"
    , "taboo"
    , "tacit"
    , "tacky"
    , "talented"
    , "tall"
    , "tame"
    , "tan"
    , "tangible"
    , "tangy"
    , "tart"
    , "tasteful"
    , "tasteless"
    , "tasty"
    , "tawdry"
    , "teal"
    , "tearful"
    , "tedious"
    , "teeny"
    , "telling"
    , "temporary"
    , "tender"
    , "tense"
    , "tenuous"
    , "terrible"
    , "terrific"
    , "tested"
    , "testy"
    , "thankful"
    , "therapeutic"
    , "thick"
    , "thin"
    , "thinkable"
    , "third"
    , "thirsty"
    , "thoughtful"
    , "thoughtless"
    , "threatening"
    , "thriving"
    , "thundering"
    , "tidy"
    , "tight"
    , "tightfisted"
    , "timely"
    , "tiny"
    , "tired"
    , "tiresome"
    , "toothsome"
    , "top"
    , "tops"
    , "torpid"
    , "tough"
    , "touted"
    , "towering"
    , "tranquil"
    , "trashy"
    , "tremendous"
    , "tricky"
    , "trim"
    , "trite"
    , "tropical"
    , "troubled"
    , "truculent"
    , "true"
    , "trusty"
    , "truthful"
    , "try"
    , "typical"
    , "ubiquitous"
    , "ugliest"
    , "ugly"
    , "ultra"
    , "unable"
    , "unaccountable"
    , "unadvised"
    , "unarmed"
    , "unbecoming"
    , "unbiased"
    , "uncovered"
    , "understood"
    , "undesirable"
    , "undisturbed"
    , "unequal"
    , "unequaled"
    , "uneven"
    , "unhealthy"
    , "uninterested"
    , "unique"
    , "united"
    , "unkempt"
    , "unknown"
    , "unnatural"
    , "unruly"
    , "unsightly"
    , "unsuitable"
    , "untidy"
    , "unused"
    , "unusual"
    , "unwavering"
    , "unwieldy"
    , "unwritten"
    , "upbeat"
    , "uplifting"
    , "uppity"
    , "upset"
    , "uptight"
    , "urbane"
    , "usable"
    , "used"
    , "useful"
    , "useless"
    , "utmost"
    , "utopian"
    , "utter"
    , "uttermost"
    , "vacuous"
    , "vagabond"
    , "vague"
    , "valid"
    , "valuable"
    , "various"
    , "vast"
    , "vengeful"
    , "venomous"
    , "verdant"
    , "versed"
    , "vestal"
    , "viable"
    , "victorious"
    , "vigorous"
    , "violent"
    , "violet"
    , "vital"
    , "vivacious"
    , "vivid"
    , "vocal"
    , "vogue"
    , "voiceless"
    , "volatile"
    , "voracious"
    , "vulgar"
    , "wacky"
    , "waggish"
    , "waiting"
    , "wakeful"
    , "wandering"
    , "wanted"
    , "wanting"
    , "warlike"
    , "warm"
    , "wary"
    , "wasteful"
    , "watery"
    , "weak"
    , "wealthy"
    , "weary"
    , "wet"
    , "whimsical"
    , "whispering"
    , "whole"
    , "wholesale"
    , "wicked"
    , "wide"
    , "wiggly"
    , "wild"
    , "willing"
    , "windy"
    , "winged"
    , "wired"
    , "wiry"
    , "wise"
    , "wistful"
    , "witty"
    , "woebegone"
    , "womanly"
    , "wonderful"
    , "wooden"
    , "woozy"
    , "workable"
    , "worried"
    , "worthless"
    , "worthy"
    , "wrathful"
    , "wretched"
    , "wrong"
    , "wry"
    , "xenophobic"
    , "yielding"
    , "young"
    , "youthful"
    , "yummy"
    , "zany"
    , "zealous"
    , "zesty"
    , "zippy"
    , "zonked"
    ]


nouns : List String
nouns =
    [ "account"
    , "achiever"
    , "acoustics"
    , "act"
    , "action"
    , "activity"
    , "actor"
    , "addition"
    , "adjustment"
    , "advertisement"
    , "advice"
    , "aftermath"
    , "afternoon"
    , "afterthought"
    , "agreement"
    , "air"
    , "airplane"
    , "airport"
    , "alarm"
    , "amount"
    , "amusement"
    , "anger"
    , "angle"
    , "animal"
    , "ants"
    , "apparatus"
    , "apparel"
    , "appliance"
    , "approval"
    , "arch"
    , "argument"
    , "arithmetic"
    , "arm"
    , "army"
    , "art"
    , "attack"
    , "attraction"
    , "aunt"
    , "authority"
    , "back"
    , "badge"
    , "bag"
    , "bait"
    , "balance"
    , "ball"
    , "base"
    , "baseball"
    , "basin"
    , "basket"
    , "basketball"
    , "bat"
    , "bath"
    , "battle"
    , "bead"
    , "bear"
    , "bed"
    , "bedroom"
    , "beds"
    , "bee"
    , "beef"
    , "beginner"
    , "behavior"
    , "belief"
    , "believe"
    , "bell"
    , "bells"
    , "berry"
    , "bike"
    , "bikes"
    , "bird"
    , "birds"
    , "birth"
    , "birthday"
    , "bit"
    , "bite"
    , "blade"
    , "blood"
    , "blow"
    , "board"
    , "boat"
    , "bomb"
    , "bone"
    , "book"
    , "books"
    , "boot"
    , "border"
    , "bottle"
    , "boundary"
    , "box"
    , "brake"
    , "branch"
    , "brass"
    , "breath"
    , "brick"
    , "bridge"
    , "brother"
    , "bubble"
    , "bucket"
    , "building"
    , "bulb"
    , "burst"
    , "bushes"
    , "business"
    , "butter"
    , "button"
    , "cabbage"
    , "cable"
    , "cactus"
    , "cake"
    , "cakes"
    , "calculator"
    , "calendar"
    , "camera"
    , "camp"
    , "can"
    , "cannon"
    , "canvas"
    , "cap"
    , "caption"
    , "car"
    , "card"
    , "care"
    , "carpenter"
    , "carriage"
    , "cars"
    , "cart"
    , "cast"
    , "cat"
    , "cats"
    , "cattle"
    , "cause"
    , "cave"
    , "celery"
    , "cellar"
    , "cemetery"
    , "cent"
    , "chalk"
    , "chance"
    , "change"
    , "channel"
    , "cheese"
    , "cherries"
    , "cherry"
    , "chess"
    , "chicken"
    , "chickens"
    , "chin"
    , "church"
    , "circle"
    , "clam"
    , "class"
    , "cloth"
    , "clover"
    , "club"
    , "coach"
    , "coal"
    , "coast"
    , "coat"
    , "cobweb"
    , "coil"
    , "collar"
    , "color"
    , "committee"
    , "company"
    , "comparison"
    , "competition"
    , "condition"
    , "connection"
    , "control"
    , "cook"
    , "copper"
    , "corn"
    , "cough"
    , "country"
    , "cover"
    , "cow"
    , "cows"
    , "crack"
    , "cracker"
    , "crate"
    , "crayon"
    , "cream"
    , "creator"
    , "creature"
    , "credit"
    , "crib"
    , "crime"
    , "crook"
    , "crow"
    , "crowd"
    , "crown"
    , "cub"
    , "cup"
    , "current"
    , "curtain"
    , "curve"
    , "cushion"
    , "dad"
    , "daughter"
    , "day"
    , "death"
    , "debt"
    , "decision"
    , "deer"
    , "degree"
    , "design"
    , "desire"
    , "desk"
    , "destruction"
    , "detail"
    , "development"
    , "digestion"
    , "dime"
    , "dinner"
    , "dinosaurs"
    , "direction"
    , "dirt"
    , "discovery"
    , "discussion"
    , "distance"
    , "distribution"
    , "division"
    , "dock"
    , "doctor"
    , "dog"
    , "dogs"
    , "doll"
    , "dolls"
    , "donkey"
    , "door"
    , "downtown"
    , "drain"
    , "drawer"
    , "dress"
    , "drink"
    , "driving"
    , "drop"
    , "duck"
    , "ducks"
    , "dust"
    , "ear"
    , "earth"
    , "earthquake"
    , "edge"
    , "education"
    , "effect"
    , "egg"
    , "eggnog"
    , "eggs"
    , "elbow"
    , "end"
    , "engine"
    , "error"
    , "event"
    , "example"
    , "exchange"
    , "existence"
    , "expansion"
    , "experience"
    , "expert"
    , "eye"
    , "eyes"
    , "face"
    , "fact"
    , "fairies"
    , "fall"
    , "fang"
    , "farm"
    , "fear"
    , "feeling"
    , "field"
    , "finger"
    , "fire"
    , "fireman"
    , "fish"
    , "flag"
    , "flame"
    , "flavor"
    , "flesh"
    , "flight"
    , "flock"
    , "floor"
    , "flower"
    , "flowers"
    , "fly"
    , "fog"
    , "fold"
    , "food"
    , "foot"
    , "force"
    , "fork"
    , "form"
    , "fowl"
    , "frame"
    , "friction"
    , "friend"
    , "friends"
    , "frog"
    , "frogs"
    , "front"
    , "fruit"
    , "fuel"
    , "furniture"
    , "gate"
    , "geese"
    , "ghost"
    , "giants"
    , "giraffe"
    , "glass"
    , "glove"
    , "gold"
    , "government"
    , "governor"
    , "grade"
    , "grain"
    , "grandfather"
    , "grandmother"
    , "grape"
    , "grass"
    , "grip"
    , "ground"
    , "group"
    , "growth"
    , "guide"
    , "guitar"
    , "gun"
    , "hair"
    , "haircut"
    , "hall"
    , "hammer"
    , "hand"
    , "hands"
    , "harbor"
    , "harmony"
    , "hat"
    , "head"
    , "health"
    , "heat"
    , "hill"
    , "history"
    , "hobbies"
    , "hole"
    , "holiday"
    , "home"
    , "honey"
    , "hook"
    , "hope"
    , "horn"
    , "horse"
    , "horses"
    , "hose"
    , "hospital"
    , "hot"
    , "hour"
    , "house"
    , "houses"
    , "humor"
    , "hydrant"
    , "ice"
    , "icicle"
    , "idea"
    , "impulse"
    , "income"
    , "increase"
    , "industry"
    , "ink"
    , "insect"
    , "instrument"
    , "insurance"
    , "interest"
    , "invention"
    , "iron"
    , "island"
    , "jail"
    , "jam"
    , "jar"
    , "jeans"
    , "jelly"
    , "jellyfish"
    , "jewel"
    , "join"
    , "judge"
    , "juice"
    , "jump"
    , "kettle"
    , "key"
    , "kick"
    , "kiss"
    , "kittens"
    , "kitty"
    , "knee"
    , "knife"
    , "knot"
    , "knowledge"
    , "laborer"
    , "lace"
    , "ladybug"
    , "lake"
    , "lamp"
    , "land"
    , "language"
    , "laugh"
    , "leather"
    , "leg"
    , "legs"
    , "letter"
    , "letters"
    , "lettuce"
    , "level"
    , "library"
    , "limit"
    , "line"
    , "linen"
    , "lip"
    , "liquid"
    , "loaf"
    , "lock"
    , "locket"
    , "look"
    , "loss"
    , "love"
    , "low"
    , "lumber"
    , "lunch"
    , "lunchroom"
    , "machine"
    , "magic"
    , "maid"
    , "mailbox"
    , "man"
    , "marble"
    , "mark"
    , "market"
    , "mask"
    , "mass"
    , "match"
    , "meal"
    , "measure"
    , "meat"
    , "meeting"
    , "memory"
    , "men"
    , "metal"
    , "mice"
    , "middle"
    , "milk"
    , "mind"
    , "mine"
    , "minister"
    , "mint"
    , "minute"
    , "mist"
    , "mitten"
    , "mom"
    , "money"
    , "month"
    , "moon"
    , "morning"
    , "mother"
    , "motion"
    , "mountain"
    , "mouth"
    , "move"
    , "muscle"
    , "name"
    , "nation"
    , "neck"
    , "need"
    , "needle"
    , "nerve"
    , "nest"
    , "night"
    , "noise"
    , "north"
    , "nose"
    , "note"
    , "notebook"
    , "number"
    , "nut"
    , "oatmeal"
    , "observation"
    , "ocean"
    , "offer"
    , "office"
    , "oil"
    , "orange"
    , "oranges"
    , "order"
    , "oven"
    , "page"
    , "pail"
    , "pan"
    , "pancake"
    , "paper"
    , "parcel"
    , "part"
    , "partner"
    , "party"
    , "passenger"
    , "payment"
    , "peace"
    , "pear"
    , "pen"
    , "pencil"
    , "person"
    , "pest"
    , "pet"
    , "pets"
    , "pickle"
    , "picture"
    , "pie"
    , "pies"
    , "pig"
    , "pigs"
    , "pin"
    , "pipe"
    , "pizzas"
    , "place"
    , "plane"
    , "planes"
    , "plant"
    , "plantation"
    , "plants"
    , "plastic"
    , "plate"
    , "play"
    , "playground"
    , "pleasure"
    , "plot"
    , "plough"
    , "pocket"
    , "point"
    , "poison"
    , "pollution"
    , "popcorn"
    , "porter"
    , "position"
    , "pot"
    , "potato"
    , "powder"
    , "power"
    , "price"
    , "produce"
    , "profit"
    , "property"
    , "prose"
    , "protest"
    , "pull"
    , "pump"
    , "punishment"
    , "purpose"
    , "push"
    , "quarter"
    , "quartz"
    , "queen"
    , "question"
    , "quicksand"
    , "quiet"
    , "quill"
    , "quilt"
    , "quince"
    , "quiver"
    , "rabbit"
    , "rabbits"
    , "rail"
    , "railway"
    , "rain"
    , "rainstorm"
    , "rake"
    , "range"
    , "rat"
    , "rate"
    , "ray"
    , "reaction"
    , "reading"
    , "reason"
    , "receipt"
    , "recess"
    , "record"
    , "regret"
    , "relation"
    , "religion"
    , "representative"
    , "request"
    , "respect"
    , "rest"
    , "reward"
    , "rhythm"
    , "rice"
    , "riddle"
    , "rifle"
    , "ring"
    , "rings"
    , "river"
    , "road"
    , "robin"
    , "rock"
    , "rod"
    , "roll"
    , "roof"
    , "room"
    , "root"
    , "rose"
    , "route"
    , "rub"
    , "rule"
    , "run"
    , "sack"
    , "sail"
    , "salt"
    , "sand"
    , "scale"
    , "scarecrow"
    , "scarf"
    , "scene"
    , "scent"
    , "school"
    , "science"
    , "scissors"
    , "screw"
    , "sea"
    , "seashore"
    , "seat"
    , "secretary"
    , "seed"
    , "selection"
    , "self"
    , "sense"
    , "servant"
    , "shade"
    , "shake"
    , "shame"
    , "shape"
    , "sheep"
    , "sheet"
    , "shelf"
    , "ship"
    , "shirt"
    , "shock"
    , "shoe"
    , "shoes"
    , "shop"
    , "show"
    , "side"
    , "sidewalk"
    , "sign"
    , "silk"
    , "silver"
    , "sink"
    , "sister"
    , "sisters"
    , "size"
    , "skate"
    , "skin"
    , "skirt"
    , "sky"
    , "slave"
    , "sleep"
    , "sleet"
    , "slip"
    , "slope"
    , "smash"
    , "smell"
    , "smile"
    , "smoke"
    , "snail"
    , "snails"
    , "snake"
    , "snakes"
    , "sneeze"
    , "snow"
    , "soap"
    , "society"
    , "sock"
    , "soda"
    , "sofa"
    , "son"
    , "song"
    , "songs"
    , "sort"
    , "sound"
    , "soup"
    , "space"
    , "spade"
    , "spark"
    , "spiders"
    , "sponge"
    , "spoon"
    , "spot"
    , "spring"
    , "spy"
    , "square"
    , "squirrel"
    , "stage"
    , "stamp"
    , "star"
    , "start"
    , "statement"
    , "station"
    , "steam"
    , "steel"
    , "stem"
    , "step"
    , "stew"
    , "stick"
    , "sticks"
    , "stitch"
    , "stocking"
    , "stomach"
    , "stone"
    , "stop"
    , "store"
    , "story"
    , "stove"
    , "stranger"
    , "straw"
    , "stream"
    , "street"
    , "stretch"
    , "string"
    , "structure"
    , "substance"
    , "sugar"
    , "suggestion"
    , "suit"
    , "summer"
    , "sun"
    , "support"
    , "surprise"
    , "sweater"
    , "swim"
    , "swing"
    , "system"
    , "table"
    , "tail"
    , "talk"
    , "tank"
    , "taste"
    , "tax"
    , "teaching"
    , "team"
    , "teeth"
    , "temper"
    , "tendency"
    , "tent"
    , "territory"
    , "test"
    , "texture"
    , "theory"
    , "thing"
    , "things"
    , "thought"
    , "thread"
    , "thrill"
    , "throat"
    , "throne"
    , "thumb"
    , "thunder"
    , "ticket"
    , "tiger"
    , "time"
    , "tin"
    , "title"
    , "toad"
    , "toe"
    , "toes"
    , "tomatoes"
    , "tongue"
    , "tooth"
    , "toothbrush"
    , "toothpaste"
    , "top"
    , "touch"
    , "town"
    , "toy"
    , "toys"
    , "trade"
    , "trail"
    , "train"
    , "trains"
    , "tramp"
    , "transport"
    , "tray"
    , "treatment"
    , "tree"
    , "trees"
    , "trick"
    , "trip"
    , "trouble"
    , "trousers"
    , "truck"
    , "trucks"
    , "tub"
    , "turkey"
    , "turn"
    , "twig"
    , "twist"
    , "umbrella"
    , "uncle"
    , "underwear"
    , "unit"
    , "use"
    , "vacation"
    , "value"
    , "van"
    , "vase"
    , "vegetable"
    , "veil"
    , "vein"
    , "verse"
    , "vessel"
    , "vest"
    , "view"
    , "visitor"
    , "voice"
    , "volcano"
    , "volleyball"
    , "voyage"
    , "walk"
    , "wall"
    , "war"
    , "wash"
    , "waste"
    , "watch"
    , "water"
    , "wave"
    , "waves"
    , "wax"
    , "way"
    , "wealth"
    , "weather"
    , "week"
    , "weight"
    , "wheel"
    , "whip"
    , "whistle"
    , "wilderness"
    , "wind"
    , "window"
    , "wine"
    , "wing"
    , "winter"
    , "wire"
    , "wish"
    , "wood"
    , "wool"
    , "word"
    , "work"
    , "worm"
    , "wound"
    , "wren"
    , "wrench"
    , "wrist"
    , "writer"
    , "writing"
    , "yak"
    , "yam"
    , "yard"
    , "yarn"
    , "year"
    , "yoke"
    , "zebra"
    , "zephyr"
    , "zinc"
    , "zipper"
    , "zoo"
    ]
