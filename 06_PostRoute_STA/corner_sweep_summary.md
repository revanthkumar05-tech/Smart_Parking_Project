# Smart Parking Controller — 16-Library STA Sweep

Routed design; nominal extracted RC parasitics used for all runs.

This is a library/PVT sweep, not a full multi-RC signoff matrix.

| Corner | Worst setup slack (ns) | Worst hold slack (ns) | WNS (ns) | TNS (ns) | Status |
|---|---:|---:|---:|---:|---|
| ff_100C_1v65 | 6.41 | 0.23 | 0.00 | 0.00 | PASS |
| ff_100C_1v95 | 6.68 | 0.14 | 0.00 | 0.00 | PASS |
| ff_n40C_1v56 | 5.91 | 0.31 | 0.00 | 0.00 | PASS |
| ff_n40C_1v65 | 6.18 | 0.25 | 0.00 | 0.00 | PASS |
| ff_n40C_1v76 | 6.42 | 0.19 | 0.00 | 0.00 | PASS |
| ff_n40C_1v95 | 6.68 | 0.12 | 0.00 | 0.00 | PASS |
| ss_100C_1v40 | 1.18 | 0.66 | 0.00 | 0.00 | PASS |
| ss_100C_1v60 | 3.62 | 0.91 | 0.00 | 0.00 | PASS |
| ss_n40C_1v28 | -13.28 | -0.95 | -13.28 | -99.88 | VIOLATION_OR_INCOMPLETE |
| ss_n40C_1v35 | -5.92 | -0.13 | -5.92 | -40.41 | VIOLATION_OR_INCOMPLETE |
| ss_n40C_1v40 | -2.71 | 0.23 | -2.71 | -16.21 | VIOLATION_OR_INCOMPLETE |
| ss_n40C_1v44 | -0.84 | 0.44 | -0.84 | -3.91 | VIOLATION_OR_INCOMPLETE |
| ss_n40C_1v60 | 2.87 | 0.93 | 0.00 | 0.00 | PASS |
| ss_n40C_1v76 | 4.44 | 0.65 | 0.00 | 0.00 | PASS |
| tt_025C_1v80 | 5.93 | 0.33 | 0.00 | 0.00 | PASS |
| tt_100C_1v80 | 5.99 | 0.34 | 0.00 | 0.00 | PASS |

**Completed log files:** 16 / 16

**No reported violations in extracted metrics:** 12 / 16
