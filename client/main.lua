local QBCore = exports['qbr-core']:GetCoreObject()
local telegrams = {}
local index = 1
local menu = false

------------------------------------
--- ADD YOUR OWN LOCATIONS BELOW ---
------------------------------------

local locations = {
    { x=-178.90, y=626.71, z=114.09 }, -- Valentine train station
    { x=1225.57, y=-1293.87, z=76.91 }, -- Rhodes train station
    { x=2731.55, y=-1402.37, z=46.18 }, -- Saint Denis train station
    { x=1521.96, y=439.48, z=90.68 }, -- Emerald Ranch train station
    { x=2985.95, y=569.64, z=44.62 }, -- Van Horn
    { x=2939.10, y=1287.60, z=44.65 }, -- Annesburg
    { x=-1094.25, y=-574.81, z=82.50 }, -- Riggs Station
    { x=-1765.06, y=-384.20, z=157.74 }, -- Strawberry
    { x=-874.97, y=-1328.76, z=43.95 }, -- Blackwater
    { x=-3733.97, y=-2597.82, z=-12.92 }, -- Armadillo train station
    { x=-5227.40, y=-3470.58, z=-20.56 }, -- Benedict point
}

for k, v in pairs(locations) do
    Citizen.CreateThread(function()
        while true do       
            Citizen.Wait(1000)
                local blip = N_0x554d9d53f696d002(1664425300, vector3(v.x,v.y,v.z))
                SetBlipSprite(blip, 1475382911)
                SetBlipScale(blip, 0.2)
                Citizen.InvokeNative(0x9CB1A1623062F402, tonumber(blip), Lang:t('telegram.post_office'))
            break
        end
    end)
end

RegisterNetEvent("Telegram:ReturnMessages")
AddEventHandler("Telegram:ReturnMessages", function(data)
    index = 1
    telegrams = data

    if next(telegrams) == nil then
        SetNuiFocus(true, true)
        SendNUIMessage({ message = Lang:t('telegram.no_telegrams') })
    else
        SetNuiFocus(true, true)
        SendNUIMessage({ sender = telegrams[index].sender, message = telegrams[index].message })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        for key, value in pairs(locations) do
           if IsPlayerNearCoords(value.x, value.y, value.z) then
                if not menu then
                    DrawText3D(value.x, value.y, value.z, Lang:t('telegram.press_to_view', {value = '~d~[G]~s~'}))
                    if IsControlJustReleased(0, 0x760A9C6F) then
                        menu = true
                        TriggerServerEvent("Telegram:GetMessages")
                    end
                end
            end
        end
    end
end)

function IsPlayerNearCoords(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true)

    if distance < 2 then
        return true
    end
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function CloseTelegram()
    index = 1
    menu = false
    SetNuiFocus(false, false)
    SendNUIMessage({})
end

RegisterNUICallback('back', function()
    if index > 1 then
        index = index - 1
        SendNUIMessage({ sender = telegrams[index].sender, message = telegrams[index].message })
    end
end)

RegisterNUICallback('next', function()
    if index < #telegrams then
        index = index + 1
        SendNUIMessage({ sender = telegrams[index].sender, message = telegrams[index].message })
    end
end)

RegisterNUICallback('close', function()
    CloseTelegram()
end)

RegisterNUICallback('new', function()
    CloseTelegram()
    GetFirstname()
end)

RegisterNUICallback('delete', function()
    TriggerServerEvent("Telegram:DeleteMessage", telegrams[index].id)
end)

function GetFirstname()
    AddTextEntry("FMMC_KEY_TIP8", Lang:t('telegram.first_name'))
    DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP8", "", "", "", "", "", 30)

    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0);
    end

    while (UpdateOnscreenKeyboard() == 2) do
        Wait(0);
        break
    end

    while (UpdateOnscreenKeyboard() == 1) do
        Wait(0)
        if (GetOnscreenKeyboardResult()) then
            local firstname = GetOnscreenKeyboardResult()

            GetLastname(firstname)

            break
        end
    end
end

function GetLastname(firstname)
    AddTextEntry("FMMC_KEY_TIP8", Lang:t('telegram.last_name'))
    DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP8", "", "", "", "", "", 30)

    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0);
    end

    while (UpdateOnscreenKeyboard() == 2) do
        Wait(0);
        break
    end

    while (UpdateOnscreenKeyboard() == 1) do
        Wait(0)
        if (GetOnscreenKeyboardResult()) then
            local lastname = GetOnscreenKeyboardResult()

            GetMessage(firstname, lastname)

            break
        end
    end
end

function GetMessage(firstname, lastname)
    AddTextEntry("FMMC_KEY_TIP12", Lang:t('telegram.message'))
    DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP12", "", "", "", "", "", 150)

    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0);
    end

    while (UpdateOnscreenKeyboard() == 2) do
        Wait(0);
        break
    end

    while (UpdateOnscreenKeyboard() == 1) do
        Wait(0)
        if (GetOnscreenKeyboardResult()) then
            local message = GetOnscreenKeyboardResult()
            TriggerServerEvent("Telegram:SendMessage", firstname, lastname, message, GetPlayerServerIds())
           
            break
        end
    end
end

function GetPlayerServerIds()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end
