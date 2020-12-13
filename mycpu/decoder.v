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
    output reg [`RegAddrBus] waddr_o, // 指令需要写入的目的寄存器地址

    output reg branch_flag_o, // 跳转标志信号 高位有效
    output reg [`RegBus] branch_target_address_o // 目标地址
);
    wire [4:0] rs; // source reg
    wire [4:0] rt; // source reg
    wire [4:0] rd; // store reg
    wire [4:0] sa;
    wire [5:0] func; // function 
    wire [25:0] instr_index;
    wire [15:0] imm; // immediate
    wire [5:0] opcode;
    wire [5:0] base;
    reg [`RegBus] imm_o;
    assign {opcode,rs,rt,rd,sa,func} = inst_i;
    assign base = rs;
    assign imm = inst_i[15:0];
    assign instr_index = inst_i[25:0];
    wire [31:0] pc_plus_4;
    wire [31:0] imm_sll2_signedext;
    assign pc_plus_4 = inst_addr_i + 32'd4;
    assign imm_sll2_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};

    always @ (*) begin
        branch_flag_o = `False_v;
        branch_target_address_o = `ZeroWord;
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
                        imm_o = `ZeroWord;

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                    6'b100100:begin
                        alusel_o = `EXE_LOGIC;
                        aluop_o = `AND;

                        reg1_read_o = `True_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = rs;
                        reg2_addr_o = rt;
                        imm_o = 32'b0;

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                    6'b100101:begin
                        alusel_o = `EXE_LOGIC;
                        aluop_o = `OR;

                        reg1_read_o = `True_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = rs;
                        reg2_addr_o = rt;
                        imm_o = `ZeroWord;

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                    6'b100110:begin
                        alusel_o = `EXE_LOGIC;
                        aluop_o = `XOR;

                        reg1_read_o = `True_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = rs;
                        reg2_addr_o = rt;
                        imm_o = 32'b0;

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                    6'b000000:begin
                        alusel_o = `EXE_SHIFT;
                        aluop_o = `SLL;

                        reg1_read_o = `False_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = 5'b0;
                        reg2_addr_o = rt;
                        imm_o = {27'b0,sa};

                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                    6'b000010:begin
                        alusel_o = `EXE_SHIFT;
                        aluop_o = `SRL;

                        reg1_read_o = `False_v;
                        reg2_read_o = `True_v;
                        reg1_addr_o = 5'b0;
                        reg2_addr_o = rt;
                        imm_o = {27'b0,sa};
                    
                        we_o = `WriteEnable;
                        waddr_o = rd;
                    end
                     6'b001000:begin
                        alusel_o = `EXE_JUMP_BRANCH;
                        aluop_o = `JR;

                        reg1_read_o = `True_v;
                        reg2_read_o = `False_v;
                        reg1_addr_o = rs;
                        reg2_addr_o = 5'b0;
                        imm_o = 32'b0;

                        we_o = `WriteDisable;
                        waddr_o = 5'b0;

                        branch_target_address_o = reg1_data_i;
                        branch_flag_o = `Branch;
                    end
                endcase
            end
            6'b001001:begin
                alusel_o = `EXE_ARITHMETIC;
                aluop_o = `ADDIU;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = rs;
                reg2_addr_o = 5'b0;
                imm_o = {{16{imm[15]}},imm};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b011100:begin
                alusel_o = `EXE_ARITHMETIC;
                aluop_o = `MUL;

                reg1_read_o = `True_v;
                reg2_read_o = `True_v;
                reg1_addr_o = rs;
                reg2_addr_o = rt;
                imm_o = 32'b0;

                we_o = `WriteEnable;
                waddr_o = rd;
            end
            6'b001100:begin
                alusel_o = `EXE_LOGIC;
                aluop_o = `ANDI;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = rs;
                reg2_addr_o = 5'b0;
                imm_o = {16'b0,imm};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b001111:begin
                alusel_o = `EXE_LOGIC;
                aluop_o = `LUI;

                reg1_read_o = `False_v;
                reg2_read_o = `False_v;
                reg1_addr_o = 5'b0;
                reg2_addr_o = 5'b0;
                imm_o = {imm,16'b0};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b001101:begin
                alusel_o = `EXE_LOGIC;
                aluop_o = `ORI;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = rs;
                reg2_addr_o = 5'b0;
                imm_o = {16'b0,imm};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b001110:begin
                alusel_o = `EXE_LOGIC;
                aluop_o = `XORI;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = rs;
                reg2_addr_o = 5'b0;
                imm_o = {16'b0,imm};

                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b000100:begin
                alusel_o = `EXE_JUMP_BRANCH;
                aluop_o = `BEQ;

                reg1_read_o = `True_v;
                reg2_read_o = `True_v;
                reg1_addr_o = rs;
                reg2_addr_o = rt;
                imm_o = `ZeroWord;
                
                we_o = `WriteDisable;
                waddr_o = 5'b0;

                if (reg1_data_i == reg2_data_i) begin
                    branch_flag_o = `Branch;
                    branch_target_address_o = pc_plus_4 + imm_sll2_signedext;
                end
            end
            6'b000101:begin
                alusel_o = `EXE_JUMP_BRANCH;
                aluop_o = `BNE;

                reg1_read_o = `True_v;
                reg2_read_o = `True_v;
                reg1_addr_o = rs;
                reg2_addr_o = rt;
                imm_o = `ZeroWord;

                we_o = `WriteDisable;
                waddr_o = 5'b0;
                if (reg1_data_i != reg2_data_i) begin
                    branch_target_address_o = pc_plus_4 + imm_sll2_signedext;
                    branch_flag_o = `Branch;
                end
            end
            6'b000111:begin
                alusel_o = `EXE_JUMP_BRANCH;
                aluop_o = `BGTZ;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = rs;
                reg2_addr_o = 5'b0;
                imm_o = `ZeroWord;

                we_o = `WriteDisable;
                waddr_o = 5'b0;
                
                if (reg1_data_i[31] == 1'b0 && reg1_data_i != `ZeroWord) begin
                    branch_target_address_o = pc_plus_4 + imm_sll2_signedext;
                    branch_flag_o = `Branch;
                end
            end
            6'b000010:begin
                alusel_o = `EXE_JUMP_BRANCH;
                aluop_o = `J;

                reg1_read_o = `False_v;
                reg2_read_o = `False_v;
                reg1_addr_o = 5'b0;
                reg2_addr_o = 5'b0;
                imm_o = `ZeroWord;

                we_o = `WriteDisable;
                waddr_o = 5'b0;

                branch_target_address_o = {pc_plus_4[31:28],instr_index,2'b0};
                branch_flag_o = `Branch;
            end
            6'b000011:begin
                alusel_o = `EXE_JUMP_BRANCH;
                aluop_o = `JAL;

                reg1_read_o = `False_v;
                reg2_read_o = `False_v;
                reg1_addr_o = 5'b0;
                reg2_addr_o = 5'b0;
                imm_o = `ZeroWord;

                we_o = `WriteEnable;
                waddr_o = 5'd31;

                branch_target_address_o = {pc_plus_4[31:28],instr_index,2'b0};
                branch_flag_o = `Branch;
            end
            6'b100011:begin
                alusel_o = `EXE_LOAD_STORE;
                aluop_o = `LW;

                reg1_read_o = `True_v;
                reg2_read_o = `False_v;
                reg1_addr_o = base;
                reg2_addr_o = 5'b0;
                imm_o = `ZeroWord;
                
                we_o = `WriteEnable;
                waddr_o = rt;
            end
            6'b101011:begin
                alusel_o = `EXE_LOAD_STORE;
                aluop_o = `SW;

                reg1_read_o = `True_v;
                reg2_read_o = `True_v;
                reg1_addr_o = base;
                reg2_addr_o = rt;
                imm_o = `ZeroWord;

                we_o = `WriteDisable;
                waddr_o = 5'b0;
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
