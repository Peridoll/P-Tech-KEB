Config = {}

-- Server-side configuration. Do not store secrets in this file.
Config.AcePermission = 'ptech.vigilance.security.manage'
Config.EnableCommands = true
Config.CommandPrefix = 'vsecurity'

-- Identifiers must contain only letters, numbers, underscores and hyphens.
Config.Sites = {
    hospital = { label = 'Hospital', armed = false },
    cityhall = { label = 'City Hall', armed = false }
}

Config.MaxEventLog = 100
