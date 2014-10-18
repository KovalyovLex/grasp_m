#!/bin/bash
/usr/local/MATLAB/R2011b/bin/matlab -glnx86 -r "cd ~/Desktop/Dropbox/Matlab/grasp_m_develop/; grasp_startup;cd ~/Desktop/Dropbox/Matlab/grasp_compiled/grasp_linux_compiled32/;mcc -m grasp; exit"
cd ~/Desktop/Dropbox/Matlab/grasp_compiled/
zip -r ~/Desktop/Dropbox/Public/grasp/grasp_linux_compiledR2011b_32.zip grasp_linux_compiled32/


