// 2016 Rui Tu
//  control Module
// combinational logic
/* information from http://www.cs.columbia.edu/~martha/courses/3827/sp11/slides/9_singleCycleMIPS.pdf 
	http://www.eng.ucy.ac.cy/mmichael/courses/ECE314/LabsNotes/02/MIPS_Instruction_Coding_With_Hex.pdf
*/
module control_32(
	input  wire [5:0] opcode,

	output reg 	[1:0] alu_op,
	output reg  [1:0] mem_toreg,
	output reg 		  mem_write,
	output reg 		  mem_read,
	output reg 		  branch,
	output reg 		  alu_src,
	output reg 	[1:0] reg_dst,
	output reg 		  reg_write,
	output reg 	[1:0]	jump,

	output reg        err_illegal_opcode
);
			    /* possible opcodes */
	parameter   r_type      = 6'b0000_00,
			    lw		    = 6'b1000_11,
			    sw 		    = 6'b1010_11,
			    beq 	    = 6'b0001_00,
			    addi	    = 6'b0010_00,
			    j    	    = 6'b0000_10,
			    jr    	  = 6'b0010_00,
			    jal    	  = 6'b0000_11,

			    on  	    = 1'b1,
			    off 	    = 1'b0,

        /* reg_dst mux3 possible values */
        // http://meseec.ce.rit.edu/eecc550-winter2005/550-chapter5-exercises.pdf
			    regdst_r  	    = 2'b01,
			    regdst_jal  	  = 2'b10,
			    regdst_lw  	    = 2'b00,
			    regdst_invalid  = 2'b11,

        /* memtoreg mux3 possible values -- taken from same url as reg_dst */
          memtoreg_r      = 2'b00,
          memtoreg_jal    = 2'b10,
          memtoreg_lw     = 2'b01,
          memtoreg_invalid = 2'b11,

        /* jump mux3 possible values -- taken from same url as reg_dst */
          jumpmux_nojump  = 2'b00,
          jumpmux_j_jal   = 2'b01,
          jumpmux_jr      = 2'b10,
          jumpmux_invalid = 2'b11,

				/* 3 difference aluop */
			    mem_alu     = 2'b00,
			    beq_alu	    = 2'b01,
			    artih_alu   = 2'b10,
			    aluop_invalid	= 2'b11;
	
	always @(*) begin
		case (opcode)
			
			r_type: begin
				mem_toreg          <= memtoreg_r;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= regdst_r;
				reg_write          <= on;
				jump               <= jumpmux_nojump;

				alu_op             <= artih_alu;
				err_illegal_opcode <= off;

			end

			lw: begin
				mem_toreg          <= memtoreg_lw;
				mem_write          <= off;
				mem_read           <= on;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= regdst_lw;
				reg_write          <= on;
				jump               <= jumpmux_nojump;
				
				alu_op             <= mem_alu;
				err_illegal_opcode <= off;

			end

			sw: begin
				mem_toreg          <= memtoreg_invalid;
				mem_write          <= on;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= regdst_invalid;
				reg_write          <= off;
				jump               <= jumpmux_nojump;

				alu_op     		   <= mem_alu;
				err_illegal_opcode <= off;

			end

			beq: begin
				mem_toreg          <= memtoreg_invalid;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= on;
				alu_src            <= off;
				reg_dst            <= regdst_invalid;
				reg_write          <= off;
				jump               <= jumpmux_nojump;

				alu_op             <= beq_alu;
				err_illegal_opcode <= off;

			end

			addi: begin
				mem_toreg          <= memtoreg_invalid;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= on;
				reg_dst            <= regdst_invalid;
				reg_write          <= on;
				jump               <= jumpmux_nojump;

				alu_op             <= mem_alu;
				err_illegal_opcode <= off;
			end

			jr: begin
				mem_toreg          <= memtoreg_jal;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= regdst_jal;
				reg_write          <= on;
				jump 	             <= jumpmux_jr;

				alu_op             <= aluop_invalid;
				err_illegal_opcode <= off;
			end

			jal: begin
				mem_toreg          <= memtoreg_jal;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= regdst_jal;
				reg_write          <= on;
				jump 	             <= jumpmux_j_jal;

				alu_op             <= aluop_invalid;
				err_illegal_opcode <= off;
			end

			j: begin
				mem_toreg          <= memtoreg_invalid;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= regdst_invalid;
				reg_write          <= off;
				jump               <= jumpmux_j_jal;

				jump 	           <= on;
				alu_op             <= aluop_invalid;
				err_illegal_opcode <= off;
			end

			default: begin 
				mem_toreg          <= memtoreg_invalid;
				mem_write          <= off;
				mem_read           <= off;
				branch             <= off;
				alu_src            <= off;
				reg_dst            <= regdst_invalid;
				reg_write          <= off;
				jump               <= jumpmux_invalid;

				alu_op             <= aluop_invalid;
				err_illegal_opcode <= on;
				$display("cannot decode instruction %b\n", opcode);
			end
		endcase
	end
endmodule
