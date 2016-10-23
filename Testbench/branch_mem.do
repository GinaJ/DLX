onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_dlx/clock
add wave -noupdate -format Logic /tb_dlx/reset
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {mux next PC} -format Logic /tb_dlx/u1/pipeline/cu_for_branch/jump
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {mux next PC} -format Literal -radix decimal /tb_dlx/u1/pipeline/stagef/next_pc
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {mux next PC} -format Literal -radix decimal /tb_dlx/u1/pipeline/stagef/target_jump
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {mux next PC} -format Literal -radix decimal /tb_dlx/u1/pipeline/stagef/actual_pc
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {Stall PC} -format Logic /tb_dlx/u1/pipeline/stagef/stall
add wave -noupdate -expand -group {FETCH STAGE} -expand -group {Stall PC} -format Literal -radix decimal /tb_dlx/u1/pipeline/stagef/actual_pc
add wave -noupdate -expand -group DECODE -format Literal -radix decimal /tb_dlx/u1/pipeline/staged/nextpc_in_decode
add wave -noupdate -expand -group DECODE -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/staged/instr_in_decode
add wave -noupdate -expand -group DECODE -format Literal -radix decimal /tb_dlx/u1/pipeline/staged/target_jump
add wave -noupdate -expand -group DECODE -format Logic /tb_dlx/u1/pipeline/cu_for_branch/jump
add wave -noupdate -expand -group DECODE -format Literal -radix decimal /tb_dlx/u1/pipeline/staged/reg1_check_beq
add wave -noupdate -height 30 -expand -group EXECUTE -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/input1_to_alu
add wave -noupdate -height 30 -expand -group EXECUTE -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/input2_to_alu
add wave -noupdate -height 30 -expand -group EXECUTE -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/alu_out
add wave -noupdate -height 30 -expand -group EXECUTE -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagee/regdst
add wave -noupdate -height 30 -expand -group MEMORY -format Logic /tb_dlx/u1/pipeline/stagem/req
add wave -noupdate -height 30 -expand -group MEMORY -format Logic /tb_dlx/u1/pipeline/stagem/read_notwrite
add wave -noupdate -height 30 -expand -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagem/addr_to_dram
add wave -noupdate -height 30 -expand -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagem/data_from_dram
add wave -noupdate -height 30 -expand -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagem/data_to_dram
add wave -noupdate -height 30 -expand -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/exmem_stage/regdst_addr_out_exmem
add wave -noupdate -height 30 -expand -group MEMORY -format Literal -radix decimal /tb_dlx/u1/pipeline/stagem/data_to_mem_wb
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/datamem/mem
add wave -noupdate -height 30 -expand -group WRITEBACK -format Literal -radix unsigned /tb_dlx/u1/pipeline/regfile_dec_wb/rd_addr
add wave -noupdate -height 30 -expand -group WRITEBACK -format Literal -radix decimal /tb_dlx/u1/pipeline/regfile_dec_wb/rd_data
add wave -noupdate -height 30 -expand -group WRITEBACK -format Logic /tb_dlx/u1/pipeline/regfile_dec_wb/req_write
add wave -noupdate -height 30 -expand -group WRITEBACK -format Literal -radix decimal /tb_dlx/u1/pipeline/regfile_dec_wb/regbank
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {202000000 fs} 0} {{Cursor 2} {25137000 fs} 0} {{Cursor 3} {32666800 fs} 0}
configure wave -namecolwidth 293
configure wave -valuecolwidth 72
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {144514400 fs} {254271200 fs}
