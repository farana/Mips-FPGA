// 2016 Ryan Leonard
// RegisterFile (RF) Module
//
//  The internal data structure is a collection of 
//  32 registeread_addr_s each 32 bits in size. This is represented
//  using the 'memories' data structure as discussed in:
//    http://www.verilogtutorial.info/chapter_3.htm
//
//  Notice that on the positive edge of each clock cycle, we
//  are performing data write. On the negative edge of each clock
//  cycle, we are performing data read.

// TODO: How do we make the finish bit work as expected?

module rf_32(
  clock,
  read_enabled,
  read_addr_s, 
  read_addr_t, 
  write_enabled,
  write_addr,
  write_data,
  outA, 
  outB
);

localparam 
  REG_SIZE = 32,
  REGFILE_SIZE = 32,
  INDEX_SIZE = 5,
  ZERO = 32'b0;

input wire        clock;
input wire        read_enabled;
input wire [INDEX_SIZE-1:0]  read_addr_s;
input wire [INDEX_SIZE-1:0]  read_addr_t;
input wire        write_enabled;
input wire [INDEX_SIZE-1:0]  write_addr;
input wire [REG_SIZE-1:0] write_data;
output wire [REG_SIZE-1:0] outA;
output wire [REG_SIZE-1:0] outB;

// A 'memories' data structure representing:
//    32 registeread_addr_s each 32 bits
reg [REG_SIZE-1:0] register_file[REGFILE_SIZE-1:0];

// write logic 
always @ (negedge clock)
begin
  if (write_enabled)
    register_file[write_addr] <= write_data;
  register_file[0] <= ZERO;
end

// Read logic is combinational
assign outA = register_file[read_addr_s];
assign outB = register_file[read_addr_t];

endmodule
