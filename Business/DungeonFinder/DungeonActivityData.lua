local GAFE = GroupActivityFinderExtensions

local ActivityId = GAFE.Constants.ActivityId
local PledgeId = GAFE.Constants.PledgeId

-- https://esoitem.uesp.net/viewlog.php
GAFE.DungeonActivityData={
    --Normal
    [ActivityId.NormalFungalGrottoI]		= {id=294, 		q=3993,		p=PledgeId.FungalGrottoI,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalFungalGrottoII]		= {id=1562,		q=4303,		p=PledgeId.FungalGrottoII,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalSpindleclutchI]		= {id=301, 		q=4054,		p=PledgeId.SpindleclutchI,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalSpindleclutchII]		= {id=1571,		q=4555,		p=PledgeId.SpindleclutchII,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalBanishedCellsI]		= {id=325, 		q=4107,		p=PledgeId.BanishedCellsI,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalBanishedCellsII]		= {id=1555,		q=4597,		p=PledgeId.BanishedCellsII,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalDarkshadeCavernsI]	= {id=78, 		q=4145,		p=PledgeId.DarkshadeCavernsI,   hm=false,   tt=false,   nd=false},
    [ActivityId.NormalDarkshadeCavernsII]	= {id=1587,		q=4641,		p=PledgeId.DarkshadeCavernsII,  hm=false,   tt=false,   nd=false},
    [ActivityId.NormalEldenHollowI]			= {id=11, 		q=4336,		p=PledgeId.EldenHollowI,        hm=false,   tt=false,   nd=false},
    [ActivityId.NormalEldenHollowII]		= {id=1579,		q=4675,		p=PledgeId.EldenHollowII,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalWayrestSewersI]		= {id=79, 		q=4246,		p=PledgeId.WayrestSewersI,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalWayrestSewersII]		= {id=1595,		q=4813,		p=PledgeId.WayrestSewersII,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalArxCorinium]			= {id=272, 		q=4202,		p=PledgeId.ArxCorinium,         hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCityOfAshI]			= {id=551, 		q=4778,		p=PledgeId.CityOfAshI,          hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCityOfAshII]			= {id=1603,		q=5120,		p=PledgeId.CityOfAshII,         hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCryptOfHeartsI]		= {id=80, 		q=4379,		p=PledgeId.CryptOfHeartsI,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCryptOfHeartsII]		= {id=1616,		q=5113,		p=PledgeId.CryptOfHeartsII,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalDirefrostKeep]		= {id=357, 		q=4346,		p=PledgeId.DirefrostKeep,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalTempestIsland]		= {id=81, 		q=4538,		p=PledgeId.TempestIsland,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalVolenfell]			= {id=391, 		q=4432,		p=PledgeId.Volenfell,           hm=false,   tt=false,   nd=false},
    [ActivityId.NormalBlackheartHaven]		= {id=410, 		q=4589,		p=PledgeId.BlackheartHaven,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalBlessedCrucible]		= {id=393, 		q=4469,		p=PledgeId.BlessedCrucible,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalSelenesWeb]			= {id=417, 		q=4733,		p=PledgeId.SelenesWeb,          hm=false,   tt=false,   nd=false},
    [ActivityId.NormalVaultsOfMadness]		= {id=570, 		q=4822,		p=PledgeId.VaultsOfMadness,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalBloodrootForge]		= {id=1690,		q=5889,		p=PledgeId.BloodrootForge,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCastleThorn]   		= {id=2704,		q=6507,		p=PledgeId.CastleThorn,         hm=false,   tt=false,   nd=false},
    [ActivityId.NormalCradleOfShadows]		= {id=1522,		q=5702,		p=PledgeId.CradleOfShadows,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalDepthsOfMalatar]		= {id=2270,		q=6251,		p=PledgeId.DepthsOfMalatar,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalFalkreathHold]		= {id=1698,		q=5891,		p=PledgeId.FalkreathHold,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalFangLair]				= {id=1959,		q=6064,		p=PledgeId.FangLair,            hm=false,   tt=false,   nd=false},
    [ActivityId.NormalFrostvault]			= {id=2260,		q=6249,		p=PledgeId.Frostvault,          hm=false,   tt=false,   nd=false},
    [ActivityId.NormalIcereach]				= {id=2539,		q=6414,		p=PledgeId.Icereach,            hm=false,   tt=false,   nd=false},
    [ActivityId.NormalImperialCityPrison]	= {id=1345,		q=5136,		p=PledgeId.ImperialCityPrison,  hm=false,   tt=false,   nd=false},
    [ActivityId.NormalLairOfMaarselok]		= {id=2425,		q=6351,		p=PledgeId.LairOfMaarselok,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalMarchOfSacrifices]	= {id=2162,		q=6188,		p=PledgeId.MarchOfSacrifices,   hm=false,   tt=false,   nd=false},
    [ActivityId.NormalMoonHunterKeep]		= {id=2152,		q=6186,		p=PledgeId.MoonHunterKeep,      hm=false,   tt=false,   nd=false},
    [ActivityId.NormalMoongraveFane]		= {id=2415,		q=6349,		p=PledgeId.MoongraveFane,       hm=false,   tt=false,   nd=false},
    [ActivityId.NormalRuinsOfMazzatun]		= {id=1504,		q=5403,		p=PledgeId.RuinsOfMazzatun,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalScalecallerPeak]		= {id=1975,		q=6065,		p=PledgeId.ScalecallerPeak,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalStoneGarden]			= {id=2694,		q=6505,		p=PledgeId.StoneGarden,         hm=false,   tt=false,   nd=false},
    [ActivityId.NormalUnhallowedGrave]		= {id=2549,		q=6416,		p=PledgeId.UnhallowedGrave,     hm=false,   tt=false,   nd=false},
    [ActivityId.NormalWhiteGoldTower] 		= {id=1346,		q=5342,		p=PledgeId.WhiteGoldTower,      hm=false,   tt=false,   nd=false},
    --Veteran
    [ActivityId.VeteranFungalGrottoI]		= {id=1556,		q=3993, 	p=PledgeId.FungalGrottoI, 		hm=1561,	tt=1559,	nd=1560},	--Fungal Grotto I
    [ActivityId.VeteranFungalGrottoII]		= {id=343,		q=4303, 	p=PledgeId.FungalGrottoII, 		hm=342,		tt=340,		nd=1563},	--Fungal Grotto II
    [ActivityId.VeteranSpindleclutchI]		= {id=1565,		q=4054, 	p=PledgeId.SpindleclutchI, 		hm=1570,	tt=1568,	nd=1569},	--Spindleclutch I
    [ActivityId.VeteranSpindleclutchII]		= {id=421,		q=4555, 	p=PledgeId.SpindleclutchII,		hm=448,		tt=446,		nd=1572},	--Spindleclutch II
    [ActivityId.VeteranBanishedCellsI]		= {id=1549,		q=4107,		p=PledgeId.BanishedCellsI, 		hm=1554,	tt=1552,	nd=1553},	--Banished Cells I
    [ActivityId.VeteranBanishedCellsII]		= {id=545,		q=4597,		p=PledgeId.BanishedCellsII,		hm=451,		tt=449,		nd=1564},	--Banished Cells II
    [ActivityId.VeteranDarkshadeCavernsI]	= {id=1581,		q=4145, 	p=PledgeId.DarkshadeCavernsI,	hm=1586,	tt=1584,	nd=1585},	--Darkshade Caverns I
    [ActivityId.VeteranDarkshadeCavernsII]	= {id=464,		q=4641, 	p=PledgeId.DarkshadeCavernsII,	hm=467,		tt=465,		nd=1588},	--Darkshade Caverns II
    [ActivityId.VeteranEldenHollowI]		= {id=1573,		q=4336, 	p=PledgeId.EldenHollowI, 		hm=1578,	tt=1576,	nd=1577},	--Elden Hollow I
    [ActivityId.VeteranEldenHollowII]		= {id=459,		q=4675,		p=PledgeId.EldenHollowII, 		hm=463,		tt=461,		nd=1580},	--Elden Hollow II
    [ActivityId.VeteranWayrestSewersI]		= {id=1589, 	q=4246, 	p=PledgeId.WayrestSewersI, 		hm=1594,	tt=1592,	nd=1593},	--Wayrest Sewers I
    [ActivityId.VeteranWayrestSewersII]		= {id=678,		q=4813, 	p=PledgeId.WayrestSewersII,		hm=681,		tt=679,		nd=1596},	--Wayrest Sewers II
    [ActivityId.VeteranArxCorinium]			= {id=1604,		q=4202, 	p=PledgeId.ArxCorinium, 		hm=1609,	tt=1607,	nd=1608},	--Arx Corinium
    [ActivityId.VeteranCityOfAshI]			= {id=1597,		q=4778, 	p=PledgeId.CityOfAshI,			hm=1602,	tt=1600,	nd=1601},	--City of Ash I
    [ActivityId.VeteranCityOfAshII]			= {id=878,		q=5120, 	p=PledgeId.CityOfAshII, 		hm=1114,	tt=1108,	nd=1107},	--City of Ash II
    [ActivityId.VeteranCryptOfHeartsI]		= {id=1610,		q=4379, 	p=PledgeId.CryptOfHeartsI, 		hm=1615,	tt=1613,	nd=1614},	--Crypt of Hearts I
    [ActivityId.VeteranCryptOfHeartsII]		= {id=876,		q=5113, 	p=PledgeId.CryptOfHeartsII,		hm=1084,	tt=941,		nd=942},	--Crypt of Hearts II
    [ActivityId.VeteranDirefrostKeep]		= {id=1623,		q=4346, 	p=PledgeId.DirefrostKeep, 		hm=1628,	tt=1626,	nd=1627},	--Direfrost Keep
    [ActivityId.VeteranTempestIsland]		= {id=1617,		q=4538, 	p=PledgeId.TempestIsland, 		hm=1622,	tt=1620,	nd=1621},	--Tempest Island
    [ActivityId.VeteranVolenfell]			= {id=1629,		q=4432, 	p=PledgeId.Volenfell,			hm=1634,	tt=1632,	nd=1633},	--Volenfell
    [ActivityId.VeteranBlackheartHaven]		= {id=1647,		q=4589, 	p=PledgeId.BlackheartHaven,		hm=1652,	tt=1650,	nd=1651},	--Blackheart Haven
    [ActivityId.VeteranBlessedCrucible]		= {id=1641,		q=4469, 	p=PledgeId.BlessedCrucible,		hm=1646,	tt=1644,	nd=1645},	--Blessed Crucible
    [ActivityId.VeteranSelenesWeb]			= {id=1635,		q=4733, 	p=PledgeId.SelenesWeb,			hm=1640,	tt=1638,	nd=1639},	--Selene's Web
    [ActivityId.VeteranVaultsOfMadness]		= {id=1653,		q=4822, 	p=PledgeId.VaultsOfMadness,		hm=1658,	tt=1656,	nd=1657},	--Vaults of Madness
    [ActivityId.VeteranBloodrootForge]		= {id=1691,		q=5889, 	p=PledgeId.BloodrootForge, 		hm=1696,	tt=1694,	nd=1695},	--Bloodroot Forge
	[ActivityId.VeteranCastleThorn]			= {id=2705,		q=6507,     p=PledgeId.CastleThorn, 		hm=2706,	tt=2707,	nd=2708},	--Castle Thorn
    [ActivityId.VeteranCradleOfShadows]		= {id=1523,		q=5702, 	p=PledgeId.CradleOfShadows,		hm=1524,	tt=1525,	nd=1526},	--Cradle of Shadows
    [ActivityId.VeteranDepthsOfMalatar]		= {id=2271,		q=6251, 	p=PledgeId.DepthsOfMalatar,		hm=2272,	tt=2273,	nd=2274},	--Depths of Malatar
    [ActivityId.VeteranFalkreathHold]		= {id=1699,		q=5891, 	p=PledgeId.FalkreathHold, 		hm=1704,	tt=1702,	nd=1703},	--Falkreath Hold
    [ActivityId.VeteranFangLair]			= {id=1960,		q=6064, 	p=PledgeId.FangLair,			hm=1965,	tt=1963,	nd=1964},	--Fang Lair
    [ActivityId.VeteranFrostvault]			= {id=2261,		q=6249, 	p=PledgeId.Frostvault,			hm=2262,	tt=2263,	nd=2264},	--Frostvault
    [ActivityId.VeteranIcereach]			= {id=2540,		q=6414, 	p=PledgeId.Icereach, 			hm=2541,	tt=2542,	nd=2543},	--Icereach
    [ActivityId.VeteranImperialCityPrison]	= {id=880,		q=5136, 	p=PledgeId.ImperialCityPrison,	hm=1303,	tt=1128,	nd=1129},	--Imperial City Prison
    [ActivityId.VeteranLairOfMaarselok]		= {id=2426,		q=6351, 	p=PledgeId.LairOfMaarselok,		hm=2427,	tt=2428,	nd=2429},	--Lair of Maarselok
    [ActivityId.VeteranMarchOfSacrifices]	= {id=2163,		q=6188, 	p=PledgeId.MarchOfSacrifices,	hm=2164,	tt=2165,	nd=2166},	--March of Sacrifices
    [ActivityId.VeteranMoonHunterKeep]		= {id=2153,		q=6186, 	p=PledgeId.MoonHunterKeep, 		hm=2154,	tt=2155,	nd=2156},	--Moon Hunter Keep
    [ActivityId.VeteranMoongraveFane]		= {id=2416,		q=6349, 	p=PledgeId.MoongraveFane, 		hm=2417,	tt=2418,	nd=2419},	--Moongrave Fane
    [ActivityId.VeteranRuinsOfMazzatun]		= {id=1505,		q=5403, 	p=PledgeId.RuinsOfMazzatun,		hm=1506,	tt=1507,	nd=1508},	--Ruins of Mazzatun
    [ActivityId.VeteranScalecallerPeak]		= {id=1976,		q=6065, 	p=PledgeId.ScalecallerPeak,		hm=1981,	tt=1979,	nd=1980},	--Scalecaller Peak
	[ActivityId.VeteranStoneGarden]			= {id=2695,		q=6505,     p=PledgeId.StoneGarden, 		hm=2755,	tt=2697,	nd=2698},	--Stone Garden
    [ActivityId.VeteranUnhallowedGrave]		= {id=2550,		q=6416, 	p=PledgeId.UnhallowedGrave,		hm=2551,	tt=2552,	nd=2553},	--Unhallowed Grave
    [ActivityId.VeteranWhiteGoldTower]		= {id=1120,		q=5342, 	p=PledgeId.WhiteGoldTower, 		hm=1279,	tt=1275,	nd=1276},	--White-Gold Tower
}