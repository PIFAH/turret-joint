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
mag_d=(25.4/2)+2.0; // adding 2 mm for easier insertion.
mag_h=25.4/1 + 1.5; // adding a fudge to slide it in easier.

wire_hole_diameter = 4.0; 
// mag_d=12; // magnet diam
// mag_h=3;  // magnet height

// magnet holder dimensions:
// lip_t=1;  // lip thickness of the cup that holds the magnet
// Rob will try half this:
lip_t = 1.7;
lip_h = 1.0;

// coupler dimensions:
coupler_d  = 25; // coupler diameter at the mid section (where glued together)
coupler_h  = mag_h+5; // coupler height of each half
actuator_h = 16;
head_depth = 12; // actuator head depth into coupler

// actuator dimensions:
//   see actuator_head_and_bolt module
bolt_l = 35; // overly generous bolt length

// global resolution
$fs = 0.2;  // Don't generate smaller facets than 0.1 mm
$fa = 10;    // Don't generate larger angles than 5 degrees

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
 //   head_and_bolt(hx=9.5,hy=6, hz=hz, bd=4.5, b2e=4);
    head_and_bolt(hx=8.5,hy=7, hz=hz, bd=4.5, b2e=4);
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
    pushrod_diameter = 9;
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
    cylinder(h=ch,d=pushrod_diameter);
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
//    union() {
//      translate([0,0,-lt])  
//        cylinder(h=ch, d=md);
//      translate([0,0,-2*lt])  
//        cylinder(h=ch+3*lt, d=md-2*lt);
//    }  
      union() {
      translate([0,0,-lip_h])  
        cylinder(h=ch, d=md);
      translate([0,0,-2*lip_h])  
        cylinder(h=ch+3*lip_h, d=md-2*lt);
    }  
      
  }
}

