//    TurretJoin.scad
//    Copyright 2015, Robert L. Read

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
    
    

// Some parameters for the Beholder Joint
// These units are in mm (I generall print all of this at 1/4th size!)
ball_radius = 100/4; // Ths inner ball of the Beholder
rotor_thickness = 10/4; // The thickness of the moving "rotors"
lock_thickness = 10/4; // The thickness of the locking shell
rotor_gap = 3/4; // a tolerance space to allow motion

mounting_clevis_height = 100/4;

// These units are in degrees
// some of these are explicitly created from my Gluss Pusher model
// 
least_spread_angle = 19.47;
most_spread_angle = 48.59;

screw_hole_radius_mm = 8/4; // This is a guess (this is guess for #4 machines screws when reduced by a factor of 4)
locking_peg_percent_tolerance = 5;


// the edge difference of the rotor to make sure it doesn't fall out
safety_lip_angle = 4;

// the angle of the post (at the surface of the rotor!)
post_half_angle = 2;

ball_locking_peg_width_factor = 10;
ball_locking_peg_height_factor = 4;
ball_locking__peg_tolerance_factor = 1.0;

three_hole_cap_seam_height_mm = 10/4;

module fake_module_so_customizer_does_not_show_computed_values() {
}

// Let's go for some high-res spheres (I don't fully understand this variable!)
$fa = 6;


// Computed parameters...
// Note that I implicitly assuming this hole is centered on the 
// tetrahedronal geomety---that is neither necessary nor obviously
// correct in the case of Gluss Triangle.  I will have to 
// generate the holes by a more general mechanism later.
hole_angle = most_spread_angle - least_spread_angle;
radius_at_rotor_edge = ball_radius+rotor_thickness+2*rotor_gap;
outermost_radius = radius_at_rotor_edge + lock_thickness;

hole_size_mm = radius_at_rotor_edge*2.0*sin(hole_angle/2);

rotor_size_mm = (ball_radius+rotor_thickness+2*rotor_gap)*2.0*sin((hole_angle+2*post_half_angle)/2.0);

post_radius_mm = radius_at_rotor_edge*sin(2*post_half_angle);

rotor_hole_angle = (most_spread_angle + least_spread_angle) / 2;


echo("Rotor Hole Angle");
echo(rotor_hole_angle);

//insert

// This code came from "Andrei" http://forum.openscad.org/Cylinders-td2443.html

module cylinder_ep(p1, p2, r1, r2) {
translate(p1)sphere(r=r1,center=true);
translate(p2)sphere(r=r2,center=true);
assign(vector = [p2[0] - p1[0],p2[1] - p1[1],p2[2] - p1[2]])
assign(distance = sqrt(pow(vector[0], 2) +
pow(vector[1], 2) +
pow(vector[2], 2)))
translate(vector/2 + p1)
//rotation of XoY plane by the Z axis with the angle of the [p1 p2] line projection with the X axis on the XoY plane
rotate([0, 0, atan2(vector[1], vector[0])]) //rotation
//rotation of ZoX plane by the y axis with the angle given by the z coordinate and the sqrt(x^2 + y^2)) point in the XoY plane
rotate([0, atan2(sqrt(pow(vector[0], 2)+pow(vector[1], 2)),vector[2]), 0])
cylinder(h = distance, r1 = r1, r2 = r2,center=true);
}

// lintrans is the linear translation along the p0 and p1 points to put the box.
module six_hole_box_ep(p1, p2, lintrans, w, d,h) {
assign(vector = [p2[0] - p1[0],p2[1] - p1[1],p2[2] - p1[2]])
assign(distance = sqrt(pow(vector[0], 2) +
pow(vector[1], 2) +
pow(vector[2], 2)))
translate(vector*lintrans + p1)
//rotation of XoY plane by the Z axis with the angle of the [p1 p2] line projection with the X axis on the XoY plane
rotate([0, 0, atan2(vector[1], vector[0])]) //rotation
//rotation of ZoX plane by the y axis with the angle given by the z coordinate and the sqrt(x^2 + y^2)) point in the XoY plane
rotate([0, atan2(sqrt(pow(vector[0], 2)+pow(vector[1], 2)),vector[2]), 0])
 difference() { // Cut six holes out!
cube([w,d,h],center=true);
translate([w/4,0,h/4]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);
translate([w/4,0,0]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);
translate([w/4,0,-h/4]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);
translate([-w/4,0,h/4]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);
translate([-w/4,0,0]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);
translate([-w/4,0,-h/4]) rotate([90,0,0]) cylinder(h=(w+h+d),r=screw_hole_radius_mm,center=true);

 }
}
 

