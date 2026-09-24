# Movey-Window-Demo
Copyright (c) 2026 Sedat Arıtürk. 

See [LICENSE](LICENSE) for details on this project and its dependencies' licenses.
See [CREDITS](CREDITS) for details on audiovisual assets used in this project.

Made with [LOVE2D](https://github.com/love2d/love), for LOVE2D

## What is this?

This is Movey-Window-Demo, made of

* a simple library (windowmover.lua)
* a set of example events (windowevents.lua)
* a simple example runtime (main.lua)

Demonstrating a simple window moving across the screen from a random list of set functions.

## Running the demo:
Install LOVE2D version 11.5 and set it up. Make sure "love" can run from your terminal.

Navigate in a terminal of your choice to the directory where you wish to store the demo.

`git clone https://github.com/sedat-34/Movey-Window-Demo`

`love Movey-Window-Demo`

## Interacting with the demo:

Upon launch, the window is positioned at the center of the screen with placeholder text.

Press any key (other than 1), and the engine will run the current queued command, initially selected randomly 
from its internal EVENTLISTs.

When one EVENTLIST ends, the window will move back to the center.

After this, pressing any key (other than 1) will load a new EVENTLIST.

This is only the demo functionality. In theory, the program can run any type of window movement,

and load any set of arbitrary scripts.

(provided that the movement can be recreated using the external library "flux". see legal info in LICENSE)

Limitations: While the window can be moved very well, rescaling is problematic.

Rapid resizing calls are really intensive to call. This makes it near-impossible to use

flux to change the scale. After heavy testing, the planned feature was abandoned.

The library still keeps track of the window's height and with, but only external scripts can

modify the scale.