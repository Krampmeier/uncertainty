# Uncertainty

A Keithley TSP script for estimating measurement uncertainty on the DMM6500 / DAQ6510 instrumentation platform.

This project calculates the uncertainty of the most recently measured value based on the active instrument configuration, including function, range, calibration interval, NPLC setting, and measurement conditions. It is intended to provide a practical view of absolute uncertainty, relative uncertainty, and error limits directly on the instrument display.

## Overview

The script is designed for Keithley instruments running the TSP scripting environment. It evaluates uncertainty for the current measurement configuration and exposes the result via the `getUncertainty()` function.

The main goal is to help users estimate how much uncertainty is associated with a reading under the current configuration, which is especially relevant in metrology, calibration, and precision measurement work.

## Features

- On-instrument dashboard for uncertainty display
- Absolute and relative uncertainty calculation
- Lower and upper error limit display
- Calibration interval selection
- Auto-trigger support for app-driven measurements
- Measurement improvement hints for better accuracy
- Support for several common Keithley measurement modes

## Supported measurement functions

The script includes uncertainty calculations for:

- DC voltage
- DC current
- Resistance
- 4-wire resistance
- Capacitance
- Diode
- AC voltage
- AC current

Some measurement types are not implemented yet, especially frequency-, temperature- and ratio-related functions.

## Repository structure

- `uncertainty.tspa` — main script containing the uncertainty logic and user interface. Only this file is needed on the meter.
- `logo_*.png` — script logo image files
- `app_logo.ods` — editable source asset for the application logo

## How it works

The script:

1. Reads the latest value from `defbuffer1`
2. Checks whether the reading is valid
3. Chooses the appropriate uncertainty function based on the active measurement mode
4. Calculates uncertainty using measurement range and calibration interval
5. Displays the result on the instrument screen

The most relevant function for remote automation is:

```lua
getUncertainty()