local GAFE = GroupActivityFinderExtensions

GAFE_LFG_ACTIVITY_TRIAL = LFG_ACTIVITY_ITERATION_END + 1
GAFE_LFG_ACTIVITY_MASTER_TRIAL = LFG_ACTIVITY_ITERATION_END + 2
GAFE_ACTIVITY_FINDER_SORT_PRIORITY = {
	ACTIVITY_SCHEDULE = ZO_ACTIVITY_FINDER_SORT_PRIORITY.DUNGEONS + 1000,
	TRIALS = ZO_ACTIVITY_FINDER_SORT_PRIORITY.DUNGEONS + 50
}

GAFE.Constants = {}

GAFE.Constants.PledgeId = {
    FungalGrottoI 		= 1,
    FungalGrottoII 		= 2,
    SpindleclutchI 		= 3,
    SpindleclutchII 	= 4,
    BanishedCellsI 		= 5,
    BanishedCellsII 	= 6,
    DarkshadeCavernsI 	= 7,
    DarkshadeCavernsII 	= 8,
    EldenHollowI 		= 9,
    EldenHollowII 		= 10,
    WayrestSewersI 		= 11,
    WayrestSewersII 	= 12,
    ArxCorinium 		= 13,
    CityOfAshI 			= 14,
    CityOfAshII 		= 15,
    CryptOfHeartsI 		= 16,
    CryptOfHeartsII 	= 17,
    DirefrostKeep 		= 18,
    TempestIsland 		= 19,
    Volenfell 			= 20,
    BlackheartHaven 	= 21,
    BlessedCrucible 	= 22,
    SelenesWeb 			= 23,
    VaultsOfMadness 	= 24,
    BloodrootForge 		= 25,
    CastleThorn 		= 26,
    CradleOfShadows 	= 27,
    DepthsOfMalatar 	= 28,
    FalkreathHold 		= 29,
    FangLair 			= 30,
    Frostvault 			= 31,
    Icereach 			= 32,
    ImperialCityPrison 	= 33,
    LairOfMaarselok 	= 34,
    MarchOfSacrifices 	= 35,
    MoonHunterKeep 		= 36,
    MoongraveFane 		= 37,
    RuinsOfMazzatun 	= 38,
    ScalecallerPeak 	= 39,
    StoneGarden 		= 40,
    UnhallowedGrave 	= 41,
    WhiteGoldTower 		= 42,
	BlackDrakeVilla		= 43,
	Cauldron			= 44,
	RedPetalBastion		= 45,
	DreadCellar			= 46
}

