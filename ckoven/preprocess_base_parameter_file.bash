#! /bin/bash

## to run on ncar machine, do this:
#module load python/2.7.15
#ncar_pylib


DATE=`date +%Y%m%d`
param_file_dir=~/scratch/parameter_file_sandbox/
srcdir=~/ctsm/src/fates/

scriptdir=$srcdir/tools/ 

cd $srcdir
GITHASH=`git log -n 1 --format=%h`

echo $DATE

ncgen -o $param_file_dir/fates_params_default_$GITHASH.nc $srcdir/parameter_files/fates_params_default.cdl

cd $param_file_dir

descriptor=2PFTs_pureEDbareground_exp4

# make 2 clones of the tropical forest PFT
$scriptdir/FatesPFTIndexSwapper.py --fin fates_params_default_${GITHASH}.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --pft-indices=1,1

# set maximum crown area at 200 cm
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_dbh_maxheight --val 200

# use martinez-cano height allometry
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_hmode --val 5
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_d2h1 --val 57.6
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_d2h2 --val 0.74
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_d2h3 --val 21.6

# use chave AGB allometry
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_amode --val 3
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_agb1 --val 0.0673
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_agb2 --val 0.976
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_agb3 --val -999
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_agb4 --val -999

# set power-law crown area with capped crown area at dbh_maxh
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_lmode --val 3
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --allpfts --var fates_allom_d2bl3 --val -999

# decouple root from leaf biomass trimming logic
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_allom_fmode --val 2 --allpfts

# set disturbance parameters
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_comp_excln --val -1
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_mort_disturb_frac --val 1.0
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_mort_understorey_death --val 1.0

## kill off the second PFT entirely
#$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_recruit_initd --val 0 --pft 2

# increase history variable resolution for size, age, and height bins
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_history_ageclass_bin_edges --val 0,1,2,5,10,20,50,100,200 --changeshape
# $scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_history_sizeclass_bin_edges --val 0,1,1.221403,1.491825,1.822119,2.225541,2.718282,3.320117,4.0552,4.953032,6.049647,7.389056,9.025014,11.02318,13.46374,16.44465,20.08554,24.53253,29.9641,36.59824,44.70118,54.59815,66.68633,81.45087,99.48431,121.5104 --changeshape
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_history_sizeclass_bin_edges --val 0,1,1.221403,1.491825,1.822119,2.225541,2.718282,3.320117,4.0552,4.953032,6.049647,7.389056,9.025014,11.02318,13.46374,16.44465,20.08554,24.53253,29.9641,36.59824,44.70118,54.59815,66.68633,81.45087,99.48431,121.5104,148.41389376,181.27317508,221.40759986,270.42790669,330.30145651,403.43118989,492.75206562,601.84885121,735.09999241,897.85333603 --changeshape
$scriptdir/modify_fates_paramfile.py --fin fates_params_default_${GITHASH}_mod$descriptor.nc --fout fates_params_default_${GITHASH}_mod$descriptor.nc --O --var fates_history_height_bin_edges --val 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48 --changeshape

