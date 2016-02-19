$ballShiftCoeffFirst = 0.4;
$ballShiftCoeffSecond = -0.4;
$holeDiameterCoeff = 0.8;

//Make one part with hole
module makeOneFirstDummy(baseLength, baseWidth, hingeHeight) {
    difference(){
        union(){
            cube([baseLength, baseWidth, hingeHeight]);
            translate([0, baseWidth/2, hingeHeight])
            rotate([0, 90, 0])
            cylinder(baseLength, baseWidth/2, baseWidth/2);
        }
        translate([baseLength + baseWidth*0.5*$ballShiftCoeffFirst, baseWidth/2, hingeHeight])
        intersection(){
            sphere(baseWidth*0.5*$holeDiameterCoeff);
            translate([-baseWidth/2, 0, 0])
            cube(baseWidth, center=true);
        }
    }
}

//Make one part with pin
module makeOneSecondDummy(baseLength, baseWidth, hingeHeight) {
    union(){
        union(){
            cube([baseLength, baseWidth, hingeHeight]);
            translate([0, baseWidth/2, hingeHeight])
            rotate([0, 90, 0])
            cylinder(baseLength, baseWidth/2, baseWidth/2);
        }
        translate([baseLength + baseWidth*0.5*$ballShiftCoeffSecond, baseWidth/2, hingeHeight])
        intersection(){
            sphere(baseWidth*0.5*$holeDiameterCoeff);
            translate([baseWidth/2, 0, 0])
            cube(baseWidth, center=true);
        }
    }
}

//Make one part either with hole or pin
module makeOne(baseLength, baseWidth, hingeHeight, makeHole, center = false) {
    if(center) {
        translate([-baseLength/2, -baseWidth/2, 0])
        if(makeHole)
            makeOneFirstDummy(baseLength, baseWidth, hingeHeight);
        else
            makeOneSecondDummy(baseLength, baseWidth, hingeHeight);
    }
    else {
        if(makeHole)
            makeOneFirstDummy(baseLength, baseWidth, hingeHeight);
        else
            makeOneSecondDummy(baseLength, baseWidth, hingeHeight);
    }
}

//Make one side of hinge pair either.
//Hole side is outer
module makePair(base, hingeL, hingeW, hingeH, makeHole, easingL = 0.0) {
    if(makeHole) {
        makeOne(hingeL, hingeW, hingeH, makeHole);
        
        translate([base, 0, 0])
        mirror([1, 0, 0])
        makeOne(hingeL, hingeW, hingeH, makeHole);
    }
    else {
        translate([2*hingeL + easingL, 0, 0])
        mirror([1, 0, 0])
        makeOne(hingeL, hingeW, hingeH, makeHole);
        
        translate([base - 2*hingeL - easingL, 0, 0])
        makeOne(hingeL, hingeW, hingeH, makeHole);
    }
}

module makePairHole(base, hingeL, hingeW, hingeH) {
    makePair(base, hingeL, hingeW, hingeH, true);
}
module makePairPin(base, hingeL, hingeW, hingeH, easingL = 0.0) {
    makePair(base, hingeL, hingeW, hingeH, false, easingL);
}

module makePair2(hingeL, hingeW, hingeH, makeHole, easingL=0.0) {
    if(makeHole){
        union(){
            makeOne(hingeL/2, hingeW, hingeH, true);
            mirror([1, 0, 0])
            makeOne(hingeL/2, hingeW, hingeH, true);
        }
    }
    else {
        translate([hingeL+easingL/2, 0, 0])
        mirror([1, 0, 0])
        makeOne(hingeL/2, hingeW, hingeH, false);
        
        translate([-hingeL - easingL/2, 0, 0])
        makeOne(hingeL/2, hingeW, hingeH, false);
    }
}

//Example
$fn = 25;
//color("green")
//makePairHole(10, 1, 2, 3);
//makePairPin(10, 1, 2, 3, 0.1);

//makePairHole(10, 1, 2, 1);
//makePairPin(10, 1, 2, 1, 0.1);

%makePair2(2, 3, 2, true);
makePair2(2, 3, 2, false, 0.4);