module makeOne(baseLength, baseWidth, hingeHeight, makeHole, center) {
    if(center == true)
        translate([-baseLength/2, -baseWidth/2, 0])
    union()
    cube([baseLength, baseWidth, hingeHeight]);
    translate([0, baseWidth/2, hingeHeight])
    rotate([0, 90, 0])
    cylinder(baseLength, baseWidth/2, baseWidth/2);
}

$fn = 25;
makeOne(1, 2, 3, makeHole=true);