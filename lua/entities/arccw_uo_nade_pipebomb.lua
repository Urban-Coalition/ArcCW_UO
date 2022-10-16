AddCSLuaFile()
ENT.Base = "arccw_uo_nade_base"

ENT.GrenadeRadius = 838 -- 16m
ENT.GrenadeDamage = 200 -- Lethal until 8m (if I did the math right)
ENT.ExplosionParticle = "explosion_HE_m79_fas2"
ENT.Model = "models/w_models/weapons/w_eq_pipebomb.mdl"

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

        if self:GetOwner() then
            local wep = self:GetOwner():GetActiveWeapon()
            if wep then
                wep.FuseTime = math.random(30,60) / 10 -- give a new fuse time when this entity is created and thrown
            end
        end
    end

    function ENT:Think()
        if SERVER and CurTime() - self.SpawnTime >= self.FuseTime then
            self:Detonate()
        end
        if self:WaterLevel() >= 2 then
            self.Detonate = function()
                SafeRemoveEntityDelayed(self,6) -- the fuse goes out
            end
        end
    end
else
    function ENT:Think()
        if self.Ticks % 5 == 0 then
            local emitter = ParticleEmitter(self:GetPos())
            if not self:IsValid() or self:WaterLevel() > 2 then return end
            if not IsValid(emitter) then return end
            local smoke = emitter:Add("particle/particle_smokegrenade", self:GetPos())
            smoke:SetVelocity(VectorRand() * 25)
            smoke:SetGravity(Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(-20, -25)))
            smoke:SetDieTime(math.Rand(1.5, 2.0))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(0)
            smoke:SetEndSize(100)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-0.2, 0.2))
            smoke:SetColor(20, 20, 20)
            smoke:SetAirResistance(5)
            smoke:SetPos(self:GetPos())
            smoke:SetLighting(false)
            emitter:Finish()
        end
        self.Ticks = self.Ticks + 1
    end
end