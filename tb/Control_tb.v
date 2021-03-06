module control_test;
  reg   [5:0] opcode;
  reg   [5:0] funct;

  wire 	[1:0] alu_op;
  wire  [1:0] mem_toreg;
  wire 				mem_write;
  wire 				mem_read;
  wire 	[1:0]	branch;
  wire 				alu_src;
  wire 	[1:0] reg_dst;
  wire 				reg_write;
  wire 	[1:0] jump;
  wire        error;

  control_32 dut (
    .opcode(opcode),
    .funct(funct),
    .alu_op(alu_op),
    .mem_toreg(mem_toreg),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .branch(branch),
    .alu_src(alu_src),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .jump(jump),
    .err_illegal_opcode(error)
  );
 
  initial begin
    funct <= 0;
    $dumpfile("control_test.vcd");
    $dumpvars(0, control_test);

    $display("Opcode, ALUop, mem_toreg, mem_read, branch, alu_src, reg_dst, reg_write, jump, error"); 
    $monitor("%b,%b,%d,%b,%b,%b,%d,%b,%d,%b", opcode, alu_op, mem_toreg, mem_read, branch, alu_src, reg_dst, reg_write, jump, error); 
    opcode <= 6'b0000_00; #5; // r_type 

    $display("LW");
    opcode = dut.lw; #5;// lw
    $display("SW");
    opcode = dut.sw; #5;// sw
    $display("BEQ");
    opcode = dut.beq; #5;// beq 
    $display("BNE");
    opcode = dut.bne; #5;// bne
    $display("R-type");
    opcode = dut.r_type; #5;// r-type
    $display("ADDI");
    opcode = dut.addi; #5;// addi  
    $display("J");
    opcode = dut.j; #5;// jump
    $display("JAL");
    opcode = dut.jal; 
    #5;// jal
    $display("JR");
    opcode = dut.r_type; funct = dut.jr_func;
    #5;// jr

    $display("\nError codes\n\n");
    opcode <= 6'b0011_10; #5;// r_type 
    opcode <= 6'b1111_11; #5;// lw
    opcode <= 6'b1110_11; #5;// sw
    opcode <= 6'b0111_10; #5;// beq 
    opcode <= 6'b1110_10; #5;// addi  
    opcode <= 6'b1001_11; #5;// jump
  end
endmodule
