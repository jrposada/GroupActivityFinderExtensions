local GAFE = GroupActivityFinderExtensions

GAFE.DungeonFinder = {}

local DailyPledgesList = {
	[1]={	--Maj
		{en="Elden Hollow II",		ru="Элденская расщелина II",	de="Eldengrund II",	fr="Creuset des aînés II"},
		{en="Wayrest Sewers I",		ru="Канализация Вэйреста I",	de="Kanalisation I",	fr="Égouts d'Haltevoie I"},
		{en="Spindleclutch II",		ru="Логово Мертвой Хватки II",	de="Spindeltiefen II",	fr="Tressefuseau II"},
		{en="Banished Cells I",		ru="Темницы изгнанников I",	de="Verbannungszellen I",	fr="Cachot interdit I"},
		{en="Fungal Grotto II",		ru="Грибной грот II",		de="Pilzgrotte II",	fr="Champignonnière II"},
		{en="Spindleclutch I",		ru="Логово Мертвой Хватки I",	de="Spindeltiefen I",	fr="Tressefuseau I"},
		{en="Darkshade Caverns II",	ru="Пещеры Глубокой Тени II",	de="Kavernen II",		fr="Cavernes d'Ombre-noire II"},
		{en="Elden Hollow I",		ru="Элденская расщелина I",	de="Eldengrund I",	fr="Creuset des aînés I"},
		{en="Wayrest Sewers II",	ru="Канализация Вэйреста II",	de="Kanalisation II",	fr="Égouts d'Haltevoie II"},
		{en="Fungal Grotto I",		ru="Грибной грот I",		de="Pilzgrotte I",	fr="Champignonnière I"},
		{en="Banished Cells II",	ru="Темницы изгнанников II",	de="Verbannungszellen II",	fr="Cachot interdit II"},
		{en="Darkshade Caverns I",	ru="Пещеры Глубокой Тени I",	de="Kavernen I",		fr="Cavernes d'Ombre-noire I"},
		shift=0
	},
	[2]={	--Glirion
		{en="Volenfell",			ru="Воленфелл"},
		{en="Blessed Crucible I",	ru="Священное Горнило",		de="Gesegnete Feuerprobe",	fr="Creuset béni"},
		{en="Direfrost Keep I",		ru="Крепость Лютых Морозов",	de="Burg Grauenfrost",		fr="Donjon d'Affregivre"},
		{en="Vaults of Madness",	ru="Своды Безумия",		de="Kammern des Wahnsinns",	fr="Chambres de la folie"},
		{en="Crypt of Hearts II",	ru="Крипта Сердец II",		de="Krypta der Herzen II",	fr="Crypte des cœurs II"},
		{en="City of Ash I",		ru="Город Пепла I",		de="Stadt der Asche I",		fr="Cité des cendres I"},
		{en="Tempest Island",		ru="Остров Бурь",			de="Orkaninsel",			fr="Île des Tempêtes"},
		{en="Blackheart Haven",		ru="Гавань Черного Сердца",	de="Schwarzherz-Unterschlupf",fr="Havre de Cœurnoir"},
		{en="Arx Corinium",		ru="Аркс-Кориниум"},
		{en="Selene's Web",		ru="Паутина Селены",		de="Selenes Netz"},
		{en="City of Ash II",		ru="Город Пепла II",		de="Stadt der Asche II",	fr="Cité des cendres II"},
		{en="Crypt of Hearts I",	ru="Крипта Сердец I",		de="Krypta der Herzen I",	fr="Crypte des cœurs I"},
		shift=0
	},
	[3]={	--Urgarlag
		{en="Lair of Maarselok",	ru="Логово Марселока",		de="Der Hort von Maarselok",	fr="Repaire de Maarselok"},
		{en="Icereach",			ru="Ледяной Предел",		de="Eiskap",			fr="Crève-Nève"},
		{en="Unhallowed Grave",		ru="Нечестивая Могила",		de="Unheiliges Grab",		fr="Sépulcre profane"},
		{en="Stone Garden",		ru="Каменный Сад",		de="Steingarten",			fr="Jardin de pierre"},
		{en="Castle Thorn",		ru="Замок Шипов",			de="Kastell Dorn",		fr="Bastion-les-Ronce"},
		{en="Imperial City Prison",	ru="Тюрьма Имперского города",de="Gefängnis der Kaiserstadt",	fr="Tour d'Or Blanc"},
		{en="Ruins of Mazzatun",	ru="Руины Маззатуна",		de="Ruinen von Mazzatun",	fr="Ruines de Mazzatun"},
		{en="White-Gold Tower",		ru="Башня Белого Золота",	de="Weißgoldturm",		fr="Tour d'Or Blanc"},
		{en="Cradle of Shadows",	ru="Колыбель Теней",		de="Wiege der Schatten",	fr="Berceau des ombres"},
		{en="Bloodroot Forge",		ru="Кузница Кровавого корня",	de="Blutquellschmiede",		fr="Forge de Sangracine"},
		{en="Falkreath Hold",		ru="Владение Фолкрит",		de="Falkenring",			fr="Forteresse d'Épervine"},
		{en="Fang Lair",			ru="Логово Клыка",		de="Krallenhort",			fr="Repaire du croc"},
		{en="Scalecaller Peak",		ru="Пик Воспевательницы Дракона",de="Gipfel der Schuppenruferin",	fr="Pic de la Mandécailles"},
		{en="Moon Hunter Keep",		ru="Крепость Лунного Охотника",de="Mondjägerfeste",		fr="Fort du Chasseur lunaire"},
		{en="March of Sacrifices",	ru="Путь Жертвоприношений",	de="Marsch der Aufopferung",	fr="Procession des Sacrifiés"},
		{en="Depths of Malatar",	ru="Глубины Малатара",		de="Tiefen von Malatar",	fr="Profondeurs de Malatar"},
		{en="Frostvault",			ru="Морозное хранилище",	de="Frostgewölbe",		fr="Arquegivre"},
		{en="Moongrave Fane",		ru="Храм Погребенных Лун",	de="Mondgrab-Tempelstadt",	fr="le reliquaire des Lunes funèbres"},
		shift=0
	},
}

