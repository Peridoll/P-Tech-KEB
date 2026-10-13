# ptech_vigilance_security (prototype v0.1.0)

Independent, server-side security foundation for FiveM. Framework-free; no database or optional integrations required.

## Setup
1. Copy this folder into your FiveM resources directory.
2. Edit `config.lua` to configure site IDs and default armed states.
3. Add `ensure ptech_vigilance_security` to server.cfg.
4. For in-game admin command access, add `add_ace group.admin ptech.vigilance.security.manage allow` and ensure appropriate players belong to that group.

## Admin command
`/vsecurity hospital arm` / `disarm` / `status`.

Console can use `vsecurity hospital arm` without player ACE permissions. In-game feedback is currently logged to the server console; chat UI not implemented.

## Server exports
- `exports.ptech_vigilance_security:GetSiteState(siteId)`: site table or nil
- `exports.ptech_vigilance_security:SetSiteArmed(siteId, boolean)`: success, message
- `exports.ptech_vigilance_security:RaiseAlarm(siteId, reason)`: success, message; only when armed
- `exports.ptech_vigilance_security:GetRecentEvents()`: bounded event history copy

## Server-local events
- `ptech_vigilance_security:server:stateChanged` (siteId, armed, actor)
- `ptech_vigilance_security:server:alarmRaised` (siteId, reason)

No client-triggered net events are registered. Exports are for *trusted server resources*. They do not themselves enforce caller permissions.

## Limitations
- In-memory state and history reset on resource/server restart.
- Does not implement proximity checks, alarms from world triggers, dispatch, UI, persistence, or camera control.
- Not tested against a running FiveM server yet.
