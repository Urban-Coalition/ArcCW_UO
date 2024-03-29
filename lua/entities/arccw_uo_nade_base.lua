AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Base Hand Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false

ENT.Ticks = 0
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE


-- Intentionally not ENT.Damage since ArcCW base overwrites it with weapon damage (for some reason)
ENT.GrenadeDamage = false
ENT.GrenadeRadius = 0
ENT.FuseTime = 10
ENT.ArmTime = 0
ENT.DragCoefficient = 1

ENT.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"
ENT.ExplosionEffect = true
ENT.Scorch = true
ENT.ImpactFuse = false

local path = "arccw_uc/common/"
local path1 = "arccw_uc/common/"
ENT.ExplosionSounds = {path .. "explosion-close-01.ogg", path .. "explosion-close-02.ogg"}
ENT.ExplosionSoundsIndoors = {path .. "explosion-close-int-01.ogg", path .. "explosion-close-int-02.ogg", path .. "explosion-close-int-03.ogg", path .. "explosion-close-int-04.ogg"}
ENT.DebrisSounds = {path1 .. "debris-01.ogg", path1 .. "debris-02.ogg", path1 .. "debris-03.ogg", path1 .. "debris-04.ogg", path1 .. "debris-05.ogg"}
ENT.ExplosionParticle = "explosion_grenade_fas2"

-- explosion_HE_m79_fas2
-- explosion_he_grenade_fas2
-- explosion_HE_claymore_fas2
-- explosion_grenade_fas2

ENT.GrenadeDir = Vector(0,0,-1)

if SERVER then
    function ENT:Initialize()
        -- local pb_vert = 1
        -- local pb_hor = 1
        self:SetModel(self.Model)
        -- self:PhysicsInitBox(Vector(-pb_vert, -pb_hor, -pb_hor), Vector(pb_vert, pb_hor, pb_hor))
        -- self:PhysicsInitSphere(2, "grenade")

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetMaterial("grenade")
            phys:Wake()
            -- phys:SetDragCoefficient(0.1)
            -- phys:SetBuoyancyRatio(0.1)
            -- phys:SetMass(0.3)
        end

        self.SpawnTime = CurTime()

        -- for _,ent in pairs(ents.FindByClass("func_breakable_surf")) do
        --     constraint.NoCollide(self,ent,0,0)
        -- end
    end

    function ENT:Think()
        if SERVER and CurTime() - self.SpawnTime >= self.FuseTime then
            self:Detonate()
        end
    end
else
    function ENT:Think()
        if !self.Submerged and self:WaterLevel() > 0 then
            self.Submerged = true
    
            local eff = EffectData()
            eff:SetOrigin(self:GetPos())
            util.Effect("watersplash",eff)
        elseif self.Submerged and self:WaterLevel() == 0 then
            self.Submerged = nil
        end
    end
end

-- overwrite to do special explosion things
function ENT:DoDetonation()
    local attacker = IsValid(self:GetOwner()) and self:GetOwner() or self
    util.BlastDamage(self, attacker, self:GetPos(), self.GrenadeRadius, self.GrenadeDamage or self.Damage or 0)

    for _,ent in pairs(ents.FindByClass("prop_door_rotating")) do
        if ent:GetPos():DistToSqr(self:GetPos()) <= math.pow(self.GrenadeRadius / 3.5,2) then
            local trace = util.TraceLine({
                start = self:GetPos() + Vector(0,0,15),
                endpos = ent:LocalToWorld(Vector(0,25,0)),
                filter = self
            })
            if trace.Entity == ent then
                ArcCW.DoorBust(ent,(ent:GetPos() - self:GetPos()):GetNormalized() * 400)
            end
        end
    end
end

-- overwrite to keep the default explosion but still do special stuff; don't use if DoDetonation is overridden
function ENT:PostDetonation()
end

function ENT:Detonate()
    if not self:IsValid() or self.BOOM then return end
    self.BOOM = true

    if self.ExplosionEffect then
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        if self:WaterLevel() >= 1 then
            util.Effect("WaterSurfaceExplosion", effectdata)
            self:EmitSound("weapons/underwater_explode3.wav", 125, 100, 1, CHAN_AUTO)
        else
            effectdata:SetFlags(4)
            -- util.Effect("Explosion", effectdata)

            ParticleEffect(self.ExplosionParticle or "explosion_grenade_fas2", self:GetPos(), Angle(-90, 0, 0))

            -- self:EmitSound(self.ExplosionSounds[math.random(1,#self.ExplosionSounds)], 125, 100, 1, CHAN_AUTO)
            ArcCW.UO.InnyOuty(self)
            --self:EmitSound("phx/kaboom.wav", 125, 100, 1, CHAN_AUTO) -- Temporary
        end
        util.ScreenShake(self:GetPos(),25,4,.75,self.GrenadeRadius * 4)
    end

    self:DoDetonation()

    local trace = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() + Vector(0,0,-45),
        mask = MASK_SOLID_BRUSHONLY
    })

    if trace.Hit then
        if self.Scorch then
            self:FireBullets({
                Attacker = attacker,
                Damage = 0,
                Tracer = 0,
                Distance = 30,
                Dir = self.GrenadeDir or self:GetVelocity():GetNormalized(),
                Src = self:GetPos(),
                Callback = function(att, tr, dmg)
                    util.Decal("Scorch", tr.StartPos, tr.HitPos - (tr.HitNormal * 16), self)
                end
            })
        end

        -- local debrisMats = {
        --     [MAT_GRASS] = true,
        --     [MAT_DIRT] = true,
        --     [MAT_SAND] = true,
        -- }
        if self.DebrisSounds then
            self:EmitSound(self.DebrisSounds[math.random(1,#self.DebrisSounds)], 85, 100, 1, CHAN_AUTO)
        end
    end

    self:PostDetonation()
    self:Remove()
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        if data.Speed > 75 then
            self:EmitSound(Sound("physics/metal/metal_grenade_impact_hard" .. math.random(1,3) .. ".wav"))
        elseif data.Speed > 25 then
            self:EmitSound(Sound("physics/metal/metal_grenade_impact_soft" .. math.random(1,3) .. ".wav"))
        end

        if (CurTime() - self.SpawnTime >= self.ArmTime) and self.ImpactFuse then
            self:Detonate()
        end
    end
end

function ENT:Draw()
    self:DrawModel()
end