# Aerobic Efficiency (simons_garmin_ae)

A Garmin Connect IQ data field for the fr965 that displays **Aerobic Efficiency (AE)** — meters traveled per heartbeat, scaled by 60 — during a workout.

## The logic

### Aerobic Efficiency

AE is calculated in [`compute()`](source/simons_garmin_aeView.mc) as:

```
AE = averageSpeed * 3600.0 / heartRate
```

`averageSpeed` is in meters/second, so multiplying by `3600.0` and dividing by heart rate (beats/minute) gives a "meters per heartbeat, per hour" style efficiency score: the higher the number, the more distance you're covering per heartbeat — i.e. the more aerobically efficient you are at that pace/effort.

### Why heart rate is smoothed

`Activity.Info.averageHeartRate` is reported as a whole-number integer by the device. Because AE divides by heart rate, every time `averageHeartRate` ticks over by a single beat (e.g. 148 → 149), the displayed AE jumps abruptly, even though your actual effort changed gradually.

To avoid this, the data field keeps its own smoothed heart rate using an **exponential moving average (EMA)**:

```
smoothed += alpha * (heartRate - smoothed)
```

with `alpha = 0.015`. Each time `compute()` runs, the smoothed value nudges toward the current `averageHeartRate` instead of jumping straight to it, so it drifts through fractional values (148.1, 148.2, ... 149) rather than snapping. AE is then computed using this smoothed value instead of the raw integer.

The EMA is:
- **Seeded** from the first valid heart rate reading of the activity (rather than starting at 0), so there's no artificial ramp-up at the start.
- **Reset** in `onTimerReset()`, so a new activity doesn't inherit the smoothed value left over from a previous one.

## Setup

This project is built with the Monkey C Connect IQ SDK and the VS Code Monkey C extension.

1. Read the Connect IQ basics: https://developer.garmin.com/connect-iq/connect-iq-basics/
2. Follow the getting started guide to install the SDK, the VS Code Monkey C extension, and set up a developer key: https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/#getting-started
3. Open this folder in VS Code.
4. Use the Monkey C extension commands (Command Palette) to build and run:
   - **Monkey C: Build Current Project** — compiles `source/` into `bin/simons_garmin_ae.prg`.
   - **Monkey C: Run** — launches the simulator with the built app.
   - **Monkey C: Build for Device** — produces a `.prg` you can copy to a real device's `GARMIN/APPS` folder.
