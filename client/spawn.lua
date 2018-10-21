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

function CreatePlane(x, y, z, heading, destination)
	mainMenu:Visible(not mainMenu:Visible())

	modelHash = GetHashKey(config.plane_model)
	pilotModel = GetHashKey("s_m_m_pilot_01")
	
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Citizen.Wait(0)
	end

	RequestModel(pilotModel)
	while not HasModelLoaded(pilotModel) do
		Citizen.Wait(0)
	end

	if HasModelLoaded(modelHash) and HasModelLoaded(pilotModel) then
		ClearAreaOfEverything(x, y, z, 1500, false, false, false, false, false)

		AirPlane = CreateVehicle(modelHash, x, y, z-1.0, heading, true, false)
		SetVehicleOnGroundProperly(AirPlane)
		SetVehicleEngineOn(AirPlane, true, true, true)
		SetEntityProofs(AirPlane, true, true, true, true, true, true, true, false)
		SetVehicleHasBeenOwnedByPlayer(AirPlane, true)

		pilot = CreatePedInsideVehicle(AirPlane, 6, pilotModel, -1, true, false)

		SetBlockingOfNonTemporaryEvents(pilot, true)

		local netVehid = NetworkGetNetworkIdFromEntity(AirPlane)
		SetNetworkIdCanMigrate(netVehid, true)
		NetworkRegisterEntityAsNetworked(VehToNet(AirPlane))

		local netPedid = NetworkGetNetworkIdFromEntity(pilot)
		SetNetworkIdCanMigrate(netPedid, true)
		NetworkRegisterEntityAsNetworked(pilot)

		totalSeats = GetVehicleModelNumberOfSeats(modelHash)
		TaskWarpPedIntoVehicle(PlayerPedId(), AirPlane, 2)

		SetModelAsNoLongerNeeded(modelHash)
		SetModelAsNoLongerNeeded(pilotModel)
	end

	if destination == "DESRT" then
		TaskPlaneMission(pilot, AirPlane, 0, 0, -107.2212, 2717.5534, 61.9673, 4, GetVehicleModelMaxSpeed(modelHash), 1.0, 0.0, 10.0, 40.0)
	elseif destination == "AIRP" then
		TaskVehicleDriveToCoordLongrange(pilot, AirPlane, 1403.0020751953, 2995.9179, 40.5507, GetVehicleModelMaxSpeed(modelHash), 16777216, 0.0)
		Wait(5000)
		TaskPlaneMission(pilot, AirPlane, 0, 0, -1571.5589, -556.7288, 114.4482, 4, GetVehicleModelMaxSpeed(modelHash), 1.0, 0.0, 5.0, 40.0)
	end
end

RegisterNetEvent("airports:departure")
AddEventHandler("airports:departure",  function(x, y, z, heading, planeDest)
	ClearAllHelpMessages()
	CreatePlane(x, y, z, heading, planeDest)
end)

RegisterNetEvent("airports:moneyInvalid")
AddEventHandler("airports:moneyInvalid", function()
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName("You don't have enough money to buy a ticket.\n")
	SetNotificationMessage("CHAR_BLOCKED", "CHAR_BLOCKED", true, 4, "FiveM Airports", "", "You don't have enough money to buy a ticket.\n")
	DrawNotification(false, true)
end)