module cylindricalize_edges(edges,points,rad) {
    for(e = edges) {
        p0 = points[e[0]];
        p1 = points[e[1]];
        color("red") cylinder_ep(p0, p1, rad, rad, $fn=20);
    }
}

// The purpose here is to produce a matching part that mates to 
// our rotor pegs for mounting a rod (like a carbon-fiber rod with a 
// 1/4" interior diameter, for example).
// This is a sloppy, ugly function --- I did this very hastily.
module six_hole_clevis() {
    p0 = [0,0,0];
    p1 = [100,0,0];
    width = hole_size_mm*0.8;
    depth = post_radius_mm*2;
    height = mounting_clevis_height;
    tolerance = 1;
    // This is for my particular carbon fiber connector rod, this really needs to be parametrized.
    difference() {
        union () {
             translate([0,depth+tolerance,0])
            color("gray") six_hole_box_ep(p0, p1, 0.0, width, depth, height, $fn=20);  
             translate([0,-depth+-tolerance,0])
           color("gray") six_hole_box_ep(p0, p1, 0.0, width, depth, height, $fn=20);  
                translate([-height*.81 + - depth/2,0,0])
            difference() {
            cube([depth*5,depth*3,depth*3],center=true);
                translate([depth*4.5,0,0])
                cube([depth*5,depth+tolerance*3,depth*4],center=true);
            }
        }
   
        translate([-height*1.4,0,0])
        rotate([0,90,0])
        difference() {
            // These are measured numbers in mm, but my STL is 4 times too big! Need to 
            // clean this up.
        color("blue") cylinder(h = depth*4,r = 4.5);
        color("red") cylinder(h = depth*4,r = 3);
        }

    }
}

module beamify_edges(edges,points,width,depth,height) {
    for(e = edges) {
        p0 = points[e[0]];
        p1 = points[e[1]];
        color("green") six_hole_box_ep(p0, p1, 0.37, width, depth, height, $fn=20);      
    }
}



// Create a tetrahedron-like strucutre with one point
// centered on the origin, symmetric about z axis,
// with an equilateral triangle as a base
// height - height of the pyrmid
// base - length of one side of the pyramid base
// r - raadius
module create_symmetric_3_member_polygon(height,base,r) {
    h = base*sqrt(3.0)/2.0;
    basehalf = base / 2.0;
    ZH = height;
points = [
    // first point is the origin
[ 0, 0, 0],
[ h*2/3,  0, -ZH],
[-h/3, -basehalf , -ZH],
[-h/3, basehalf, -ZH]];
edges = [
[0,1],
[0,2],
[0,3]
    ];
   cylindricalize_edges(edges,points,r); 
}

// Create a tetrahedron-like strucutre with one point
// centered on the origin, symmetric about z axis,
// with an equilateral triangle as a base
// height - height of the pyrmid
// base - length of one side of the pyramid base
// r - raadius
module create_symmetric_3_member_polygon_cube(height,base,r) {
    h = base*sqrt(3.0)/2.0;
    basehalf = base / 2.0;
    ZH = height;
points = [
    // first point is the origin
[ 0, 0, 0],
[ h*2/3,  0, -ZH],
[-h/3, -basehalf , -ZH],
[-h/3, basehalf, -ZH]];
edges = [
[0,1],
[0,2],
[0,3]
    ];
   beamify_edges(edges,points,hole_size_mm*0.8,post_radius_mm*2,mounting_clevis_height); 
}


module create_symmetric_3_member_polygon_polar(height,angle,r) {
    triangle_height = height*tan(angle)*3/2;
    base = triangle_height* 2 / sqrt(3.0);
    create_symmetric_3_member_polygon(height,base,r);
}

module create_symmetric_3_member_polygon_polar_cube(height,angle,r) {
    triangle_height = height*tan(angle)*3/2;
    base = triangle_height* 2 / sqrt(3.0);
    create_symmetric_3_member_polygon_cube(height,base,r);
}

