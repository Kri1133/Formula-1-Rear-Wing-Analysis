# Formula-1-Rear-Wing-Analysis
These programs are designed to plot Force vs Time and Cl and Cd vs Velocity 

# F1 Rear Wing Analysis

This repository contains scripts used to process and analyze aerodynamic simulation data (forces, coefficients, and wall resolution) for an F1 rear wing project.

---

## 📂 Contents

- `forces_analysis.m`  
  MATLAB script that:
  - Loads simulation output `.csv` files (forces vs time).  
  - Plots downforce (Fy) and drag (Fz) time series for each test speed.  
  - Computes average values after a cutoff time.  
  - Plots average forces vs velocity and vs velocity².  
  - Prints averages to the console.

- `yplus_tools.py`  
  Python script that:
  - Reads `y+` patch data from simulation output.  
  - Extracts per-patch values and raises errors if data is missing.  
  - Plots `y+` distributions for mesh quality checks.  

- `MCL39_forces.m`  
  Simple MATLAB script for:
  - Loading a single `.csv` forces file.  
  - Plotting total force in y and z directions vs time.  
  - Computing mean forces after a specified time threshold.

---

## ▶️ Usage

1. Place your simulation `.csv` files in a folder (e.g. `MCL39 data/forces/`).
2. Update the file paths at the top of the MATLAB scripts:
   ```matlab
   files = ["D:\F1 comparison report\MCL39 data\forces\20ms.csv";
            "D:\F1 comparison report\MCL39 data\forces\30ms.csv";
            ...];
