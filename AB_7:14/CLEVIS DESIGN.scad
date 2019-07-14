$fn = 100;
////////// PROJECT VARIABLES ////////// 
shaftD = 2.4;
stemD = 1.2;
stemH = 5;
clevisOD = 4;
clevisH = 7;
clevisB_thickness = .3;
pinHoleH = 8;
pinD = .75;

/////////// NATIVE VARIABLES ///////
shaftH = 7;
rotorStemD=1;
rotorStemH=3;



////////// IMPORTS //////////    


import("/Users/baskaran/Desktop/scad proj/UNIVERSAL JOINT CUP.stl");
translate([0,0,-3])color([1,0,0]) import("/Users/baskaran/Desktop/scad proj/SHAFT.stl");
////////// DEFINITIONS //////////     
