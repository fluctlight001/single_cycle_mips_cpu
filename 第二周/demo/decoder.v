`include "defines.vh"
module decoder(
    input wire [31:0] inst_i,
    input wire [31:0] inst_addr_i,

    output reg reg1_read_o, // reg1 read enable
    output reg reg2_read_o, // reg2 read enable
    output reg [`RegAddrBus] reg1_addr_o, // reg1 read addr
    output reg [`RegAddrBus] reg2_addr_o, // reg2 read addr

    input wire [`RegBus] reg1_data_i, // reg1 data from rf 
    input wire [`RegBus] reg2_data_i, // reg2 data from rf

    output reg [`AluOpBus] aluop_o, // 需要运行的指令代码
    output reg [`AluSelBus] alusel_o, // 需要运行的指令的类型
    output reg [`RegBus] reg1_o, // 指令需要的源操作数1
    output reg [`RegBus] reg2_o, // 指令需要的源操作数2
    output reg we_o, // 指令是否需要写入寄存器
    output reg [`RegAddrBus] waddr_o //指令需要写入的目的寄存器地址
    
);
    wire [4:0] rs; // source reg
    wire [4:0] rt; // source reg
    wire [4:0] rd; // store reg
    wire [4:0] sa;
    wire [5:0] func; // function 
    wire [25:0] instr_index;
    wire [15:0] imm; // immediate
    wire [5:0] opcode;
    reg [`RegBus] imm_o;
    assign {opcode,rs,rt,rd,sa,func} = inst_i;
    assign imm = inst_i[15:0];
    assign instr_index = inst_i[25:0];

    always @ (*) begin
        case (opcode) 
            6'b000000:begin
                case (func) 
                    6'b100001:begin
                        alusel_o = `EXE_ARITHMETIC;
                        aluop_o = `ADDU;

                        reg1_read_o = `True_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = rs;
                        reg2_addr_o = rt;

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                endcase
            end
            6'b001111:begin
                alusel_o = `EXE_LOGIC;
                aluop_o = `LUI;

                reg1_read_o = `False_v;
                reg2_read_o = `False_v;
                imm_o = {imm,16'b0};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            default:begin
                
            end
        endcase
    end

    always @ (*) begin
        if (reg1_read_o == `True_v) begin
            reg1_o = reg1_data_i;
        end
        else if (reg1_read_o == `False_v) begin
            reg1_o = imm_o;
        end
        else begin
            reg1_o = `ZeroWord;
        end
    end

    always @ (*) begin
        if (reg2_read_o == `True_v) begin
            reg2_o = reg2_data_i;
        end
        else if (reg2_read_o == `False_v) begin
            reg2_o = imm_o;
        end
        else begin
            reg2_o = `ZeroWord;
        end
    end
endmodule 
