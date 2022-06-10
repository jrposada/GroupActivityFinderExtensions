local GAFE = GroupActivityFinderExtensions




ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL, "Обычный режим")
ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Ветеранский режим")

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
    Settings_ResetPremiumRewards = "Сбросить таймеры премиальных наград",
    Settings_ResetReward = "Это сбросит 20-часовой таймер.",
    CheckActivePledges = "активные дейлики",
    CheckMissingQuests = "квесты",
    CheckMissingSets = "Sets", -- TODO: translate
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
    TrialDreadsailReef = "Dreadsail Reef", -- TODO: translate
    LookForGroup = "Ищу группу (LFG)",
    LookForMore = "Ищу игроков (LFM)",
    LookForGroupDisabled = "Вы уже в группе",
    LookForMoreDisabled = "Вы должны быть лидером группы",
    AutoInvite = "Автоприглашение",
    Debug_QueuedList = "Queued: ",
    Debug_NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Группа",
    CollapseMode_Normal = "Обычный",
    CollapseMode_Veteran = "Ветеранский",
    NextReward = "Далее через",
    InXDays = "<<1[Сегодня/Через $d день/через $d дня]>>",
    ActivitySchedule = "Календарь",
    DailiesSchedule = "Dailies", -- TODO: translate
    PledgesSchedule = "Pledges" -- TODO: translate
}

-- This translations have to match pledge quest name in ingame journal
GAFE_DUNGEON_PLEDGE_QUEST_NAME = {
    [GAFE_PLEDGE_ID.FungalGrottoI] = "Грибной грот I",
    [GAFE_PLEDGE_ID.FungalGrottoII] = "Грибной грот II",
    [GAFE_PLEDGE_ID.SpindleclutchI] = "Логово Мертвой Хватки I",
    [GAFE_PLEDGE_ID.SpindleclutchII] = "Логово Мертвой Хватки II",
    [GAFE_PLEDGE_ID.BanishedCellsI] = "Темницы изгнанников I",
    [GAFE_PLEDGE_ID.BanishedCellsII] = "Темницы изгнанников II",
    [GAFE_PLEDGE_ID.DarkshadeCavernsI] = "Пещеры Глубокой Тени I",
    [GAFE_PLEDGE_ID.DarkshadeCavernsII] = "Пещеры Глубокой Тени II",
    [GAFE_PLEDGE_ID.EldenHollowI] = "Элденская расщелина I",
    [GAFE_PLEDGE_ID.EldenHollowII] = "Элденская расщелина II",
    [GAFE_PLEDGE_ID.WayrestSewersI] = "Канализация Вэйреста I",
    [GAFE_PLEDGE_ID.WayrestSewersII] = "Канализация Вэйреста II",
    [GAFE_PLEDGE_ID.ArxCorinium] = "Аркс-Кориниум",
    [GAFE_PLEDGE_ID.CityOfAshI] = "Город Пепла I",
    [GAFE_PLEDGE_ID.CityOfAshII] = "Город Пепла II",
    [GAFE_PLEDGE_ID.CryptOfHeartsI] = "Крипта Сердец I",
    [GAFE_PLEDGE_ID.CryptOfHeartsII] = "Крипта Сердец II",
    [GAFE_PLEDGE_ID.DirefrostKeep] = "Крепость Лютых Морозов",
    [GAFE_PLEDGE_ID.TempestIsland] = "Остров Бурь",
    [GAFE_PLEDGE_ID.Volenfell] = "Воленфелл",
    [GAFE_PLEDGE_ID.BlackheartHaven] = "Гавань Черного Сердца",
    [GAFE_PLEDGE_ID.BlessedCrucible] = "Священное Горнило",
    [GAFE_PLEDGE_ID.SelenesWeb] = "Паутина Селены",
    [GAFE_PLEDGE_ID.VaultsOfMadness] = "Своды Безумия",
    [GAFE_PLEDGE_ID.BlackDrakeVilla] = "Вилла Черного Змея",
    [GAFE_PLEDGE_ID.BloodrootForge] = "Кузница Кровавого корня",
    [GAFE_PLEDGE_ID.CastleThorn] = "Замок Шипов",
    [GAFE_PLEDGE_ID.CoralAerie] = "Коралловое Гнездо", -- TODO: Review
    [GAFE_PLEDGE_ID.CradleOfShadows] = "Колыбель Теней",
    [GAFE_PLEDGE_ID.DepthsOfMalatar] = "Глубины Малатара",
    [GAFE_PLEDGE_ID.FalkreathHold] = "Владение Фолкрит",
    [GAFE_PLEDGE_ID.FangLair] = "Логово Клыка",
    [GAFE_PLEDGE_ID.Frostvault] = "Морозное хранилище",
    [GAFE_PLEDGE_ID.Icereach] = "Ледяной Предел",
    [GAFE_PLEDGE_ID.ImperialCityPrison] = "Тюрьма Имперского города",
    [GAFE_PLEDGE_ID.LairOfMaarselok] = "Логово Марселока",
    [GAFE_PLEDGE_ID.MarchOfSacrifices] = "Путь Жертвоприношений",
    [GAFE_PLEDGE_ID.MoonHunterKeep] = "Крепость Лунного Охотника",
    [GAFE_PLEDGE_ID.MoongraveFane] = "Храм Погребенных Лун",
    [GAFE_PLEDGE_ID.RedPetalBastion] = "Оплот алый лепесток",
    [GAFE_PLEDGE_ID.RuinsOfMazzatun] = "Руины Маззатуна",
    [GAFE_PLEDGE_ID.ScalecallerPeak] = "Пик Воспевательницы Дракона",
    [GAFE_PLEDGE_ID.ShipwrightsRegret] = "Горе Корабела", -- TODO: Review
    [GAFE_PLEDGE_ID.StoneGarden] = "Каменный Сад",
    [GAFE_PLEDGE_ID.Cauldron] = "Котел",
    [GAFE_PLEDGE_ID.DreadCellar] = "Ужасный Подвал",
    [GAFE_PLEDGE_ID.UnhallowedGrave] = "Нечестивая Могила",
    [GAFE_PLEDGE_ID.WhiteGoldTower] = "Башня Белого Золота"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Мадж аль-Рагат"] = true,
    ["Глирион Рыжебородый"] = true,
    ["Ургарлаг Бич Вождей"] = true,
}
