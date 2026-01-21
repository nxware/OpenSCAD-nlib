
r=7.5;

module move(x=0,y=0,z=0) {
  translate([x,y,z]) children();
}
module m(x=0,y=0,z=0) {
  translate([x,y,z]) children();
}
module moveR(x=0,y=0,z=0,r=7.5) {
  translate([x*r,y*r,z*r]) children();  
}

module blue() {
  color("blue") children();
}
module red() {
  color("red") children();
}
module green() {
  color("green") children();
}
module white() {
  color("white") children();
}
module black() {
  color("black") children();
}

module balken(steps, boden=0.0, xr = true, yr=true) {
  if (boden>0) translate([-3.75, -3.75, 1.25]) { 
        cube([steps*7.5, 7.5, boden]);
  }
  difference() {
    translate([steps*7.5/2-7.5/2, 0, 5]) { 
        cube([steps*7.5, 7.5, 7.5], center = true);
    }
    for (a =[0:steps-1]) {
      translate([a*7.5,0,0]) cylinder(r=1.5,h=10, $fn=16);
    }
    if (yr) for (a =[0:steps-1]) {
      rotate(a=90, v=[1,0,0])translate([a*7.5,5,-5]) cylinder(r=1.5,h=10, $fn=16);
    }
    if (xr) translate([-5,0,5]) rotate(a=90, v=[0,1,0]) cylinder(r=1.5,h=8*steps+2, $fn=16);
  }
}

module balkenZ(length = 5, xr = true, yr=true, boden=0) {
  for(i=[0:length-1]) {
    if (i==0) {
      move(z=7.5*i)balken(1, boden, xr, yr);
    } else {
      move(z=7.5*i)balken(1, 0, xr, yr);
    }
  }
}

module raster(x,y, height = 10, r_size=7.5) {
  for (xx =[0:x-1]) {
    for (yy =[0:y-1]) {
      translate([xx*r_size,yy*r_size,0]) cylinder(r=1.5,h=height+10, $fn=16);
    }
  }  
}

module box(width, depth, height, raster_boden = true, wand = 1) {
    union() {
      difference() { // Boden
        cube([depth,width,wand]);
        if (raster_boden) {
          translate([3.75,3.75+(width%7.5/2)]) {
            raster(floor(depth/7.5), floor(width/7.5));
          }    
        } 
      }
      
      difference() {
        translate([0, -wand, 0] )cube([depth,wand,height+wand]);
        rotate (a=90, v=[1,0,0]) translate([3.75,3.75,-4]) {
          raster(floor(depth/7.5), floor(height/7.5));
        }
      }
      difference() {
        translate([0, width, 0] )cube([depth,wand,height+wand]);
        rotate (a=90, v=[1,0,0]) translate([3.75,3.75,-width-4]) {
          raster(floor(depth/7.5), floor(height/7.5));
        }
      }
      //translate([-wand, -wand, 0] )cube([1, width+2*wand,height]);
      //translate([depth, -wand, 0] )cube([1, width+2*wand,height]);
    }
}

module akkubox_18650_1x4(height = 22, cells = 3, boden_aussparung = true, boden= true, anschluss = true) {union() {
  width = 20.5*cells + ((cells==1)?2:0); // 1=22.5
  ecke4 = cells == 1 ? 0 : 1;
  difference() { // 82/4=20.5    3x->61.5
    union() {
      if (boden) color("green") {cube([77,width,1]);} 
      color("blue") translate([-7.5,0,0])cube([7.5,width,1]);
      translate([77,0,0])cube([7.5,width,1]);
      translate([-7.5,0,0])cube([7.5,7.5,height]);// ecke unten rechts
      translate([-7.5,width-7.5,0])cube([7.5,7.5,height]);
      translate([77,width-7.5,0])cube([7.5,7.5,height]);
      color("pink")translate([77,ecke4*(4)*7.5,0])cube([7.5,7.5,height]);
    }
    if (boden_aussparung) {
      color("red") translate([10,5,0]) {cube([57,width-10,1]);} // aussparung
    }
    translate([-3.75,3.75,-10]) cylinder(r=1.5,h=70, $fn=16);
    translate([-3.75,width-3.75,-10]) cylinder(r=1.5,h=70, $fn=16);
    translate([77+3.75,width-3.75,-10]) cylinder(r=1.5,h=70, $fn=16);
    color("pink")translate([77+3.75,(ecke4*4+1)*7.5-3.75,-10]) cylinder(r=1.5,h=70, $fn=16);
  }
  // Waende
  difference() {
    translate([-7.5,-1,0])cube([15+77,1,max(height, 1)]); // hohe Wand, fuer co2 hier height-15
    if (anschluss) {translate([77+3.75,40+width-6*7.5-3.75,10]) rotate([90,0,0]) cylinder(r=2.1,h=70, $fn=16);
    }
  }
  translate([-7.5,width,0])cube([15+77,1,height]);// Aussenwand
  translate([-7.5,0,0])cube([1,width,height]); // kurze Wand
  translate([77+6.5,0,0])cube([1,width,height]); // kurze Wand, hinten
}}


