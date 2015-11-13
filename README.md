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

