local GAFE = GroupActivityFinderExtensions
local SM = SCENE_MANAGER
local FG = FRAGMENT_GROUP
local MMK = MAIN_MENU_KEYBOARD

GAFE.Timers = {}

function GAFE.Timers.Init()
    local function CreateFragment()
        GAFE_QUESTS_TIMERS_FRAGMENT = ZO_FadeSceneFragment:New(GAFE_QuestsTimers)
    end

    local function CreateScene()
        -- ingame\scenes\keyboard\keyboardingamescenes.lua

        local questsTimersScene = ZO_Scene:New("questsTimers", SM)
        questsTimersScene:AddFragmentGroup(FG.MOUSE_DRIVEN_UI_WINDOW)
        questsTimersScene:AddFragmentGroup(FG.FRAME_TARGET_STANDARD_RIGHT_PANEL)
        questsTimersScene:AddFragmentGroup(FG.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
        questsTimersScene:AddFragment(ACHIEVEMENTS_FRAGMENT)
        questsTimersScene:AddFragment(FRAME_EMOTE_FRAGMENT_JOURNAL)
        questsTimersScene:AddFragment(RIGHT_BG_FRAGMENT)
        questsTimersScene:AddFragment(TREE_UNDERLAY_FRAGMENT)
        questsTimersScene:AddFragment(TITLE_FRAGMENT)
        questsTimersScene:AddFragment(JOURNAL_TITLE_FRAGMENT)
        questsTimersScene:AddFragment(CODEX_WINDOW_SOUNDS)
    end

    local function AddSceneToJournal()
        -- ingame\mainmenu\keyboard\zo_mainmenu_keyboard.lua    MainMenu_Keyboard:AddSceneGroup

        local sceneGroupName = "journalSceneGroup"
        local sceneName = "questsTimers"
        MMK:AddRawScene(sceneName, MENU_CATEGORY_JOURNAL, MMK.categoryInfo[MENU_CATEGORY_JOURNAL], "journalSceneGroup")
        local sceneGroupBarFragment = ZO_FadeSceneFragment:New(MMK.sceneGroupBar)

        local scene = SCENE_MANAGER:GetScene(sceneName)
        scene:AddFragment(sceneGroupBarFragment)

        local sceneGroupInfo = MMK.sceneGroupInfo[sceneGroupName]
        sceneGroupInfo.menuBarIconData[#sceneGroupInfo.menuBarIconData + 1] = {
            categoryName = SI_JOURNAL_MENU_LEADERBOARDS, -- It will be translated by ZOS GetString()
            descriptor = sceneName,
            normal = "EsoUI/Art/Journal/journal_tabIcon_leaderboard_up.dds",
            pressed = "EsoUI/Art/Journal/journal_tabIcon_leaderboard_down.dds",
            highlight = "EsoUI/Art/Journal/journal_tabIcon_leaderboard_over.dds",
        }
    end

    CreateFragment()
    CreateScene()
    AddSceneToJournal()
end

