onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_dlx/clock
add wave -noupdate -format Logic /tb_dlx/reset
add wave -noupdate -format Logic /tb_dlx/exception
add wave -noupdate -format Logic /tb_dlx/u1/pipeline/stagef/ck
add wave -noupdate -group FETCH -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/stagef/pc_from_fetch_to_iram
add wave -noupdate -group FETCH -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/stagef/pc_out_to_ifid
add wave -noupdate -group FETCH -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/stagef/actual_pc
add wave -noupdate -group FETCH -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/stagef/real_next_pc
add wave -noupdate -group DECODE -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/staged/nextpc_in_decode
add wave -noupdate -group DECODE -format Literal -radix hexadecimal /tb_dlx/u1/pipeline/staged/instr_in_decode
add wave -noupdate -group DECODE -format Literal -radix unsigned /tb_dlx/u1/pipeline/staged/reg1_addr_from_decode
add wave -noupdate -group DECODE -format Literal -radix unsigned /tb_dlx/u1/pipeline/staged/reg2_addr_from_decode
add wave -noupdate -expand -group EXECUTE -format Logic /tb_dlx/u1/pipeline/stagee/exe_alu/issigned
add wave -noupdate -expand -group EXECUTE -expand -group signed -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/input1_to_alu
add wave -noupdate -expand -group EXECUTE -expand -group signed -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/input2_to_alu
add wave -noupdate -expand -group EXECUTE -expand -group signed -format Literal -radix decimal /tb_dlx/u1/pipeline/stagee/alu_out
add wave -noupdate -expand -group EXECUTE -expand -group unsigned -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagee/input1_to_alu
add wave -noupdate -expand -group EXECUTE -expand -group unsigned -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagee/input2_to_alu
add wave -noupdate -expand -group EXECUTE -expand -group unsigned -format Literal -radix unsigned /tb_dlx/u1/pipeline/stagee/alu_out
add wave -noupdate -expand -group EXECUTE -format Logic -radix decimal /tb_dlx/u1/pipeline/stagee/exception
add wave -noupdate -group MEMORY -divider signed
add wave -noupdate -group MEMORY -format Literal -radix decimal /tb_dlx/u1/pipeline/exmem_stage/alures_memaddr_out_exmem
add wave -noupdate -group MEMORY -divider unsigned
add wave -noupdate -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/exmem_stage/alures_memaddr_out_exmem
add wave -noupdate -group MEMORY -format Literal -radix unsigned /tb_dlx/u1/pipeline/exmem_stage/regdst_addr_out_exmem
add wave -noupdate -expand -group WRITEBACK -format Literal -radix unsigned /tb_dlx/u1/pipeline/regfile_dec_wb/rd_addr
add wave -noupdate -expand -group WRITEBACK -divider signed
add wave -noupdate -expand -group WRITEBACK -format Literal -radix decimal /tb_dlx/u1/pipeline/regfile_dec_wb/rd_data
add wave -noupdate -expand -group WRITEBACK -divider unsigned
add wave -noupdate -format Literal -radix unsigned /tb_dlx/u1/pipeline/regfile_dec_wb/rd_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47217350 fs} 0}
configure wave -namecolwidth 342
configure wave -valuecolwidth 83
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
configure wave -timelineunits fs
update
WaveRestoreZoom {45332030 fs} {48172430 fs}
