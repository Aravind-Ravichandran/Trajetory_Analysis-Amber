# import required modules
from __future__ import unicode_literals
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation

def updateline(num, data, line1, data2, line2):
    line1.set_data(data[..., :num])
    line2.set_data(data2[..., :num])
    
    return line1, line2

# generating data of 100 elements each for line 1
fat10 = np.loadtxt("C_terminal.dat", delimiter=",")
x = fat10[:, 0]
y = fat10[:, 1]
data = np.array([x, y])

# generating data of 100 elements each for line 2
Ubi = np.loadtxt("N_terminal.dat", delimiter=",")
x2 = Ubi[:, 0]
y2 = Ubi[:, 1]
data2 = np.array([x2, y2])

# setup the formatting for saving the animation
Writer = animation.writers['ffmpeg']
Writer = Writer(fps=625, metadata=dict(artist="Me"), bitrate=-1, codec='libx264')

# Adjust the size of the figure
fig = plt.figure(figsize=(10, 2.5))  # You can change the values (width, height) as needed

ax = fig.add_subplot(111)
l, = ax.plot([], [], 'r-', label="C-terminal", linewidth=1.5)
ax2 = ax.twinx()
k = ax2.plot([], [], 'k-', label="N-terminal", linewidth=1.5)[0]

ax.legend([l, k], [l.get_label(), k.get_label()], loc=2, frameon=False, fontsize=10)

ANGSTROM = "Å"
ax.set_xlabel("End-to-End Distance, (%s)" % ANGSTROM, fontweight='bold')
ax.set_ylabel('PMF(kcal/mol)', fontweight='bold')

# axis 1
ax.set_ylim(0, 500)
ax.set_xlim(0, 600)

# axis 2
ax2.set_ylim(0, 500)
ax2.set_xlim(0, 600)

plt.xticks(fontweight="bold")
plt.yticks(fontweight="bold")

line_animation = animation.FuncAnimation(fig, updateline, frames=12495, fargs=(data, l, data2, k))
line_animation.save("PMF_animation.mp4", writer=Writer, dpi=300)

