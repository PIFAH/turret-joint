// This is an attempt to build a pneumatic system out of NinjaFlex.
// This is very experimental; I am not entirely sure what this will be.
// The first experimeis to try to make bellows-based actuator 
// that just proves that we can make a channel, a bellows, and 
// separate the action from the peneumatic force.

bnumber = 4;
bsection_height_mm = 4.5;
bradius_inner_mm = 2;
bradius_outer_mm = 7;
horizontal_thickness = 0.4;
link_length_mm = 10;
link_od_mm = 5;
link_id_mm = 2;



// Thanks to nophead for this: http://forum.openscad.org/flattening-mixed-lists-of-lists-td12316.html
function depth(a) =
   len(a)== undef 
       ? 0
       : 1+depth(a[0]);

function flatten(l) = [ for (a = l) for (b = a) b ] ;

function dflatten(l,d=3) =
// hack to flatten mixed list and list of lists
    flatten([for (a = l) depth(a) > d ? dflatten(a, d) : [a]]);



// create the bellows shape
module bellows() {
    b = bsection_height_mm;
list1 = [ for (i = [0:bnumber-1]) [[bradius_inner_mm,(i*b)],[bradius_outer_mm,(i+0.5)*b],[bradius_inner_mm,i*b+b]]];
    
thick = horizontal_thickness;
list2 = [ for (j = [0:bnumber-1]) (let (i = (bnumber-1-j)) [[bradius_inner_mm+thick,i*b+b],
    [bradius_outer_mm+thick,(i+0.5)*b],[bradius_inner_mm+thick,i*b]])];

 bellows  = concat(list1,list2);

 lf = dflatten(bellows,1);

 rotate_extrude(convexity = 10)
// rotate([90,0,0]) // Note: This is great for seeing the shape for debugging!
 offset(r = 0.3,chamfer=true) 
 polygon( points=lf);
} 


module sealed_bellows() {
   bellows();
   cylinder(h = horizontal_thickness*2, d = bradius_inner_mm*(2+0.2),center=true);
   translate([0,0,bsection_height_mm*bnumber])
   cylinder(h = horizontal_thickness*2, d = bradius_inner_mm*(2+0.2),center=true);
}

module linked_bellows() {
  difference() {
    
    union() {
     translate([0,0,link_length_mm/2.0])
     sealed_bellows();
   
     rotate([0,180,0])
     translate([0,0,link_length_mm/2.0])
     sealed_bellows();
   
    // now add the pipe
      translate([0,0,-link_length_mm/2.0])
      cylinder(h = link_length_mm,d = link_od_mm,$fn=20);       
   }
 
   translate([0,0,-link_length_mm*1.1/2.0])
   cylinder(h = link_length_mm*1.1,d = link_id_mm,$fn=20);
  }      
}

linked_bellows();

// This is an attempt to make a simple triangle of hollow cylinders
// to be injected with salt water to see if we can determine the 
// change in the lenght of the cylinder by a change in resistance
module simple_capsule(h,d,f) {
    // create a cylinder
    union() {
      difference() {
        cylinder(h = h, d = d, $fn=20,center = true);
        cylinder(h = h*1.1, d = d*0.9, $fn=20,center = true);
      }
      translate([0,0,h/2])
      difference() {
        sphere(d = d,$fn=20);
        sphere(d = d*0.9,$fn=20);
      }
      mirror([0,0,1])
      translate([0,0,h/2])
      difference() {
        sphere(d = d,$fn=20);
        sphere(d = d*0.9,$fn=20);
      }
    }
}

module capsule_cut(h,d,f) {
     // create a cylinder
    union() {
        cylinder(h = h*0.95, d = d*0.88, $fn=20,center = true);
      translate([0,0,h*0.95/2])
        sphere(d = d*0.88,$fn=20);
      mirror([0,0,1])
      translate([0,0,h*0.95/2])
        sphere(d = d*0.88,$fn=20);
    }  
}

module hemisphere(od,id) {
    difference() {
        sphere(d = od,$fn = 20);
        sphere(d = id,$fn=20);
        translate([0,0,od])
        cube(size = od*2,center = true);
    }
}
module end_cap(d,f,td,h,angle) {
   translate([td,0,h/2])
   rotate([angle,0,0])
   color("red") hemisphere(d,d*f);
}
module simple_triangle() {
    h = 15;
    d = 2;
    f = 0.9;
    td = 4.3;
   
    difference() {
      union() {
        translate([td,0,0])
        simple_capsule(h,d,f);
        rotate([0,120,0])
        translate([td,0,0])
        simple_capsule(h,d,f);
        rotate([0,240,0])
        translate([td,0,0])
        simple_capsule(h,d,f);
        // now add end-caps due to mesh problem...
        end_cap(d*1.1,f,td,h,180);
        rotate([0,120,0])
        end_cap(d*1.1,f,td,h,180);
        rotate([0,240,0])
        end_cap(d*1.1,f,td,h,180);
     
      }
//      union() { // create cut tool
//        translate([td,0,0])
//        capsule_cut(h,d,f);
//        rotate([0,120,0])
//        translate([td,0,0])
//        capsule_cut(h,d,f);
//        rotate([0,240,0])
//        translate([td,0,0])
//        capsule_cut(h,d,f);
//      }
  }
}

rotate([90,0,0])
simple_triangle();
    






