local function loadModel(model)
    local hash = GetHashKey(model)

    if (not IsModelInCdimage(hash)) then
        print("Not a game model!")
        return
    end

    RequestModel(hash)

    while (not HasModelLoaded(hash)) do
        RequestModel(hash)
        Wait(50)
    end

    return hash
end

local function deleteVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, true)
    if (veh == 0) then
        print("Not in vehicle!")
        return
    end
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
end

local function createVehicle(model)
    local hash = loadModel(model)
    local ped = GetPlayerPed(-1)
    local pedCoords = GetEntityCoords(ped, true)
    local pedHeading = GetEntityHeading(ped)
    deleteVehicle()
    local veh = CreateVehicle(hash, pedCoords, pedHeading, true, true)
    SetModelAsNoLongerNeeded(hash)
    SetEntityAsMissionEntity(veh, true, true)
    SetPedIntoVehicle(ped, veh, -1)
    SetRadioToStationName("OFF")
    return veh
end

local function repairVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, true)
    if (veh == 0) then
        print("Not in a vehicle!")
        return
    end
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
end

RegisterCommand("veh", function(src, args)
    if (#args == 0) then
        print("No argument!")
        return
    elseif (#args > 1) then
        print("Too many arguments!")
        return
    end

    createVehicle(args[1])
end)

RegisterCommand("delveh", function()
    deleteVehicle()
end)

RegisterCommand("repair", function()
    repairVehicle()
end)