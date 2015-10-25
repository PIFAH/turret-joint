# Major comoponents to place inside enclosure in simplest implementation

* Two (2) Seeed Studio [Motor Shields v2.0](http://www.seeedstudio.com/wiki/Motor_Shield_V2.0)
* One Arduino Uno
* A 12 volt lipo or lithium ion battery (currently unspecified). This will be a typical Radio controlled hobby battery of some kind.
* A radio board of some kind (currently unspecified. This is a lower priority.)

The enclusre hase five other requirements:

1. The Enclosure must be openable to allow the battery to be taken out and recharged.
2. It must be ventilated to allow waste heat (not too much, approximate 25 watts at most) to be ejected.
3. It must have (small) attachmentment points in approximately a tetrahedral configuration.  That is, it should have
3 attachment points at the base in an equilateral triangle, and one at the top at the center.  These can just be small holes
of any kind that we can bend the spring wires into.
4. It must fit within a 10 centimeter cube (10 centimeters on each side.)
5. It needs 4 entry points, each of which must be a slot 13 mms long and 4 mm wide.


## Future enhancements

In the future, we need each cell to drive up to 6 motors.  We may construct our own board using a cheap part like [http://www.robotshop.com/en/sn754410-dual-motor-driver.html](http://www.robotshop.com/en/sn754410-dual-motor-driver.html).

This would make the enclosure smaller, probably.

Eventually, there will be no need to use the Arduino shield structure, but rather we can layout a board of our own.  However, I think it best to stick with the Arduino shield geometry for now.

