# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\Git_Smash\ECE385_Smash\Smash_Bros\workspace\SMASH_TOP\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\Git_Smash\ECE385_Smash\Smash_Bros\workspace\SMASH_TOP\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {SMASH_TOP}\
-hw {C:\Users\Git_Smash\ECE385_Smash\Smash_Bros\SMASH_TOP.xsa}\
-out {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/workspace}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {SMASH_TOP}
platform generate -quick
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform clean
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform generate -domains 
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform generate
platform clean
platform clean
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform generate -domains standalone_microblaze_0 
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform generate
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/dvt80/OneDrive/Desktop/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/dvt80/OneDrive/Desktop/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/dvt80/OneDrive/Desktop/SMASH_TOP.xsa}
platform generate -domains 
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/dvt80/OneDrive/Desktop/SMASH_TOP.xsa}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/dvt80/OneDrive/Desktop/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform generate -domains 
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {SMASH_TOP}
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform clean
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
platform config -updatehw {C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/SMASH_TOP.xsa}
platform clean
platform generate
