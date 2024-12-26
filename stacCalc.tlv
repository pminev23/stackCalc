\m5_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
   m4_include_url(['https://raw.githubusercontent.com/stevehoover/tlv_flow_lib/221c93b3603bb4c72d3b024b3ec410e48f60e199/arrays.tlv'])


   m4_define(M4_NUM_INSTRS, 21)
   
\SV_plus
   logic [3:0] instrs [0:M4_NUM_INSTRS-1];
   logic [1*8-1:0] instrs_strs [0:M4_NUM_INSTRS-1];                
   assign instrs = '{
      4'hF, //    First
      4'h5, //    5
      4'h8, //    8
      4'h6, //    6
      4'hA, //    +
      4'h3, //    3
      4'h4, //    4
      4'hC, //    *
      4'hA, //    +  
      4'hb, //    -
      4'h2, //    2
      4'h4, //    4
      4'h7, //    7
      4'hb, //    -
      4'h3, //    3
      4'h8, //    8
      4'hb, //    -
      4'hc, //    *  
      4'ha, //    +
      4'ha, //    +
      4'hE  //    End
   };
   assign instrs_strs = '{
      "(", //    First
      "5", //    5
      "8", //    8
      "6", //    6
      "+", //    +
      "3", //    3
      "4", //    4
      "*", //    *
      "+", //    +  
      "-", //    -
      "2", //    2
      "4", //    4
      "7", //    7
      "-", //    -
      "3", //    3
      "8", //    8
      "-", //    -
      "*", //    *  
      "+", //    +
      "+", //    +
      ")"  //    End
   };
