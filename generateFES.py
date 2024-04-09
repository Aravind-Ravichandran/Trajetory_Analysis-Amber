#!/usr/bin/python

import sys
import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import argparse
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.ticker import FixedLocator

#### Defining flags and help messages ############
parser = argparse.ArgumentParser()
parser.add_argument("-f", help="Input file with two columns of data")
parser.add_argument("-o", help="Output file, should be .png")
parser.add_argument("-t", help="Temperature in Kelvin", type=float)
parser.add_argument("-bx", help="resolution along x", type=int)
parser.add_argument("-by", help="resolution along y", type=int)
parser.add_argument("-lx", help="label x-axis")
parser.add_argument("-ly", help="label y-axis")

if len(sys.argv) < 14:
    parser.print_help()
    sys.exit(1)
else:
    args = parser.parse_args()

##### Variable Initializations ##########
infilename = args.f
outfilename = args.o
i1 = int(args.bx)
i2 = int(args.by)
T = float(args.t)
x_l = str(args.lx)  # .decode('utf8')
y_l = str(args.ly)  # .decode('utf8')

try:
    ifile = open(infilename, 'r')     # open file for reading
except:
    print("File does not exist")
    sys.exit(2)

V = np.zeros((i1, i2))
DG = np.zeros((i1, i2))

kB = 3.2976268E-24  # cal/K
An = 6.02214179E23

######## Reading in Data and determining span ###############
v1 = []
v2 = []
for line in ifile:
    if not line.startswith(('#', '@')):
        newline = line.rstrip('\r\n\t').split()
        if len(newline) >= 2:
            v1.append(float(newline[0]))
            v2.append(float(newline[1]))

minv1 = min(v1)
maxv1 = max(v1)
minv2 = min(v2)
maxv2 = max(v2)

################### Data span ####################
I1 = maxv1 - minv1
I2 = maxv2 - minv2

####################### Binning #####################
for i in range(len(v1)):
    for x in range(i1):
        if v1[i] <= minv1 + (x + 1) * I1 / i1 and v1[i] > minv1 + x * I1 / i1:
            for y in range(i2):
                if v2[i] <= minv2 + (y + 1) * I2 / i2 and v2[i] > minv2 + y * I2 / i2:
                    V[x][y] = V[x][y] + 1
                    break
            break

##### Finding the maximum ##############
P = list()
for x in range(i1):
    for y in range(i2):
        P.append(V[x][y])

Pmax = max(P)

##### Calculating Delta G values ##############
LnPmax = math.log(Pmax)

for x in range(i1):
    for y in range(i2):
        if V[x][y] == 0:
            DG[y][x] = 10
            continue
        else:
            DG[y][x] = -0.001 * An * kB * T * (math.log(V[x][y]) - LnPmax)  # kcal/mol

############# Plotting ####################
z_l = r'$\Delta G$' + ' [kcal/mol]'  # using LaTeX in matplotlib

# Create a figure with a fixed height and an adjusted width
fig, ax = plt.subplots(figsize=(2.5, 8), dpi=600)

im = ax.imshow(DG, cmap=cm.hot, extent=[minv1, maxv1, minv2, maxv2], origin='lower', aspect='auto')
ax.tick_params(axis='both', labelsize=15)

# Set the number of ticks along the x-axis
num_ticks = 5  # Adjust as needed

# Generate evenly spaced values within the range of minv1 to maxv1
x_tick_locations = np.linspace(minv1, maxv1, num_ticks)

ax.set_xticks(x_tick_locations)
xtick_labels = [f'{x:.1f}' for x in x_tick_locations]
ax.set_xticklabels(xtick_labels, rotation=45)  # Format labels to two decimal places

# Make the x-axis tick labels bold
for label in ax.get_xticklabels():
    label.set_weight('bold')
    
# Generate evenly spaced values within the range of minv2 to maxv2
y_tick_locations = np.linspace(1, 5, num_ticks)

ax.set_yticks(y_tick_locations)
ytick_labels = [f'{int(y)}' for y in y_tick_locations]
ax.set_yticklabels(ytick_labels)  # Format labels to two decimal places

# Make the y-axis tick labels bold
for label in ax.get_yticklabels():
    label.set_weight('bold')

# Adjust the margins for x-axis labels
plt.subplots_adjust(bottom=0.15, left=0.10, right=0.75, top=0.90)

divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="5%", pad=0.25)

cbar = plt.colorbar(im, cax=cax)
#cbar.set_label(z_l, size=14)

# Make the Delta G' label in the colorbar bold
cbar.ax.yaxis.label.set_weight('bold')

# Make the Delta G' label in the colorbar bold
cbar.set_label(z_l, weight='bold', size=14)

# Rotate the x-axis labels (adjust the rotation angle as needed)
plt.xticks(rotation=45)

# Save the plot as an SVG file
plt.savefig(outfilename, format='png')

ifile.close()
sys.exit(0)