module arca_plate(top_height = 3, length = 5, raster = true) {
  difference() {
    translate([-42/2,0,0]) {
      linear_extrude(height = length) {
        polygon([
          [0,0], [16,0], [18,2], [23.5,2], [25.5,0], [42, 0], 
          [38,4], [38, 4+top_height], [4,4+top_height], [4,4]]);   
      }
    }
    translate([0, 10, 3.75]) rotate([90,0,0])raster(1,floor(length/7.5));
  }  
}

module arca_aufnehmer(length = 7.5*14, raster = true, 
                    rand = true, aufrastern = true,
                    feststeller = true, festhalter = true) {
difference() {
  union() {
    linear_extrude(length)move(y=-27.25)polygon([
       [24.475,18.2366 ],[ 17.4926,18.2366 ],[ 22.475,23.2366 ],
       [ 19.3651,23.2366 ],[ 17.4376,25.2941 ],[ 13.1625,25.2941 ],
       [ 11.2922,23.2366 ],[ 5.07634,23.2366 ],[ 3.42274,25.2366 ],
       [ -2.97758,25.2366 ],[ -4.62634,23.2366 ],[ -10.7322,23.2366],
       [ -12.5714,25.2941 ],[ -17.0672,25.2941 ],
       [ -18.5383,23.2366 ],[ -21.525,23.2366 ],[-16.5189,18.2366 ],
       [ -24.525,18.2366],[ -24.525,27.2366 ],[ 24.475,27.2366]
    ]);
    if (aufrastern) {
      move(7.5*3, -7.5-1.5)cube([3.75, 1.5+7.5,length]);
      move(-7.5*4+3.75, -7.5-1.5)cube([3.75, 1.5+7.5,length]);
    }
    if (feststeller) {
      if (rand) {
        difference() {
            color("blue")move(-33.75,-9)cube([7.5,9,30]);
            move(-30,z=3.75)rotate([90,0,0])m3hole();
        }
      } else {
        color("blue")move(-32,-9)cube([7.5,9,30]);
      }
    }
  }
  if(raster)for(i=[0:ceil(length/7.5)]) {
    move(z=3.75+i*7.5)rotate([90,0,0])m3hole();
    move(-15,z=3.75+i*7.5)rotate([90,0,0])m3hole();
    move(15,z=3.75+i*7.5)rotate([90,0,0])m3hole();
  }
  move(-35,-6.5,22.5)rotate([0,90,0])m3hole();  
  if (feststeller) {
    move(-30,-6.5,22.5)rotate([0,90,0])cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, h=3, $fn=6);
    move(-30,-26.5,19.20)cube([3,20, 6.75]);
  }
}
if (festhalter) {
  move(-22,-9)cube([44,9,2]);
}
if (rand) {
  difference() {
    move(7.5*3, -7.5-1.5)cube([7.5+3.75, 1.5+7.5,length]);
    for(i=[0:ceil(length/7.5)])move(7.5*4,z=3.75+i*7.5)rotate([90,0,0])m3hole();
  }
  if (feststeller) {
    difference() { // Seite des feststellers
    move(-7.5*5+3.75, -7.5-1.5,7.5*4)cube([7.5+3.75, 1.5+7.5,length-7.5*4]);
    for(i=[0:ceil(length/7.5)])move(-7.5*4,z=3.75+i*7.5)rotate([90,0,0])m3hole();
  }
  } else {
  difference() { // Seite des feststellers
    move(-7.5*5+3.75, -7.5-1.5)cube([7.5+3.75, 1.5+7.5,length]);
    for(i=[0:ceil(length/7.5)])move(-7.5*4,z=3.75+i*7.5)rotate([90,0,0])m3hole();
  }
  }
}
}


module ring(d=55, thickness =5, h=5, $fn=64) {
  difference() {
    cylinder(d=d, h=h, $fn=$fn);
    translate([0,0,-1])cylinder(d=d-thickness, h=h+2, $fn=$fn);
    
  }    
}

module rotateMultiply(x=20, count=3) {
  for(i=[0:count]) {
     rotate([0,0,(360/count)*i])translate([x, 0, 0])children();  
  }
}

module cubec(x=10, y=10, z=7.5) {
	translate([-x/2,-y/2, 0])cube([x,y,z]);
}

module cubex(x=10, y=10, z=7.5) {
	translate([-x/2,0, 0])cube([x,y,z]);
}

module m3hole(h=20, d=3) {
  move(z=-1)cylinder(d=d, h=h, $fn=16);
}

module m3holeX(h=20, r=1.5) {
  rotate([0,90,0])cylinder(r=r, h=h, $fn=16);
}
module m3holeY(h=20, r=1.5) {
  rotate([-90,0,0])cylinder(r=r, h=h, $fn=16);
}

module zoverhang(width=7.5) {
  move(3.75,7.5, 7.5) rotate([0,90,180])linear_extrude(width)polygon([[0,0,], [0,7.5], [7.5, 7.5]]);
}

