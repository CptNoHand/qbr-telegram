local QBCore = exports['qbr-core']:GetCoreObject()
local redemrp = true

RegisterServerEvent("Telegram:GetMessages")
AddEventHandler("Telegram:GetMessages", function(src)
	local _source
	
	if not src then 
		_source = source
	else 
		_source = src
	end
	local Player = QBCore.Functions.GetPlayer(_source)
    local recipient = Player.PlayerData.citizenid

	MySQL.Async.fetchAll("SELECT * FROM telegrams WHERE recipient=@recipient ORDER BY id DESC", { ['@recipient'] = recipient}, function(result)
		TriggerClientEvent("Telegram:ReturnMessages", _source, result)
	end)
end)

RegisterServerEvent("Telegram:SendMessage")
AddEventHandler("Telegram:SendMessage", function(firstname, lastname, message, players)
	local _source = source

	local Player = QBCore.Functions.GetPlayer(_source)
    local recipient = Player.PlayerData.citizenid

	MySQL.Async.fetchAll("SELECT citizenid FROM players WHERE (charinfo LIKE '%"..firstname.."%') AND (charinfo LIKE '%"..lastname.."%');", function(result)
		if result[1] then 
			local sender = firstname.." "..lastname
			local recipient = result[1].citizenid 
					local paramaters = { ['@sender'] = sender, ['@recipient'] = recipient, ['@message'] = message }

					MySQL.Async.execute("INSERT INTO telegrams (sender, recipient, message) VALUES (@sender, @recipient, @message)",  paramaters, function(count)
						if count > 0 then 
							--[[
							for k, v in pairs(players) do
								local user = QBCore.Functions.GetPlayer(v)
									if user.getName() == firstname .. " " .. lastname then 
										TriggerClientEvent('QBCore:Notify', _source, "You've received a Telegram.")
									end
								end)
							end
							]]
						else 
							TriggerClientEvent('QBCore:Notify', _source, Lang:t('telegram.unable_to_process'), 'error')
						end
					end)

					TriggerClientEvent('QBCore:Notify', _source, Lang:t('telegram.telegram_posted'), 'success')
				else 
					TriggerClientEvent('QBCore:Notify', _source, Lang:t('telegram.invalid_name'), 'error')
				end
			end)
end)

RegisterServerEvent("Telegram:DeleteMessage")
AddEventHandler("Telegram:DeleteMessage", function(id)
	local _source = source
	MySQL.Async.execute("DELETE FROM telegrams WHERE id=@id",  { ['@id'] = id }, function(count)
		if count > 0 then 
			TriggerEvent("Telegram:GetMessages", _source)
		else
			TriggerClientEvent('QBCore:Notify', _source, Lang:t('telegram.unable_to_delete'), 'error')
		end
	end)
end)
