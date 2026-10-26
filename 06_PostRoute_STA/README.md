# Post-Routing Static Timing Analysis

These reports are from the existing OpenLane routed design.

## Nominal routed timing

- Clock period: 10 ns
- Setup worst slack: +5.93 ns
- Setup WNS: 0.00 ns
- Setup TNS: 0.00 ns
- Hold worst slack: +0.33 ns

## Report files

- `post_route_sta_summary.rpt`: nominal routed timing summary
- `setup_timing.rpt`: detailed maximum-delay timing paths
- `hold_timing.rpt`: detailed minimum-delay timing paths
- `corner_sweep_summary.md`: 16-library corner sweep summary

## Corner coverage limitation

The corner sweep uses nominal extracted RC parasitics for all library runs.
It is a library/PVT sweep, not a full multi-RC signoff matrix.
Four slow-library corners have reported negative setup slack.
Therefore, the nominal routed timing pass does not establish that every
tested corner passes timing.
