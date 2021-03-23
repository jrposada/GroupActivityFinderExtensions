local GAFE = GroupActivityFinderExtensions

-- List header text in activity finder are set by zo with GetString("SI_LFGACTIVITY", activityType).
-- This means we have the same prefix plus our custom activity type id.
-- Since we use LFG_ACTIVITY_ITERATION_END + 1 it should never overwrite and actual zo string.
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL, "Обычный режим")
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Ветеранский режим")

GAFE.Localization = {
    Settings_Description = "Добавляет дополнительные функции и информацию в пользовательский интерфейс Группа и Поиск активностей.",
    Settings_AutoConfirm = "'Кнопка автопринятия",
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
    LookForGroup = "Ищу группу(LFG)",
    LookForMore = "Все ещё ищу ",
    LookForGroupDisabled = "Вы уже в группе",
    LookForMoreDisabled = "Вы должны быть лидером группы",
    AutoInvite = "Автоприглашение",
}