`include "defines.vh"
module ex(
    input wire [31:0] inst_i,
    input wire [`AluOpBus] aluop_i,
	input wire [`AluSelBus] alusel_i,
	input wire [`RegBus] reg1_i,
	input wire [`RegBus] reg2_i,

	output reg [`RegBus] wdata_o,

    // ram contral
    output reg mem_cs_o, // mem ¼´memory ´æ´¢Æ÷
    output reg mem_rw_o,
    output reg [31:0] mem_addr_o,
    output reg [31:0] mem_wdata_o,
    input wire [31:0] mem_rdata_i
);

    reg [`RegBus] logic_o;
    reg [`RegBus] arithmetic_o;
    reg [`RegBus] shift_o;
    reg [`RegBus] load_o;
// logic_o
    always @ (*) begin
        case (aluop_i) 
            `LUI:begin
                logic_o = reg1_i;
            end
            default:begin
                logic_o = `ZeroWord;
            end
        endcase
    end

// arithmetic_o
    always @ (*) begin
        case (aluop_i)
            `ADDU:begin
                arithmetic_o = reg1_i + reg2_i;
            end 
            default:begin
                arithmetic_o = `ZeroWord;
            end 
        endcase
    end

// shift_o
    always @ (*) begin
        case (aluop_i)
            `SLL:begin
                shift_o = reg2_i << reg1_i;
            end
            default:begin
                shift_o = `ZeroWord;
            end
        endcase 
    end

// load & store
    always @ (*) begin
        case (aluop_i)
            `LW:begin
                mem_cs_o = `True_v;
                mem_rw_o = 1'b1;
                mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
                mem_wdata_o = `ZeroWord;
                load_o = mem_rdata_i;
            end
            `SW:begin
                mem_cs_o = `True_v;
                mem_rw_o = 1'b0;
                mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
                mem_wdata_o = reg2_i;
                load_o = `ZeroWord;
            end
            default:begin
                mem_cs_o = `False_v;
                mem_rw_o = 1'b0;
                mem_addr_o = `ZeroWord;
                mem_wdata_o = `ZeroWord;
                load_o = `ZeroWord;
            end
        endcase
    end

// wdata
    always @ (*) begin
        case (alusel_i)
            `EXE_LOGIC:begin
                wdata_o = logic_o;
            end 
            `EXE_ARITHMETIC:begin
                wdata_o = arithmetic_o;
            end
            `EXE_SHIFT:begin
                wdata_o = shift_o;
            end
            `EXE_LOAD_STORE:begin
                if(aluop_i == `LW || aluop_i == `LB) begin
                    wdata_o = load_o;
                end
                else begin
                    wdata_o = `ZeroWord;
                end
            end
            default:begin
                wdata_o = `ZeroWord;
            end
        endcase
    end
endmodule 