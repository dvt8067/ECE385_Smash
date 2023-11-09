# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.runs/synth_1/SMASH_TOP.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param checkpoint.writeSynthRtdsInDcp 1
set_param chipscope.maxJobs 2
set_param synth.incrementalSynthesisCache C:/Users/ehoon2/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-3112-DESKTOP-MTC1J3G/incrSyn
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7s50csga324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.cache/wt [current_project]
set_property parent.project_path C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/IPrepo [current_project]
update_ip_catalog
set_property ip_output_repo c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_verilog -library xil_defaultlib -sv {
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/Color_Mapper.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/Palette.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/VGA_controller.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/ball.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/hex.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/imports/design_source/ram.sv
  C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/new/SMASH_TOP.sv
}
add_files C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/bd/mb_ball/mb_ball.bd
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_0/mb_ball_microblaze_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_0/mb_ball_microblaze_0_0_ooc_debug.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_0/mb_ball_microblaze_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_dlmb_v10_0/mb_ball_dlmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_ilmb_v10_0/mb_ball_ilmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_dlmb_bram_if_cntlr_0/mb_ball_dlmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_ilmb_bram_if_cntlr_0/mb_ball_ilmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_lmb_bram_0/mb_ball_lmb_bram_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_xbar_0/mb_ball_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_axi_intc_0/mb_ball_microblaze_0_axi_intc_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_axi_intc_0/mb_ball_microblaze_0_axi_intc_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_axi_intc_0/mb_ball_microblaze_0_axi_intc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_mdm_1_0/mb_ball_mdm_1_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_mdm_1_0/mb_ball_mdm_1_0_ooc_trace.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_clk_wiz_1_0/mb_ball_clk_wiz_1_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_clk_wiz_1_0/mb_ball_clk_wiz_1_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_clk_wiz_1_0/mb_ball_clk_wiz_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_rst_clk_wiz_1_100M_0/mb_ball_rst_clk_wiz_1_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_rst_clk_wiz_1_100M_0/mb_ball_rst_clk_wiz_1_100M_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_rst_clk_wiz_1_100M_0/mb_ball_rst_clk_wiz_1_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_uartlite_0_0/mb_ball_axi_uartlite_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_uartlite_0_0/mb_ball_axi_uartlite_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_uartlite_0_0/mb_ball_axi_uartlite_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_0/mb_ball_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_0/mb_ball_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_0/mb_ball_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_1/mb_ball_axi_gpio_0_1_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_1/mb_ball_axi_gpio_0_1_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_1/mb_ball_axi_gpio_0_1.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_2/mb_ball_axi_gpio_0_2_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_2/mb_ball_axi_gpio_0_2_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_gpio_0_2/mb_ball_axi_gpio_0_2.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_timer_0_0/mb_ball_axi_timer_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_timer_0_0/mb_ball_axi_timer_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_quad_spi_0_0/mb_ball_axi_quad_spi_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_quad_spi_0_0/mb_ball_axi_quad_spi_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_quad_spi_0_0/mb_ball_axi_quad_spi_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_axi_quad_spi_0_0/mb_ball_axi_quad_spi_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/mb_ball_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/bd/mb_ball/ip/mb_ball_microblaze_0_0/data/mb_bootloop_le.elf]

read_ip -quiet C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/sources_1/ip/hdmi_tx_0/hdmi_tx_0.xci

OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/constrs_1/imports/pin_assignment/mb_usb_hdmi_top.xdc
set_property used_in_implementation false [get_files C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/constrs_1/imports/pin_assignment/mb_usb_hdmi_top.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1

read_checkpoint -auto_incremental -incremental C:/Users/Git_Smash/ECE385_Smash/Smash_Bros/Smash_Bros.srcs/utils_1/imports/synth_1/SMASH_TOP.dcp
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top SMASH_TOP -part xc7s50csga324-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef SMASH_TOP.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file SMASH_TOP_utilization_synth.rpt -pb SMASH_TOP_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
