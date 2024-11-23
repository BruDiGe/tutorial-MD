#!/bin/bash
#SBATCH -J 6GGI-A               # Job name
#SBATCH --account=XXXX        # Tracking account
#SBATCH -t 3-00:00:00
#SBATCH -N 1
#SBATCH -p small-g             # Queue name (where job is submitted)
#SBATCH --gres=gpu:1
#SBATCH -o amber_restart.out                               # Combined output and error messages file
#SBATCH --mail-type=BEGIN,END,FAIL              # Mail preferences
#SBATCH --mail-user=bgeronimo3@gatech.edu

module load LUMI/24.03 partition/G
module load Local-CSC
module load PLUMED/2.9.2-cpeGNU-24.03-noPython
module load amber/24-gpu

PMEMD=pmemd.hip


top=6GGI-A.prmtop
inpcrd=6GGI-A.inpcrd
name=6GGI-A


#1.- Minimization steps
$PMEMD -O -i min1.in -o $name.min1.out -p $top -c $inpcrd -r $name.m1.rst -ref $inpcrd
$PMEMD -O -i min2.in -o $name.min2.out -p $top -c $name.m1.rst -r $name.m2.rst -ref $name.m1.rst
$PMEMD -O -i min3.in -o $name.min3.out -p $top -c $name.m2.rst -r $name.m3.rst -ref $name.m2.rst
##
###2.- Heating (100 --> 300K)
$PMEMD -O -i h.in -o $name.h.out -p $top -c $name.m3.rst -r $name.h.rst  -ref $name.m3.rst
##
###3.- Equilibration steps (=pre-production)
$PMEMD -O -i eq1.in -o $name.eq1.out -p $top -c $name.h.rst -r $name.eq1.rst -ref $name.h.rst
$PMEMD -O -i eq2.in -o $name.eq2.out -p $top -c $name.eq1.rst -r $name.eq2.rst -ref $name.eq1.rst
$PMEMD -O -i eq3.in -o $name.eq3.out -p $top -c $name.eq2.rst -r $name.eq3.rst -ref $name.eq2.rst
$PMEMD -O -i eq4.in -o $name.eq4.out -p $top -c $name.eq3.rst -r $name.eq4.rst -ref $name.eq3.rst
$PMEMD -O -i eq5.in -o $name.eq5.out -p $top -c $name.eq4.rst -r $name.eq5.rst -ref $name.eq4.rst
$PMEMD -O -i eq6.in -o $name.eq6.out -p $top -c $name.eq5.rst -r $name.eq6.rst -ref $name.eq5.rst
##
rm -f $name.md0.rst
ln -s $name.eq6.rst $name.md0.rst
##
#4.- MD production
for i in `seq 1 1 500`; do
echo $i
j=$((i-1))
$PMEMD -O -i md.in -o $name.md$i.out -p $top -c $name.md$j.rst -r $name.md$i.rst -x $name.md$i.dcd -ref $name.md$j.rst
#bzip2 $name.md$j.rst $name.md$j.nc
done
##