\TLV
   m4_define_hier(['M4_ENTRY'], 6)
   |example
      @0
         /instr_mem[20:0]
            $instr[4:0] = *instrs[instr_mem];
            $instr_strs[1*8-1:0] = *instrs_strs[instr_mem];
         // reset signal from instantiation of m4_makerchip_module above
         $reset = *reset;
         $data[7:0] =  $reset ? 8'h0 : ($op == 4'hA) ? $sum :
                  ($op == 4'hB) ? $dif :
                  ($op == 4'hC) ? $prod :
                  ($op == 4'hD) ? $quot :
                  ($op == 4'hE) ? >>1$data :
                  ($op == 4'hF) ? 8'h0 : {4'h0, /instr_mem[$pc]$instr};
         
         $op[3:0] = $reset ? 8'h0 : *instrs\[$pc\];
         $pc[4:0] = $reset ? 4'h0  :
                   (>>1$op == 4'hE) ? >>1$pc :
                    (>>1$pc + 1) % M4_NUM_INSTRS;
         $sp[3:0]  = $reset ? 8'h0 :
                     ($op >= 4'hA && $op < 4'hE) ? >>1$sp - 1 :
                     ($op == 4'hE) ? >>1$sp :
                     ($op == 4'hF) ? 4'h0 : >>1$sp + 1;
         
         $sum[7:0] = $tos + $nos;
         $dif[7:0] = $tos - $nos;
         $prod[7:0] = $tos * $nos;
         $quot[7:0] = $tos / $nos;
         $wr_en = 1'b1;
         $tos[7:0]  = $reset ? 8'h0 : >>1$data;
         $nos[7:0]  = $reset ? 8'h0 : /top|rd<>0$data;
         
         /instr_mem[20:0]
            \viz_js
               all: {
                        init() {
                                  let imem_header = new fabric.Text("Postfix Expression:", {
                                       top: 10,
                                       left: 140,
                                       fontSize: 22,
                                       fontWeight: 800,
                                       fontFamily: "monospace",
                                       fill: "#1b4f72"
                                    })
                                    return {imem_header}
                                 },
                        render() {// Highlight instruction.
                                    let pc = '|example$pc'.asInt(1)
                                    this.highlighted_addr = pc
                                    let instance = this.getContext().children[pc%20]
                                    instance.initObjects.instr_asm_box.set({fill: "#b0ffff"})
                        },
                        unrender() {// Unhighlight instruction.
                                    let instance = this.getContext().children[this.highlighted_addr%20]
                                    instance.initObjects.instr_asm_box.set({fill: "#fcf3cf"})
                        }
               },
               box: {strokeWidth: 0},
               where0: {left: -150, top: 40},
               layout: {left: 50}, //scope's instance stacked horizontally
               init() {
                        let instr_str = new fabric.Text("-" , {
                                    left: 40,
                                    fontSize: 22,
                                    fontFamily: "monospace"
                                 })
                        let instr_asm_box = new fabric.Rect({
                                    left: 30,
                                    fill: "#fcf3cf",
                                    width: 80,
                                    height: 30
                                 })
                       return {instr_asm_box, instr_str}
                      },
               render() { // Instruction memory is constant, so just create it once.
                            if (!this.initialized) {
                               let instr_str = '$instr_strs'.asString("?")
                               this.getObjects().instr_str.set({text: `${instr_str}`})
                               this.initialized = true
                            }
                         },
         \viz_js
            // JavaScript code
            box: {strokeWidth: 0},
            init() {
            let hexcalname = new fabric.Text("Calculations", {
              left: -150 + 128,
              top: -450 + 40,
              textAlign: "center",
              fontSize: 22,
              fontWeight: 600,
              fontFamily: "Timmana",
              fontStyle: "italic",
              fill: "#1b4f72",
            })
            let calbox = new fabric.Rect({
              left: -150,
              top: -430,
              fill: "#d0d8e0",
              width: 316,
              height: 366,
              strokeWidth: 3,
              stroke: "#a0a0a0",
            })
            let val1box = new fabric.Rect({
              left: -210 + 82,
              top: -450 + 83,
              fill: "#fdfefe",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let val1num = new fabric.Text("--------", {
              left: -210 + 80,
              top: -450 + 83 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let val2box = new fabric.Rect({
              left: -150 + 187,
              top: -450 + 83,
              fill: "#fdfefe",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let val2num = new fabric.Text("--------", {
              left: -150 + 185,
              top: -450 + 83 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let outbox = new fabric.Rect({
              left: -150 + 97,
              top: -450 + 248,
              fill: "#fdfefe",
              width: 199,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let outnum = new fabric.Text("--------", {
              left: -150 + 185,
              top: -450 + 248 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let equalname = new fabric.Text("=", {
              left: -150 + 38,
              top: -450 + 248,
              fontSize: 28,
              fontFamily: "Courier New",
            })
            let sumbox = new fabric.Rect({
              left: -158 + 28,
              top: -450 + 148,
              fill: "#fcf3cf",
              width: 64,
              height: 64,
              strokeWidth: 1,
              stroke: "#b0b0b0",
            })
            let prodbox = new fabric.Rect({
              left: -158 + 99,
              top: -450 + 148,
              fill: "#fcf3cf",
              width: 64,
              height: 64,
              strokeWidth: 1,
              stroke: "#b0b0b0",
            })
            let minbox = new fabric.Rect({
              left: -158 + 170,
              top: -450 + 148,
              fill: "#fcf3cf",
              width: 64,
              height: 64,
              strokeWidth: 1,
              stroke: "#b0b0b0",
            })
            let quotbox = new fabric.Rect({
              left: -158 + 241,
              top: -450 + 148,
              fill: "#fcf3cf",
              width: 64,
              height: 64,
              strokeWidth: 1,
              stroke: "#b0b0b0",
            })
            let sumicon = new fabric.Text("+", {
              left: -158 + 28 + 26,
              top: -450 + 148 + 22,
              fontSize: 22,
              fontFamily: "Times",
            })
            let prodicon = new fabric.Text("*", {
              left: -158 + 99 + 26,
              top: -450 + 148 + 22,
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let minicon = new fabric.Text("-", {
              left: -158 + 170 + 26,
              top: -450 + 148 + 22,
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let quoticon = new fabric.Text("/", {
              left: -158 + 241 + 26,
              top: -450 + 148 + 22,
              fontSize: 22,
              fontFamily: "Courier New",
            })
             let stackname = new fabric.Text("Stack", {
              left: 388,
              top: -308,
              textAlign: "center",
              fontSize: 22,
              fontWeight: 600,
              fontFamily: "Timmana",
              fontStyle: "italic",
              fill: "#1b4f72",
            })
            let stackval0box = new fabric.Rect({
              left: 370,
              top: -120,
              fill: "#d0d8e0",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let stackval0num = new fabric.Text("--------", {
              left: 370,
              top: -120 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let stackval1box = new fabric.Rect({
              left: 370,
              top: -160,
              fill: "#d0d8e0",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let stackval1num = new fabric.Text("--------", {
              left: 370,
              top: -160 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let stackval2box = new fabric.Rect({
              left: 370,
              top: -200,
              fill: "#d0d8e0",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let stackval2num = new fabric.Text("--------", {
              left: 370,
              top: -200 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let stackval3box = new fabric.Rect({
              left: 370,
              top: -240,
              fill: "#d0d8e0",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let stackval3num = new fabric.Text("--------", {
              left: 370,
              top: -240 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
               let stackval4box = new fabric.Rect({
              left: 370,
              top: -280,
              fill: "#d0d8e0",
              width: 109,
              height: 40,
              strokeWidth: 1,
              stroke: "#303030",
            })
            let stackval4num = new fabric.Text("--------", {
              left: 370,
              top: -280 + 8,
              textAlign: "right",
              fill: "#505050",
              fontSize: 22,
              fontFamily: "Courier New",
            })
            let stackPointer = new fabric.Text("TOS 🠖", {
                                       left: 280,
                                       top: -110,  // + 18 * topStack,
                                       //fill: color,
                                       fontSize: 22,
                                       fontFamily: "monospace",
                                       opacity: 0.75
                                    })
             let instr_pointer = new fabric.Text(" 🠕 ", {
                                       left: -140,
                                       top: 70,  // + 18 * topStack,
                                       //fill: color,
                                       fontSize: 22,
                                       fontFamily: "monospace",
                                       opacity: 0.75
                                   })
            return {instr_pointer, stackPointer, calbox, val1box, val1num, val2box, val2num,
                    outbox, outnum, equalname, sumbox, minbox, prodbox, quotbox, sumicon,
                    prodicon, minicon: minicon, quoticon: quoticon, hexcalname, stackname,
                    stackval0box, stackval0num, stackval1box, stackval1num,
                    stackval2box, stackval2num, stackval3box, stackval3num, stackval4box, stackval4num}

            },
            render() {
               let op = '$op'.asInt()
               let tos = '$tos'.step(1).asInt(0)
               let nos = '$nos'.step(1).asInt(0)
               let input1 = '$tos'.asInt()
               let input2 = '$nos'.asInt()
               let topStack = '$sp'.asInt()
               let pc = '$pc'.asInt()
               let stack1 = '/top/entry[5]<>0$data'.asInt()
               let stack2 = '/top/entry[4]<>0$data'.asInt()
               let stack3 = '/top/entry[3]<>0$data'.asInt()
               let stack4 = '/top/entry[2]<>0$data'.asInt()
               let stack5 = '/top/entry[1]<>0$data'.asInt()
               let calc = op >= 10 && op < 14
               this.getObjects().stackval0num.set({text: stack5.toString(16).padStart(8, " ")})
               this.getObjects().stackval1num.set({text: stack4.toString(16).padStart(8, " ")})
               this.getObjects().stackval2num.set({text: stack3.toString(16).padStart(8, " ")})
               this.getObjects().stackval3num.set({text: stack2.toString(16).padStart(8, " ")})
               this.getObjects().stackval4num.set({text: stack1.toString(16).padStart(8, " ")})
               this.getObjects().val1num.set({text: calc ? input1.toString(16).padStart(8, " ") : " "})
               this.getObjects().val2num.set({text: calc ? input2.toString(16).padStart(8, " ") : " "})
               this.getObjects().outnum.set({text: calc ? tos.toString(16).padStart(8, " ") : " " })
               this.getObjects().sumbox.set({fill: op == 10 ?  "#a9cce3" : "#fcf3cf"})
               this.getObjects().minbox.set({fill: op == 11 ?  "#a9cce3" : "#fcf3cf"})
               this.getObjects().prodbox.set({fill: op == 12 ? "#a9cce3" : "#fcf3cf"})
               this.getObjects().quotbox.set({fill: op == 13 ? "#a9cce3" : "#fcf3cf"})
               this.getObjects().stackPointer.set({top: -110 - 40 * (topStack - 1),})
               this.getObjects().instr_pointer.set({left: -150 + 50 * (pc%20),})
            }
 
   |rd
      @0
         $rd_en = 1'b1;
         $pnosp[3:0] = /top|example>>1$sp - 4'd1;
   m5+array1r1w(/top, /entry, |example, @0, $wr_en, $sp, |rd, @0, $rd_en, $pnosp, $data[7:0], )
         // Assert these to end simulation (before Makerchip cycle limit).
   
   |example
      @1
         *passed = ! $reset && $op == 4'hE;      // Simulation ends after 40 cycles
         *failed = 1'b0;


\SV
   endmodule      // close the module
