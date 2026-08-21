local state = require('cpc/state')

local C = {}
C.__index = C

function C:init()
    self.isGlobal = true
    self.runningOrder = 0.7
    self.isFilter = true
    self.hidden = true
    self.name = "cpc"
end

function C:update(data)
    if not state.active then return true end
    if data.renderView and data.renderView ~= "main" then return true end

    local lockVeh = getObjectByID(state.lockVid)
    if not lockVeh then
        state.active = false
        return true
    end

    -- We obtain the vehicle's rotation (needed only to rotate the local offset).
    local vmvd = core_vehicle_manager and core_vehicle_manager.getVehicleData(lockVeh:getId())
    if not vmvd then return true end
    local vdata = vmvd.vdata
    if not vdata then return true end
    local refNodes = vdata.refNodes and vdata.refNodes[0]
    if not refNodes then return true end

    local refId = refNodes.ref
    local leftId = refNodes.left
    local backId = refNodes.back
    if type(refId) ~= 'number' then refId = 0 end
    if type(leftId) ~= 'number' then leftId = 1 end
    if type(backId) ~= 'number' then backId = 2 end

    local refPos = vec3(lockVeh:getNodePositionXYZ(refId))
    local leftPos = vec3(lockVeh:getNodePositionXYZ(leftId))
    local backPos = vec3(lockVeh:getNodePositionXYZ(backId))

    local dir = vec3()
    dir:setSub2(refPos, backPos)
    dir:normalize()

    local camLeft = vec3()
    camLeft:setSub2(refPos, leftPos)
    camLeft:normalize()

    local camUp = vec3()
    camUp:setCross(dir, camLeft)
    camUp:normalize()

    local vehRot = quatFromDir(dir, camUp)

    -- Current pos cam and car
    local camPos = vec3(data.res.pos)
    local carPos = vec3(lockVeh:getPosition())

    -- Capturing the local position upon initial power-up
    if not state.baseLocal then
        local invVehRot = vehRot:inversed()
        local localPos = vec3()
        localPos:setSub2(camPos, carPos)
        localPos:setRotate(invVehRot, localPos)
        state.baseLocal = vec3(localPos)
        log('I', 'cpc', 'CAPTURE: baseLocal=' .. tostring(state.baseLocal))
    end

    -- Calculate final pos
    local finalLocal = vec3(state.baseLocal)
    finalLocal:setAdd(state.offset)
    finalLocal:setRotate(vehRot, finalLocal)
    data.res.pos:setAdd2(carPos, finalLocal)

    if state.debug then
        if not state._debugCounter then state._debugCounter = 0 end
        state._debugCounter = state._debugCounter + 1
        if state._debugCounter % 10 == 1 then
            log('I', 'cpc', string.format('DEBUG: vehRot=%s offset=%s baseLocal=%s finalPos=%s',
                tostring(vehRot),
                tostring(state.offset),
                tostring(state.baseLocal),
                tostring(data.res.pos)))
        end
    end

    return true
end

return function(...)
    local o = ... or {}
    setmetatable(o, C)
    o:init()
    return o
end