module dreieckN(x=10,y=5,z=20) {
  //move(0,0,z)
  //move(z=z)  
 move(y=y) rotate([0,-90,90])
  linear_extrude(y)polygon([[z,0],[0,0],[z, x]]);
}

module dreieckP(x=10,y=5,z=20) {
  //move(0,0,z)
  //move(z=z)  
   move(y=y) rotate([0,-90,90])
  linear_extrude(y)polygon([[z,0],[0,x],[z, x]]);
}


module erweiterung2xZ(length = 2, w = 7.5) {
  move(z=15)rotate([-90,0,0])linear_extrude(height = w) 
      polygon([[0,0], [0, 15], [7.5, 0]]);
  if (length!=0)move(3.75,3.75,-1.25) {
    for(i=[2:length+1])move(z=7.5*i)balken(1);
  }
}



module schamier(h=0) {
  difference() {
    hull() {
      cube([7.5,7.5,2+h]);
      move(0,3.75,3.75+2+h)rotate([0,90,0])cylinder(d=6,h=7.5,$fn=32);
    }
    move(-1,3.75,3.75+2+h)rotate([0,90,0])cylinder(r=1.6,h=9,$fn=32);
  }
}

module trapez(x1=10, x2=5, y=50, z=10) {
rotate([90,0,0])linear_extrude(y)polygon([[-x1/2,0],[x1/2,0],[x2/2,z],[-x2/2,z]]);
}

module abdeckung(x=30,y=60) { // h=4
  x_offset = 15;
  y_offset = 7.5;
  difference() {
    move(-(x+x_offset)/2,-y-y_offset)
      cube([x+x_offset,y+y_offset,4]);
    move(0,0)trapez(x,x+2,y,3);
    move(-(x-2)/2,-y)cube([x-2,y,10]);
  }
}

module abdeckung_einschub(x=30,y=60,wand=1.75) { // h=4
  x_offset = 15;
  y_offset = 7.5;
  difference() {
    union() {
      move(0,0)trapez(x,x+2,y,3);
      move(-(x-2)/2,-y)cube([x-2,y,4]);
    }
    move(-5,-y)cube([1,30,5]);
    move(4,-y)cube([1,30,5]);
    move(-7.5,-25,1)rotate([15,0,0])cube([15,15,15]);
    move(-4,-y,-5)cube([8,wand,7]);  
  }
  hull() {
    move(-4,-y+wand,-2.25)cube([8,1,6]);
    move(-4,-y+wand+10,0)cube([8,2,1]);
  }
}
//abdeckung_einschub();

module vier(x,y) {
  move(x,y)children();
  move(x,-y)children();
  move(-x,y)children();
  move(-x,-y)children();
}

module cube_rounded(x,y,z,r=2) {
  hull() {
    move(r,r)cylinder(d=r*2,h=z,$fn=24);
    move(x-r,r)cylinder(d=r*2,h=z,$fn=24);
    move(r,y-r)cylinder(d=r*2,h=z,$fn=24);
    move(x-r,y-r)cylinder(d=r*2,h=z,$fn=24);
  }
}

module m_nut(sw=10, h=5) {
  cylinder(r = sw/ 2 / cos(180 / 6) + 0.05, h=h, $fn=6);
}

module m3_nut(h=5) {
  cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, h=h, $fn=6);
}
module m4_nut(h=3.5) {
  cylinder(r = 7 / 2 / cos(180 / 6) + 0.05, h=h, $fn=6);
}
module m6_nut(h=5.25) {
  cylinder(r = 10 / 2 / cos(180 / 6) + 0.05, h=h, $fn=6);
}
module m8_nut(h=8) {
  cylinder(d=15.5, h=h, $fn = 6);
}

 module kranz(r15=false, r30=false, r30m8=false, r45m8=false) {
  if (r15) {
    move(z=0.3)for(i=[0:11])rotate([0,0,360/12*i])move(15)m3hole(99); 
  }
  if (r30) {
    move(z=0.3)for(i=[0:11])rotate([0,0,360/12*i])move(30)m3hole();     
    for(i=[1,3,5,7,9,11])rotate([0,0,360/12*i])move(30)m3hole(d=8); 
    for(i=[3,7,11])rotate([0,0,360/12*i])move(30)m3hole(d=20);  
  }
  if (r30m8) {
    for(i=[0:11])rotate([0,0,360/12*i])move(30)m3hole(d=8); 
  }
  if (r45m8) {
    for(i=[0:11])rotate([0,0,360/12*i])move(45)m3hole(d=8); 
  }
}


module trapez(x1, x2, y, z) {
  linear_extrude(z)polygon(points=[[-x1/2,0],[x1/2,0],[x2/2,y],[-x2/2,y]]);
}

module rx(angle= 90) {
  rotate([angle, 0,0])children();
}
module ry(angle= 90) {
  rotate([0,angle, 0])children();
}
module rz(angle= 90) {
  rotate([0,0,angle])children();
}