local DungeonIndex={
    --Normal
    [2]		={id=294, 	q=3993 },	--Fungal Grotto I
    [18]	={id=1562,	q=4303 },	--Fungal Grotto II
    [3]		={id=301, 	q=4054 },	--Spindleclutch I
    [316]	={id=1571, 	q=4555 },	--Spindleclutch II
    [4]		={id=325, 	q=4107 },	--Banished Cells I
    [300]	={id=1555, 	q=4597 },	--Banished Cells II
    [5]		={id=78, 	q=4145 },	--Darkshade Caverns I
    [308]	={id=1587, 	q=4641 },	--Darkshade Caverns II
    [7]		={id=11, 	q=4336 },	--Elden Hollow I
    [303]	={id=1579, 	q=4675 },	--Elden Hollow II
    [6]		={id=79, 	q=4246 },	--Wayrest Sewers I
    [22]	={id=1595, 	q=4813 },	--Wayrest Sewers II
    [8]		={id=272, 	q=4202 },	--Arx Corinium
    [10]	={id=551, 	q=4778 },	--City of Ash I
    [322]	={id=1603, 	q=5120 },	--City of Ash II
    [9]		={id=80, 	q=4379 },	--Crypt of Hearts I
    [317]	={id=1616, 	q=5113 },	--Crypt of Hearts II
    [11]	={id=357, 	q=4346 },	--Direfrost Keep
    [13]	={id=81, 	q=4538 },	--Tempest Island
    [12]	={id=391, 	q=4432 },	--Volenfell
    [15]	={id=410, 	q=4589 },	--Blackheart Haven
    [14]	={id=393, 	q=4469 },	--Blessed Crucible
    [16]	={id=417, 	q=4733 },	--Selene's Web
    [17]	={id=570, 	q=4822 },	--Vaults of Madness
    [324]	={id=1690, 	q=5889 },	--Bloodroot Forge
    [509]   ={id=2704},	--Castle Thorn
    [295]	={id=1522, 	q=5702 },	--Cradle of Shadows
    [435]	={id=2270, 	q=6251 },	--Depths of Malatar
    [368]	={id=1698, 	q=5891 },	--Falkreath Hold
    [420]	={id=1959, 	q=6064 },	--Fang Lair
    [433]	={id=2260, 	q=6249 },	--Frostvault
    [503]	={id=2539, 	q=6414 },	--Icereach
    [289]	={id=1345, 	q=5136 },	--Imperial City Prison
    [496]	={id=2425, 	q=6351 },	--Lair of Maarselok
    [428]	={id=2162, 	q=6188 },	--March of Sacrifices
    [426]	={id=2152, 	q=6186 },	--Moon Hunter Keep
    [494]	={id=2415, 	q=6349 },	--Moongrave Fane
    [293]	={id=1504, 	q=5403 },	--Ruins of Mazzatun
    [418]	={id=1975, 	q=6065 },	--Scalecaller Peak
    [507]	={id=2694},	--Stone Garden
    [505]	={id=2549,	q=6416 },	--Unhallowed Grave
    [288] 	={id=1346,	q=5342 },	--White-Gold Tower
    --Veteran
    [299]	={id=1556,	q=3993, 	hm=1561,	tt=1559,	nd=1560},	--Fungal Grotto I
    [312]	={id=343,	q=4303, 	hm=342,		tt=340,		nd=1563},	--Fungal Grotto II
    [315]	={id=1565,	q=4054, 	hm=1570,	tt=1568,	nd=1569},	--Spindleclutch I
    [19]	={id=421,	q=4555, 	hm=448,		tt=446,		nd=1572},	--Spindleclutch II
    [20]	={id=1549,	q=4107,		hm=1554,	tt=1552,	nd=1553},	--Banished Cells I
    [301]	={id=545,	q=4597,		hm=451,		tt=449,		nd=1564},	--Banished Cells II
    [309]	={id=1581,	q=4145, 	hm=1586,	tt=1584,	nd=1585},	--Darkshade Caverns I
    [21]	={id=464,	q=4641, 	hm=467,		tt=465,		nd=1588},	--Darkshade Caverns II
    [23]	={id=1573,	q=4336, 	hm=1578,	tt=1576,	nd=1577},	--Elden Hollow I
    [302]	={id=459,	q=4675,		hm=463,		tt=461,		nd=1580},	--Elden Hollow II
    [306]	={id=1589, 	q=4246, 	hm=1594,	tt=1592,	nd=1593},	--Wayrest Sewers I
    [307]	={id=678,	q=4813, 	hm=681,		tt=679,		nd=1596},	--Wayrest Sewers II
    [305]	={id=1604,	q=4202, 	hm=1609,	tt=1607,	nd=1608},	--Arx Corinium
    [310]	={id=1597,	q=4778, 	hm=1602,	tt=1600,	nd=1601},	--City of Ash I
    [267]	={id=878,	q=5120, 	hm=1114,	tt=1108,	nd=1107},	--City of Ash II
    [261]	={id=1610,	q=4379, 	hm=1615,	tt=1613,	nd=1614},	--Crypt of Hearts I
    [318]	={id=876,	q=5113, 	hm=1084,	tt=941,		nd=942},	--Crypt of Hearts II
    [319]	={id=1623,	q=4346, 	hm=1628,	tt=1626,	nd=1627},	--Direfrost Keep
    [311]	={id=1617,	q=4538, 	hm=1622,	tt=1620,	nd=1621},	--Tempest Island
    [304]	={id=1629,	q=4432, 	hm=1634,	tt=1632,	nd=1633},	--Volenfell
    [321]	={id=1647,	q=4589, 	hm=1652,	tt=1650,	nd=1651},	--Blackheart Haven
    [320]	={id=1641,	q=4469, 	hm=1646,	tt=1644,	nd=1645},	--Blessed Crucible
    [313]	={id=1635,	q=4733, 	hm=1640,	tt=1638,	nd=1639},	--Selene's Web
    [314]	={id=1653,	q=4822, 	hm=1658,	tt=1656,	nd=1657},	--Vaults of Madness
    [325]	={id=1691,	q=5889, 	hm=1696,	tt=1694,	nd=1695},	--Bloodroot Forge
	[510]	={id=2705,	hm=2706,	tt=2707,	nd=2708},	--Castle Thorn
    [296]	={id=1523,	q=5702, 	hm=1524,	tt=1525,	nd=1526},	--Cradle of Shadows
    [436]	={id=2271,	q=6251, 	hm=2272,	tt=2273,	nd=2274},	--Depths of Malatar
    [369]	={id=1699,	q=5891, 	hm=1704,	tt=1702,	nd=1703},	--Falkreath Hold
    [421]	={id=1960,	q=6064, 	hm=1965,	tt=1963,	nd=1964},	--Fang Lair
    [434]	={id=2261,	q=6249, 	hm=2262,	tt=2263,	nd=2264},	--Frostvault
    [504]	={id=2540,	q=6414, 	hm=2541,	tt=2542,	nd=2543},	--Icereach
    [268]	={id=880,	q=5136, 	hm=1303,	tt=1128,	nd=1129},	--Imperial City Prison
    [497]	={id=2426,	q=6351, 	hm=2427,	tt=2428,	nd=2429},	--Lair of Maarselok
    [429]	={id=2163,	q=6188, 	hm=2164,	tt=2165,	nd=2166},	--March of Sacrifices
    [427]	={id=2153,	q=6186, 	hm=2154,	tt=2155,	nd=2156},	--Moon Hunter Keep
    [495]	={id=2416,	q=6349, 	hm=2417,	tt=2418,	nd=2419},	--Moongrave Fane
    [294]	={id=1505,	q=5403, 	hm=1506,	tt=1507,	nd=1508},	--Ruins of Mazzatun
    [419]	={id=1976,	q=6065, 	hm=1981,	tt=1979,	nd=1980},	--Scalecaller Peak
	[508]	={id=2695,	hm=2755,	tt=2697,	nd=2698},	--Stone Garden
    [506]	={id=2550,	q=6416, 	hm=2551,	tt=2552,	nd=2553},	--Unhallowed Grave
    [287]	={id=1120,	q=5342, 	hm=1279,	tt=1275,	nd=1276},	--White-Gold Tower
}


