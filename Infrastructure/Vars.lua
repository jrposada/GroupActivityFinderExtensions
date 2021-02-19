GAFE_LFG_ACTIVITY_TRIAL = LFG_ACTIVITY_ITERATION_END + 1
GAFE_LFG_ACTIVITY_MASTER_TRIAL = LFG_ACTIVITY_ITERATION_END + 2

GroupActivityFinderExtensions = {
    name = "GroupActivityFinderExtensions",
    version = 3.0,
    varsVersion = 4,
    Localization = {},
    Loc	= function(var) return GroupActivityFinderExtensions.Localization[var] or var end,
    DefaultVars = {
        textureSize = 25,
        autoConfirm = {
            enabled = true,
            value = false
        },
        trials = {
            chests = {}
        }
    }
}

local GAFE = GroupActivityFinderExtensions

GAFE.Vars = {}

local function migration2()
    -- Default saved vars for migration version target
    local newVersion = 2
    local newDefault = {
        autoConfirm = {
            enabled = true,
            value = false
        }
    }

    ZO_SavedVars:NewAccountWide(GAFE.name.."_Vars", newVersion, nil, newDefault, GetWorldName())
    local savedVars = GroupActivityFinderExtensions_Vars

    -- Set up locals
    local oldSavedVars = savedVars["Default"][GetDisplayName()]["$AccountWide"]
    local newSavedVars = savedVars[GetWorldName()][GetDisplayName()]["$AccountWide"]

    -- Migrate values

    local autoConfirm = oldSavedVars.autoConfirm
    newSavedVars.autoConfirm.value = autoConfirm

    -- Clear obsolete data
    savedVars["Default"] = nil
end

local function migration3()
        -- Default saved vars for migration version target
        local newVersion = 3
        local newDefault = {
            autoConfirm = {
                enabled = true,
                value = false
            },
            trials = {
                chests = {}
            }
        }
end

local function migration4()
    -- Default saved vars for migration version target
    local newVersion = 3
    local newDefault = {
        textureSize = 20,
        autoConfirm = {
            enabled = true,
            value = false
        },
        trials = {
            chests = {}
        }
    }
end

local migrations = {
    [2] = migration2,
    [3] = migration3,
    [4] = migration4,
}

function GAFE.Vars.Migrate()
    local function GetSavedVarsVersion(savedVars)
        if savedVars["Default"] and
           savedVars["Default"][GetDisplayName()] and
           savedVars["Default"][GetDisplayName()]["$AccountWide"] and
           savedVars["Default"][GetDisplayName()]["$AccountWide"]["version"] == 1 then
            return savedVars["Default"][GetDisplayName()]["$AccountWide"]["version"]
        end

        return GAFE.varsVersion
    end

    -- Get old version
    local oldSavedVars = GroupActivityFinderExtensions_Vars
    local oldVersion = GetSavedVarsVersion(oldSavedVars)

    -- Apply all migrations
    for version = oldVersion + 1, GAFE.varsVersion do
        migrations[version]()
    end
 end