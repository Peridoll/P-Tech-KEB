# P-Tech Vigilance

P-Tech Vigilance is a modular security-system suite for FiveM.

## Principles
- Each module operates independently by default.
- Cross-module integration is optional and explicitly documented.
- Shared core resources are introduced only when there is a concrete need.
- UI, naming, and configuration conventions remain consistent across modules.
- Runtime dependencies must be declared per resource.

## Naming
- Repository: `P-Tech-Vigilance`
- FiveM resources: `ptech_vigilance_<module>`
- Example module: `ptech_vigilance_security` (placeholder, not yet implemented)

## Layout
- `docs/` — architecture, planning, and specifications
- `resources/` — FiveM resources (added when designed)
- `dev/` — development tools, fixtures, and tests

**Status:** Repository scaffold only. No playable FiveM resources are included yet.
