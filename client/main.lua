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
}

for k, v in pairs(locations) do
    Citizen.CreateThread(function()
        while true do       
            Citizen.Wait(1000)
                local blip = N_0x554d9d53f696d002(1664425300, vector3(v.x,v.y,v.z))
                SetBlipSprite(blip, 1475382911)
                SetBlipScale(blip, 0.2)
                Citizen.InvokeNative(0x9CB1A1623062F402, tonumber(blip), "Post Office")
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
        SendNUIMessage({ message = "No telegrams to display." })
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
                    DrawText3D(value.x, value.y, value.z, "Press ~d~[G]~s~ to view your telegrams.", 0.5, 0.88)
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
    AddTextEntry("FMMC_KEY_TIP8", "Recipient's Firstname: ")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)

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
    AddTextEntry("FMMC_KEY_TIP8", "Recipient's Lastname: ")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)

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
    AddTextEntry("FMMC_KEY_TIP12", "Message: ")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12", "", "", "", "", "", 150)

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