GAFE.Constants.ActivityId = {
    -- ZOs
    NormalFungalGrottoI			= 2,
	VeteranFungalGrottoI		= 299,

	NormalFungalGrottoII		= 18,
	VeteranFungalGrottoII		= 312,

	NormalSpindleclutchI		= 3,
	VeteranSpindleclutchI		= 315,

	NormalSpindleclutchII		= 316,
	VeteranSpindleclutchII		= 19,

	NormalBanishedCellsI		= 4,
	VeteranBanishedCellsI		= 20,

	NormalBanishedCellsII		= 300,
	VeteranBanishedCellsII		= 301,

	NormalDarkshadeCavernsI		= 5,
	VeteranDarkshadeCavernsI	= 309,

	NormalDarkshadeCavernsII	= 308,
	VeteranDarkshadeCavernsII	= 21,

	NormalEldenHollowI			= 7,
	VeteranEldenHollowI			= 23,

	NormalEldenHollowII			= 303,
	VeteranEldenHollowII		= 302,

	NormalWayrestSewersI		= 6,
	VeteranWayrestSewersI		= 306,

	NormalWayrestSewersII		= 22,
	VeteranWayrestSewersII		= 307,

	NormalArxCorinium			= 8,
	VeteranArxCorinium			= 305,

	NormalCityOfAshI			= 10,
	VeteranCityOfAshI			= 310,

	NormalCityOfAshII			= 322,
	VeteranCityOfAshII			= 267,

	NormalCryptOfHeartsI		= 9,
	VeteranCryptOfHeartsI		= 261,

	NormalCryptOfHeartsII		= 317,
	VeteranCryptOfHeartsII		= 318,

	NormalDirefrostKeep			= 11,
	VeteranDirefrostKeep		= 319,

	NormalTempestIsland			= 13,
	VeteranTempestIsland		= 311,

	NormalVolenfell				= 12,
	VeteranVolenfell			= 304,

	NormalBlackheartHaven		= 15,
	VeteranBlackheartHaven		= 321,

	NormalBlessedCrucible		= 14,
	VeteranBlessedCrucible		= 320,

	NormalSelenesWeb			= 16,
	VeteranSelenesWeb			= 313,

	NormalVaultsOfMadness		= 17,
	VeteranVaultsOfMadness		= 314,

	NormalBlackDrakeVilla		= 591,
	VeteranBlackDrakeVilla		= 592,

	NormalBloodrootForge		= 324,
	VeteranBloodrootForge		= 325,

	NormalCastleThorn			= 509,
	VeteranCastleThorn			= 510,

	NormalCradleOfShadows		= 295,
	VeteranCradleOfShadows		= 296,

	NormalDepthsOfMalatar		= 435,
	VeteranDepthsOfMalatar		= 436,

	NormalFalkreathHold			= 368,
	VeteranFalkreathHold		= 369,

	NormalFangLair				= 420,
	VeteranFangLair				= 421,

	NormalFrostvault			= 433,
	VeteranFrostvault			= 434,

	NormalIcereach				= 503,
	VeteranIcereach				= 504,

	NormalImperialCityPrison	= 289,
	VeteranImperialCityPrison	= 268,

	NormalLairOfMaarselok		= 496,
	VeteranLairOfMaarselok		= 497,

	NormalMarchOfSacrifices		= 428,
	VeteranMarchOfSacrifices	= 429,

	NormalMoonHunterKeep		= 426,
	VeteranMoonHunterKeep		= 427,

	NormalMoongraveFane			= 494,
	VeteranMoongraveFane		= 495,

	NormalRedPetalBastion		= 595,
	VeteranRedPetalBastion		= 596,

	NormalRuinsOfMazzatun		= 293,
	VeteranRuinsOfMazzatun		= 294,

	NormalScalecallerPeak		= 418,
	VeteranScalecallerPeak		= 419,

	NormalStoneGarden			= 507,
	VeteranStoneGarden			= 508,

	NormalCauldron				= 593,
	VeteranCauldron				= 594,

	NormalDreadCellar			= 597,
	VeteranDreadCellar			= 598,

	NormalUnhallowedGrave		= 505,
	VeteranUnhallowedGrave		= 506,

	NormalWhiteGoldTower		= 288,
	VeteranWhiteGoldTower		= 287,

    -- Custom ids. For safety start from 1000
    NormalAetherianArchive      = 1001,
    VeteranAetherianArchive     = 1002,

    NormalHelRaCitadel          = 1003,
    VeteranHelRaCitadel         = 1004,

    NormalSanctumOphidia        = 1005,
    VeteranSanctumOphidia       = 1006,

    NormalMawOfLorkhaj          = 1007,
    VeteranMawOfLorkhaj         = 1008,

    NormalHallsOfFabrication    = 1009,
    VeteranHallsOfFabrication   = 1010,

    NormalAsylumSanctorium      = 1011,
    VeteranAsylumSanctorium     = 1012,

    NormalCloudrest             = 1013,
    VeteranCloudrest            = 1014,

    NormalSunspire              = 1015,
    VeteranSunspire             = 1016,

    NormalKynesAegis            = 1017,
    VeteranKynesAegis           = 1018,

	NormalRockgrave             = 1019,
	VeteranRockgrave            = 1020,
}

GAFE.Constants.CollapseMode = {
	Group = 1,
	Normal = 2,
	Veteran = 3
}

