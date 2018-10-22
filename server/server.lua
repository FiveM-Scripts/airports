--[[
            FiveM Airports
            Copyright (C) 2018 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with this resource in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

if GetCurrentResourceName() == 'airports' then
	version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)
	PerformHttpRequest("https://updates.fivem-scripts.org/verify/airports", function(err, rData, headers)
		if err == 404 then
			RconPrint("\n----------------------------------------------------")
			RconPrint("\nUPDATE ERROR: your version from FiveM Airports could not be verified.\n")
			RconPrint("If you keep receiving this error then please contact FiveM-Scripts.")
			RconPrint("\n----------------------------------------------------")
		else
			local vData = json.decode(rData)
			if vData then
				stableV = vData.version
				if vData.version < version or vData.version > version then
					RconPrint("\n----------------------------------------------------\n")
					RconPrint("You are running a outdated version of FiveM Airports.\nPlease update to the most recent version: " .. vData.version)
					RconPrint("\n----------------------------------------------------\n")
				end
			else
				RconPrint("\n----------------------------------------------------------------------")
				RconPrint("\nUPDATE ERROR: your version from FiveM Airports could not be verified.\n")
				RconPrint("If you keep receiving this error then please contact FiveM-Scripts.")
				RconPrint("\n----------------------------------------------------------------------\n")
			end
		end
	end)
end

RegisterServerEvent("airports:payTicket")
AddEventHandler("airports:payTicket", function(x, y, z, heading, destination, price)
	local src = source

	if config.use_essentialmode then
		TriggerEvent("es:getPlayerFromId", tonumber(src), function(user)
			RconPrint('using Essentialmode')

			if user.getMoney() >= tonumber(price) then
				user.removeMoney(tonumber(price))
				TriggerClientEvent("airports:departure", tonumber(src), x, y, z, heading, destination)
			elseif user.getBank() >= tonumber(price) then
				user.removeBank(tonumber(price))
				TriggerClientEvent("airports:departure", tonumber(src), x, y, z, heading, destination)
			else
				TriggerClientEvent("airports:moneyInvalid", tonumber(src))
			end
		end)
	elseif config.use_venomous then
		TriggerEvent('vf_base:FindPlayer', src, function(user)
			if user.cash >= tonumber(price) then
				TriggerEvent('vf_base:ClearCash', src, tonumber(price))
				TriggerClientEvent("airports:departure", tonumber(src), x, y, z, heading, destination)
			else
				TriggerClientEvent("airports:moneyInvalid", tonumber(src))
			end
		end)			
	end		
end)