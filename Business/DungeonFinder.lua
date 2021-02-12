local GAFE = GroupActivityFinderExtensions
local PledgeQuestName = GAFE.PledgeQuestName
local PledgeId = GAFE.Constants.PledgeId

GAFE.DungeonFinder = {}



local activityId = {
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

	NormalRuinsOfMazzatun		= 293,
	VeteranRuinsOfMazzatun		= 294,

	NormalScalecallerPeak		= 418,
	VeteranScalecallerPeak		= 419,

	NormalStoneGarden			= 507,
	VeteranStoneGarden			= 508,

	NormalUnhallowedGrave		= 505,
	VeteranUnhallowedGrave		= 506,

	NormalWhiteGoldTower		= 288,
	VeteranWhiteGoldTower		= 287
}

-- https://esoitem.uesp.net/viewlog.php
local DungeonData={
    --Normal
    [activityId.NormalFungalGrottoI]		= {id=294, 		q=3993,		p=PledgeId.FungalGrottoI},
    [activityId.NormalFungalGrottoII]		= {id=1562,		q=4303,		p=PledgeId.FungalGrottoII},
    [activityId.NormalSpindleclutchI]		= {id=301, 		q=4054,		p=PledgeId.SpindleclutchI},
    [activityId.NormalSpindleclutchII]		= {id=1571,		q=4555,		p=PledgeId.SpindleclutchII},
    [activityId.NormalBanishedCellsI]		= {id=325, 		q=4107,		p=PledgeId.BanishedCellsI},
    [activityId.NormalBanishedCellsII]		= {id=1555,		q=4597,		p=PledgeId.BanishedCellsII},
    [activityId.NormalDarkshadeCavernsI]	= {id=78, 		q=4145,		p=PledgeId.DarkshadeCavernsI},
    [activityId.NormalDarkshadeCavernsII]	= {id=1587,		q=4641,		p=PledgeId.DarkshadeCavernsII},
    [activityId.NormalEldenHollowI]			= {id=11, 		q=4336,		p=PledgeId.EldenHollowI},
    [activityId.NormalEldenHollowII]		= {id=1579,		q=4675,		p=PledgeId.EldenHollowII},
    [activityId.NormalWayrestSewersI]		= {id=79, 		q=4246,		p=PledgeId.WayrestSewersI},
    [activityId.NormalWayrestSewersII]		= {id=1595,		q=4813,		p=PledgeId.WayrestSewersII},
    [activityId.NormalArxCorinium]			= {id=272, 		q=4202,		p=PledgeId.ArxCorinium},
    [activityId.NormalCityOfAshI]			= {id=551, 		q=4778,		p=PledgeId.CityOfAshI},
    [activityId.NormalCityOfAshII]			= {id=1603,		q=5120,		p=PledgeId.CityOfAshII},
    [activityId.NormalCryptOfHeartsI]		= {id=80, 		q=4379,		p=PledgeId.CryptOfHeartsI},
    [activityId.NormalCryptOfHeartsII]		= {id=1616,		q=5113,		p=PledgeId.CryptOfHeartsII},
    [activityId.NormalDirefrostKeep]		= {id=357, 		q=4346,		p=PledgeId.DirefrostKeep},
    [activityId.NormalTempestIsland]		= {id=81, 		q=4538,		p=PledgeId.TempestIsland},
    [activityId.NormalVolenfell]			= {id=391, 		q=4432,		p=PledgeId.Volenfell},
    [activityId.NormalBlackheartHaven]		= {id=410, 		q=4589,		p=PledgeId.BlackheartHaven},
    [activityId.NormalBlessedCrucible]		= {id=393, 		q=4469,		p=PledgeId.BlessedCrucible},
    [activityId.NormalSelenesWeb]			= {id=417, 		q=4733,		p=PledgeId.SelenesWeb},
    [activityId.NormalVaultsOfMadness]		= {id=570, 		q=4822,		p=PledgeId.VaultsOfMadness},
    [activityId.NormalBloodrootForge]		= {id=1690,		q=5889,		p=PledgeId.BloodrootForge},
    [activityId.NormalCastleThorn]   		= {id=2704,		q=6507,		p=PledgeId.CastleThorn},
    [activityId.NormalCradleOfShadows]		= {id=1522,		q=5702,		p=PledgeId.CradleOfShadows},
    [activityId.NormalDepthsOfMalatar]		= {id=2270,		q=6251,		p=PledgeId.DepthsOfMalatar},
    [activityId.NormalFalkreathHold]		= {id=1698,		q=5891,		p=PledgeId.FalkreathHold},
    [activityId.NormalFangLair]				= {id=1959,		q=6064,		p=PledgeId.FangLair},
    [activityId.NormalFrostvault]			= {id=2260,		q=6249,		p=PledgeId.Frostvault},
    [activityId.NormalIcereach]				= {id=2539,		q=6414,		p=PledgeId.Icereach},
    [activityId.NormalImperialCityPrison]	= {id=1345,		q=5136,		p=PledgeId.ImperialCityPrison},
    [activityId.NormalLairOfMaarselok]		= {id=2425,		q=6351,		p=PledgeId.LairOfMaarselok},
    [activityId.NormalMarchOfSacrifices]	= {id=2162,		q=6188,		p=PledgeId.MarchOfSacrifices},
    [activityId.NormalMoonHunterKeep]		= {id=2152,		q=6186,		p=PledgeId.MoonHunterKeep},
    [activityId.NormalMoongraveFane]		= {id=2415,		q=6349,		p=PledgeId.MoongraveFane},
    [activityId.NormalRuinsOfMazzatun]		= {id=1504,		q=5403,		p=PledgeId.RuinsOfMazzatun},
    [activityId.NormalScalecallerPeak]		= {id=1975,		q=6065,		p=PledgeId.ScalecallerPeak},
    [activityId.NormalStoneGarden]			= {id=2694,		q=6505,		p=PledgeId.StoneGarden},
    [activityId.NormalUnhallowedGrave]		= {id=2549,		q=6416,		p=PledgeId.UnhallowedGrave},
    [activityId.NormalWhiteGoldTower] 		= {id=1346,		q=5342,		p=PledgeId.WhiteGoldTower},
    --Veteran
    [activityId.VeteranFungalGrottoI]		= {id=1556,		q=3993, 	p=PledgeId.FungalGrottoI, 		hm=1561,	tt=1559,	nd=1560},	--Fungal Grotto I
    [activityId.VeteranFungalGrottoII]		= {id=343,		q=4303, 	p=PledgeId.FungalGrottoII, 		hm=342,		tt=340,		nd=1563},	--Fungal Grotto II
    [activityId.VeteranSpindleclutchI]		= {id=1565,		q=4054, 	p=PledgeId.SpindleclutchI, 		hm=1570,	tt=1568,	nd=1569},	--Spindleclutch I
    [activityId.VeteranSpindleclutchII]		= {id=421,		q=4555, 	p=PledgeId.SpindleclutchII,		hm=448,		tt=446,		nd=1572},	--Spindleclutch II
    [activityId.VeteranBanishedCellsI]		= {id=1549,		q=4107,		p=PledgeId.BanishedCellsI, 		hm=1554,	tt=1552,	nd=1553},	--Banished Cells I
    [activityId.VeteranBanishedCellsII]		= {id=545,		q=4597,		p=PledgeId.BanishedCellsII,		hm=451,		tt=449,		nd=1564},	--Banished Cells II
    [activityId.VeteranDarkshadeCavernsI]	= {id=1581,		q=4145, 	p=PledgeId.DarkshadeCavernsI,	hm=1586,	tt=1584,	nd=1585},	--Darkshade Caverns I
    [activityId.VeteranDarkshadeCavernsII]	= {id=464,		q=4641, 	p=PledgeId.DarkshadeCavernsII,	hm=467,		tt=465,		nd=1588},	--Darkshade Caverns II
    [activityId.VeteranEldenHollowI]		= {id=1573,		q=4336, 	p=PledgeId.EldenHollowI, 		hm=1578,	tt=1576,	nd=1577},	--Elden Hollow I
    [activityId.VeteranEldenHollowII]		= {id=459,		q=4675,		p=PledgeId.EldenHollowII, 		hm=463,		tt=461,		nd=1580},	--Elden Hollow II
    [activityId.VeteranWayrestSewersI]		= {id=1589, 	q=4246, 	p=PledgeId.WayrestSewersI, 		hm=1594,	tt=1592,	nd=1593},	--Wayrest Sewers I
    [activityId.VeteranWayrestSewersII]		= {id=678,		q=4813, 	p=PledgeId.WayrestSewersII,		hm=681,		tt=679,		nd=1596},	--Wayrest Sewers II
    [activityId.VeteranArxCorinium]			= {id=1604,		q=4202, 	p=PledgeId.ArxCorinium, 		hm=1609,	tt=1607,	nd=1608},	--Arx Corinium
    [activityId.VeteranCityOfAshI]			= {id=1597,		q=4778, 	p=PledgeId.CityOfAshI,			hm=1602,	tt=1600,	nd=1601},	--City of Ash I
    [activityId.VeteranCityOfAshII]			= {id=878,		q=5120, 	p=PledgeId.CityOfAshII, 		hm=1114,	tt=1108,	nd=1107},	--City of Ash II
    [activityId.VeteranCryptOfHeartsI]		= {id=1610,		q=4379, 	p=PledgeId.CryptOfHeartsI, 		hm=1615,	tt=1613,	nd=1614},	--Crypt of Hearts I
    [activityId.VeteranCryptOfHeartsII]		= {id=876,		q=5113, 	p=PledgeId.CryptOfHeartsII,		hm=1084,	tt=941,		nd=942},	--Crypt of Hearts II
    [activityId.VeteranDirefrostKeep]		= {id=1623,		q=4346, 	p=PledgeId.DirefrostKeep, 		hm=1628,	tt=1626,	nd=1627},	--Direfrost Keep
    [activityId.VeteranTempestIsland]		= {id=1617,		q=4538, 	p=PledgeId.TempestIsland, 		hm=1622,	tt=1620,	nd=1621},	--Tempest Island
    [activityId.VeteranVolenfell]			= {id=1629,		q=4432, 	p=PledgeId.Volenfell,			hm=1634,	tt=1632,	nd=1633},	--Volenfell
    [activityId.VeteranBlackheartHaven]		= {id=1647,		q=4589, 	p=PledgeId.BlackheartHaven,		hm=1652,	tt=1650,	nd=1651},	--Blackheart Haven
    [activityId.VeteranBlessedCrucible]		= {id=1641,		q=4469, 	p=PledgeId.BlessedCrucible,		hm=1646,	tt=1644,	nd=1645},	--Blessed Crucible
    [activityId.VeteranSelenesWeb]			= {id=1635,		q=4733, 	p=PledgeId.SelenesWeb,			hm=1640,	tt=1638,	nd=1639},	--Selene's Web
    [activityId.VeteranVaultsOfMadness]		= {id=1653,		q=4822, 	p=PledgeId.VaultsOfMadness,		hm=1658,	tt=1656,	nd=1657},	--Vaults of Madness
    [activityId.VeteranBloodrootForge]		= {id=1691,		q=5889, 	p=PledgeId.BloodrootForge, 		hm=1696,	tt=1694,	nd=1695},	--Bloodroot Forge
	[activityId.VeteranCastleThorn]			= {id=2705,		q=6507,     p=PledgeId.CastleThorn, 		hm=2706,	tt=2707,	nd=2708},	--Castle Thorn
    [activityId.VeteranCradleOfShadows]		= {id=1523,		q=5702, 	p=PledgeId.CradleOfShadows,		hm=1524,	tt=1525,	nd=1526},	--Cradle of Shadows
    [activityId.VeteranDepthsOfMalatar]		= {id=2271,		q=6251, 	p=PledgeId.DepthsOfMalatar,		hm=2272,	tt=2273,	nd=2274},	--Depths of Malatar
    [activityId.VeteranFalkreathHold]		= {id=1699,		q=5891, 	p=PledgeId.FalkreathHold, 		hm=1704,	tt=1702,	nd=1703},	--Falkreath Hold
    [activityId.VeteranFangLair]			= {id=1960,		q=6064, 	p=PledgeId.FangLair,			hm=1965,	tt=1963,	nd=1964},	--Fang Lair
    [activityId.VeteranFrostvault]			= {id=2261,		q=6249, 	p=PledgeId.Frostvault,			hm=2262,	tt=2263,	nd=2264},	--Frostvault
    [activityId.VeteranIcereach]			= {id=2540,		q=6414, 	p=PledgeId.Icereach, 			hm=2541,	tt=2542,	nd=2543},	--Icereach
    [activityId.VeteranImperialCityPrison]	= {id=880,		q=5136, 	p=PledgeId.ImperialCityPrison,	hm=1303,	tt=1128,	nd=1129},	--Imperial City Prison
    [activityId.VeteranLairOfMaarselok]		= {id=2426,		q=6351, 	p=PledgeId.LairOfMaarselok,		hm=2427,	tt=2428,	nd=2429},	--Lair of Maarselok
    [activityId.VeteranMarchOfSacrifices]	= {id=2163,		q=6188, 	p=PledgeId.MarchOfSacrifices,	hm=2164,	tt=2165,	nd=2166},	--March of Sacrifices
    [activityId.VeteranMoonHunterKeep]		= {id=2153,		q=6186, 	p=PledgeId.MoonHunterKeep, 		hm=2154,	tt=2155,	nd=2156},	--Moon Hunter Keep
    [activityId.VeteranMoongraveFane]		= {id=2416,		q=6349, 	p=PledgeId.MoongraveFane, 		hm=2417,	tt=2418,	nd=2419},	--Moongrave Fane
    [activityId.VeteranRuinsOfMazzatun]		= {id=1505,		q=5403, 	p=PledgeId.RuinsOfMazzatun,		hm=1506,	tt=1507,	nd=1508},	--Ruins of Mazzatun
    [activityId.VeteranScalecallerPeak]		= {id=1976,		q=6065, 	p=PledgeId.ScalecallerPeak,		hm=1981,	tt=1979,	nd=1980},	--Scalecaller Peak
	[activityId.VeteranStoneGarden]			= {id=2695,		q=6505,     p=PledgeId.StoneGarden, 		hm=2755,	tt=2697,	nd=2698},	--Stone Garden
    [activityId.VeteranUnhallowedGrave]		= {id=2550,		q=6416, 	p=PledgeId.UnhallowedGrave,		hm=2551,	tt=2552,	nd=2553},	--Unhallowed Grave
    [activityId.VeteranWhiteGoldTower]		= {id=1120,		q=5342, 	p=PledgeId.WhiteGoldTower, 		hm=1279,	tt=1275,	nd=1276},	--White-Gold Tower
}

