


// Some parameters for the Beholder Joint
// These units are in mm
ball_diameter = 100; // Ths inner ball of the Beholder
rotor_thickness = 10; // The thickness of the moving "rotors"
lock_thickness = 10; // The thickness of the locking shell
rotor_gap = 3; // a tolerance space to allow motion

// These units are in degrees
// some of these are explicitly created from my Gluss Pusher model
// 
least_spread_angle = 19.47;
most_spread_angle = 48.59;
hole_angle = most_spread_angle - least_spread_angle;

// the edge difference of the rotor to make sure it doesn't fall out
safety_lip_angle = 4;

// the angle of the post (at the surface of the rotor!)
post_half_angle = 4;








// Tetrahedron

// base coordinates
// source:  http://dmccooey.com/polyhedra/Tetrahedron.txt
// generated by  http://kitwallace.co.uk/3d/solid-to-scad.xq
Name = "Tetrahedron";
// 3 sided faces = 4
C0 = 0.353553390593273762200422181052;
points = [
[ C0, -C0,  C0],
[ C0,  C0, -C0],
[-C0,  C0,  C0],
[-C0, -C0, -C0]];
faces = [
[ 2 , 1, 0],
[ 3 , 0, 1],
[ 0 , 3, 2],
[ 1 , 2, 3]];
edges = [
[1,2],
[0,1],
[0,2],
[0,3],
[1,3],
[2,3]];
// --------------------------------- 

// I don't understand all that Kit Wallace did below
// I am going to try to 

// cut holes out of shell
eps=0.02;
radius=20;
shell_ratio=0.1;
prism_base_ratio =0.8;
prism_height_ratio=0.3;
prism_scale=0.5;
nfaces = [];
scale=1;

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
 

module cylindricalize_edges(e,points,rf) {
    for(e = edges) {
        p0 = points[e[0]];
        p1 = points[e[1]];
        color("red") cylinder_ep(p0, p1, C0/rf, C0/rf, $fn=20);
    }
}

module create_tetrahedron(rf) {
    // I'm not sure 109.5/2 is really right, but it seems to work.
   rotate([0,-(109.5/2),0]) 
    translate([-0.5,0,-C0]) rotate([0,0,45])  
    cylindricalize_edges(edges,points,rf);
}

// I am really making this a hemisphere now
// so that we can see into it.  That of course 
// can be changed later.
module beholderBall(d) {
        difference() {
            sphere(d);
            translate([-d,-d,0]) cube(2*d);
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

module beholderRotorsShell(d,buffer) {
    inner = d + rotor_gap;
    outer = inner + rotor_thickness;
    difference() {
        beholderBall(outer+buffer);
        sphere(inner-buffer);
    }
}

// A basic tetrahedronal tool is 
// an apex focusd on the origin, with 
// one peg along the x axis, and the 
// other two properly arranged
module tetrahedronalTool(r) {
    myrf = 
    scale(ball_diameter*4) create_tetrahedron(rf);
}

module tetrahedronal_cut_tool_for_shell(rf) {
    difference() {
       tetrahedronalTool(rf);
       beholderBall(ball_diameter);
    }
}

module tetrahedronal_lock() {
    difference() {
        beholderLock(ball_diameter);
        tetrahedronal_cut_tool_for_shell(4);
    }
}

module shell(id,od) {
    difference() {
        sphere(od);
        sphere(id);
    }
}
module tetrahedronal_rotors() {
// Now try to attach "pegs" to the rotor discs....
    union() {
       difference() {
            difference() {
                tetrahedronalTool(10);
                sphere(ball_diameter + rotor_gap + (rotor_thickness / 2.0));
           }
           shell(ball_diameter*2,ball_diameter*20);
        }
    difference() { // clean up
        difference() {
            color("green") beholderRotorsShell(ball_diameter,0);
            difference () {
                color("gray") beholderRotorsShell(ball_diameter,0.5);
                tetrahedronal_cut_tool_for_shell(2.8);
            } 
        }
    // Needed to clean up artifacts...
        d = ball_diameter;
        translate([-d*1.2,-d*1.2,-1]) cube(2.5*d);
    }
}

}



color( "Purple") beholderBall(ball_diameter);
color("yellow") beholderRotorsShell(ball_diameter);
tetrahedronal_rotors();
tetrahedronal_lock();

