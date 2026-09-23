# Movey-Window-Demo
Copyright (c) 2026 Sedat Arıtürk. 

See [LICENSE](LICENSE) for details on this project and its dependencies' licenses.

Made with [LOVE2D](https://github.com/love2d/love), for LOVE2D

## What is this?

This is Movey-Window-Demo, made of

* a simple library (windowmover.lua)
* a set of example events (windowevents.lua)
* a simple example engine

Demonstrating a simple window moving across the screen from a random list of set functions.

## Running the demo:
Install LOVE2D version 11.5 and set it up. Make sure "love" can run from your terminal.

 `git clone https://github.com/sedat-34/Movey-Window-Demo`

 `love Movey-Window-Demo`

## Interacting with the demo:
Upon launch, the window is positioned at the center of the screen with placeholder text.

Press any key, and the engine will run the current queued command, initially selected randomly from an internal "EVENTLIST".

When one EVENTLIST ends, the window will move back to the center.

After this, pressing any key will load a new EVENTLIST.

This is only the demo functionality. In theory, the program can run any type of window movement

(provided that the movement can be recreated using the external library "flux". see legal info in LICENSE)
