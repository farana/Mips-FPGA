module pc_control_32(
	input 		            clk,			        // clock
	input                   reset,		            // reset bit
	input wire              beq,	     	        // branch and zero
	input wire	            jump,			        // if jump then 1
	input wire [31:0]       branch_addr,	        // from branch_addr 
	input wire [25:0]       jump_addr,		        // instruction [25:0]

	output reg [31:0]       pc			            // pc out
);

	wire [1: 0]             jump_branch;
	wire [27:0]				shifted_jump_addr;
	reg  [31:0]             pc_reg;
	reg  [31:0]             temp_pc_reg;

	assign shifted_jump_addr [25:0] = jump_addr;

	always @(posedge clk) begin

		if ( reset ) begin

			pc_reg      <= 0;
		
			temp_pc_reg <= 0;
		
		end else begin
	
			temp_pc_reg = pc_reg + 4;

			if ( jump == 1 ) begin

				pc_reg[27 :0]  = ( jump_addr << 2 );

				pc_reg[31:28]  =   temp_pc_reg; 	
			
			end else if ( beq == 1 ) begin
				$display("beq ================================================== ");
				pc_reg = temp_pc_reg + ( branch_addr << 2 );
			
			end else begin
			
				pc_reg = temp_pc_reg;
			
			end
		end
		
		pc = pc_reg;
	
	end
endmodule