local pledgeList = {
	[1]={	--Maj
		PledgeId.EldenHollowII,
		PledgeId.WayrestSewersI,
		PledgeId.SpindleclutchII,
		PledgeId.BanishedCellsI,
		PledgeId.FungalGrottoII,
		PledgeId.SpindleclutchI,
		PledgeId.DarkshadeCavernsII,
		PledgeId.EldenHollowI,
		PledgeId.WayrestSewersII,
		PledgeId.FungalGrottoI,
		PledgeId.BanishedCellsII,
		PledgeId.DarkshadeCavernsI,
		shift=0
	},
	[2]={	--Glirion
		PledgeId.Volenfell,
		PledgeId.BlessedCrucible,
		PledgeId.DirefrostKeep,
		PledgeId.VaultsOfMadness,
		PledgeId.CryptOfHeartsII,
		PledgeId.CityOfAshI,
		PledgeId.TempestIsland,
		PledgeId.BlackheartHaven,
		PledgeId.ArxCorinium,
		PledgeId.SelenesWeb,
		PledgeId.CityOfAshII,
		PledgeId.CryptOfHeartsI,
		shift=0
	},
	[3]={	--Urgarlag
		PledgeId.LairOfMaarselok,
		PledgeId.Icereach,
		PledgeId.UnhallowedGrave,
		PledgeId.StoneGarden,
		PledgeId.CastleThorn,
		PledgeId.ImperialCityPrison,
		PledgeId.RuinsOfMazzatun,
		PledgeId.WhiteGoldTower,
		PledgeId.CradleOfShadows,
		PledgeId.BloodrootForge,
		PledgeId.FalkreathHold,
		PledgeId.FangLair,
		PledgeId.ScalecallerPeak,
		PledgeId.MoonHunterKeep,
		PledgeId.MarchOfSacrifices,
		PledgeId.DepthsOfMalatar,
		PledgeId.Frostvault,
		PledgeId.MoongraveFane,
		shift=0
	},
}

