// Generated by alg3
`timescale 1ns/10ps


typedef reg [31:0] Raddr;
typedef reg signed [31:0] Rdata;

reg reset;
Raddr PC;
Rdata mem[Raddr];
reg signed [31:0] Reg[31:0];
iunion inst;
reg [63:0] icnt;
Rdata finishedcode;


function Rdata MEM(Raddr r);
    if ( (!(^r===1'bX)) && mem.exists(r&32'hffff_fffc))
    return mem[r&32'hffff_fffc];
    return 32'hXXXX_XXXX;
endfunction : MEM

task WMEM(Raddr r,Rdata d);
    if(r==32'hf000_0000) begin
        $display("Finish code %08h",d);
        finishedcode=d;
    end
    mem[r&32'hffff_fffc]=d;
endtask : WMEM

task unsupported();
    $error("invalid instruction code %h",inst.I.opcode5);
    $finish;
endtask : unsupported

task wreg(input reg [4:0] ra,Rdata rd);
    if(ra != 0) Reg[ra]=rd;
endtask : wreg

function Rdata REG(reg [4:0] rix);
    if(rix==0) return 0;
    return Reg[rix];
endfunction : REG

function Rdata SE8(input reg [7:0] bd);
    return {((bd[7])?24'hFFFF_FF:24'h0),bd};
endfunction : SE8

function Rdata SE16(input reg [15:0] bd);
    return {((bd[15])?16'hFF:16'h0),bd};
endfunction : SE16

function Rdata SE12(input reg [11:0] bd);
    return {((bd[11])?20'hFFFFF:20'h00000),bd};
endfunction : SE12

function Raddr eaI();
    Raddr wa,se;
    se=SE12(inst.I.imm12);
//    $display("inst %h imm12 %h of eaI %h",
//        inst.raw,inst.I.imm12,se);
    wa=REG(inst.I.rs1)+SE12(inst.I.imm12);
    return wa;
endfunction : eaI

task LB();
    Raddr ma;
    Rdata rd;
    ma=eaI();
    rd=SE8(32'hff&(MEM(ma&32'hffff_fffe)>>((ma&3)*8)));
    wreg(inst.I.rd,rd);
endtask : LB

task LBU();
    Rdata rd;
    Raddr ma;
    ma=eaI();
    rd=32'hff&(MEM(ma&32'hffff_fffe)>>((ma&3)*8));
    wreg(inst.I.rd,rd);
endtask : LBU

task LH();
    Rdata res;
    reg [63:0] rd;
    Raddr ma;
    ma=eaI();
    rd = {MEM((ma&32'hFFFF_FFFF)+4),MEM(ma&32'hFFFF_FFFF)};
    res = (rd>>((ma&1)*16))&32'hFFFF;
    res=SE16(res);
    wreg(inst.I.rd,res);
endtask : LH

task LHU();
    Raddr ma;
    Rdata res;
    reg [63:0] rd;
    ma=eaI();
    rd = {MEM((ma&32'hFFFF_FFFF)+4),MEM(ma&32'hFFFF_FFFF)};
    res = (rd>>((ma&1)*16))&32'hFFFF;
    wreg(inst.I.rd,res);
endtask : LHU

task LW();
    Raddr ma;
    Rdata res;
    reg [63:0] rd;
    ma=eaI();
//    $display("LW inst %h Fetching word from %h",inst.raw,ma);
    rd = {MEM(ma+4),MEM(ma)};
//    $display("selected from %h",rd);
    res = (rd>>((ma&3)*8)) & 32'hFFFFffff;
//    $display("Results are %h",res);
    wreg(inst.I.rd,res);
endtask : LW

task nextIns();
    PC=PC+4;
endtask : nextIns

function Raddr SE13(Raddr v);
    if (v[12]) begin
        return {19'h7ffff,v[12:0]};
    end
    return v;
endfunction : SE13

function Raddr Btar();
    Raddr rn;
    rn=(inst.B.imm4_1_11)&32'h1e;
    rn|=((inst.B.imm12_10_5)&32'h1f)<<5;
    rn|=((inst.B.imm4_1_11)&1)<<11;
    rn|=(inst.B.imm12_10_5[5:0])<<5;
    rn|=(inst.B.imm12_10_5[6])<<12;
//    $display("PC %h rn %h se13 %d",PC,rn,$signed(SE13(rn)));
    return SE13(rn)+PC;
endfunction : Btar

task BEQ();
    if (REG(inst.B.rs1)==REG(inst.B.rs2)) begin
        PC=Btar();
    end else begin
        nextIns;
    end
endtask : BEQ

task BNE();
    if (REG(inst.B.rs1)!=REG(inst.B.rs2)) begin
        PC=Btar();
    end else begin
        nextIns;
    end
endtask : BNE

task BLT();
    if (REG(inst.B.rs1)<REG(inst.B.rs2)) begin
//        $display("BLT taking branch");
        PC=Btar();
//        $display("New PC is %h",PC);
    end else begin
        nextIns;
    end
endtask : BLT

task BLTU();
    if ($unsigned(Reg[inst.B.rs1])<$unsigned(Reg[inst.B.rs2]) ) begin
        PC=Btar();
    end else begin
        nextIns;
    end
endtask : BLTU

task BGE();
    if (Reg[inst.B.rs1]>=Reg[inst.B.rs2]) begin
        PC=Btar();
    end else begin
        nextIns;
    end
endtask : BGE

task BGEU();
    if ($unsigned(Reg[inst.B.rs1])>=$unsigned(Reg[inst.B.rs2]) ) begin
        PC=Btar();
    end else begin
        nextIns;
    end
endtask : BGEU

task ADDI();
    wreg(inst.I.rd,eaI());
endtask : ADDI

task XORI();
    wreg(inst.I.rd,SE12(inst.I.imm12)^REG(inst.I.rs1));
endtask : XORI

task ORI();
    wreg(inst.I.rd,SE12(inst.I.imm12)|REG(inst.I.rs1));
endtask : ORI

task ANDI();
    wreg(inst.I.rd,SE12(inst.I.imm12)&REG(inst.I.rs1));
endtask : ANDI

task SLLI();
    Rdata w;
    w=REG(inst.R.rs1);
    w=w<<inst.R.rs2;
    wreg(inst.R.rd,w);
endtask : SLLI

task SRLI();
    Rdata w;
    w=REG(inst.R.rs1);
    w=$unsigned(w)>>inst.R.rs2;
    wreg(inst.R.rd,w);
endtask : SRLI

task SRAI();
    Rdata w;
    w=REG(inst.R.rs1);
    w=w>>>inst.R.rs2;
    wreg(inst.R.rd,w);
endtask : SRAI

task SLTI();
    Rdata w;
    w=SE12(inst.I.imm12);
    wreg(inst.I.rd,(REG(inst.I.rs1)<w)?32'h1:32'h0);
endtask : SLTI

task SLTIU();
    Rdata w;
    w=SE12(inst.I.imm12);
    wreg(inst.I.rd,($unsigned(REG(inst.I.rs1))<$unsigned(w))?32'h1:32'h0);
endtask : SLTIU

function Raddr eaS();
    Raddr rv,indx;
    rv=REG(inst.S.rs1);
    indx={(inst.S.imm11_5[6])?20'hffff:20'h0,inst.S.imm11_5,inst.S.imm4_0};
    return rv+indx;
endfunction : eaS

task SB();
    Rdata td;
    reg [31:0] mask;
    Raddr wa;
    reg [1:0] low2;
    wa=eaS();
//    $display("storing a byte %h to %h",REG(inst.S.rs2),wa);
    low2=wa&32'h3;
    mask=32'hff<<(low2*8);
    td=MEM(wa);  // does a read/modify write
    td=(td& ~mask)| ((REG(inst.S.rs2)<<(low2*8))&mask);
//    $display("New memory data will be %h",td);
    WMEM(wa,td);
endtask : SB

task SH();
    Rdata [1:0] td;
    reg [63:0] wd;
    Raddr ra;
    reg [63:0] mask;
    reg [1:0] low2;
    ra=eaS();
    low2=ra&3;
    mask=64'hffff<<(low2*8);
    td[0]=MEM(ra);
    td[1]=MEM(ra+4);
    wd=REG(inst.S.rs2);
    td= (td& ~mask) | ((wd<<(low2*8))&mask);
    WMEM(ra,td[0]);
    WMEM(ra+4,td[1]);
endtask : SH

task SW();
    Rdata [1:0] td;
    reg [63:0] wd;
    Raddr ra;
    reg [63:0] mask;
    reg [1:0] low2;
    ra=eaS();
    low2=ra&3;
    mask=64'hffffFFFF<<(low2*8);
    td[0]=MEM(ra);
    td[1]=MEM(ra+4);
    wd=REG(inst.S.rs2);
    td= (td& ~mask) | ((wd<<(low2*8))&mask);
    WMEM(ra,td[0]);
    WMEM(ra+4,td[1]);
endtask : SW

task LUI();
    Rdata rv;
    rv={inst.U.imm31_12,12'h0};
    wreg(inst.U.rd,rv);
endtask : LUI

task AUIPC();
    Rdata rv;
    rv={inst.U.imm31_12,12'h0}+PC;
    wreg(inst.U.rd,rv);
endtask : AUIPC

task JAL();
    Raddr ta;
    ta={(inst.J.imm20_10_1_11_19_12[19])?12'hfff:12'h0,
        inst.J.imm20_10_1_11_19_12[19],
        inst.J.imm20_10_1_11_19_12[7:0],
        inst.J.imm20_10_1_11_19_12[8],
        inst.J.imm20_10_1_11_19_12[18:9],1'b0};
    ta+=PC;
    wreg(inst.J.rd,PC+4);
    PC=ta;
endtask : JAL

task JALR();
    Raddr ta;
    ta=eaI();
    wreg(inst.I.rd,PC+4);
    PC=ta;
endtask : JALR

task SLL();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a<<b[4:0];
    wreg(inst.R.rd,r);
endtask : SLL

task SRL();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a>>b[4:0];
    wreg(inst.R.rd,r);
endtask : SRL

task SRA();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a>>>b[4:0];
    wreg(inst.R.rd,r);
endtask : SRA

task ADD();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a+b;
    wreg(inst.R.rd,r);
endtask : ADD

task SUB();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a-b;
    wreg(inst.R.rd,r);
endtask : SUB

task SLT();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=(a<b)?1:0;
    wreg(inst.R.rd,r);
endtask : SLT

task SLTU();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=($unsigned(a)<$unsigned(b))?1:0;
    wreg(inst.R.rd,r);
endtask : SLTU

task XOR();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a^b;
    wreg(inst.R.rd,r);
endtask : XOR

task OR();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a|b;
    wreg(inst.R.rd,r);
endtask : OR

task AND();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a&b;
    wreg(inst.R.rd,r);
endtask : AND

task MUL();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a*b;
    wreg(inst.R.rd,r);
endtask : MUL

task MULU();
    reg [31:0] a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a*b;
    wreg(inst.R.rd,r);
endtask : MULU

task MULH();
    Rdata a,b;
    reg signed [63:0] r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a*b;
    wreg(inst.R.rd,r[63:32]);
endtask : MULH

task MULHU();
    reg [31:0] a,b;
    reg [63:0] r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a*b;
    wreg(inst.R.rd,r[63:32]);
endtask : MULHU

task MULHSU();
    reg [31:0] b;
    Rdata a;
    reg [63:0] r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a*b;
    wreg(inst.R.rd,r[63:32]);
endtask : MULHSU

task DIV();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a/b;
    wreg(inst.R.rd,r);
endtask : DIV

task DIVU();
    reg [31:0] a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a/b;
    wreg(inst.R.rd,r);
endtask : DIVU

task REM();
    Rdata a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a%b;
    wreg(inst.R.rd,r);
endtask : REM

task REMU();
    reg [31:0] a,b,r;
    a=REG(inst.R.rs1);
    b=REG(inst.R.rs2);
    r=a%b;
    wreg(inst.R.rd,r);
endtask : REMU


// A nop for this model
task FENCE();

endtask : FENCE

// A nop for this model
task FENCEI();

endtask : FENCEI


// Need to set up for the ECALL and EBREAK instructions
// Place holders for now
task ECALL();

endtask : ECALL

task EBREAK();

endtask : EBREAK

// CSR are a to do item.

task CSRRW();
    nextIns;
endtask : CSRRW

task CSRRS();
    nextIns;
endtask : CSRRS

task CSRRC();
    nextIns;
endtask : CSRRC

task CSRRWI();
    nextIns;
endtask : CSRRWI

task CSRRSI();
    nextIns;
endtask : CSRRSI

task CSRRCI();
    nextIns;
endtask : CSRRCI

task REMUL(reg reset);
    icnt+=1;
    finishedcode=0;
    if(reset) begin
        PC=32'h8000_0000;
        icnt=0;
        for(int ix=0; ix < 32; ix+=1) Reg[ix]=ix;
        $display("REMUL Reset complete\n");
    end else begin
        inst.raw=MEM(PC);
        #5;
        $display("%d %h (inst) @ %h ",icnt,inst.raw,PC);
        if (inst.R.ones!=2'b11) begin
            unsupported;
        end else case (inst.R.opcode5)
            5'b00000: begin
                case (inst.I.funct3)
                    3'b000: LB;
                    3'b001: LH;
                    3'b010: LW;
                    3'b100: LBU;
                    3'b101: LHU;
                    default:
                        unsupported;
                endcase
                nextIns;
            end
            5'b00011: begin
                case(inst.R.funct3)
                    3'b000: FENCE;
                    3'b001: FENCEI;
                    default:
                        unsupported;
                endcase
                nextIns;
            end
            5'b00100: begin
                case (inst.I.funct3)
                    3'b000: ADDI;
                    3'b001: begin
                        if(inst.R.funct7==0) SLLI;
                        else unsupported;
                    end
                    3'b010: SLTI;
                    3'b011: SLTIU;
                    3'b100: XORI;
                    3'b101: case(inst.R.funct7)
                        0: begin 
                            SRLI; 
                            $display("Congrats you ran the instruction"); 
                            end
                        7'h20 : SRAI;
                        default:
                            unsupported;
                    endcase
                    3'b110: ORI;
                    3'b111: ANDI;
                    default:
                        unsupported;
                endcase
                nextIns;
            end
            5'b00101: begin
                AUIPC;
                nextIns;
            end
            5'b01000: begin
                case(inst.I.funct3)
                    3'b000: SB;
                    3'b001: SH;
                    3'b010: SW;
                    default: unsupported;
                endcase
                nextIns;
            end
            5'b01100: begin
                case(inst.R.funct3)
                    3'b000: case(inst.R.funct7)
                        0: ADD;
                        7'b0100000: SUB;
                        7'b0000001: MUL;
                        default: unsupported;
                    endcase
                    3'b001: case(inst.R.funct7)
                        0: SLL;
                        7'b0000001: MULH;
                        default: unsupported;
                    endcase
                    3'b010: case(inst.R.funct7)
                        0: SLT;
                        7'b0000001: MULHSU;
                        default: unsupported;
                    endcase
                    3'b011: case(inst.R.funct7)
                        0: SLTU;
                        1: MULHU;
                        default: unsupported;
                    endcase
                    3'b100: case(inst.R.funct7)
                        0: XOR;
                        1: DIV;
                        default: unsupported;
                    endcase
                    3'b101: case (inst.R.funct7)
                        0: SRL;
                        1: DIVU;
                        7'b0100000: SRA;
                        default: unsupported;
                    endcase
                    3'b110: case(inst.R.funct7)
                        0: OR;
                        1: REM;
                        default: unsupported;
                    endcase
                    3'b111: case(inst.R.funct7)
                        0: AND;
                        1: REMU;
                        default: unsupported;
                    endcase
                endcase
                nextIns;
            end
            5'b01101: begin
                LUI;
                nextIns;
            end
            5'b11000: begin
                case (inst.B.funct3)
                    3'b000: BEQ;
                    3'b001: BNE;
                    3'b100: BLT;
                    3'b101: BGE;
                    3'b110: BLTU;
                    3'b111: BGEU;
                    default:
                        unsupported;
                endcase
            end
            5'b11001: begin
                if(inst.I.funct3==0) JALR;
                    else unsupported;
            end
            5'b11011: begin
                JAL;
            end
            5'b11100: begin
                case(inst.I.funct3)
                    3'b000: begin
                        case(inst[31:7])
                            0: ECALL;
                            'b000000000001_00000_000_00000: EBREAK;
                            default:
                                unsupported;
                        endcase
                    end
                    3'b001: CSRRW;
                    3'b010: CSRRS;
                    3'b011: CSRRC;
                    3'b101: CSRRWI;
                    3'b110: CSRRSI;
                    3'b111: CSRRCI;
                endcase
            end
            default:
              unsupported;
        endcase
    end
endtask : REMUL


