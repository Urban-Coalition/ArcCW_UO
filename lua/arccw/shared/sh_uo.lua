ArcCW.UO = {}

if game.SinglePlayer() and SERVER then
    util.AddNetworkString("ArcCW_UO_InnyOuty")
elseif game.SinglePlayer() and CLIENT then
    net.Receive("ArcCW_UO_InnyOuty", function(len, ply)
        ArcCW.UO.InnyOuty(net.ReadEntity())
    end)
end


-- right forward up
local traces1 = {
    {
        Distance = Vector(0, 0, 1024),
        Influence = 1,
    }, -- Up

}

local traces2 = {
    {
        Distance = Vector(0, 0, 1024),
        Influence = 1,
    }, -- Up
    {
        Distance = Vector(768, 768, 0),
        Influence = 0.5,
    }, -- Right
    {
        Distance = Vector(-768, 768, 0),
        Influence = 0.5,
    }, -- Left

}

local traces3 = {
    {
        Distance = Vector(0, 0, 1024),
        Influence = 0,
    }, -- Up
    {
        Distance = Vector(0, 768, 768),
        Influence = 1,
    }, -- Up Forward
    {
        Distance = Vector(0, -768, 768),
        Influence = 1,
    }, -- Up Back
    {
        Distance = Vector(0, 768, 0),
        Influence = 0.5,
    }, -- Forward
    {
        Distance = Vector(768, 768, 0),
        Influence = 0.5,
    }, -- Right
    {
        Distance = Vector(-768, 768, 0),
        Influence = 0.5,
    }, -- Left

}

local traces4 = {
    {
        Distance = Vector(0, 0, 1024),
        Influence = 0.5,
    }, -- Up
    {
        Distance = Vector(0, 768, 768),
        Influence = 1,
    }, -- Up Forward
    {
        Distance = Vector(0, -768, 768),
        Influence = 1,
    }, -- Up Back
    {
        Distance = Vector(0, 768, 0),
        Influence = 0.5,
    }, -- Forward
    {
        Distance = Vector(0, -1024, 0),
        Influence = 0.5,
    }, -- Back
    {
        Distance = Vector(768, 768, 0),
        Influence = 0.5,
    }, -- Right
    {
        Distance = Vector(-768, 768, 0),
        Influence = 0.5,
    }, -- Left
    {
        Distance = Vector(-768, -768, 0),
        Influence = 0.5,
    }, -- Left Back
    {
        Distance = Vector(768, -768, 0),
        Influence = 0.5,
    }, -- Right Back

}

local tracebase = {
    start = 0,
    endpos = 0,
    filter = NULL,
}

local choice = {
    [1] = traces1,
    [2] = traces2,
    [3] = traces3,
    [4] = traces4,
}

ArcCW.UO.InnyOuty = function(gren)
    if SERVER and game.SinglePlayer() then
        net.Start("ArcCW_UO_InnyOuty")
        net.WriteEntity(gren)
        net.Broadcast()
    elseif CLIENT then
        local so = gren.ExplosionSounds
        local si = gren.ExplosionSoundsIndoors
        local vol = 0
        local wop = gren:GetPos() -- Can cause null exceptions
        local woa = Angle(0, 0, 0)
        local t_influ = 0
        local option = GetConVar("arccw_uc_disttrace"):GetInt()
        local fps = 1 / RealFrameTime()

        if option > 0 then
            option = choice[option]
        else
            if fps > 100 then
                option = 4
            elseif fps > 40 then
                option = 3
            else
                option = 2
            end

            if GetConVar("developer"):GetInt() > 0 then
                print("perf" .. option)
            end

            option = choice[option]
        end

        for _, tin in ipairs(option) do
            tracebase.start = wop
            offset = Vector()
            --if !tin.AngleUp then--_ != 1 then
            offset = offset + (tin.Distance.x * woa:Right())
            offset = offset + (tin.Distance.y * woa:Forward())
            offset = offset + (tin.Distance.z * woa:Up())
            --end
            tracebase.endpos = wop + offset
            tracebase.filter = wo
            t_influ = t_influ + (tin.Influence or 1)
            local result = util.TraceLine(tracebase)
            debugoverlay.Line(wop - (vector_up * 4), result.HitPos - (vector_up * 4), 1, Color((_ / 4) * 255, 0, (1 - (_ / 4)) * 255))
            debugoverlay.Text(result.HitPos - (vector_up * 4), math.Round((result.HitSky and 1 or result.Fraction) * 100) .. "%", 1)
            vol = vol + (result.HitSky and 1 or result.Fraction) * tin.Influence
        end

        vol = vol / t_influ
        local thresh = .4

        if so then
            for _, snd in ipairs(so) do
                gren:StopSound(snd)
            end

            if math.max(thresh, vol) ~= thresh then
                gren:EmitSound(so[math.random(1, #so)], 125, 100, 1, CHAN_VOICE2)
            end
        end

        if si then
            thresh = 1 - thresh
            for _, snd in ipairs(si) do
                gren:StopSound(snd)
            end

            if math.min(thresh, vol) ~= thresh then
                gren:EmitSound(si[math.random(1, #si)], 150, 100, 1, CHAN_STREAM)
            end
        end
    end
end