// bd = base diameter
// ch = coupler height
// md = magnet diameter
// lt = lip thickness
module magnet_connector_side_cut(bd, ch, md, mh, lt)
{
    displace = 2;
  difference() {
      union() {
      magnet_connector(bd,ch,md,lt);
          // Adding in side flanges for stronger wiring in
          // of the magnet.
      translate([0,displace + bd/4,ch*1/2])
      rotate([0,90,0]) // lay it on its side...
      translate([0,0,-md*0.7]) // center...
      cylinder(h=md*1.4,d=wire_hole_diameter*3);
      }
      
      // cut the slide hole....
      translate([0,md,(mh-1)/2 ])
      cube([md,md*2,mh+1],center=true);
// now cut a small hole that we can jam a steel wire through (like a twist tie).
      translate([0,displace+bd/4,ch*1/2])
      rotate([0,90,0]) // lay it on its side...
      translate([0,0,-md*5]) // center...
      cylinder(h=md*10,d=wire_hole_diameter);
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

def_one_piece_connector("stator");

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

//translate([0,30,0])
// def_one_piece_connector("pushrod");

// translate([0,-30,0])
// def_one_piece_connector("stator");

//translate([-15,0,0])
// def_stator_connector();

 //translate([15,0,0])
//  def_magnet_connector_side_cut();

//translate([40,0,0])
//  def_magnet_plug();

/*
 *    polyScrewThread_r1.scad    by aubenc @ Thingiverse
 *
 * This script contains the library modules that can be used to generate
 * threaded rods, screws and nuts.
 *
 * http://www.thingiverse.com/thing:8796
 *
 * CC Public Domain
 */

module screw_thread(od,st,lf0,lt,rs,cs)
{
    or=od/2;
    ir=or-st/2*cos(lf0)/sin(lf0);
    pf=2*PI*or;
    sn=floor(pf/rs);
    lfxy=360/sn;
    ttn=round(lt/st+1);
    zt=st/sn;

    intersection()
    {
        if (cs >= -1)
        {
           thread_shape(cs,lt,or,ir,sn,st);
        }

        full_thread(ttn,st,sn,zt,lfxy,or,ir);
    }
}

module hex_nut(df,hg,sth,clf,cod,crs)
{

    difference()
    {
        hex_head(hg,df);

        hex_countersink_ends(sth/2,cod,clf,crs,hg);

        screw_thread(cod,sth,clf,hg,crs,-2);
    }
}


module hex_screw(od,st,lf0,lt,rs,cs,df,hg,ntl,ntd)
{
    ntr=od/2-(st/2)*cos(lf0)/sin(lf0);

    union()
    {
        hex_head(hg,df);

        translate([0,0,hg])
        if ( ntl == 0 )
        {
            cylinder(h=0.01, r=ntr, center=true);
        }
        else
        {
            if ( ntd == -1 )
            {
                cylinder(h=ntl+0.01, r=ntr, $fn=floor(od*PI/rs), center=false);
            }
            else if ( ntd == 0 )
            {
                union()
                {
                    cylinder(h=ntl-st/2,
                             r=od/2, $fn=floor(od*PI/rs), center=false);

                    translate([0,0,ntl-st/2])
                    cylinder(h=st/2,
                             r1=od/2, r2=ntr, 
                             $fn=floor(od*PI/rs), center=false);
                }
            }
            else
            {
                cylinder(h=ntl, r=ntd/2, $fn=ntd*PI/rs, center=false);
            }
        }

        translate([0,0,ntl+hg]) screw_thread(od,st,lf0,lt,rs,cs);
    }
}

module hex_screw_0(od,st,lf0,lt,rs,cs,df,hg,ntl,ntd)
{
    ntr=od/2-(st/2)*cos(lf0)/sin(lf0);

    union()
    {
        hex_head_0(hg,df);

        translate([0,0,hg])
        if ( ntl == 0 )
        {
            cylinder(h=0.01, r=ntr, center=true);
        }
        else
        {
            if ( ntd == -1 )
            {
                cylinder(h=ntl+0.01, r=ntr, $fn=floor(od*PI/rs), center=false);
            }
            else if ( ntd == 0 )
            {
                union()
                {
                    cylinder(h=ntl-st/2,
                             r=od/2, $fn=floor(od*PI/rs), center=false);

                    translate([0,0,ntl-st/2])
                    cylinder(h=st/2,
                             r1=od/2, r2=ntr, 
                             $fn=floor(od*PI/rs), center=false);
                }
            }
            else
            {
                cylinder(h=ntl, r=ntd/2, $fn=ntd*PI/rs, center=false);
            }
        }

        translate([0,0,ntl+hg]) screw_thread(od,st,lf0,lt,rs,cs);
    }
}

module thread_shape(cs,lt,or,ir,sn,st)
{
    if ( cs == 0 )
    {
        cylinder(h=lt, r=or, $fn=sn, center=false);
    }
    else
    {
        union()
        {
            translate([0,0,st/2])
              cylinder(h=lt-st+0.005, r=or, $fn=sn, center=false);

            if ( cs == -1 || cs == 2 )
            {
                cylinder(h=st/2, r1=ir, r2=or, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }

            translate([0,0,lt-st/2])
            if ( cs == 1 || cs == 2 )
            {
                  cylinder(h=st/2, r1=or, r2=ir, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }
        }
    }
}

module full_thread(ttn,st,sn,zt,lfxy,or,ir)
{
  if(ir >= 0.2)
  {
    for(i=[0:ttn-1])
    {
        for(j=[0:sn-1])
			assign( pt = [	[0,                  0,                  i*st-st            ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt-st       ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt-st   ],
								[0,0,i*st],
                        [or*cos(j*lfxy),     or*sin(j*lfxy),     i*st+j*zt-st/2     ],
                        [or*cos((j+1)*lfxy), or*sin((j+1)*lfxy), i*st+(j+1)*zt-st/2 ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt          ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt      ],
                        [0,                  0,                  i*st+st            ]	])
        {
            polyhedron(points=pt,
              		  triangles=[	[1,0,3],[1,3,6],[6,3,8],[1,6,4],
											[0,1,2],[1,4,2],[2,4,5],[5,4,6],[5,6,7],[7,6,8],
											[7,8,3],[0,2,3],[3,2,7],[7,2,5]	]);
        }
    }
  }
  else
  {
    echo("Step Degrees too agresive, the thread will not be made!!");
    echo("Try to increase de value for the degrees and/or...");
    echo(" decrease the pitch value and/or...");
    echo(" increase the outer diameter value.");
  }
}

module hex_head(hg,df)
{
	rd0=df/2/sin(60);
	x0=0;	x1=df/2;	x2=x1+hg/2;
	y0=0;	y1=hg/2;	y2=hg;

	intersection()
	{
	   cylinder(h=hg, r=rd0, $fn=6, center=false);

		rotate_extrude(convexity=10, $fn=6*round(df*PI/6/0.5))
		polygon([ [x0,y0],[x1,y0],[x2,y1],[x1,y2],[x0,y2] ]);
	}
}

module hex_head_0(hg,df)
{
    cylinder(h=hg, r=df/2/sin(60), $fn=6, center=false);
}

module hex_countersink_ends(chg,cod,clf,crs,hg)
{
    translate([0,0,-0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2, 
             r2=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             $fn=floor(cod*PI/crs), center=false);

    translate([0,0,hg-chg+0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
}

module screw_connector() 
{
    od = 8.0;
    st = 1.3;
    degrees = 30;
    length = 4;
    resolution_angle = PI/2;
    countersink_style = 1;
    disc_h = 3;
    overlap = 1;
    

    translate([0,0,-(disc_h + length*3) + overlap])
    screw_thread(od,st,degrees,length*3,resolution_angle,countersink_style);

    translate([0,0,-disc_h*1.5])
    cylinder(h=disc_h/2,d=coupler_d/2); 
    translate([0,0,-disc_h])
    cylinder(h=disc_h,d=coupler_d); 
    
    magnet_connector_side_cut(bd=coupler_d, ch=coupler_h, md=mag_d,mh=mag_h, lt=lip_t);
    
}
translate([0,30,0])
screw_connector();



