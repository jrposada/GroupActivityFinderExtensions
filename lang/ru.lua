local GAFE = GroupActivityFinderExtensions
local PledgeId = GAFE.Constants.PledgeId

-- List header text in activity finder are set by zo with GetString("SI_LFGACTIVITY", activityType).
-- This means we have the same prefix plus our custom activity type id.
-- Since we use LFG_ACTIVITY_ITERATION_END + 1 it should never overwrite and actual zo string.
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL, "Обычный режим")
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Ветеранский режим")

GAFE.Localization = {
    Settings_Description = "Добавляет дополнительные функции и информацию в пользовательский интерфейс Группа и Поиск активностей.",
    Settings_AutoConfirm = "Кнопка автопринятия",
    Settings_AutoConfirmDelay = "задержка автоматического принятия",
    Settings_LoopQueueCompletedNotification = "При активности петли обнаружен звук",
    Settings_TrialsChest = "Сбросить таймер сундука",
    Settings_ResetChestWarning = "Это сбросит таймер на 1 неделю!",
    Settings_AutoMarkPledges = "Автоматическая отметка доступных дейликов",
    Settings_MarkPledgesWithIcon = "Использовать иконку для дейликов",
    Settings_TextureSize = "Размер иконки",
    Settings_AutoInvite = "BETA Автоприглашение",
    Settings_HandleQuest = "Автоматически брать квест дейликов Неустрашимых",
    Settings_CompatibilityTitle = "Совместимость",
    Settings_PerfectPixelAddon = "PerfectPixel",
    CheckActivePledges = "Проверить активные дейлики",
    CheckMissingQuests = "Проверить не выполненные квесты",
    AutoConfirm = "Автопринятие",
    TrialsCategoryHeader = "Испытания",
    TrialsSpecificFilterText = "Конкретные Испытания",
    TrialAetherianArchive = "Этерианский Архив",
    TrialHelRaCitadel = "Цитадель Хел Ра",
    TrialSanctumOphidia = "Святилище Офидии",
    TrialMawOfLorkhaj = "Пасть Лорхаджа",
    TrialHallsOfFabrication = "Залы Фабрикации",
    TrialAsylumSanctorium = "Изоляционный Санктуарий",
    TrialCloudrest = "Клаудрест",
    TrialSunspire = "Солнечный Шпиль",
    TrialKynesAegis = "Эгида Кин",
    TrialRockgrave = "Каменная Роща",
    LookForGroup = "Ищу группу (LFG)",
    LookForMore = "Ищу игроков (LFM)",
    LookForGroupDisabled = "Вы уже в группе",
    LookForMoreDisabled = "Вы должны быть лидером группы",
    AutoInvite = "Автоприглашение",
    QueuedList = "В очереди: ",
    NotQueuedList = "Не в очереди: ",
    CollapseMode_Group = "Группа",
    CollapseMode_Normal = "Обычный",
    CollapseMode_Veteran = "Ветеранский",
}


GAFE.DungeonPledgeQuestName = {
	[PledgeId.FungalGrottoI] = "Грибной грот I",
	[PledgeId.FungalGrottoII] = "Грибной грот II",
	[PledgeId.SpindleclutchI] = "Логово Мертвой Хватки I",
	[PledgeId.SpindleclutchII] = "Логово Мертвой Хватки II",
	[PledgeId.BanishedCellsI] = "Темницы изгнанников I",
	[PledgeId.BanishedCellsII] = "Темницы изгнанников II",
	[PledgeId.DarkshadeCavernsI] = "Пещеры Глубокой Тени I",
	[PledgeId.DarkshadeCavernsII] = "Пещеры Глубокой Тени II",
	[PledgeId.EldenHollowI] = "Элденская расщелина I",
	[PledgeId.EldenHollowII] = "Элденская расщелина II",
	[PledgeId.WayrestSewersI] = "Канализация Вэйреста I",
	[PledgeId.WayrestSewersII] = "Канализация Вэйреста II",
	[PledgeId.ArxCorinium] = "Аркс-Кориниум",
	[PledgeId.CityOfAshI] = "Город Пепла I",
	[PledgeId.CityOfAshII] = "Город Пепла II",
	[PledgeId.CryptOfHeartsI] = "Крипта Сердец I",
	[PledgeId.CryptOfHeartsII] = "Крипта Сердец II",
	[PledgeId.DirefrostKeep] = "Крепость Лютых Морозов",
	[PledgeId.TempestIsland] = "Остров Бурь",
	[PledgeId.Volenfell] = "Воленфелл",
	[PledgeId.BlackheartHaven] = "Гавань Черного Сердца",
	[PledgeId.BlessedCrucible] = "Священное Горнило",
	[PledgeId.SelenesWeb] = "Паутина Селены",
	[PledgeId.VaultsOfMadness] = "Своды Безумия",
	[PledgeId.BlackDrakeVilla] = "Вилла Черного Змея",
	[PledgeId.BloodrootForge] = "Кузница Кровавого корня",
	[PledgeId.CastleThorn] = "Замок Шипов",
	[PledgeId.CradleOfShadows] = "Колыбель Теней",
	[PledgeId.DepthsOfMalatar] = "Глубины Малатара",
	[PledgeId.FalkreathHold] = "Владение Фолкрит",
	[PledgeId.FangLair] = "Логово Клыка",
	[PledgeId.Frostvault] = "Морозное хранилище",
	[PledgeId.Icereach] = "Ледяной Предел",
	[PledgeId.ImperialCityPrison] = "Тюрьма Имперского города",
	[PledgeId.LairOfMaarselok] = "Логово Марселока",
	[PledgeId.MarchOfSacrifices] = "Путь Жертвоприношений",
	[PledgeId.MoonHunterKeep] = "Крепость Лунного Охотника",
	[PledgeId.MoongraveFane] = "Храм Погребенных Лун",
	[PledgeId.RedPetalBastion] = "Red Petal Bastion", --translate
	[PledgeId.RuinsOfMazzatun] = "Руины Маззатуна",
	[PledgeId.ScalecallerPeak] = "Пик Воспевательницы Дракона",
	[PledgeId.StoneGarden] = "Каменный Сад",
	[PledgeId.Cauldron] = "Котел",
	[PledgeId.DreadCellar] = "The Dread Cellar", --translate
	[PledgeId.UnhallowedGrave] = "Нечестивая Могила",
	[PledgeId.WhiteGoldTower] = "Башня Белого Золота"
}

GAFE.PledgeChatterOptions = {
    "Какой обет сегодня?"
}