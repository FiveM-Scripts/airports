--[[
            FiveM Airports
            Copyright (C) 2018-2020 FiveM-Scripts
              
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
