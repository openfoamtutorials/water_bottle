//Inputs
bottleRadius = .04; // m
bottleLength = 0.2; // m
nozzleRadius = 0.5 * bottleRadius; // m
taperLength = 1.0 * bottleRadius; // m
domainDistance = 5 * bottleRadius; // m

insideLc = 0.05 * bottleRadius;
outsideLc = 1.0 * bottleRadius;

wedgeAngle = 5 * Pi / 180;

ce = 1;

// inside bottle
p0 = ce;
bottom = ce;
Point(ce++) = {0, 0, 0, insideLc};
lip = ce;
Point(ce++) = {nozzleRadius, 0, 0, insideLc};
Point(ce++) = {bottleRadius, taperLength, 0, insideLc};
Point(ce++) = {bottleRadius, bottleLength, 0, insideLc};
Point(ce++) = {0, bottleLength, 0, insideLc};

l0 = ce;
For k In {p0 : p0 + 3}
    Line(ce++) = {k, k + 1};
EndFor
Line(ce++) = {p0 + 4, p0};

outerlines[] = {l0};

Line Loop(ce++) = {l0 : l0 + 4};
innersurface = ce;
Plane Surface(ce++) = {ce - 2};

// outside bottle
p0 = ce;
Point(ce++) = {nozzleRadius + insideLc, 0, 0, insideLc};
Point(ce++) = {bottleRadius + insideLc, taperLength, 0, outsideLc};
Point(ce++) = {bottleRadius + insideLc, bottleLength + insideLc, 0, outsideLc};
top = ce;
Point(ce++) = {0, bottleLength + insideLc, 0, outsideLc};

l0 = ce;
Line(ce++) = {lip, p0};
For k In {p0 : p0 + 2}
    Line(ce++) = {k, k + 1};
EndFor

outerlines[] += {l0 : l0 + 3};

// outer domain
p0 = ce;
Point(ce++) = {0, domainDistance + bottleLength, 0, outsideLc};
Point(ce++) = {domainDistance, domainDistance + bottleLength, 0, outsideLc};
Point(ce++) = {domainDistance, -domainDistance, 0, outsideLc};
Point(ce++) = {0, -domainDistance, 0, outsideLc};

l0 = ce;
Line(ce++) = {top, p0};
For k In {p0 : p0 + 2}
    Line(ce++) = {k, k + 1};
EndFor
Line(ce++) = {p0 + 3, bottom};

outerlines[] += {l0 : l0 + 4};

Line Loop(ce++) = outerlines[];
outersurface = ce;
Plane Surface(ce++) = {ce - 2};

// rotate
Rotate {{0,1,0}, {0,0,0}, wedgeAngle/2}
{
  Surface{innersurface, outersurface};
}

// extrude
domainEntities[] = Extrude {{0,1,0}, {0,0,0}, -wedgeAngle}
{
  Surface{innersurface, outersurface};
  Layers{1};
  Recombine;
};

Physical Surface("wedge0") = {innersurface, outersurface};
Physical Surface("wedge1") = {domainEntities[{0, 6}]};
Physical Surface("walls") = {domainEntities[{3 : 5, 9 : 15}]};

Physical Volume("interior") = {domainEntities[1]};
Physical Volume(1000) = {domainEntities[7]};
