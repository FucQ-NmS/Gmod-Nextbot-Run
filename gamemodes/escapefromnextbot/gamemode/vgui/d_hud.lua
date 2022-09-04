-- local nbCount = 0
-- local nbMax = 0
-- local nbStatus = 0

-- net.Receive("nbInfo", function(len)
--     nbCount = net.ReadInt(9)
--     nbMax = net.ReadInt(9)
--     nbStatus = net.ReadInt(9)
-- end)

net.Start("req_nbInfo")
net.SendToServer()

surface.CreateFont("DL_Large", {
    font = "DermaLarge",
    -- size = ScreenScale(13),
    size = 52,
    weight = 500
})
surface.CreateFont("DL_Medium", {
    font = "DermaLarge",
    -- size = ScreenScale(9),
    size = 36,
    weight = 500
})
surface.CreateFont("DL_Small", {
    font = "DermaLarge",
    -- size = ScreenScale(7),
    size = 28,
    weight = 500
})
surface.CreateFont("DDB_Medium", {
    font = "DermaDefaultBold",
    -- size = ScreenScale(10)
    size = 40
})
surface.CreateFont("DDB_Small", {
    font = "DermaDefaultBold",
    -- size = ScreenScale(5)
    size = 20
})

--隐藏原本的hud
hook.Add("HUDShouldDraw", "hideDefaultHud", function(name)
    net.Start("req_nbInfo")
    net.SendToServer()

    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
        if (name == v) then
            return false
        end
    end
end)

local nbSt = ""

--绘制hud
hook.Add("HUDPaint", "nextbotHud", function()
    local cl = LocalPlayer()

    if (nbStatus == 1) then
        nbSt = translate.Get("hud_nbstatus_one")
    elseif (nbStatus == 0) then
        nbSt = translate.Get("hud_nbstatus_zero")
    end

    --Nextbot信息
    if (NBR.gui.show_nb_info) then
        draw.RoundedBox(15, -10, 20, 400, 200, Color(255, 120, 120, 150))
        draw.SimpleText(translate.Format("hud_nbinfo_num", nbCount, nbMax), "DL_Medium", 3, 30, Color(255,255,255), 0, 0)
        draw.SimpleText(translate.Format("hud_nbinfo_status", nbSt), "DL_Small", 3, 70, Color(255,255,255), 0, 0)

        draw.SimpleText(translate.Format("hud_death_count", LocalPlayer():Deaths()), "DL_Medium", 3, 100, Color(255,12,12), 0, 0)
    end

    --玩家信息
    if (cl:Health() >= 100 || cl:Health() <= 0) then
        
    elseif (cl:Armor() <= 0) then
        draw.RoundedBox(4, -10, ScrH() - 60, 360, 60, Color(50, 50, 50, 225))

        draw.RoundedBox(15, 30, ScrH() - 40, 300, 10, Color(255, 200, 12))
        draw.RoundedBox(15, 30, ScrH() - 40, math.Clamp(cl:Health(), 0, 100) * 3, 10, Color(255, 12, 12))
        draw.SimpleText(tostring(cl:Health()), "DermaDefaultBold", 10, ScrH() - 40 - 3, Color(0, 255, 255), 0, 0)
    else 
        draw.RoundedBox(4, -10, ScrH() - 60, 360, 60, Color(50, 50, 50, 225))

        draw.RoundedBox(15, 30, ScrH() - 40, 300, 10, Color(255, 200, 12))
        draw.RoundedBox(15, 30, ScrH() - 40, math.Clamp(cl:Health(), 0, 100) * 3, 10, Color(255, 12, 12))
        draw.SimpleText(tostring(cl:Health()), "DermaDefaultBold", 5, ScrH() - 40 - 3, Color(0, 255, 255), 0, 0)

        draw.RoundedBox(15, 30, ScrH() - 20, 300, 10, Color(255, 200, 255))
        draw.RoundedBox(15, 30, ScrH() - 20, math.Clamp(cl:Armor(), 0, 100) * 3, 10, Color(12, 100, 100))
        draw.SimpleText(tostring(cl:Armor()), "DermaDefaultBold", 5, ScrH() - 20 - 3, Color(255, 255, 255), 0, 0)
    end

    --弹药
    if (cl:GetActiveWeapon():IsValid()) then
        if (cl:GetActiveWeapon():Clip1() != -1 && cl:GetActiveWeapon():Clip1() != nil) then
            draw.RoundedBox(4, -10, ScrH() - 150, 150, 70, Color(10, 10, 10, 225))

            draw.SimpleText(translate.Format("hud_ammo", tostring(cl:GetActiveWeapon():Clip1()), tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()))), "DDB_Small", 10, ScrH() - 140)

            if (cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()) > 0 && cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()) != nil) then
                draw.SimpleText(translate.Format("hud_sec_ammo", tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()))), "DDB_Small", 10, ScrH() - 115)
            end
        elseif (cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()) != 0) then
            draw.RoundedBox(4, -10, ScrH() - 150, 120, 43, Color(10, 10, 10, 225))

            draw.SimpleText(translate.Format("hud_ammo_single", tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()))), "DDB_Small", 10, ScrH() - 140)
        end
    end
end)