local sites = {}
local history = {}

local function validSiteId(id)
    return type(id) == 'string' and #id > 0 and #id <= 64 and id:match('^[%w_-]+$') ~= nil
end

local function canManage(source)
    return source == 0 or IsPlayerAceAllowed(source, Config.AcePermission)
end

local function record(kind, siteId, source)
    history[#history + 1] = { kind = kind, siteId = siteId, actor = source, timestamp = os.time() }
    while #history > (Config.MaxEventLog or 100) do
        table.remove(history, 1)
    end
end

local function setArmed(siteId, armed, actor)
    if not validSiteId(siteId) or not sites[siteId] or type(armed) ~= 'boolean' then
        return false, 'invalid site or state'
    end
    if sites[siteId].armed == armed then
        return true, 'unchanged'
    end
    sites[siteId].armed = armed
    record(armed and 'armed' or 'disarmed', siteId, actor or 0)
    TriggerEvent('ptech_vigilance_security:server:stateChanged', siteId, armed, actor or 0)
    return true, 'updated'
end

for id, entry in pairs(Config.Sites or {}) do
    if validSiteId(id) and type(entry) == 'table' then
        sites[id] = { label = tostring(entry.label or id), armed = entry.armed == true }
    else
        print(('[P-Tech Vigilance] Ignored invalid site id: %s'):format(tostring(id)))
    end
end

exports('GetSiteState', function(siteId)
    if not validSiteId(siteId) or not sites[siteId] then return nil end
    return { id = siteId, label = sites[siteId].label, armed = sites[siteId].armed }
end)

-- Server-only exports. Calling resources must implement their own access control.
exports('SetSiteArmed', function(siteId, armed)
    return setArmed(siteId, armed, 0)
end)

exports('RaiseAlarm', function(siteId, reason)
    if not validSiteId(siteId) or not sites[siteId] then return false, 'invalid site' end
    if not sites[siteId].armed then return false, 'site disarmed' end
    if type(reason) ~= 'string' then reason = 'unspecified' end
    reason = reason:sub(1, 120)
    record('alarm', siteId, 0)
    TriggerEvent('ptech_vigilance_security:server:alarmRaised', siteId, reason)
    print(('[P-Tech Vigilance] Alarm: %s (%s)'):format(siteId, reason))
    return true, 'raised'
end)

exports('GetRecentEvents', function()
    local result = {}
    for i, event in ipairs(history) do
        result[i] = {
            kind = event.kind, siteId = event.siteId,
            actor = event.actor, timestamp = event.timestamp
        }
    end
    return result
end)

if Config.EnableCommands then
    RegisterCommand(Config.CommandPrefix, function(source, args)
        if not canManage(source) then
            if source > 0 then TriggerClientEvent('chat:addMessage', source, { args = { 'Vigilance', 'Permission denied' } }) end
            return
        end
        local siteId, action = args[1], args[2]
        if not siteId or (action ~= 'arm' and action ~= 'disarm' and action ~= 'status') then
            print('Usage: /' .. Config.CommandPrefix .. ' <siteId> <arm|disarm|status>')
            return
        end
        if not validSiteId(siteId) or not sites[siteId] then
            print('[P-Tech Vigilance] Unknown site: ' .. tostring(siteId))
            return
        end
        if action == 'status' then
            print(('[P-Tech Vigilance] %s armed=%s'):format(siteId, tostring(sites[siteId].armed)))
        else
            local ok, message = setArmed(siteId, action == 'arm', source)
            print(('[P-Tech Vigilance] %s: %s (%s)'):format(siteId, tostring(ok), message))
        end
    end, false)
end

print('[P-Tech Vigilance] Security foundation ready')