local function GetGoalPledges()
    local pledgeQuests, havePledge = {}, false
    for i=1, MAX_JOURNAL_QUESTS do
        local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
        if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP then
            local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):lower())
            pledgeQuests[text]=stepType~=QUEST_STEP_TYPE_AND
            if stepType==QUEST_STEP_TYPE_AND then havePledge=true end
		end
    end
    return pledgeQuests, havePledge
end

local function DungeonFinder()
    local pledgeQuests, havePledge, haveQuests={}, false, false
	local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1517464800)/86400)

	local function CheckPledges()
		local c = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 2 or 3 -- Normal => 2, Veteran => 3
		local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj and obj.pledge and obj.check:GetState()==0 then
					obj.check:SetState(BSTATE_PRESSED, true)
					ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
				end
			end
		end
	end

	local function CheckQuests()
		local c = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 2 or 3 -- Normal => 2, Veteran => 3
		local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj and obj.quest and obj.check:GetState()==0 then
					obj.check:SetState(BSTATE_PRESSED, true)
					ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
				end
			end
		end
	end

	local function MarkPledges()
		-- Get player difficulty mode
		local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3

		-- Get today pledges
		local todayPledges = {}
		for npc=1,3 do
			local dpList=pledgeList[npc]
			local n=1+(day+dpList.shift)%#dpList
			todayPledges[npc] = dpList[n]
		end

		for c=2,3 do
			local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local actrivityId=obj.node.data.id
						if DungeonData[actrivityId] then
							local pledgeText=""
							-- Mark dialy pledges
							for npc=1,3 do
								local pledgeId = todayPledges[npc]
								if pledgeId and DungeonData[actrivityId].p==pledgeId then
									local pledgeName = PledgeQuestName[pledgeId]:lower()
									local questCompleted=pledgeQuests[pledgeName]
									-- Save if it needs to be checked
									obj.pledge=questCompleted==false
									if questCompleted==true then
										-- In Journal and completed
										pledgeText="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_up.dds|t"
									elseif questCompleted==false then
										-- In Journal and no completed
										pledgeText="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_down.dds|t" -- Ok
									else
										-- TODO: Differentiate between done and no in journal and not done and not in journal
										-- No in journal quest
										pledgeText="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_over.dds|t"
									end
									break
								end
							end
							local pledgeLabel = GAFE.UI.Label(GAFE.name.."_DungeonInfo_Pledge"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, pledgeText)

							-- Quest (skill point)
							local debug = GetDisplayName() == "@Panicida"
							local achivementText=""
							if DungeonData[actrivityId].q then
								achivementText=achivementText..((GetCompletedQuestInfo(DungeonData[actrivityId].q) ~= "" and true or false) and "|t20:20:/esoui/art/icons/achievements_indexicon_quests_up.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."q"
							end

							-- General Vanquisher (normal) / Conqueror (veteran)
							if DungeonData[actrivityId].id then
								achivementText=achivementText..(IsAchievementComplete(DungeonData[actrivityId].id) and "|t20:20:/esoui/art/announcewindow/announcement_icon_up.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."i"
							end
							
							-- Death challenge (hard mode)
							if DungeonData[actrivityId].hm then
								achivementText=achivementText..(IsAchievementComplete(DungeonData[actrivityId].hm) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."h"
							end

							-- Speed challenge
							if DungeonData[actrivityId].tt then
								achivementText=achivementText..(IsAchievementComplete(DungeonData[actrivityId].tt) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."t"
							end

							-- Survivor challenge (no death)
							if DungeonData[actrivityId].nd then
								achivementText=achivementText..(IsAchievementComplete(DungeonData[actrivityId].nd) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."n"
							end
							local achievementsLabel = GAFE.UI.Label(GAFE.name.."_DungeonInfo_Achievements"..c..i, pledgeLabel, {105,20}, {RIGHT,pledgeLabel,RIGHT,0,0}, "ZoFontGameLarge", nil, {0,1}, achivementText)

							-- Quest -- FIX?
							obj.quest = GetCompletedQuestInfo(DungeonData[actrivityId].q) == "" and true or false
							haveQuests = haveQuests or obj.quest
						else
							local todo = GAFE.UI.Label(GAFE.name.."_DungeonInfo_Pledge"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..actrivityId)
						end
					end
				end
			end

			-- Collapse corresponding panel depending on dungeon mode
			local header=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
			if header then
				local state=header.text:GetColor()
				if ((difficultyMode==c)==(state==1)) then header:OnMouseUp(true) end
			end
		end

		-- Add check pledges buttons
		local parent=ZO_DungeonFinder_Keyboard
		if parent then
			local w=parent:GetWidth()
			local dims = {200,28}

			local questsButton=GAFE.UI.Button("GAFE_QuestsCheck", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("CheckMissingQuests"), CheckQuests, haveQuests)
			local pledgesButton=GAFE.UI.Button("GAFE_PledgesCheck", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("CheckActivePledges"), CheckPledges, havePledge)

			if ZO_DungeonFinder_KeyboardQueueButton then
				ZO_DungeonFinder_KeyboardQueueButton:ClearAnchors()
				ZO_DungeonFinder_KeyboardQueueButton:SetAnchor(BOTTOM,parent,BOTTOM,-w/3,0)
				ZO_DungeonFinder_KeyboardQueueButton:SetDrawTier(2)
			end
		end
	end

    ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyShown', function() pledgeQuests, havePledge=GetGoalPledges() GAFE.CallLater("MarkPledges",200,MarkPledges) end)
	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyHidden', function() pledgeQuests={} end)
end

function GAFE.DungeonFinder.Init()
	DungeonFinder()
end