local function GetGoalPledges()
    local pledgeQuests, havePledge = {}, false
    for i=1, MAX_JOURNAL_QUESTS do
        local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
        if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP and name:match(".*:%s*(.*)") then
            local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):gsub("%s+"," "):lower())
            local number=string.match(text,"%sii$")
            text=string.match(text,"[^%s]+")..(number or "")
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
		-- Mark pledges
		local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3
		for c=2,3 do
			local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local id=obj.node.data.id
						if DungeonIndex[id] then
							local text=""
							-- Get quest name from current control
							local controlQuestName=obj.text:GetText():lower():gsub("the ",""):gsub(" "," ")
							if c==3 then
								local _start,_end=string.find(controlQuestName,"s|t")
								if _start then controlQuestName=string.sub(controlQuestName,_end+2) end
							end
                            local number=string.match(controlQuestName,"%sii$")
							controlQuestName=string.match(controlQuestName,"[^%s]+")..(number or "")

							-- Dialy pledges
							for npc=1,3 do
								local dpList=DailyPledgesList[npc]
								local n=1+(day+dpList.shift)%#dpList
								local dpName=dpList[n].en
								if dpName then
									dpName=dpName:lower()
                                    number=string.match(dpName,"%sii$")
									dpName=string.match(dpName,"[^%s]+")..(number or "")
									if controlQuestName==dpName then
										local questCompleted=pledgeQuests[controlQuestName]
										-- Save if it needs to be checked
										obj.pledge=questCompleted==false
										if questCompleted==true then
											-- In Journal and completed
											text="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_up.dds|t"
										elseif questCompleted==false then
											-- In Journal and no completed
											text="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_down.dds|t" -- Ok
										else
											-- TODO: Differentiate between done and no in journal and not done and not in journal
											-- No in journal quest
											text="|t20:20:/esoui/art/lfg/lfg_indexicon_dungeon_over.dds|t"
										end
									end
								end
							end
							local pledge = GAFE.UI.Label("PDP_DungeonInfo_Pledge"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, text)

							-- Achievement
							local achivementText=(IsAchievementComplete(DungeonIndex[id].id) and "|t20:20:/esoui/art/cadwell/check.dds|t" or "")
							achivementText=achivementText..((DungeonIndex[id].q and GetCompletedQuestInfo(DungeonIndex[id].q) ~= "" and true or false) and "|t20:20:/esoui/art/icons/achievements_indexicon_quests_up.dds|t" or "")
							achivementText=achivementText..((DungeonIndex[id].hm and IsAchievementComplete(DungeonIndex[id].hm)) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
							achivementText=achivementText..((DungeonIndex[id].tt and IsAchievementComplete(DungeonIndex[id].tt)) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
							achivementText=achivementText..((DungeonIndex[id].nd and IsAchievementComplete(DungeonIndex[id].nd)) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
							local achivements = GAFE.UI.Label("PDP_DungeonInfo_Achivements"..c..i, pledge, {105,20}, {RIGHT,pledge,RIGHT,0,0}, "ZoFontGameLarge", nil, {0,1}, achivementText)

							-- Quest
							obj.quest = GetCompletedQuestInfo(DungeonIndex[id].q) == "" and true or false
							haveQuests = haveQuests or obj.quest
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

			local questsButton=GAFE_QuestsCheck or GAFE.UI.Button("GAFE_QuestsCheck", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("CheckMissingQuests"), CheckQuests, haveQuests)
			local pledgesButton=GAFE_PledgesCheck or GAFE.UI.Button("GAFE_PledgesCheck", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("CheckActivePledges"), CheckPledges, havePledge)

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