module ball_locking_peg(width_factor = 10,height_factor = 4, tolerance_factor = 1.0) {
  translate([ball_radius/2,0,0]) cylinder(r = tolerance_factor * ball_radius/width_factor, h = tolerance_factor *ball_radius/height_factor,center = true);
}
module three_locking_pegs(tf) {  
 union() {
    rotate([0,0,0]) ball_locking_peg(tolerance_factor = tf);
    rotate([0,0,120]) ball_locking_peg(tolerance_factor = tf);
    rotate([0,0,240]) ball_locking_peg(tolerance_factor = tf);
 }
}

// I am really making this a hemisphere now
// so that we can see into it.  That of course 
// can be changed later.
module beholderBall(d) {
    difference() {
    union() {
        difference() {
            sphere(d);
            translate([-d,-d,0]) cube(2*d);
        }
        three_locking_pegs(1.0 - locking_peg_percent_tolerance/100.0);
    }
    rotate([0,0,60]) three_locking_pegs(1.0 + locking_peg_percent_tolerance/100.0);
}
}

module beholderLock(d) {
    inner = d + rotor_thickness + rotor_gap*2;
    outer = inner + lock_thickness;
    difference() {
        beholderBall(outer);
        sphere(inner);
    }
    
}

// WARNING: This is using a combination of global and local values
module beholderRotorsShell(d,buffer) {
    inner = d + rotor_gap;
    outer = inner + rotor_thickness;
    difference() {
        beholderBall(outer+buffer);
        sphere(inner-buffer);
    }
}

module equilateral_cut_tool_for_shell(rf) {
    difference() {
       create_symmetric_3_member_polygon_polar(ball_radius*4,rotor_hole_angle,rf);
       beholderBall(ball_radius);
    }
}

module planar_circle_cut_tool() {
              // rotate 30 degrees
            rotate([0,0,30])
            // Lay it onto x axix...
            rotate([0,90,0]) 
            cylinder(ball_radius*4,r=hole_size_mm/2);
}

module bolting_flange() { 
    translate([radius_at_rotor_edge+lock_thickness,0,-post_radius_mm])
    difference() {
    cylinder(r = hole_size_mm*0.4,h = post_radius_mm,$fn=20);
        translate([lock_thickness,0,-post_radius_mm])
         cylinder(r = screw_hole_radius_mm,h = post_radius_mm*4,$fn=20);
        translate([-ball_radius+-lock_thickness/2,-ball_radius/2,-ball_radius/2])
        cube(ball_radius);
    }
}

module bolting_flanges() {
    bolting_flange();
    rotate([0,0,120])
    bolting_flange();
    rotate([0,0,240])
    bolting_flange();
}

module snowflake_planar_cut_tool() {
    rotate([0,0,0]) planar_circle_cut_tool();
    rotate([0,0,60]) planar_circle_cut_tool();
    rotate([0,0,120]) planar_circle_cut_tool();
    rotate([0,0,180]) planar_circle_cut_tool();
    rotate([0,0,240]) planar_circle_cut_tool();
    rotate([0,0,300]) planar_circle_cut_tool();
}

module tetrahedronal_lock() {
    union() {
    difference() {
        beholderLock(ball_radius);
        equilateral_cut_tool_for_shell(hole_size_mm/2);
        // Now we will attempt to make the other cut outs...
        // These should split the angles of the tetrahedron...
        // So they should be rotate 30 degrees from the x-axis
       snowflake_planar_cut_tool();
    }
    color("green") bolting_flanges();
    }
}

// This is for a lock that works with a hemisphere
// and provides room for the snowflake cuts but does not use 
// a full ball.


module nine_hole_cap_lock() {
    seam_height = (hole_size_mm/2)*1.2;
    // Pythagorean theorem
    cap_radius = sqrt(outermost_radius* outermost_radius - seam_height*seam_height);
    union() {
        difference() {
            union() {  
                rotate([0,0,30]) rotate([180,0,0]) beholderBall(ball_radius);
                rotate([180,0,0]) tetrahedronal_lock();
            }
            translate([0,0,ball_radius/2+seam_height])
                cylinder(r = ball_radius * 2, h = ball_radius,center = true);
        }
        translate([0,0,seam_height])
        cylinder(r = cap_radius, h = lock_thickness,center = true);
    }
}

