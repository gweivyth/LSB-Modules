-----------------------------------
-- Unlock Mog Wardrobe slots as you complete missions
-----------------------------------
require('modules/module_utils')
require('scripts/globals/missions')
require('scripts/globals/utils')
-----------------------------------
local m = Module:new('mission_wardrobe_unlocks')

-- Mission unlock details
local unlocks = {
    [xi.mission.log_id.ZILART] = {
        [xi.mission.id.zilart.ARK_ANGELS] = { xi.inv.WARDROBE3, 5 },
    },
}

-- Mapping of inventory slots to names
local bagNames = {
    [xi.inv.INVENTORY]  = 'Inventory',
    [xi.inv.MOGSAFE]    = 'Mog Safe',
    [xi.inv.STORAGE]    = 'Storage',
    [xi.inv.TEMPITEMS]  = 'Temp. Items',
    [xi.inv.MOGLOCKER]  = 'Mog Locker',
    [xi.inv.MOGSATCHEL] = 'Mog Satchel',
    [xi.inv.MOGSACK]    = 'Mog Sack',
    [xi.inv.MOGCASE]    = 'Mog Case',
    [xi.inv.WARDROBE]   = 'Mog Wardrobe 1',
    [xi.inv.MOGSAFE2]   = 'Mog Safe 2',
    [xi.inv.WARDROBE2]  = 'Mog Wardrobe 2',
    [xi.inv.WARDROBE3]  = 'Mog Wardrobe 3',
    [xi.inv.WARDROBE4]  = 'Mog Wardrobe 4',
    [xi.inv.WARDROBE5]  = 'Mog Wardrobe 5',
    [xi.inv.WARDROBE6]  = 'Mog Wardrobe 6',
    [xi.inv.WARDROBE7]  = 'Mog Wardrobe 7',
    [xi.inv.WARDROBE8]  = 'Mog Wardrobe 8',
    [xi.inv.RECYCLEBIN] = 'Recycle Bin',
}

-- Change wardrobe sizes upon character creation
m:addOverride('xi.player.charCreate', function(player)
    super(player)
    
    -- Apply size change for all wardrobes
    for i = xi.inv.WARDROBE, xi.inv.WARDROBE8 do
        player:changeContainerSize(i, -80)
    end
end)

-- Handle mission completion to unlock wardrobe slots
m:addOverride('npcUtil.completeMission', function(player, logId, missionId, params)
    local result = super(player, logId, missionId, params)

    -- Check if the mission unlocks a wardrobe slot
    if result and unlocks[logId] and unlocks[logId][missionId] then
        local unlock = unlocks[logId][missionId]
        local bag, bagIncrease = unlock[1], unlock[2]
        local bagName = bagNames[bag]

        local oldSize = player:getContainerSize(bag)
        player:changeContainerSize(bag, bagIncrease)
        local newSize = player:getContainerSize(bag)

        -- Print the update message
        local message = string.format(
            '%s capacity has been increased by %i from %i to %i',
            bagName, bagIncrease, oldSize, newSize)
        player:printToPlayer(message, xi.msg.channel.SYSTEM_3, '')
    end

    return result
end)

return m
