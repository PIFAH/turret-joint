// Magnet coupler has 3 parts that are glued together:
// 1) Actuator connector which there are two types
// 2) Magnet connector which is a cup that holds the magnet
// 3) Magnet plug which holds the magnet in the cup

// Copyright Robert Gatliff, 2016.

// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.

// Modifications by Robert L. Read, 2016

// magnet dimensions:

// For 1/2" long and 1/4" in diameter:
// mag_d=(25.4/4)+1.0; // adding 1 mm for easier insertion.
// mag_h=25.4/2 + 0.5; // adding a fudge to slight it in easier.

// For 1" long and 1/2" in diameter:
mag_d=(25.4/2)+1.0; // adding 1 mm for easier insertion.
mag_h=25.4/1 + 0.5; // adding a fudge to slight it in easier.

wire_hole_diameter = 1.0; 
// mag_d=12; // magnet diam
// mag_h=3;  // magnet height

// magnet holder dimensions:
// lip_t=1;  // lip thickness of the cup that holds the magnet
// Rob will try half this:
lip_t = 0.8;

// coupler dimensions:
coupler_d  = 25; // coupler diameter at the mid section (where glued together)
coupler_h  = mag_h+5; // coupler height of each half
actuator_h = 16;
head_depth = 12; // actuator head depth into coupler

// actuator dimensions:
//   see actuator_head_and_bolt module
bolt_l = 35; // overly generous bolt length

// global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

// head and bolt - with the actuator standing on end, aligned on the z-axis,
//                 resting its extreme end on the x-y plane, and
//                 its bolt is positioned above and parallel the y-axis
//            
// hx  - head_x (width)
// hy  - head_y (thickness) 
// hz  - head_z (height)
// bd  - bolt_diameter
// b2e - bolt_to_end (edge of bolt hole to end of the actuator)
// bl  - bolt_length
module head_and_bolt(hx,hy,hz,bd,b2e,bl=bolt_l) {
  translate([-hx/2,-hy/2,0])  
  cube([hx,hy,hz]);
  
  translate([0,0,b2e+bd/2])  
    rotate([90,0,0])
      cylinder(d=bd,h=bl,center=true);
}

// defines each types of actuator head
module actuator_head_and_bolt(type)
{
    hz = 30;
  if (type=="pushrod")
    head_and_bolt(hx=9.5,hy=6, hz=hz, bd=4.5, b2e=4);
  else if (type=="stator")
    head_and_bolt(hx=11, hy=9, hz=hz, bd=4.5, b2e=5);
  else
    echo("BAD ACTUATOR TYPE");
}

// bd = base diameter
// ch = coupler height
// type = "pushrod" or "stator"
// hd = head depth
module actuator_connector(bd, ch, type, hd)
{
    hz = 30;
  difference() {
  difference() {
    cylinder(h=ch, d1=bd, d2=16);
    translate([0,0,ch-hd])  
      actuator_head_and_bolt(type);
  }
 if (type=="pushrod") 
     // we want to cut an additional cylinder to make room
    translate([0,0,ch-3])
  // adding fudge factor
    cylinder(h=ch,d=11+0.1);
  else if (type=="stator")
  // This is creating a problem for simplify3d for some unknown reason
    translate([12,0,(ch/2)+(ch-5)])
   cube([11,11,ch+10],center=true);
  else
    echo("BAD ACTUATOR TYPE");
  }
}

// bd = base diameter
// ch = coupler height
// md = magnet diameter
// lt = lip thickness
module magnet_connector(bd, ch, md, lt)
{
  difference() {
    cylinder(h=ch, d1=bd, d2=md+2*lt);
    union() {
      translate([0,0,-lt])  
        cylinder(h=ch, d=md);
      translate([0,0,-2*lt])  
        cylinder(h=ch+3*lt, d=md-2*lt);
    }  
      
  }
}

// bd = base diameter
// ch = coupler height
// md = magnet diameter
// lt = lip thickness
module magnet_connector_side_cut(bd, ch, md, mh, lt)
{
  difference() {
      magnet_connector(bd,ch,md,lt);
      
      // cut the slide hole....
      translate([0,md,(mh-1)/2 ])
      cube([md,md*2,mh+1],center=true);
// now cut a small hole that we can jam a steel wire through (like a twist tie).
      translate([0,bd/4,ch*1/3])
      rotate([0,90,0]) // lay it on its side...
      translate([0,0,-md*5]) // center...
      cylinder(h=md*10,d=wire_hole_diamter);
  }
}


// ch = coupler height
// md = magnet diameter
// mh = magnet height (thickness)
module magnet_plug(ch, md, mh)
{
  cylinder(d=md, h=ch-mh);   
}

// ------------------------
// default connector pieces
// ------------------------

module def_stator_connector()
{
  actuator_connector(bd=coupler_d, ch=actuator_h, type="stator", hd=head_depth);
}

module def_pushrod_connector()
{
  actuator_connector(bd=coupler_d, ch=actuator_h, type="pushrod", hd=head_depth);
}

module def_magnet_connector()
{
  magnet_connector(bd=coupler_d, ch=coupler_h, md=mag_d, lt=lip_t);
}

module def_magnet_connector_side_cut()
{
  magnet_connector_side_cut(bd=coupler_d, ch=coupler_h, md=mag_d,mh=mag_h, lt=lip_t);
}

module def_one_piece_connector(type="pushrod")
{
    union() {
        // let's fudge just a hair so no faces conincide:
        // Probably should just make the magnet_height just 
        // a bit bigger than reality to fit.
        translate([0,0,-0.5])
        if (type=="pushrod")
            def_pushrod_connector();
        else 
            def_stator_connector();
        rotate([180,0,0])
        def_magnet_connector_side_cut();
    }
}

module def_magnet_plug()
{
  // plug is a slightly smaller smaller than the magnet
  magnet_plug(ch=coupler_h, md=mag_d-1, mh=mag_h-0.5);
}

// --------
// examples
// --------

//translate([-40,0,0])
// def_pushrod_connector();

translate([0,30,0])
 def_one_piece_connector("pushrod");

translate([0,-30,0])
 def_one_piece_connector("stator");

//translate([-15,0,0])
// def_stator_connector();

 //translate([15,0,0])
//  def_magnet_connector_side_cut();

//translate([40,0,0])
//  def_magnet_plug();

