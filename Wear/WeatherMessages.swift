import Foundation

struct WeatherMessages {
    static let messages: [WeatherCondition: [String]] = [
        .sunny: [
            "A tyrant above,\nburning the land with great wrath.\nNo shade shall save you.",
            "The eye never blinks.\nIt watches, it knows, it burns.\nWe are but insects.",
            "A golden idol,\nhanging high in cursed heavens.\nIt demands worship.",
            "A searing white gaze,\nunblinking in endless void.\nIt knows. It watches.",
            "No clouds, no mercy.\nNowhere to hide from its gaze.\nYou are seen. Bare. Known.",
            "Molten light descends\nDripping gold on mortal flesh\nTime melts like amber",
            "Ancient fire burns\nCasting shadows of old gods\nTheir whispers still glow",
            "The sky bleeds daylight\nPiercing through our fragile shells\nWe are transparent",
            "Light bends reality\nMirages dance on hot air\nTruth becomes fluid",
            "Sun's corona burns\nRevealing forbidden signs\nScrawled across the sky"
        ],
        .partlyCloudy: [
            "Clouds drift like lost souls,\nhalf veiling the searing truth—\nthe sun still watches.",
            "Shadows creep and shift,\nwhispering between the clouds.\nThey plot in silence.",
            "Veiled signs in the sky,\nscribbled warnings half-concealed.\nThe rite is not done.",
            "Veils of ashen mist,\nthin shrouds across writhing stars.\nThe truth seeps through cracks.",
            "The veil is so thin.\nLight spills through in broken waves.\nWhat if it all breaks?",
            "Light and shadow dance\nPlaying games with mortal eyes\nNeither side can win",
            "Clouds weave sacred signs\nHalf-formed symbols fade and shift\nMessages unread",
            "Through gaps in the veil\nGlimpses of what lies beyond\nBest to look away",
            "Sky's patchwork curtain\nTorn between light and shadow\nReality bleeds",
            "Cloud gates open wide\nReveal celestial secrets\nThen seal them again"
        ],
        .cloudy: [
            "A shroud cloaks the sky,\nhiding heaven's distant eye.\nShadows rule the earth.",
            "The sky wears a shroud,\nhiding horrors coiled within.\nDo not look too long.",
            "A leaden curtain\ndrawn tight against prying eyes.\nSomething waits beyond.",
            "A sky smothered dark,\nhiding horrors vast and old.\nThey shift in their sleep.",
            "A smothered silence.\nThe sky forgets how to breathe.\nOr is it waiting?",
            "Grey walls press us down\nSealing ancient memories\nBeneath leaden skies",
            "No light penetrates\nThe barrier between worlds\nPerhaps that's mercy",
            "Clouds whisper secrets\nIn languages long forgotten\nBetter left unheard",
            "Sky becomes a tomb\nSealing light in ashen vault\nDarkness takes the throne",
            "Cloud-woven cocoon\nWraps the world in mystery\nWhat will emerge next?"
        ],
        .rainy: [
            "Tears of gods descend,\ndrowning the earth in sorrow.\nFlee, or learn to swim.",
            "Dark blood stains the earth.\nThe sky weeps for what it lost.\nOr what it will take.",
            "Chanting on the wind,\nsoft as the priest's trembling lips.\nThe sky spills secrets.",
            "Each drop, an eye blink,\nweeping from a broken god.\nThe earth drinks deeply.",
            "Footsteps in puddles,\nbut no one walks beside you.\nThe rain is listening.",
            "Water carries words\nWhispered from the void above\nDrowned prophecies fall",
            "Rain taps ancient code\nMorse signals from watching eyes\nMessages in drops",
            "Sky bleeds mercury\nSilver tears on darkened ground\nWashing sins away",
            "Liquid voices sing\nHymns of drowning civilizations\nRising once again",
            "Rain forms sacred pools\nMirrors to forgotten realms\nDon't look too deeply"
        ],
        .thunderstorm: [
            "The sky splits open,\nlight and fury wage their war.\nEarth trembles in fear.",
            "The heavens rupture,\na god's fury unfettered—\nor something older.",
            "Lightning splits the void,\na sigil scorched on the sky.\nThe summoning nears.",
            "The heavens rupture,\ntentacles of light lash down.\nThe gods are screaming.",
            "A scream from above,\na warning, a battle cry,\nor something breaking?",
            "Electric runes flash\nWriting doom in blinding script\nAcross darkened sky",
            "Thunder speaks in tongues\nAncient deities converse\nIn forgotten speech",
            "Storm-gates crack open\nGlimpses of celestial war\nLightning scars remain",
            "Sky wounds bleed white fire\nStitched by thunder's needle thread\nScars mark heaven's face",
            "Storm gods wage their war\nHurling spears of liquid light\nWe are caught between"
        ],
        .stormy: [
            "Winds howl like lost souls,\nraging through the broken world.\nAll must bow or break.",
            "The wind wails, hungry,\nraking claws across the land.\nIt seeks an offering.",
            "A howling spiral,\nsigils traced in dirt and bone.\nThe wind knows your name.",
            "The wind wails and twists,\nchanting names not meant for tongues.\nDo not heed the call.",
            "The wind takes its due,\nripping, gnawing, demanding.\nYou could be next.",
            "Gale force fingers reach\nTearing veils between the worlds\nReality bends",
            "Storm winds speak your name\nIn voices from the abyss\nPretend not to hear",
            "Cyclone eyes open\nVortex gates to other realms\nSpiral ever down",
            "Air becomes a blade\nCutting through dimensional\nWalls we thought were strong",
            "Tempest spirits dance\nWrithing in their wind-formed flesh\nWatching as we cower"
        ],
        .foggy: [
            "The world fades away,\nghosts whisper in the pale mist.\nYou are not alone.",
            "Something stirs within,\nhalf-seen shapes that do not breathe.\nThey wait. They listen.",
            "Ghost-light in the mist,\na lantern sways without hands.\nIt beckons. Follow.",
            "A shroud thick as sin,\nwrithing fingers grasp the earth.\nSomething walks within.",
            "Shapes shift in the mist.\nYou blink, and they are closer.\nDo not blink again.",
            "Grey veils part and close\nRevealing glimpses of truth\nBetter left unseen",
            "Mist-wrapped silhouettes\nDance on edges of vision\nNever quite take form",
            "Fog swallows the world\nLeaving only memory\nOf what once was real",
            "Through the churning grey\nShadows wear familiar shapes\nBut are not the same",
            "Reality thins\nWhere the mist touches your skin\nBoundaries dissolve"
        ],
        .veryHot: [
            "The air turns to flame,\nflesh wilts like a dying leaf.\nThe sun laughs at you.",
            "The ground cracks open.\nSomething ancient stirs beneath,\nsighing molten breath.",
            "The air hums and sways,\nembers rise in twisting runes.\nThe old ones return.",
            "The air bends, warps, screams.\nSpace itself recoils and melts.\nThe sun is hungry.",
            "Air thick, lungs heavy.\nLike drowning without the waves.\nYou are trapped inside.",
            "Heat distorts the world\nMelting reality's edge\nTruth becomes fluid",
            "Furnace winds howl past\nCarrying whispers of flame\nFrom deeper hells still",
            "The air itself burns\nBreathing becomes sacrifice\nLungs fill with fire",
            "Mirages dance close\nShowing truths from other worlds\nWhere all flesh is ash",
            "Temperature rises\nPast where thermometers break\nPhysics starts to fail"
        ],
        .hot: [
            "The heat stalks the land,\ncloaked in waves of shimmering\nmirage-born deceit.",
            "The air writhes, alive,\na shimmer that is not heat.\nIt sees you. It laughs.",
            "Sweat drips from your brow.\nIncense thickens in the air.\nA trial begins.",
            "The heat breathes, alive,\nits breath like rotting ether.\nIt whispers your name.",
            "Heat clings to your skin.\nA thing that will not release.\nNot until it's done.",
            "Warmth becomes a cage\nInvisible bars of heat\nTrap us in this realm",
            "Sun's fingers reach down\nCaressing with burning touch\nLeaving golden scars",
            "Heat ripples the air\nReality starts to bend\nTruth becomes fluid",
            "Summer spirits dance\nLeaving trails of shimmer-light\nIn their burning wake",
            "The air thick as soup\nBreathing becomes an effort\nOxygen burns hot"
        ],
        .warm: [
            "A deceiver's touch—\nsoft and pleasant on the skin,\nyet doom lurks ahead.",
            "The wind speaks in tongues,\ncaressing skin like a priest—\nsoft, before the knife.",
            "The sun's gentle touch,\na whisper through open doors.\nAre you listening?",
            "Soft warmth on your skin,\na lie told in golden hues.\nThe dark waits beneath.",
            "Gentle, too gentle.\nLike a hand before the blade.\nThis is how it starts.",
            "False comfort descends\nWrapping us in golden lies\nTrap disguised as gift",
            "Warmth whispers sweetly\nPromising eternal peace\nWhile sharpening knives",
            "Pleasant breeze deceives\nLulling us to dream-filled sleep\nNightmares wait their turn",
            "Spring air carries hints\nOf the summer's coming wrath\nEnjoy peace while here",
            "Warm winds bring changes\nWhispering of things to come\nNot all change brings good"
        ],
        .mild: [
            "The calm before storms,\ntoo perfect, too still, too bright.\nFate plots in silence.",
            "Too still, too silent.\nThe trees have ceased their chatter.\nThey have heard it move.",
            "The leaves shift and bow,\npressed low by unseen fingers.\nA presence walks past.",
            "The calm lulls the mind.\nA dream within waking flesh.\nThe stars start to blink.",
            "Nothing feels quite real.\nA dream you cannot wake from.\nOr did you ever?",
            "Perfect days deceive\nHiding chaos underneath\nCalm masks coming storms",
            "Balance point trembles\nBetween order and chaos\nNeither side prevails",
            "Stillness holds its breath\nWaiting for the pendulum\nTo begin its swing",
            "Time seems to pause here\nCaught between what was and is\nChoice point approaches",
            "Peace hangs by a thread\nDelicate as spider silk\nOne breath could break all"
        ],
        .cool: [
            "The wind bears whispers,\nchilling words from ancient times.\nA warning, maybe.",
            "The breeze coils around,\nsoft as a lover's whisper.\nIt wants you to come.",
            "A hush on the wind,\nthe scent of smoldering herbs.\nThe ritual starts.",
            "The chill pulls you close,\na whisper from the abyss.\nYou almost recall.",
            "A whisper, a breath.\nThe cold moves, but not the trees.\nSomething else is here.",
            "Cool fingers of air\nTrace sigils on warming skin\nMarking those who know",
            "Autumn spirits dance\nLeaving trails of fallen leaves\nWriting nature's code",
            "Crisp air carries hints\nOf winter's approaching reign\nChange whispers its song",
            "Fresh breeze brings wisdom\nFrom the edges of the world\nListen carefully",
            "Cool winds sweep away\nVeils of summer's warm deceits\nTruth becomes more clear"
        ],
        .cold: [
            "The earth stands frozen,\ntime itself slows in the frost.\nWarmth is but a dream.",
            "The frost does not bite.\nIt seeps deep into your bones,\nclaiming you as kin.",
            "Frozen hands reach up,\netching circles in the frost.\nSpirits mark their claim.",
            "Frost scrawls eldritch runes,\ncarved by hands unseen, unfelt.\nThe ice sings secrets.",
            "Your fingers go numb.\nA quiet creeping inward.\nYou won't feel the end.",
            "Winter's teeth bite deep\nGnawing through flesh to the bone\nMarking those who dare",
            "Ice forms sacred signs\nFrost runes tell forbidden tales\nWritten in white fire",
            "Cold seeps through the walls\nBringing whispers from the void\nWhere no warmth survives",
            "Frozen time stands still\nCaught in crystalline moments\nEternity waits",
            "Bitter winds howl past\nCarrying echoes of death\nFrom the frozen wastes"
        ],
        .veryCold: [
            "The ice speaks, cracking.\nIt sings in a voice of void.\nStep closer. Listen.",
            "A kingdom of ice,\nCandles flicker and expire.\nYou are not alone.",
            "Ice seals the doorway.\nCandles flicker and expire.\nYou are not alone.",
            "The void cracks open.\nShadows slither through the snow.\nIt was never dead.",
            "Cold past skin and bone.\nIt settles into your soul.\nAnd makes itself home.",
            "Deep freeze claims all life\nSuspending time in crystal\nEternity sleeps",
            "Arctic spirits dance\nLeaving trails of frozen breath\nIn the endless night",
            "Temperature drops past\nWhere thermometers can read\nPhysics starts to fail",
            "Frost giants awake\nStretching crystalline fingers\nToward mortal realms",
            "In this frozen waste\nAncient things preserved in ice\nSlowly start to stir"
        ]
    ]
    
    static func randomMessage(for condition: WeatherCondition) -> String {
        guard let messages = messages[condition],
              !messages.isEmpty else {
            return "Sky data not found,\nwhispers lost in empty void,\nthe wind does not speak."
        }
        
        return messages.randomElement() ?? "Sky data not found,\nwhispers lost in empty void,\nthe wind does not speak."
    }
} 