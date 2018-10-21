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

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("", "~s~DESTINATION", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
_menuPool:Add(mainMenu)

_menuPool:ControlDisablingEnabled(false)
_menuPool:MouseControlsEnabled(false)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

function AddAirPortMenu(menu)
	if config.use_essentialmode or config.use_venomous then
		SantonsButton = NativeUI.CreateItem("Los Santos International Airport", "Buy a ticket for "..config.moneyCurrency .." " ..config.ticketPrice)
		DesrtButton = NativeUI.CreateItem("Sandy Shores Airfield", "Buy a ticket for "..config.moneyCurrency .." " ..config.ticketPrice)
	else
		SantonsButton = NativeUI.CreateItem("Los Santos International Airport", "")
		DesrtButton = NativeUI.CreateItem("Sandy Shores Airfield", "")
	end

    menu:AddItem(SantonsButton)
    menu:AddItem(DesrtButton)
    menu.OnItemSelect = function(sender, item, index)
        if item == DesrtButton then
        	if not IsEntityInZone(PlayerPedId(), "DESRT") then
        		startZone = "AIRP"
        		planeDest = "DESRT"
        		if config.use_essentialmode or config.use_venomous then
        			TriggerServerEvent('airports:payTicket', -1675.2446, -2798.8835, 14.5409, 327.8560, planeDest, config.ticketPrice)
        		else
        			CreatePlane(-1675.2446, -2798.8835, 14.5409, 327.8560, planeDest)
        		end
        	else
        		ShowNotification("No plane is ~y~scheduled~w~ to that location right now.")
        	end
        elseif item == SantonsButton then
        	if not IsEntityInZone(PlayerPedId(), "AIRP") then
        		startZone = "DESRT"
        		planeDest = "AIRP"
        		if config.use_essentialmode then
        			TriggerServerEvent('airports:payTicket', 1599.02453, 3231.2016, 40.4115, 105.7817, planeDest, config.ticketPrice)
        		else
        			CreatePlane(1599.02453, 3231.2016, 40.4115, 105.7817, planeDest)
        		end
        	else
        		ShowNotification("No plane is ~y~scheduled~w~ to that location right now.")
        	end
        end
    end   
end

AddAirPortMenu(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		_menuPool:ProcessMenus()
	end
end)