GAFE.Constants.SetId = {
	Sellistrix = 271,
	LamiasSong = 303,
	Medusa = 304,
	UndauntedInfiltrator = 156,
	PirateSkeleton = 277,
	BonePiratesTatters = 308,
	KnightErrantsMail = 309,
	UndauntedUnweaver = 157,
	TheTrollKing = 278,
	NikulasHeavyArmor = 72,
	NobleDuelistsSilks = 46,
	SwordDancer = 310,
	InfernalGuardian = 272,
	ValkynSkoria = 169,
	BurningSpellweave = 160,
	Embershield = 158,
	Sunderflame = 159,
	Ilambris = 273,
	Nerieneth = 168,
	EbonArmory = 122,
	Leviathan = 302,
	ShroudoftheLich = 134,
	EngineGuardian = 166,
	SentinelofRkugamz = 268,
	ArmorofTruth = 96,
	NetchsTouch = 300,
	StrengthoftheAutomaton = 301,
	Iceheart = 274,
	DraugrHulk = 307,
	MagickaFurnace = 103,
	TheIceFurnace = 53,
	Chokethorn = 269,
	Nightflame = 167,
	Barkskin = 28,
	LightSpeaker = 298,
	UndauntedBastion = 155,
	Kragh = 266,
	SpawnofMephala = 162,
	DreughKingSlayer = 61,
	SpiderCultistCowl = 297,
	VipersSting = 33,
	Selene = 279,
	DuroksBane = 71,
	HircinesVeneer = 123,
	VestmentsoftheWarlock = 19,
	Bloodspawn = 163,
	SwarmMother = 267,
	Knightmare = 35,
	PrayerShawl = 55,
	Spelunker = 296,
	Stormfist = 275,
	JoltingArms = 186,
	OverwhelmingSurge = 193,
	StormMaster = 188,
	MawoftheInfernal = 170,
	Shadowrend = 265,
	Jailbreaker = 295,
	Sanctuary = 110,
	Tormentor = 197,
	Grothdarr = 280,
	OblivionsEdge = 91,
	Rattlecage = 311,
	TheWormsRaiment = 124,
	Tremorscale = 276,
	Crusader = 77,
	DunerippersScales = 102,
	TreasureHunter = 305,
	ScourgeHarvester = 165,
	Slimecraw = 270,
	CombatPhysician = 194,
	SergeantsMail = 29,
	Toothrow = 299,
    EncratissBehemoth = 577,
    DrakesRush = 571,
    KinrassWrath = 570,
    TrueSwornFury = 569,
    Earthgore = 341,
    Blooddrinker = 339,
    FlameBlossom = 338,
    HagravensGarden = 340,
    LadyThorn = 535,
    CrimsonTwilight = 515,
    TalfygsTreachery = 513,
    UnleashedTerror = 514,
    Velidreth = 257,
    Gossamer = 261,
    HandofMephala = 263,
    Widowmaker = 262,
    SymphonyofBlades = 436,
    AuroransThunder = 435,
    FrozenWatcher = 433,
    ScavengingDemise = 434,
    Domihaus = 342,
    DraugrsRest = 335,
    Ironblood = 337,
    PillarofNirn = 336,
    Thurvokun = 349,
    CaluurionsLegacy = 343,
    TrappingsofInvigoration = 344,
    UlfnorsFavor = 345,
    Stonekeeper = 432,
    IcyConjuror = 431,
    MightyGlacier = 429,
    TzogvinsWarband = 430,
    MotherCiannait = 478,
    BanisTorment = 473,
    HitisHearth = 471,
    TitanbornStrength = 472,
    LordWarden = 164,
    LeechingPlate = 196,
    ScathingMage = 190,
    SheerVenom = 195,
    Maarselok = 459,
    AzureblightReaper = 456,
    DragonsDefilement = 457,
    ZensRedress = 455,
    Balorgh = 397,
    BloodMoon = 400,
    HanusCompassion = 399,
    HavenofUrsus = 401,
    Vykosa = 398,
    JailersTenacity = 404,
    MoonHunter = 402,
    SavageWerewolf = 403,
    Grundwulf = 458,
    DroZakarsClaws = 453,
    HollowfangThirst = 452,
    RenaldsResolve = 454,
    PriorThierric = 608,
    GrislyGourmet = 607,
    SilverRoseVigil = 605,
    ThunderCaller = 606,
    MightyChudan = 256,
    AmberPlasm = 258,
    AspectofMazzatun = 260,
    HeemJasRetribution = 259,
    Zaan = 350,
    CurseofDoylemish = 348,
    JorvuldsGuidance = 346,
    PlagueSlinger = 347,
    StoneHusk = 534,
    ArkasissGenius = 518,
    ElementalCatalyst = 516,
    KraglensHowl = 517,
    BaronZaudrus = 578,
    DagonsDominion = 573,
    FoolkillersWard = 574,
    UnleashedRitualist = 572,
    MagmaIncarnate = 609,
    CrimsonOathsRive = 602,
    RushofAgony = 604,
    ScorionsFeast = 603,
    KjalnarsNightmare = 479,
    AegisCaller = 475,
    DraugrkinsGrip = 474,
    GraveGuardian = 476,
    MolagKena = 183,
    BrandsofImperium = 184,
    EssenceThief = 198,
    SpellPowerCure = 185,
}
