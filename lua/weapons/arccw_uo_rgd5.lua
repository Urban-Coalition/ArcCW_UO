SWEP.Base = "arccw_base_nade"

SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Urban Coalition" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Light Frag Grenade"
SWEP.TrueName = "RGD-5"
SWEP.Trivia_Class = "Fragmentation Grenade"
SWEP.Trivia_Desc = [[Cheap Cold War era, TNT-based anti-personnel grenade. Saturates its surroundings with shrapnel with a short fuse and a narrow lethal radius.

Can be cooked with the "COOK" firemode, allowing the user to start the fuse early for a reduced time to detonation.]]
SWEP.Trivia_Calibre = "Trinitrotoluene"
SWEP.Trivia_Mechanism = "Pyrotechnic Delay Fuse"
SWEP.Trivia_Country = "Soviet Union"
SWEP.Trivia_Year = 1954

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
end

SWEP.Slot = 4
SWEP.CamAttachment = 1

SWEP.CustomizePos = Vector(0, -5, 0)
SWEP.CustomizeAng = Angle(15, 15, 15)

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_uo_rgd.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_uo_rgd.mdl"
SWEP.ViewModelFOV = 65

SWEP.Throwing = true
SWEP.Singleton = false -- for grenades, means that weapons ARE ammo; hold one, use one.

SWEP.ShootEntity = "arccw_uo_nade_rgd5" -- See the entity's code for damage info

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "fcg.grenade",
        Override_CookPrimFire = false,
        Override_CookAltFire = false,
    },
    {
        Mode = 1,
        PrintName = "fcg.cook",
        Override_CookPrimFire = true,
        Override_CookAltFire = true,
    },
}

SWEP.MuzzleVelocity = 1500
SWEP.MuzzleVelocityAlt = 700 -- Throwing with alt-fire will use this velocity if exists

SWEP.PullPinTime = .8
SWEP.FuseTime = 3.4

SWEP.CookPrimFire = false
SWEP.CookAltFire = false

SWEP.WindupTime = 1.5 -- Time to reach max velocity (does not apply for altfire)
SWEP.WindupMinimum = 0.25 -- Velocity fraction if released without windup

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
        Time = 28/40,
        SoundTable = {
            {s = rottle, t = 0},
        },
    },
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "ready",
        Time = 63/40,
        SoundTable = {
            {s = rottle, t = 0},
        },
    },

    -- Overhand

    ["pre_throw"] = {
        Source = "throw_start",
        Time = 1,
        MinProgress = .8,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
        },
    },
    ["pre_throw_hold"] = {
        Source = "throw_idle",
        -- Time = 70 / 30,
    },
    ["throw"] = {
        Source = "throw_end",
        Time = 1,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15}, -- temporary
            {s = path .. "spooneject.wav", t = 0.2}, -- temporary
        }
    },

    -- Overhand, cooked

    ["pre_throw_cook"] = {
        Source = "throw2_start",
        Time = 1,
        MinProgress = .95,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
            {s = path .. "spooneject.wav", t = 0.8},
        },
    },
    ["pre_throw_hold_cook"] = {
        Source = "throw2_idle",
        Time = 2.6,
    },
    ["throw_cook"] = {
        Source = "throw_end",
        Time = 1,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15} -- temporary
        }
    },

    -- Underhand

    ["pre_throw_alt"] = {
        Source = "lowthrow_start",
        Time = 1,
        MinProgress = .8,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
        }
    },
    ["pre_throw_hold_alt"] = {
        Source = "lowthrow_idle",
    },
    ["throw_alt"] = {
        Source = "lowthrow_end",
        Time = 1,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15}, -- temporary
            {s = path .. "spooneject.wav", t = 0.2}, -- temporary
        },
    },

    -- Underhand, cooked

    ["pre_throw_alt_cook"] = {
        Source = "lowthrow2_start",
        Time = 1,
        MinProgress = .8,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.4},
            {s = path .. "spooneject.wav", t = 0.8},
        },
    },
    ["pre_throw_hold_alt_cook"] = {
        Source = "lowthrow2_idle",
        MinProgress = .95,
        -- Time = 70 / 30,
    },
    ["throw_alt_cook"] = {
        Source = "lowthrow_end",
        Time = 1,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15}, -- temporary
        }
    },
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep:GetCurrentFiremode() == wep.Firemodes[2] and wep.Animations[anim .. "_cook"] then
        return anim .. "_cook"
    end
end