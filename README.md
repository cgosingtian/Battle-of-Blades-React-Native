Battle-of-Blades
================

Battle of Blades Project: Battle enemies within a time limit by tapping randomly appearing buttons.


NOTE ON ABANDONED MEMORY:
The UILabels appearing in CALayers create overhead (though not as great so as to cause trouble), so repeatedly instantiating the Attack Buttons (which have a UILabel in its XIB) will increase the overhead over time.

The only remaining thing to do is to store the Attack Buttons in a Store object to cache them, just like how the images are cached.

Then, change how the buttons are spawned.
