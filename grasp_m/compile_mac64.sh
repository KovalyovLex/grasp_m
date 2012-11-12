#!/usr/bin/env sh

# run Matlab, install GRASP env, and create stand-alone"
matlab -maci64 -r  "cd /Users/chuck/Desktop/grasp_m_develop; grasp_startup; cd ../grasp_mac_compiled64; mcc -m grasp; exit"

# create the GRASP launcher with Matlab RT being installed in 
#    /Applications/MATLAB/MATLAB_Compiler_Runtime/v711
cd /Users/chuck/Desktop/
echo '#!/usr/bin/env sh'  > grasp_mac_compiled64/go_grasp.sh
echo ./run_grasp.sh /Applications/MATLAB/MATLAB_Compiler_Runtime/v711 >>  grasp_mac_compiled64/go_grasp.sh
cd grasp_mac_compiled64
chmod 777 *.*
cd ..


# create the DMG
hdiutil create ./grasp64.dmg -srcfolder grasp_mac_compiled64 -ov
