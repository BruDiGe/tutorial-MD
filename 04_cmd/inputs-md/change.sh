#!/bin/bash

### script to change non-solvent residues in equilibration and heating

for i in eq?.in
do
 sed -i 's/1-240/1-2405/g' $i 
 sed -i 's/1-240/1-2405/g' h.in
done
