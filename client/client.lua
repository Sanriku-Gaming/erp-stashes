local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local PlayerJob = nil

local Targets = {}
local props = {}

--FUNCTIONS

--Used for debugging tables
local function printTable(tbl)
  for key, value in pairs(tbl) do
    if type(value) == "table" then
      print(key .. " (table):")
      printTable(value)
    else
      print(key .. ":", value)
    end
  end
end

--Prop Spawning
local time = 1000
local function loadModel(model) if not HasModelLoaded(model) then
	if Config.Debug then print('^5Debug^7: ^2Loading Model^7: ^6'..model..'^7') end
	while not HasModelLoaded(model) do
		if time > 0 then time = time - 1 RequestModel(model)
		else time = 1000 print('^5Debug^7: ^3LoadModel^7: ^2Timed out loading model ^7: ^6'..model..'^7') break
		end
		Wait(10)
	end
end end

local function createProp(data, freeze, synced)
  loadModel(data.prop)
  local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z, synced or 0, synced or 0, 0)
  SetEntityHeading(prop, data.coords.w)
  FreezeEntityPosition(prop, freeze or 0)
  if Config.Debug then print('^5Debug^7: ^6Prop ^2Created ^7: ^6'..prop..'^7') end
  return prop
end

RegisterNetEvent('erp-stashes:client:OpenStash', function(data)
  if Config.Debug then printTable(data) end

  -- Set stash name
  local stashName
  if data.stashJob then
    stashName = 'jobstash_'..data.stashJob..'_'..data.index
    if data.stashType == 'personal' then
      stashName = stashName..'_personal_'..PlayerData.citizenid
    else
      stashName = stashName..'_public'
    end
  else
    if data.stashType == 'personal' then
      stashName = 'personal_'..data.index..'_'..PlayerData.citizenid
    else
      stashName = 'public_'..data.index
    end
  end

  TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
    maxweight = data.weight,
    slots = data.slots,
  })
  TriggerEvent("inventory:client:SetCurrentStash", stashName)
end)

-- MAIN THREAD
CreateThread(function()
  for k, v in pairs(Config.Stashes) do
    local jobName = v.job
    if v.jType then jobName = v.jType end
    if type(v.job) == 'table' then jobName = 'shared' end

    -- Create prop if needed
    if v.useProp then
      propModel = v.prop
      props[#props+1] = createProp({prop = propModel, coords = vector4(v.coords.x, v.coords.y, v.coords.z, v.coords.w)}, 1, false)
      if Config.Debug then print('prop '..propModel..', Created at '..tostring(v.coords)) end
    end

    -- Create stash target
    Targets['stash-'..k] = exports['qb-target']:AddCircleZone('stash-'..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.pSize, {
      name = 'stash-'..k,
      debugPoly = Config.DebugPoly,
      useZ = false,
    }, {
      options = {
        {
          type = "client",
          event = "erp-stashes:client:OpenStash",
          icon = "fas fa-box-open",
          label = "Open Stash",
          canInteract = function()
            if v.jType and PlayerJob.type ~= v.jType then
              return false
            elseif v.job == false then
              return true
            elseif type(v.job) == 'table' then
              for job, requiredGrade in pairs(v.job) do
                if type(job) == 'number' then
                  if PlayerJob.name == job and PlayerJob.grade >= requiredGrade then
                    return true
                  end
                elseif type(job) == 'string' then
                  if PlayerJob.name == job then
                    return true
                  end
                end
              end
            elseif type(v.job) == 'string' then
              if PlayerJob.name == v.job then
                return true
              end
            end
            return false
          end,
          stashType = v.sType,
          stashJob = jobName,
          weight = v.weight,
          slots = v.slots,
          index = k,
        },
      },
      distance = 2.5
    })
  end
end)

-- Base Events
AddEventHandler('onResourceStart', function(resource)
  if resource == GetCurrentResourceName() then
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
  end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  PlayerData = QBCore.Functions.GetPlayerData()
  PlayerJob = PlayerData.job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
  PlayerJob = JobInfo
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) if Config.Debug then print('Targets '..k..' Removed') end end
    for i = 1, #props do DeleteEntity(props[i]) if Config.Debug then print('props '..i..' Deleted') end end
	end
end)