#!/bin/sh

# Quit script if any step has error:
set -e

# Make the mesh:
gmsh mesh/main.geo -format msh2 -3 -o main.msh
# Convert the mesh to OpenFOAM format:
gmshToFoam main.msh -case case
# Adjust polyMesh/boundary:
changeDictionary -case case
# Let's set the initial conditions (water phase)
# First, let's load original alpha.water file.
cp case/0/alpha.water.original case/0/alpha.water
setFields -case case
# Finally, run the simulation:
interFoam -case case

