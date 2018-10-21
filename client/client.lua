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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPlayerNearAirport() then
			if IsControlJustPressed(0, 38) then
				if not IsPlayerWantedLevelGreater(PlayerId(), 0) then
					mainMenu:Visible(not mainMenu:Visible())
				else
					if IsHelpMessageBeingDisplayed() then
						ClearAllHelpMessages()
					end

					BeginTextCommandDisplayHelp("STRING")
					AddTextComponentSubstringPlayerName("Lose the Cops")
					EndTextCommandDisplayHelp(0, 0, 1, -1)
				end
			end
		else
			if  _menuPool:IsAnyMenuOpen() then
				mainMenu:Visible(not mainMenu:Visible())
			end				
		end

		if not landing then
			if IsEntityInAir(AirPlane) then
				SetVehicleLandingGear(AirPlane, 1)
			end

			if startZone == "AIRP" and planeDest == "DESRT" then
				if IsEntityInZone(AirPlane, "DESRT") or IsEntityInZone(PlayerPedId(), "GREATC") then
					TaskPlaneLand(pilot, AirPlane, 881.4462, 3060.4829, 41.1682+10.0001, 1657.07, 3238.21, 40.5669+1.0001)
					SetPedKeepTask(pilot, true)
					landing = true
				end
			elseif startZone == "DESRT" and planeDest == "AIRP" then
				if IsEntityInZone(AirPlane, "RICHM") or IsEntityInZone(AirPlane, "OCEANA") then
					TaskPlaneLand(pilot, AirPlane, -1792.00122, -2882.29980, 13.9440+1.0001, -998.5266, -3341.3579, 13.9444+1.0001)
					SetPedKeepTask(pilot, true)
					landing = true
				end
			end
		end

		if not IsEntityInZone(PlayerPedId(), startZone) then
			if not IsEntityInAir(AirPlane) and IsPedInVehicle(PlayerPedId(), AirPlane, false) then
				TaskVehicleTempAction(pilot, Airplane, 27, -1)
				SetVehicleHandbrake(AirPlane, true)

				if GetEntitySpeed(AirPlaine) == 0.0 then
					if IsEntityInZone(PlayerPedId(), "AIRP") then
						Wait(500)
						DoScreenFadeOut(200)
						while not IsScreenFadedOut() do
							Citizen.Wait(0)
						end

						SetEntityCoords(PlayerPedId(), -1042.0395, -2740.7780, 20.1692)
						SetEntityHeading(PlayerPedId(), 340.2285)
						Wait(800)
						DoScreenFadeIn(500)
					else
						TaskLeaveVehicle(PlayerPedId(), AirPlane, 0)
					end
				end
			end

			if not IsPedInVehicle(PlayerPedId(), AirPlane, false) and landing == true then
				SetVehicleHandbrake(AirPlane, false)
				SetBlockingOfNonTemporaryEvents(pilot, false)
				
				SetEntityAsNoLongerNeeded(pilot)
				SetEntityAsNoLongerNeeded(AirPlane)

				startZone = nil
				planeDest = nil
				landing = false
			end
		end

	end
end)