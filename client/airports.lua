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

StarPoints = {
	{x= -1030.8077, y= -2493.35766, z=20.16929, desc="Los Santos International"},
	{x= 1752.15, y= 3290.56, z= 41.1109, desc="Sandy shores"}
}

local function CreateAirportBlips()
	for k,v in pairs(StarPoints) do
		blip = AddBlipForCoord(v.x, v.y, v.z-1)
		SetBlipSprite(blip, 90)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("BLIP_90")
		EndTextCommandSetBlipName(blip)
	end
end

function IsPlayerNearAirport()
	for k,v in pairs(StarPoints) do
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), v.x, v.y, v.z, true) < 80.0 then
			if not IsPedInAnyPlane(PlayerPedId()) then
				if not _menuPool:IsAnyMenuOpen() then
					DrawMarker(1, v.x, v.y, v.z-1.0001, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 219, 77, 155, 0, 0, 2, 0, 0, 0, 0)
				end
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), v.x, v.y, v.z, true) < 2.0 then
			if not _menuPool:IsAnyMenuOpen() then
				if not IsHelpMessageBeingDisplayed() then
					BeginTextCommandDisplayHelp("STRING")
					AddTextComponentSubstringPlayerName(GetLabelText("MATC_DPADRIGHT"))
					EndTextCommandDisplayHelp(0, 0, 1, -1)
				end
			else
				ClearAllHelpMessages()
			end
			return true
		end
	end
end

Citizen.CreateThread(function()
	CreateAirportBlips()
end)