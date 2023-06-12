local GAFE = GroupActivityFinderExtensions




ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL, "Обычный режим")
ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Ветеранский режим")

GAFE.lang = "ru"
GAFE.Localization = {
    Settings_Description = "Добавляет дополнительные функции и информацию в пользовательский интерфейс Группа и Поиск активностей.",
    Settings_AutoConfirm = "Кнопка автопринятия",
    Settings_AutoConfirmDelay = "задержка автоматического принятия",
    Settings_Difficulty = "Сложность",
    Settings_FavouriteLocation = "Любимое место",
    Settings_LoopQueueCompletedNotification = "При активности петли обнаружен звук",
    Settings_TrialsChest = "Сбросить таймер сундука",
    Settings_ResetChestWarning = "Это сбросит таймер на 1 неделю!",
    Settings_AutoMarkPledges = "Автоматическая отметка доступных дейликов",
    Settings_MarkPledgesWithIcon = "Использовать иконку для дейликов",
    Settings_TextureSize = "Размер иконки",
    Settings_AutoInvite = "BETA Автоприглашение",
    Settings_HandleQuest = "Автоматизировать поддерживаемые квесты",
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
    TrialRockgrove = "Каменная Роща",
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
    PledgesSchedule = "Pledges", -- TODO: translate
    Available = "Доступный"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Мадж аль-Рагат"] = true,
    ["Глирион Рыжебородый"] = true,
    ["Ургарлаг Бич Вождей"] = true,
}

-- TODO: translate
GAFE_DIALY_NPC_NAME = {
    -- Fargrave Dialies
    ["Luna Beriel"] = true,
    ["Vaveli Indavel"] = true,
    --
    ["Justiciar Farowel"] = true
}