module three_hole_cap_lock() {

    seam_height = three_hole_cap_seam_height_mm;
    // Pythagorean theorem
    cap_radius = sqrt(outermost_radius* outermost_radius - seam_height*seam_height);
    union() {
        difference() {
            union() {  
                rotate([0,0,30]) rotate([180,0,0]) beholderBall(ball_radius);
                rotate([180,0,0]) tetrahedronal_lock();
            }
            translate([0,0,ball_radius+seam_height])
                cylinder(r = ball_radius * 2, h = ball_radius*2,center = true);
        }
        translate([0,0,seam_height])
        cylinder(r = cap_radius, h = lock_thickness,center = true);
    }
}

module shell(id,od) {
    difference() {
        sphere(od);
        sphere(id);
    }
}

module tetrahedronal_pegs() {
    union() {
      difference() {
            difference() {
                create_symmetric_3_member_polygon_polar(ball_radius*4,rotor_hole_angle,post_radius_mm);
                sphere(ball_radius + rotor_gap + (rotor_thickness / 2.0));
            }
            shell(ball_radius*1.5,ball_radius*20);
    }
    color("green") create_symmetric_3_member_polygon_polar_cube(ball_radius*4,rotor_hole_angle,post_radius_mm);
   }
}

module tetrahedronal_rotors() {
// Now try to attach "pegs" to the rotor discs....
    union() {
       tetrahedronal_pegs();
    difference() { // clean up
        difference() {
            color("green") beholderRotorsShell(ball_radius,0);
            difference () {
                color("gray") beholderRotorsShell(ball_radius,0.5);
               equilateral_cut_tool_for_shell(rotor_size_mm/2.0);
            } 
        }
    // Needed to clean up artifacts...
        d = ball_radius;
       translate([-d*1.2,-d*1.2,-1]) cube(2.5*d);
    }
    }
}

module one_tetrahedronal_rotor() {
    difference() {
        tetrahedronal_rotors();
        translate([-ball_radius*1.8,0,-ball_radius*2]) cube(ball_radius*4,center = true);
    }
}

// This is a mount for the pushod end of the 
// Clevis joint of a Firgelli miniactuator

// This really needs to be turned into a module reused in our other 
// work
module one_Firgelli_pushrod_rotor() {

    union() {
        // The spherical part of the rotor -- needs to cut with inverted tool!

 //      translate([-((ball_radius+rotor_gap+rotor_thickness)+(lock_thickness+5)),0,0])
 translate([-((ball_radius+5+2+lock_thickness*1.5+lock_thickness)),0,0])
       rotate([0,270,0])
       difference() {         
           beholderRotorsShell(ball_radius,0);
            // now make an cutting tool...
           difference() {
           beholderRotorsShell(ball_radius,5);
                rotate([0,180,0])
  //           cylinder(h = ball_radius*2, r1 = 0, r2 = 2*ball_radius*sin(theta), center = false);
               // Note: The is twice, so we double the rotor_size_mm
            cylinder(h = ball_radius*2, r1 = 0, r2 = (rotor_size_mm/2)*2, center = false);         
            }
                // cleanup
               cube([ball_radius*2.5,ball_radius*2.5,ball_radius/10],center=true);
        }
        // The post
        translate([-(lock_thickness+5),0,0])
        rotate([0,90,0])
        cylinder(r=post_radius_mm,h=lock_thickness*2,center=true,$fn=20);
        
        
    difference() {
        
     // construct the shell
        translate([-2,0,0])
    cube([10,8,12],center=true);
     // construct the cavity
        union() {
            // the real cavity
        cube([6,6,10],center=true);
            // cleanup
            translate([3,0,0])
            cube([10,6,10],center= true );
        }
    }
}
}

module beholder_joint() {
//    color( "Purple") beholderBall(ball_radius);
    tetrahedronal_rotors();
//    tetrahedronal_lock();
 //   translate([0,0,100])
//   nine_hole_cap_lock();

// translate([0,0,25])
// three_hole_cap_lock();
}



 beholder_joint();

// translate([-40,0,0])
//six_hole_clevis();

//one_tetrahedronal_rotor();

one_Firgelli_pushrod_rotor();







