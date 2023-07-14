Config = Config or {}

Config.DebugPoly = false                                      -- Show poly zone for stashes
Config.Debug = false                                          -- Show prints to help debug

Config.Stashes = {
  {
    coords = vector4(-125.86, -638.54, 168.59, 15.52),        -- Target and Prop Location
    pSize = 0.65,                                             -- Target Size
    jType = 'leo',                                            -- job.type support (example PlayerJob.type = 'leo') | priority over job
    job = false,                                              -- Job to access (false for all jobs) | supports multiple jobs (use a table {'job1', 'job2'}) and grade checks (table {['job1'] = 2, ['job2'] = 1})
    sType = 'personal',                                       -- personal or shared
    useProp = false,                                          -- Create a prop if needed | true/false
    prop = nil,                                               -- Prop to create if useProp is true | nil or 'propname'
    weight = 1500000,                                         -- Stash Weight
    slots = 50,                                               -- Stash Slots
  },
  {
    coords = vector4(-133.48, -642.7, 167.80, 124.12),
    pSize = 0.65,
    jType = false,
    job = 'admin',
    sType = 'personal',
    useProp = true,
    prop = 'prop_mil_crate_02',
    weight = 2500000,
    slots = 500
  },
  {
    coords = vector4(-130.83, -643.37, 167.82, 187.34),
    pSize = 0.65,
    jType = false,
    job = {'police', 'admin'},
    sType = 'shared',
    useProp = true,
    prop = 'p_cs_locker_01_s',
    weight = 1000000,
    slots = 100
  },
  {
    coords = vector4(-134.02, -640.72, 167.82, 93.53),
    pSize = 0.65,
    jType = false,
    job = false,
    sType = 'shared',
    useProp = true,
    prop = 'bkr_prop_gunlocker_01a',
    weight = 2000000,
    slots = 300
  },
  {
    coords = vector4(-129.59, -643.27, 167.82, 211.4),
    pSize = 0.65,
    jType = false,
    job = {['police'] = 3},
    sType = 'shared',
    useProp = true,
    prop = 'ch_prop_ch_service_locker_02b',
    weight = 2000000,
    slots = 300
  },
}


--[[
Example Props:

p_cs_locker_01_s - Single Locker
ch_prop_ch_service_locker_02b - Single Locker
bkr_prop_gunlocker_01a - Gun Locker (open)
v_ind_cfcovercrate - Wood Crate
prop_mil_crate_01 - Military Crate (medium)
prop_mil_crate_02 - Military Crate (small)

More can be found at: https://forge.plebmasters.de/objects
]]--