import Foundation

struct WeatherMessages {
    static let messages: [WeatherCondition: [String]] = [
        .sunny: [
            "A child points upward\nMouth opens in silent scream\nEyes turn molten gold.",
            "Shadows flee in fear\nLeaving flesh exposed and raw\nLight digests us all.",
            "Morning breaks the mind\nReality peels away slow\nTruth burns through our eyes.",
            "Daylight strips our skin\nUnderneath we writhe in dark\nSun knows what we are.",
            "We shield mortal eyes\nBut light seeps through flesh and bone\nMelts us from within.",
            "Dawn brings truth to light\nWhat we thought was human form\nSheds its meat disguise.",
            "Noon reveals too much\nBeneath our skin something moves\nWe can't look away.",
            "The sun feeds on thoughts\nIt has tasted human minds\nWe feed it our dreams.",
            "Light peels back our lies\nExposing the void within\nWe were never here.",
            "Sunshine vivisects\nLayer by layer we peel\nTruth bleeds golden rays."
        ],
        .partlyCloudy: [
            "The clouds split open\nSomething peers through the wound now\nIt sees what we are.",
            "Gaps in sky reveal\nThings that swim in higher seas\nThey remember us.",
            "Light breaks through the veil\nIlluminates ancient truths\nMind shatters like glass.",
            "Between cloud and sun\nReality starts to tear\nVoid seeps through the cracks.",
            "Through the rips we see\nWhat exists beyond the blue\nSanity dissolves.",
            "Clouds try to shield us\nFrom the truth that waits above\nTheir flesh wears too thin.",
            "The wounds in sky bleed\nGolden light that burns our thoughts\nMemories turn ash.",
            "Clouds become windows\nShowing what we used to be\nBefore we grew legs.",
            "Patches of blue sky\nReveal the lie we live in\nTruth drives us all mad.",
            "Light pierces the clouds\nShowing what swims far above\nWe remember now."
        ],
        .cloudy: [
            "The mass writhes above\nPregnant with forbidden things\nBirth pains shake the world.",
            "Clouds digest the light\nLeaving us in mercied dark\nUntil they get hungry.",
            "The sky shifts and moans\nStraining to contain what grows\nSeams begin to split.",
            "Shadows fall like rain\nTheir darkness stains minds below\nLeaving holes in thought.",
            "The grey becomes teeth\nChewing holes through space and time\nHunger never ends.",
            "The mass grows above\nWhat forms inside isn't rain\nWe pray it can't fall.",
            "Clouds write twisted signs\nProphecy in bloated script\nSky begins to birth.",
            "Grey thoughts coagulate\nForming shapes we can't describe\nSanity bleeds out.",
            "The clouds split apart\nRevealing the things that swim\nIn seas up above.",
            "The sky becomes void\nSwollen with forbidden life\nLabor pains begin."
        ],
        .drizzle: [
            "First drop hits my tongue\nTastes of memories not mine\nSomeone else lives now.",
            "Light rain taps my skull\nEach drop drills a little hole\nThoughts begin to leak.",
            "Mist becomes needles\nPiercing through reality\nWorld starts to unwind.",
            "Soft rain whispers lies\nI believe them one by one\nMind dissolves like salt.",
            "Gentle droplets fall\nEach one plants a squirming thought\nParasites take root.",
            "Water seeps through skin\nReplacing blood with old dreams\nI remember seas.",
            "Drizzle carries eggs\nThey hatch behind my wet eyes\nVision turns to dark.",
            "Rain writes on my flesh\nMessages I can't unsee\nSkin begins to read.",
            "Each drop holds a face\nI recognize all of them\nThey were once my own.",
            "Mist becomes a voice\nWhispering what I'll become\nChange has just begun."
        ],
        .rainy: [
            "Rain pounds through my skull\nWashing memories away\nStrange thoughts flood back in.",
            "Water fills my lungs\nI breathe ancient oceans now\nGills split through my neck.",
            "Storm drowns sanity\nMind floats in primordial seas\nNew forms take our shape.",
            "Rain brings what was lost\nMillions of years of darkness\nWe remember fins.",
            "Drops become needles\nStitching new truths through our flesh\nWe transform again.",
            "Sky bleeds mercury\nIt runs down our throats like fire\nBurns us from within.",
            "Rain carries old souls\nThey seek warm bodies to wear\nWe host them like eggs.",
            "Water breaks our forms\nReshaping flesh like wet clay\nWe become the sea.",
            "Each raindrop burns deep\nCarving channels through our minds\nThoughts flow out like blood.",
            "Storm brings evolution\nWe shed our humanity\nOceans claim us now."
        ],
        .downpour: [
            "Walls of water fall\nReality dissolves fast\nNothing stays intact.",
            "Flood drowns history\nWashes clean what we once were\nNew forms rise from depths.",
            "Rain becomes our blood\nWe float in primordial seas\nGills remember how.",
            "Deluge breaks the world\nFragments of what we once were\nSwirl down cosmic drains.",
            "Water fills all space\nLungs become useless anchors\nWe breathe ancient seas.",
            "Heaven's wounds gush forth\nDrowning land in amnion\nRebirth comes through pain.",
            "Rain erases time\nWashes clean the slate of now\nPast floods back through cracks.",
            "Torrents strip our flesh\nRevealing the fish within\nWe swim toward home.",
            "Storm tears holes in space\nThrough them ancient seas pour in\nWorld returns to dark.",
            "Downpour flays our minds\nStrips away false memories\nTruth floats up like corpse."
        ],
        .thunderstorm: [
            "Lightning splits the sky\nThrough the wound the gods fall down\nTheir screams shatter minds.",
            "Thunder speaks my name\nIn a voice that breaks my thoughts\nI answer in tongues.",
            "The flash shows what waits\nBetween the spaces of time\nClaws reach through the dark.",
            "Each flash burns new truths\nInto the flesh of my eyes\nI see too much now.",
            "Lightning splits my mind\nThunder stitches it back wrong\nNew thoughts crawl inside.",
            "The storm breaks the world\nFragments of what we once were\nRain washes truth clean.",
            "Thunder cracks the earth\nThrough the gaps old ones slip in\nThey remember us.",
            "Each flash freezes time\nBetween the light and darkness\nGods dance in my eyes.",
            "The storm changes all\nLightning rewrites history\nNothing stays the same.",
            "Thunder shakes loose thoughts\nLightning illuminates truth\nMadness sets us free."
        ],
        .stormy: [
            "Wind peels off my skin\nRevealing the thing beneath\nIt was never me.",
            "The gale strips flesh clean\nExposing the writhing dark\nThat we kept inside.",
            "The storm tears through time\nThrough gaps crawl ancient beings\nThey wear our faces.",
            "The tempest breaks all\nReality comes undone\nChaos claims its own.",
            "Wind carries lost screams\nFrom when the world was still young\nWe remember now.",
            "The storm rips minds wide\nScattering thoughts to the void\nMadness fills the gaps.",
            "The gale splits the veil\nBetween what is and what was\nTruth comes howling through.",
            "Winds strip us all bare\nOf all we thought permanent\nChange takes everything.",
            "The tempest brings dark\nThat existed before light\nIt remembers us.",
            "Wind becomes a voice\nSpeaking truths we can't contain\nSanity breaks free."
        ],
        .windy: [
            "The breeze brings whispers\nOf what we will soon become\nChange rides on the wind.",
            "The air comes alive\nBreathing thoughts into our lungs\nMind starts to transform.",
            "Wind slips through my pores\nReplacing blood with old dreams\nI am not the same.",
            "The gusts shape my thoughts\nBlowing through the halls of mind\nStrange seeds take root now.",
            "A presence rides wind\nWearing shapes of dust and leaves\nIt has found us all.",
            "The breeze brings the spores\nThey grow inside mortal minds\nFlesh remembers how.",
            "Wind erodes our forms\nStripping layers of pretense\nTruth shows through the gaps.",
            "The air brings lost songs\nFrom when the world was not world\nWe start singing too.",
            "The breeze cuts like knives\nSlicing through reality\nVoid seeps through the wounds.",
            "Wind reshapes our thoughts\nBlowing through the mind's dark halls\nStrangers live there now."
        ],
        .foggy: [
            "The grey swallows light\nI reach out to touch my hand\nSomeone else's moves.",
            "The mist takes our names\nI forget which shape was mine\nStrangers wear my skin.",
            "The fog fills my lungs\nBreathing in lost memories\nI become someone.",
            "Through the churning grey\nShapes that once were human drift\nWearing borrowed flesh.",
            "The mist takes my form\nI seep into other lives\nNone of them feel right.",
            "The grey fills my mind\nWhat I was fades like a dream\nNew self emerges.",
            "The fog steals my truth\nReality blurs and shifts\nTruth becomes like mist.",
            "In the swirling grey\nI trade faces with the lost\nNone fit quite right now.",
            "The mist takes my past\nMemories turn fluid now\nI flow with the fog.",
            "The void fills my eyes\nWhat was solid melts away\nI become the mist."
        ],
        .hellscape: [
            "Flesh starts to bubble\nSkin peels back in burning sheets\nBones begin to melt.",
            "Air ignites my thoughts\nMind combusts in golden flames\nAshes float away.",
            "Heat strips sanity\nReality warps and bends\nTruth evaporates.",
            "Atmosphere catches\nFire spreads from breath to breath\nWe burn from within.",
            "My shadow catches\nFire as the ground turns glass\nI leave burning tracks.",
            "Light devours all\nMatter returns to pure heat\nExistence burns through.",
            "Time itself catches\nFire as dimensions melt\nSpace becomes pure flame.",
            "Heat peels back the world\nUnderneath is only fire\nWe were always ash.",
            "Thoughts turn incandescent\nBrain matter starts to bubble\nSkull becomes a forge.",
            "Reality burns\nLeaving only light and pain\nWe transcend through fire."
        ],
        .inferno: [
            "Heat cracks my skull wide\nThoughts leak out like mercury\nMind starts to combust.",
            "Skin becomes too tight\nUnderneath something writhes hot\nTrying to break free.",
            "Air shimmers with rage\nBreathing draws in liquid fire\nLungs start to ignite.",
            "Ground melts like black wax\nFootsteps fill with molten dreams\nI wade through what burns.",
            "Light bends reality\nHeat makes truth too fluid now\nNothing stays intact.",
            "Sweat boils on my skin\nSteam carries my essence up\nI diffuse like mist.",
            "Fire fills my veins\nBlood becomes too hot to hold\nI leak golden light.",
            "Heat peels back my thoughts\nUnderneath writhes something strange\nMade of flame and dark.",
            "Mind melts down to slag\nDripping thoughts of liquid fire\nPuddle at my feet.",
            "Temperature rises\nPast where flesh can still exist\nI sublime to light."
        ],
        .sweltering: [
            "Heat makes my skin crawl\nUnderneath something moves wrong\nI'm not alone here.",
            "Air thick as hot blood\nBreathing becomes drowning now\nLungs fill up with light.",
            "Sweat carries my self\nDropping pieces of my mind\nI dissolve in heat.",
            "Light bends space and time\nReality starts to warp\nTruth becomes fluid.",
            "Heat makes memories\nMelt and run like candle wax\nMind loses its shape.",
            "My shadow catches\nFire in the burning air\nFlesh remembers flame.",
            "Thoughts turn viscous now\nDripping through the cracks of mind\nLeaving holes behind.",
            "Air shimmers with dreams\nOf when all was burning bright\nFlesh remembers fire.",
            "Heat peels back my thoughts\nExposing the thing beneath\nThat writhes in the light.",
            "Temperature rises\nPast where reason still exists\nMadness blooms like flame."
        ],
        .sultry: [
            "Heat makes air too thick\nTo hold thoughts in proper shape\nMind starts to dissolve.",
            "Sweat carries my name\nDropping letters one by one\nI forget who's here.",
            "Air becomes syrup\nThoughts wade through it slow and strange\nTime loses its grip.",
            "Light bends memory\nInto shapes that hurt to hold\nPast becomes fluid.",
            "Heat makes skin too tight\nSomething moves beneath its mask\nTrying to break free.",
            "Air thick with old dreams\nBreathing draws them deep inside\nThey nest in my lungs.",
            "Warmth seeps through my pores\nReplacing blood with soft light\nI glow from within.",
            "Time melts in the heat\nDripping moments pool and merge\nNow becomes always.",
            "My shadow ripples\nLike dark water in the heat\nSomething swims beneath.",
            "Temperature rises\nPast where thoughts keep proper shape\nMind begins to flow."
        ],
        .balmy: [
            "Warmth seeps through my skin\nGently loosening my thoughts\nMind starts to unwind.",
            "Air carries whispers\nOf what summer will bring next\nChange comes with the heat.",
            "Light bends gently now\nReality softens slow\nTruth becomes like dreams.",
            "Heat makes memories\nSoft around their hardened edge\nPast begins to blur.",
            "Warmth brings ancient thoughts\nRising up from deeper mind\nStrangers live there now.",
            "Air thick with promise\nOf metamorphosis near\nChange comes with the warmth.",
            "My shadow stretches\nTrying shapes it shouldn't know\nHeat makes rules bend wrong.",
            "Temperature rises\nJust enough to start the change\nWe won't stay the same.",
            "Comfort hides the truth\nOf what warmth will bring to us\nWhen the heat grows strong.",
            "Gentle warmth deceives\nMaking us forget the cold\nThat will come again."
        ],
        .temperate: [
            "Balance point trembles\nBetween what was and will be\nChange waits in between.",
            "Perfect moment holds\nTime balanced on needle point\nSoon it has to fall.",
            "Now hangs suspended\nBetween memory and dream\nNeither wins just yet.",
            "Reality holds\nIts breath between truth and lie\nWaiting for the break.",
            "Present moment floats\nCaught between opposing pulls\nSoon it must decide.",
            "Time stops flowing now\nCaught between then and not yet\nChoice point approaches.",
            "World holds its balance\nOn the edge of knife-blade change\nSoon we all must fall.",
            "Stillness hides the truth\nOf chaos that waits to bloom\nWhen balance point breaks.",
            "Perfect moment hides\nThe horror that waits to birth\nWhen time starts again.",
            "Now becomes a pause\nBetween what was and will be\nNeither truth will last."
        ],
        .brisk: [
            "Cold starts creeping in\nNibbling at my fingertips\nHunger grows with time.",
            "Autumn wind brings change\nCarrying scents of decay\nWinter's scouts arrive.",
            "Chill air fills my lungs\nBreathing in the taste of frost\nChange begins within.",
            "Wind carries whispers\nOf the ice that's yet to come\nPromising dark dreams.",
            "Cold makes thoughts move slow\nLike insects caught in amber\nFrozen memories.",
            "Crisp air carries hints\nOf the darkness yet to come\nWinter's shadows grow.",
            "My breath turns to mist\nCarrying pieces of self\nOut into the cold.",
            "Temperature drops slow\nLike a blade sliding through flesh\nPain comes later on.",
            "Brisk wind starts to cut\nPeeling layers of warmth off\nExposing what's raw.",
            "Cold begins its work\nStripping warmth from flesh and bone\nWinter's teeth grow sharp."
        ],
        .chilly: [
            "Cold seeps through my skin\nReplacing blood with ice melt\nChange starts from within.",
            "Chill makes my thoughts freeze\nCracking into crystal shards\nMind begins to break.",
            "Frost forms in my veins\nBlood moves thick with memories\nOf when we were warm.",
            "Winter's scouts arrive\nTesting flesh with gentle bites\nBefore the real cold.",
            "My breath turns to ghosts\nEach one carries warmth away\nLeaving holes in time.",
            "Cold makes skin shrink tight\nUnderneath something moves slow\nWaiting to break free.",
            "Chill air fills my lungs\nFreezing thoughts to crystal form\nMemories crack clean.",
            "Temperature drops more\nPast where comfort used to live\nNumbness comes as friend.",
            "Ice forms in my mind\nThoughts become too cold to hold\nShatter when they fall.",
            "Winter starts its work\nReshaping what warmth made soft\nNothing stays the same."
        ],
        .frosty: [
            "Frost crawls through my veins\nReplacing blood with ice dreams\nI remember cold.",
            "Winter's teeth bite deep\nChewing holes through memory\nCold fills empty space.",
            "Ice grows in my mind\nForming crystals sharp with truth\nThoughts shatter like glass.",
            "Frost etches strange signs\nOn the windows of my eyes\nI see winter's plans.",
            "Cold makes time freeze still\nCaught between now and not yet\nIce preserves this pause.",
            "My breath breaks in shards\nFalling like crystalline thoughts\nToo cold to hold long.",
            "Frost forms patterns now\nWriting futures in ice script\nOn my cooling skin.",
            "Winter's voice speaks clear\nIn the language of pure cold\nI translate through pain.",
            "Ice grows from within\nPushing warmth out of my core\nCold claims empty space.",
            "Frost rewrites my thoughts\nIn the grammar of pure ice\nMind becomes crystal."
        ],
        .frigid: [
            "Cold strips flesh from bone\nLeaving only ice beneath\nWe were winter's child.",
            "Frost fills empty space\nWhere my thoughts once used to flow\nMind becomes pure ice.",
            "Blood freezes mid-flow\nTime caught in crystalline pause\nNothing moves but cold.",
            "Winter claims its own\nStripping warmth from flesh and bone\nIce fills empty space.",
            "Breath shatters like glass\nScattering frozen moments\nTime breaks in the cold.",
            "Ice grows from within\nPushing life out of my core\nCold becomes my truth.",
            "Frigid air bites deep\nChewing holes through memory\nCold thoughts fill the gaps.",
            "My skin turns to frost\nShattered by the weight of cold\nIce shows through the cracks.",
            "Winter speaks in tongues\nOf pure ice and absolute\nZero kelvin dreams.",
            "Cold rewrites my code\nDNA turns crystalline\nIce flows through my veins."
        ],
        .glacial: [
            "Time freezes in place\nCaught in walls of ancient ice\nMemory turns white.",
            "Cold transcends all thought\nMind becomes pure crystal now\nThinking stops in ice.",
            "Glacial dreams take hold\nReshaping what once was warm\nInto forms of frost.",
            "Ice age claims my thoughts\nFreezing them to crystal forms\nThat shatter when touched.",
            "Winter's final truth\nReveals itself through pure cold\nWe were always ice.",
            "Breath turns into snow\nCarrying last warmth away\nLeaving only frost.",
            "Cold rewrites my core\nDNA turns crystalline\nIce flows in my veins.",
            "Time stops flowing now\nCaught in walls of ancient ice\nFrozen memories.",
            "Glaciers claim my mind\nGrinding thoughts to crystal dust\nThat drifts like snow falls.",
            "Ice age blooms within\nFreezing blood to crystal form\nWe become pure cold."
        ],
        .polar: [
            "Cold beyond all thought\nWhere even ice fears to form\nVoid consumes all warmth.",
            "Time itself freezes\nCaught in absolute zero\nNothing moves but dark.",
            "Polar vortex spins\nStripping atoms of their heat\nVoid fills empty space.",
            "Cold transcends all bounds\nWhere even quantum motion\nFreezes into still.",
            "Ice becomes like steel\nShattering molecules now\nAtoms freeze in place.",
            "Temperature drops\nPast where physics still makes sense\nReality breaks.",
            "Polar night descends\nDarkness thick with ancient cold\nSwallows all that was.",
            "Winter's final form\nReveals truth through absolute\nZero kelvin dreams.",
            "Cold strips existence\nDown to fundamental frost\nVoid fills what remains.",
            "Polar vortex pulls\nReality apart now\nNothing moves but dark."
        ],
        .snowy: [
            "The flakes carry souls\nOf those winter claimed as prey\nThey want company.",
            "The snow takes the world\nRewriting all that we knew\nIn blank poetry.",
            "Each crystal contains\nMemories of those now lost\nIn the endless white.",
            "The winter brings change\nEach flake bears a frozen dream\nOf what we'll become.",
            "The snow writes new truths\nIn the language of the void\nErasing what was.",
            "The crystals descend\nHolding winter's frozen young\nWaiting time to hatch.",
            "The white fills all space\nSwallowing what we once were\nLeaving only snow.",
            "The winter sends seeds\nPlanting frost in mortal minds\nCold thoughts start to grow.",
            "The snow becomes skin\nWe shed what we used to be\nJoin the endless white.",
            "The blizzard takes all\nLeaving only crystal dreams\nOf what cold creates."
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