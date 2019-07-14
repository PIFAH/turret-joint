difference(){
    
    translate([80,25,-50]) import("/Users/baskaran/turret-joint/STLs/ScrewPushRodRotor.stl");
    
    
    
    
    
    translate([50,0,0])cube(100,100,100,center=true);



}








    scale([2, 2, 2]) rotate([0,-90,0]) translate([0,0,-12]) import("/Users/baskaran/Desktop/scad proj/SHAFT.stl");
