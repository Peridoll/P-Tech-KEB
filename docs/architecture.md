# Architecture

## Scope
Security and facility-protection gameplay for FiveM.

## Modular design
1. Resources use the naming convention `ptech_vigilance_<module>`.
2. Modules are independently installable and upgradable whenever possible.
3. Optional integrations must fail gracefully when the counterpart is absent.
4. Every module documents configuration, exports/events, permissions, data persistence and dependencies.
5. Introduce `ptech_vigilance_core` only if genuinely shared capabilities are necessary.

## Potential modules (not committed specifications)
- Security management: `ptech_vigilance_security`
- CCTV monitoring: `ptech_vigilance_cctv`
- Access management: `ptech_vigilance_access`
- Alarm systems: `ptech_vigilance_alarm`
- Panic button: `ptech_vigilance_panic_button`

These names are provisional. Implementation order and interfaces are undecided.
