SWEP.Base = "arccw_base_nade"

SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Urban Coalition" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Frag Grenade"
SWEP.TrueName = "RGD-5"
SWEP.Trivia_Class = "Fragmentation Grenade"
SWEP.Trivia_Desc = [[Cold War era, TNT-based anti-personnel grenade. Saturates its surroundings with shrapnel with a short fuse and a narrow lethal radius.

Can be cooked with the "COOK" firemode, allowing the user to start the fuse early for a reduced time to detonation.]]
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Pyrotechnic Delay Fuse"
SWEP.Trivia_Country = "Soviet Union"
SWEP.Trivia_Year = 1954

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
end

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_uc_common_rgd.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_uc_common_rgd.mdl"
SWEP.ViewModelFOV = 60

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

SWEP.MuzzleVelocity = 1600
SWEP.MuzzleVelocityAlt = 500 -- Throwing with alt-fire will use this velocity if exists

SWEP.PullPinTime = .75
SWEP.FuseTime = 3.4
SWEP.CookPrimFire = false 
SWEP.CookAltFire = false

SWEP.ChamberSize = 0

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "grenade"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "grenade"

SWEP.BashPreparePos = Vector(2.187, -7.117, -1)
SWEP.BashPrepareAng = Angle(5, -3.652, -19.039)

SWEP.BashPos = Vector(8.876, 0, 0)
SWEP.BashAng = Angle(-16.524, 70, -11.046)

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
        Time = .75,
        MinProgress = .75,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.25},
        }
    },
    ["pre_throw_cook"] = {
        Source = "throw2_start",
        Time = .85,
        MinProgress = .85,
        SoundTable = {
            {s = rottle, t = 0.05},
            {s = path .. "pinpull.wav", t = 0.25},
            {s = path .. "spooneject.wav", t = 0.55},
        }
    },
    ["pre_throw_hold"] = {
        Source = "throw_idle",
        Time = 70 / 30,
    },
    ["pre_throw_hold_cook"] = {
        Source = "throw2_idle",
        Time = 2.6,
    },
    ["throw"] = {
        Source = "throw_end",
        Time = .5,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        SoundTable = {
            {s = "weapons/arccw/melee_lift.wav", t = 0.15}, -- temporary
            {s = path .. "spooneject.wav", t = 0.2}, -- temporary
        }
    },
    ["throw_cook"] = {
        Source = "throw_end",
        Time = .5,
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