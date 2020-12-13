`include "defines.vh"
module ex(
    input wire [`AluOpBus] aluop_i,
	input wire [`AluSelBus] alusel_i,
	input wire [`RegBus] reg1_i,
	input wire [`RegBus] reg2_i,

	output reg [`RegBus] wdata_o
);

    reg [`RegBus] logic_o;
    reg [`RegBus] arithmetic_o;
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
// wdata
    always @ (*) begin
        case (alusel_i)
            `EXE_LOGIC:begin
                wdata_o = logic_o;
            end 
            `EXE_ARITHMETIC:begin
                wdata_o = arithmetic_o;
            end
            default:begin
                wdata_o = `ZeroWord;
            end
        endcase
    end
endmodule 