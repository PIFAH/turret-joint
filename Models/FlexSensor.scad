//    FlexSensor.scad --- an attempt to build a flexible 3d printable linear position sensor
//    Copyright (C) 2015  Robert L. Read
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.


// My basic idea is to build a "Bellows", but water is incomprehensible
// so I intend to build a "dimple club" to allow volumetric change.



// Number of lobes in the top fold
NumLobesTop = 4;
// Number of lobes in the bottom fold
NumLobesBot = 4;
// Lobe crest-to-crest (in mm) 
LobeCrest = 10.0;
// Lobe max diameter (in mm)
LobeMaxDiameter = 25.0;
// Skin Width (in mm)
SkinWidth = 1.0;
// Collar height (in mm)
CollarHeight = 20.0;
// Collar thickness (in mm)
CollarThickness = LobeMaxDiameter;
// ColorSkinThickness (in mm)
CollarSkinThickness = 3.0;
// DimpleClub circle width (in mm)
DCCircle = 10.0;
// DimpleClub skin thickness (in mm)
DCSkin = 1.0;


// so ends the customizable parameters
module fake_module() {
}

// Lobe min diameter (in mm)
LobeMinDiameter = LobeMaxDiameter - LobeCrest;

// DimpleClub distance (in 5-ring configuration)
DCCDist = DCCircle / 4.0;

module Bellows() {
    r = LobeCrest/2;
    w = SkinWidth;
   
    translate([0,0,r]) 
    rotate_extrude(convexity= 20)
    rotate([0,0,90])
    translate([0,LobeMaxDiameter - r,0])
    union() {
    for (a =[0:NumLobesTop-1]) {     
        translate([a*LobeCrest*2,0,0])
        union() {
       2D_arc(w=w,r=r,deg=180,fn=200);
            translate([LobeCrest,0,0])
            rotate([0,0,180])
       2D_arc(w=w,r=r,deg=180,fn=200);
        }
    }
}

}

module Actuator() {
    translate([0,0,CollarHeight/2])
    Bellows();
    
    rotate([0,180,0])
    translate([0,0,CollarHeight/2])
    Bellows();
    
    // create collar
    difference() {
    cylinder(h = CollarHeight,d = CollarThickness,center=true);
    cylinder(h = CollarHeight*1.1,d = (CollarThickness - CollarSkinThickness*2),center=true);   
    }

    translate([LobeMaxDiameter/2,0,0])
    rotate([0,90,0])    
    DimpleClub();
}


function dist(x0,y0,x1,y1)  = sqrt( (x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));

module linear_bar(x0,y0,x1,y1,d) {
    len = dist(x0,y0,x1,y1);
    yd = (y1 - y0);
    xd = (x1 - x0);
    // sadly this does not get the quadrant right....  
    a = atan2(yd,xd);

    echo("a");
    echo(a);
  
    translate([x0,y0,0])
    rotate([0,0,a])
    scale([len,1,1])
    color("red") square(d,center = false);
}

// Our plan here is to to construct a rotational extrusion
// based on the "5 Ring Dimple Club Design".
module DimpleClub() {
    r = DCCircle / 2.0;
    w = DCSkin;
    x = DCCircle;
    
   rotate_extrude(convexity = 10)
 difference() {
  // cut away everything not in positve x   
 union() {
     
     // Thre furthest three rings...    
    translate([x+x/4,x/2 + x/8,0])
    rotate([0,0,-60])
    2D_arc(w=w,r=r,deg=200,fn=200);
  
  
    translate([0,(x/2 + x/8),0])
    rotate([0,0,210])
    2D_arc(w=w,r=r,deg=60,fn=200);
        
    translate([x*3/4,-(x/2 + x/8),0])
    rotate([0,0,80])
    2D_arc(w=w,r=r,deg=120,fn=200); 
    
 // now attempt to join the arcs.....
 
color("blue")
//linear_extrude(height = 1)
linear_bar(9.5,10.9,3.8,3.8,1);

color("blue")
// linear_extrude(height = 1)
linear_bar(5.5,-2.2,15,1.3,1);
}
//translate([-50,0,0])
//cube(size = 100, center= true);
}
    
    
}




/*
Plot a 2D or 3D arc from 0.1 to ~358 degrees.

Set Width of drawn arc, Radius, Thickness, resolution ($fn) and height for the 3D arc. Arc is centered around the origin

By tony@think3dprint3d.com
GPLv3

*/


module 2D_arc(w, r, deg=90,fn = 100 ) {
	render() {
		difference() {
			// outer circle
			circle(r=r+w/2,center=true,$fn=fn);
			// outer circle
			circle(r=r-w/2,center=true,$fn=fn);

		//remove the areas not covered by the arc
		translate([sin(90-deg/2)*((r+w/2)*2),
						-sin(deg/2)*((r+w/2)*2)])
			rotate([0,0,90-deg/2])
				translate([((r+w/2))-sin(90-(deg)/4)*((r+w/2)),
							((r+w/2))*2-sin(90-(deg)/4)*((r+w/2))])
					square([sin(90-deg/4)*((r+w/2)*2),
								sin(90-deg/4)*((r+w/2)*2)],center=true);
		translate([-sin(90-(deg)/2)*((r+w/2)*2),
						-sin(deg/2)*((r+w/2)*2)])
			rotate([0,0,-(90-deg/2)])
			  translate([-((r+w/2))+sin(90-(deg)/4)*((r+w/2)),
							((r+w/2))*2-sin(90-(deg)/4)*((r+w/2))])
					square([sin(90-deg/4)*((r+w/2)*2),
								sin(90-deg/4)*((r+w/2)*2)],center=true);
		}
		//line to see the arc
		//#translate([-((r)*2)/2, sin((180-deg)/2)*(r)]) square([(r+w/2)*2+1,0.01]); 
	}
}

module 3D_arc(w, r, deg, h,fn) {
	linear_extrude(h)
			2D_arc(w, r, deg,fn);

}




translate([10,0,0])
rotate([0,90,0])
DimpleClub();



 //Actuator();

 Bellows();


