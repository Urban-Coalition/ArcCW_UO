AddCSLuaFile()
ENT.Base = "arccw_uo_nade_base"

ENT.GrenadeRadius = 628 -- 12m
ENT.GrenadeDamage = 172 -- Lethal until 5m (if I did the math right)

function ENT:PostDetonation()
    for i = 1,15 do
        local dir = Vector(math.sin(i * math.pi / 6),math.cos(i * math.pi / 6),0) + VectorRand() * Vector(0,0,.5)

        debugoverlay.Line(self:GetPos(),self:GetPos() + dir * 256,4)

        self:FireBullets({
            Src = self:GetPos(),
            Dir = dir,
            Damage = 0,
            Num = 1,
        })
    end
end