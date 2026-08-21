local M = {}
local state = require('cpc/state')

local function notify(msg)
    if guihooks and guihooks.trigger then
        guihooks.trigger('toastrMsg', {
            type = 'info',
            title = 'Cam Position Changer',
            msg = msg,
            config = { timeOut = 1200, extendedTimeOut = 0 }
        })
    end
end

function M.toggleLock(player)
    player = player or 0
    local veh = be:getPlayerVehicle(player)
    if not veh then
        notify('Нет машины')
        return
    end

    if state.active then
        state.active = false
        state.lockVid = nil
        state.baseLocal = nil
        state.baseRot = nil
        notify('OFF')
        return
    end

    state.lockVid = veh:getId()
    state.active = true
    state.offset:set(0, 0, 0)
    state.baseLocal = nil
    state.baseRot = nil
    state._debugCounter = 0
    notify('ON')
end

function M.moveOffset(dx, dy, dz)
    if not state.active then return end
    state.offset.x = state.offset.x + dx
    state.offset.y = state.offset.y + dy
    state.offset.z = state.offset.z + dz
    local limit = 3.0
    state.offset.x = math.max(-limit, math.min(limit, state.offset.x))
    state.offset.y = math.max(-limit, math.min(limit, state.offset.y))
    state.offset.z = math.max(-limit, math.min(limit, state.offset.z))
end

function M.resetOffset()
    if state.active then
        state.offset:set(0, 0, 0)
    end
end

function M.onVehicleSwitched(oldId, newId)
    if state.active then
        state.active = false
        state.lockVid = nil
        state.baseLocal = nil
        state.baseRot = nil
        notify('Lock released (vehicle changed)')
    end
end

function M.onVehicleDestroyed(vid)
    if state.active and vid == state.lockVid then
        state.active = false
        state.lockVid = nil
        state.baseLocal = nil
        state.baseRot = nil
    end
end

function M.onClientEndMission()
    state.active = false
    state.lockVid = nil
    state.baseLocal = nil
    state.baseRot = nil
end

function M.onExtensionLoaded()
    _G.cpc_main = M
    log('I', 'cpc', 'CPC loaded')
end

return M