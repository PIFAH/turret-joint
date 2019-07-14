# turret-joint
A three-dimensional joint for connecting up to 12 members to a central point allowing angular movement of members

### Note: After building this, I learned that it was essentially invented in 1999 as expressed in this [patent](https://patents.google.com/patent/US20010002964A1/en) by Se-Kyong Song, Dong-Soo Kwon, Wan Soo Kim. This joint should really be called the "Song Kwon Kim" or SKK joint in honor of them.  However, "turret-joint" better captures what it actually is shaped like.

## Motivation

This project is part of the Gluss project. (Click for introductory video.)

<a href="http://www.youtube.com/watch?feature=player_embedded&v=cpzPVwBoE_4
" target="_blank"><img src="http://img.youtube.com/vi/cpzPVwBoE_4/0.jpg"
alt="Glussionics introduction" width="240" height="180" border="10" /></a>

<iframe width="560" height="315" src="https://www.youtube.com/embed/cpzPVwBoE_4?list=PL9nAioXQFlE7_1zlxAb6CpyUpH4s4bhc8" frameborder="0" allowfullscreen></iframe>

In order to build a Gluss, we have to have a joint that can connect multiple members coming into a point.  In the Octet truss
configuration of Buckminster Fuller, this join is a cuboctahedron connecting up to 12 members, though more generally nine,
and with only 3 you can build a tetrahedron, the simplest 3D gluss robot.

But the joint must allow for motion.  In particular, in a Gluss model, it must support the widest and narrowest angle which
can be constructed by the individual Gluss members in the most fully and least fully extended configurations.

(Click to see YouTube video on GlussBot #1.)
<a href="http://www.youtube.com/watch?feature=player_embedded&v=SXRqqOAzkWg
" target="_blank"><img src="http://img.youtube.com/vi/SXRqqOAzkWg/0.jpg"
alt="Glussbot #1 Video" width="240" height="180" border="10" /></a>



This repo holds the physical designs of such a joint, which I call a "turret joint".

## Sharing and Patent Law

The Public Invention project does not seek patents on any of its inventions.
If someone knows of this being done before, please inform me. **I now know this was previously invented in 1999 by Song, Kwong and Kim.**

You are free to use anything you find in the repo under either the GPL or the Creative Commons Share-Alike license v4.0.

Public Invention seeks to give gifts to the whole world. If someone takes one of our freely published inventions and seeks a monopoly through a patent on it, it is directly counter to our mission, in addition to being fraudulent and illegal.

However, you are welcome to manufacture and sell a Turret Joint to your heart's content, since the Song Kwon Kim patent has expired. Certain improvements made by Public Invention will not be patented. We (and the inventor in this case, Robert L. Read) would appreciate attribution of those improvements, after crediting Song, Kwon and Kim with the basic idea..

## Notes and To-be-dones

I 3D printed some triangular rotors. However, I did it wrong.  I now believe I have to use more spherical trigonometry to produce curved edges, and also need to consider the case of three rotors coming together in the tightest possible packing. The result is likely to be a gently curved triangle---sort of an "inflated triangele", that is just a little bigger than the circular center.

### Sealing of Ninjaflex

I followed Mikey77's instructions for sealing ninjaflex using Loctite Frabric glue thinned with MEK. After the second coat, it seemd to work.  This opens up some possibilities. If I can inject salt water and and sense resistance change, then I may have created a very effective way of making multiple sensors at the same time with a 3D printer.

### I performed this experiment on Novemeber 13th.  I injected saltwater into my "dual bellows" ninjaflex contraption.  It reads bout 300 kilo Ohms.  This decreases as you squeeze it.  Unfortunately, the saltwater is incompressible, and using very much pressure at all somehow allows the saltwater to find a tiny hole in my apparatus and escape.  However, I can measure a variance in the resistance based on geometry.  I think improvements in this apparatus, to either allow more change in shape without changing the internal pressure, might allow us to make an effective, 3D printable sensor that can be printed in multiples. The printing of multiples in a given geometry at the same time is really the key to an inexpensive solution.  In fact it is even possible that we could make the electrodes out of "conductive PLA", a commercial product, and print with a dual-extruder 3D printer.  I will have to purchase some of that and try it.  However, I will also have to design a better "expandable" system than what I currently have.  It was hard enough to seal it (following Mikey77's instructable using fabric glue thinned with MEK) in the first place!

Note: It is also the case that the area of the electrode in the solution may strong affect the resistance.  I did a poor job with this, just heating some jumper wires and pushing them into place and then sealing with epoxy.  That will have to be controlled in a better version.

###

Note: in July 2019, Avinash Baskaran joined this project.
