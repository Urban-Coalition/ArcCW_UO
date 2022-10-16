SWEP.Base = "arccw_base_nade"

SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Urban Coalition" -- edit this if you like
SWEP.UC_CategoryPack = "6Urban Ordnance"
SWEP.AdminOnly = false

SWEP.PrintName = "Pipe Bomb"
SWEP.TrueName = "Pipe Bomb"
SWEP.Trivia_Class = "Improvised Explosive Device"
SWEP.Trivia_Desc = [[Crude explosive fashioned by hand out of a pipe segment, two end caps, a firework, and a homemade explosive concoction. Usually produced and used by criminals or demonstrators without access to military-grade explosives in a similar vein to Molotov cocktails.

Very strong and heavy, but has a highly randomized fuse time. As unsafe for the user as for the target.]]
SWEP.Trivia_Calibre = "Ammonium Nitrate/Fuel Oil"
SWEP.Trivia_Mechanism = "Black Match"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = nil -- "War without fire is like sausages without mustard." -Jean Juvénal des Ursins

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
end

SWEP.Slot = 4
SWEP.CamAttachment = 1

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_uo_rgd.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_uo_rgd.mdl"
SWEP.ViewModelFOV = 65

SWEP.Throwing = true
SWEP.Singleton = false -- for grenades, means that weapons ARE ammo; hold one, use one.

SWEP.ShootEntity = "arccw_uo_nade_pipebomb" -- See the entity's code for damage info

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "fcg.grenade",
    },
}

SWEP.MuzzleVelocity = 1000
SWEP.MuzzleVelocityAlt = 200 -- Throwing with alt-fire will use this velocity if exists

SWEP.PullPinTime = .8
SWEP.FuseTime = 5
SWEP.CookPrimFire = true
SWEP.CookAltFire = true

SWEP.ChamberSize = 0

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "slam"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "grenade"

SWEP.CanBash = false

SWEP.HolsterPos = Vector(0.532, -1, 0)
SWEP.HolsterAng = Angle(-10, 0, 0)

SWEP.IronSightStruct = false

SWEP.MeleeSwingSound = "weapons/arccw/m249/m249_draw.wav"
SWEP.MeleeHitSound = "weapons/arccw/knife/knife_hitwall1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.ShootWhileSprint = true

SWEP.SpeedMult = 1


local path = "arccw_uo/common/"
local common = "arccw_uc/common/"
local rottle = {common .. "cloth_1.ogg", common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "ready",
    },
    ["pre_throw"] = {
        Source = "throw_start",
        -- Time = .75,
        MinProgress = .8,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
        }
    },
    ["pre_throw_cook"] = {
        Source = "throw2_start",
        -- Time = .85,
        MinProgress = .95,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
            {s = path .. "spooneject.wav", t = 0.8},
        }
    },
    ["pre_throw_hold"] = {
        Source = "throw_idle",
        -- Time = 70 / 30,
    },
    ["pre_throw_hold_cook"] = {
        Source = "throw2_idle",
        Time = 2.6,
    },
    ["throw"] = {
        Source = "throw_end",
        -- Time = .5,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15}, -- temporary
            {s = path .. "spooneject.wav", t = 0.2}, -- temporary
        }
    },
    ["throw_cook"] = {
        Source = "throw_end",
        -- Time = .5,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15} -- temporary
        }
    },
}

SWEP.Hook_TranslateAnimation = function(wep,anim)
    if (anim == "pre_throw" or anim == "pre_throw_hold" or anim == "throw") and wep:GetCurrentFiremode() == wep.Firemodes[2] then
        return anim .. "_cook"
    end
end


SWEP.Attachments = {
    {
        PrintName = "Filling",
        DefaultAttName = "Ammonium Nitrate/Fuel Oil",
        Slot = {"uo_pipebomb_filling"},
    },
}