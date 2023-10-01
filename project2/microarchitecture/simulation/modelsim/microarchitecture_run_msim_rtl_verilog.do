transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/alu.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/register_file.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/data_memory.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/ALUControl.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/JR_Control.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/control.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/mips_16.sv}
vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/instr_mem.sv}

vlog -sv -work work +incdir+C:/Users/luism/source/repos/AC1/project2/microarchitecture {C:/Users/luism/source/repos/AC1/project2/microarchitecture/mips_16_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  mips_16_tb

add wave *
view structure
view signals
run -all
