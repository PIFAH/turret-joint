

    scale([2, 2, 2]) rotate([0,90,0]) translate([-4.65,3.2,-5]) import("/Users/baskaran/Desktop/scad proj/UNIVERSAL JOINT CUP.stl");
    
    
difference(){
    
    rotate([0,-90,0])translate([1.5,0,0]) import("/Users/baskaran/Desktop/scad proj/new/PI_Pot Sleeve.STL");
    
    rotate([0,90,0])translate([-9,6.5,-6])cylinder(7,10,10);

    



}







