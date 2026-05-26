`timescale 1ns / 1ps
module instructionMem #(parameter instructionMemSizeInBytes = 6144)
(
    input             reset,
    input      [31:0] pcVal,
    output     [31:0] instruction
);
    reg [7:0] mem [instructionMemSizeInBytes-1 : 0];
    assign instruction = {mem[pcVal], mem[pcVal+1], mem[pcVal+2], mem[pcVal+3]};
    task load_program;
        integer i;
        begin
            for (i = 0; i < instructionMemSizeInBytes; i = i + 1) mem[i] = 8'h00;
            mem[0]=8'h3C; mem[1]=8'h08; mem[2]=8'hFF; mem[3]=8'hFF;      // lui  r8, 0xffff
            mem[4]=8'h35; mem[5]=8'h08; mem[6]=8'hFF; mem[7]=8'h00;      // ori  r8, r8, 0xff00
            mem[8]=8'h34; mem[9]=8'h01; mem[10]=8'h00; mem[11]=8'h19;    // ori  r1, r0, 0x0019
            mem[12]=8'h34; mem[13]=8'h02; mem[14]=8'h00; mem[15]=8'h19;  // ori  r2, r0, 0x0019
            mem[16]=8'h34; mem[17]=8'h03; mem[18]=8'h00; mem[19]=8'h3F;  // ori  r3, r0, 0x003f
            mem[20]=8'h34; mem[21]=8'h04; mem[22]=8'h00; mem[23]=8'h1F;  // ori  r4, r0, 0x001f
            mem[24]=8'h3C; mem[25]=8'h05; mem[26]=8'hFF; mem[27]=8'hFF;  // lui  r5, 0xffff
            mem[28]=8'h34; mem[29]=8'hA5; mem[30]=8'hFF; mem[31]=8'hFF;  // ori  r5, r5, 0xffff
            mem[32]=8'h34; mem[33]=8'h06; mem[34]=8'h00; mem[35]=8'h01;  // ori  r6, r0, 0x0001
            mem[36]=8'h00; mem[37]=8'h00; mem[38]=8'hA0; mem[39]=8'h20;  // add  r20, r0, r0
            mem[40]=8'h12; mem[41]=8'h80; mem[42]=8'h00; mem[43]=8'h08;  // beq  r20, r0, 0x0020
            mem[44]=8'h00; mem[45]=8'h00; mem[46]=8'h00; mem[47]=8'h00;  // nop
            mem[48]=8'h00; mem[49]=8'h00; mem[50]=8'h00; mem[51]=8'h00;  // nop
            mem[52]=8'h00; mem[53]=8'h00; mem[54]=8'h00; mem[55]=8'h00;  // nop
            mem[56]=8'h22; mem[57]=8'h94; mem[58]=8'hFF; mem[59]=8'hFF;  // addi r20, r20, -1
            mem[60]=8'h08; mem[61]=8'h00; mem[62]=8'h00; mem[63]=8'h0A;  // j    0x00000028
            mem[64]=8'h00; mem[65]=8'h00; mem[66]=8'h00; mem[67]=8'h00;  // nop
            mem[68]=8'h00; mem[69]=8'h00; mem[70]=8'h00; mem[71]=8'h00;  // nop
            mem[72]=8'h00; mem[73]=8'h00; mem[74]=8'h00; mem[75]=8'h00;  // nop
            mem[76]=8'h8D; mem[77]=8'h07; mem[78]=8'h00; mem[79]=8'h00;  // lw   r7, 0(r8)
            mem[80]=8'h8D; mem[81]=8'h09; mem[82]=8'h00; mem[83]=8'h01;  // lw   r9, 1(r8)
            mem[84]=8'h8D; mem[85]=8'h0A; mem[86]=8'h00; mem[87]=8'h02;  // lw   r10, 2(r8)
            mem[88]=8'h8D; mem[89]=8'h0B; mem[90]=8'h00; mem[91]=8'h03;  // lw   r11, 3(r8)
            mem[92]=8'h8D; mem[93]=8'h0C; mem[94]=8'h00; mem[95]=8'h04;  // lw   r12, 4(r8)
            mem[96]=8'h8D; mem[97]=8'h0D; mem[98]=8'h00; mem[99]=8'h05;  // lw   r13, 5(r8)
            mem[100]=8'h8D; mem[101]=8'h0E; mem[102]=8'h00; mem[103]=8'h06; // lw   r14, 6(r8)
            mem[104]=8'h11; mem[105]=8'hC0; mem[106]=8'h00; mem[107]=8'h0B; // beq  r14, r0, 0x002c
            mem[108]=8'h00; mem[109]=8'h00; mem[110]=8'h00; mem[111]=8'h00; // nop
            mem[112]=8'h00; mem[113]=8'h00; mem[114]=8'h00; mem[115]=8'h00; // nop
            mem[116]=8'h00; mem[117]=8'h00; mem[118]=8'h00; mem[119]=8'h00; // nop
            mem[120]=8'h34; mem[121]=8'h01; mem[122]=8'h00; mem[123]=8'h19; // ori  r1, r0, 0x0019
            mem[124]=8'h34; mem[125]=8'h02; mem[126]=8'h00; mem[127]=8'h19; // ori  r2, r0, 0x0019
            mem[128]=8'h34; mem[129]=8'h03; mem[130]=8'h00; mem[131]=8'h3F; // ori  r3, r0, 0x003f
            mem[132]=8'h34; mem[133]=8'h04; mem[134]=8'h00; mem[135]=8'h1F; // ori  r4, r0, 0x001f
            mem[136]=8'h3C; mem[137]=8'h05; mem[138]=8'hFF; mem[139]=8'hFF; // lui  r5, 0xffff
            mem[140]=8'h34; mem[141]=8'hA5; mem[142]=8'hFF; mem[143]=8'hFF; // ori  r5, r5, 0xffff
            mem[144]=8'h34; mem[145]=8'h06; mem[146]=8'h00; mem[147]=8'h01; // ori  r6, r0, 0x0001
            mem[148]=8'h00; mem[149]=8'h00; mem[150]=8'hA0; mem[151]=8'h20; // add  r20, r0, r0
            mem[152]=8'h11; mem[153]=8'h40; mem[154]=8'h00; mem[155]=8'h04; // beq  r10, r0, 0x0010
            mem[156]=8'h00; mem[157]=8'h00; mem[158]=8'h00; mem[159]=8'h00; // nop
            mem[160]=8'h00; mem[161]=8'h00; mem[162]=8'h00; mem[163]=8'h00; // nop
            mem[164]=8'h00; mem[165]=8'h00; mem[166]=8'h00; mem[167]=8'h00; // nop
            mem[168]=8'h20; mem[169]=8'h21; mem[170]=8'hFF; mem[171]=8'hFF; // addi r1, r1, -1
            mem[172]=8'h28; mem[173]=8'h27; mem[174]=8'h00; mem[175]=8'h01; // slti r7, r1, 1
            mem[176]=8'h10; mem[177]=8'hE0; mem[178]=8'h00; mem[179]=8'h04; // beq  r7, r0, 0x0010
            mem[180]=8'h00; mem[181]=8'h00; mem[182]=8'h00; mem[183]=8'h00; // nop
            mem[184]=8'h00; mem[185]=8'h00; mem[186]=8'h00; mem[187]=8'h00; // nop
            mem[188]=8'h00; mem[189]=8'h00; mem[190]=8'h00; mem[191]=8'h00; // nop
            mem[192]=8'h34; mem[193]=8'h01; mem[194]=8'h00; mem[195]=8'h01; // ori  r1, r0, 0x0001
            mem[196]=8'h11; mem[197]=8'h60; mem[198]=8'h00; mem[199]=8'h04; // beq  r11, r0, 0x0010
            mem[200]=8'h00; mem[201]=8'h00; mem[202]=8'h00; mem[203]=8'h00; // nop
            mem[204]=8'h00; mem[205]=8'h00; mem[206]=8'h00; mem[207]=8'h00; // nop
            mem[208]=8'h00; mem[209]=8'h00; mem[210]=8'h00; mem[211]=8'h00; // nop
            mem[212]=8'h20; mem[213]=8'h21; mem[214]=8'h00; mem[215]=8'h01; // addi r1, r1, 1
            mem[216]=8'h34; mem[217]=8'h07; mem[218]=8'h00; mem[219]=8'h31; // ori  r7, r0, 0x0031
            mem[220]=8'h00; mem[221]=8'hE1; mem[222]=8'h38; mem[223]=8'h2A; // slt  r7, r7, r1
            mem[224]=8'h10; mem[225]=8'hE0; mem[226]=8'h00; mem[227]=8'h04; // beq  r7, r0, 0x0010
            mem[228]=8'h00; mem[229]=8'h00; mem[230]=8'h00; mem[231]=8'h00; // nop
            mem[232]=8'h00; mem[233]=8'h00; mem[234]=8'h00; mem[235]=8'h00; // nop
            mem[236]=8'h00; mem[237]=8'h00; mem[238]=8'h00; mem[239]=8'h00; // nop
            mem[240]=8'h34; mem[241]=8'h01; mem[242]=8'h00; mem[243]=8'h31; // ori  r1, r0, 0x0031
            mem[244]=8'h11; mem[245]=8'h80; mem[246]=8'h00; mem[247]=8'h04; // beq  r12, r0, 0x0010
            mem[248]=8'h00; mem[249]=8'h00; mem[250]=8'h00; mem[251]=8'h00; // nop
            mem[252]=8'h00; mem[253]=8'h00; mem[254]=8'h00; mem[255]=8'h00; // nop
            mem[256]=8'h00; mem[257]=8'h00; mem[258]=8'h00; mem[259]=8'h00; // nop
            mem[260]=8'h20; mem[261]=8'h42; mem[262]=8'hFF; mem[263]=8'hFF; // addi r2, r2, -1
            mem[264]=8'h28; mem[265]=8'h47; mem[266]=8'h00; mem[267]=8'h01; // slti r7, r2, 1
            mem[268]=8'h10; mem[269]=8'hE0; mem[270]=8'h00; mem[271]=8'h04; // beq  r7, r0, 0x0010
            mem[272]=8'h00; mem[273]=8'h00; mem[274]=8'h00; mem[275]=8'h00; // nop
            mem[276]=8'h00; mem[277]=8'h00; mem[278]=8'h00; mem[279]=8'h00; // nop
            mem[280]=8'h00; mem[281]=8'h00; mem[282]=8'h00; mem[283]=8'h00; // nop
            mem[284]=8'h34; mem[285]=8'h02; mem[286]=8'h00; mem[287]=8'h01; // ori  r2, r0, 0x0001
            mem[288]=8'h11; mem[289]=8'hA0; mem[290]=8'h00; mem[291]=8'h04; // beq  r13, r0, 0x0010
            mem[292]=8'h00; mem[293]=8'h00; mem[294]=8'h00; mem[295]=8'h00; // nop
            mem[296]=8'h00; mem[297]=8'h00; mem[298]=8'h00; mem[299]=8'h00; // nop
            mem[300]=8'h00; mem[301]=8'h00; mem[302]=8'h00; mem[303]=8'h00; // nop
            mem[304]=8'h20; mem[305]=8'h42; mem[306]=8'h00; mem[307]=8'h01; // addi r2, r2, 1
            mem[308]=8'h34; mem[309]=8'h07; mem[310]=8'h00; mem[311]=8'h31; // ori  r7, r0, 0x0031
            mem[312]=8'h00; mem[313]=8'hE2; mem[314]=8'h38; mem[315]=8'h2A; // slt  r7, r7, r2
            mem[316]=8'h10; mem[317]=8'hE0; mem[318]=8'h00; mem[319]=8'h04; // beq  r7, r0, 0x0010
            mem[320]=8'h00; mem[321]=8'h00; mem[322]=8'h00; mem[323]=8'h00; // nop
            mem[324]=8'h00; mem[325]=8'h00; mem[326]=8'h00; mem[327]=8'h00; // nop
            mem[328]=8'h00; mem[329]=8'h00; mem[330]=8'h00; mem[331]=8'h00; // nop
            mem[332]=8'h34; mem[333]=8'h02; mem[334]=8'h00; mem[335]=8'h31; // ori  r2, r0, 0x0031
            mem[336]=8'h00; mem[337]=8'h65; mem[338]=8'h18; mem[339]=8'h20; // add  r3, r3, r5
            mem[340]=8'h00; mem[341]=8'h86; mem[342]=8'h20; mem[343]=8'h20; // add  r4, r4, r6
            mem[344]=8'h28; mem[345]=8'h87; mem[346]=8'h00; mem[347]=8'h01; // slti r7, r4, 1
            mem[348]=8'h10; mem[349]=8'hE0; mem[350]=8'h00; mem[351]=8'h05; // beq  r7, r0, 0x0014
            mem[352]=8'h00; mem[353]=8'h00; mem[354]=8'h00; mem[355]=8'h00; // nop
            mem[356]=8'h00; mem[357]=8'h00; mem[358]=8'h00; mem[359]=8'h00; // nop
            mem[360]=8'h00; mem[361]=8'h00; mem[362]=8'h00; mem[363]=8'h00; // nop
            mem[364]=8'h34; mem[365]=8'h06; mem[366]=8'h00; mem[367]=8'h01; // ori  r6, r0, 0x0001
            mem[368]=8'h34; mem[369]=8'h04; mem[370]=8'h00; mem[371]=8'h01; // ori  r4, r0, 0x0001
            mem[372]=8'h28; mem[373]=8'h87; mem[374]=8'h00; mem[375]=8'h3E; // slti r7, r4, 62
            mem[376]=8'h14; mem[377]=8'hE0; mem[378]=8'h00; mem[379]=8'h06; // bne  r7, r0, 0x0018
            mem[380]=8'h00; mem[381]=8'h00; mem[382]=8'h00; mem[383]=8'h00; // nop
            mem[384]=8'h00; mem[385]=8'h00; mem[386]=8'h00; mem[387]=8'h00; // nop
            mem[388]=8'h00; mem[389]=8'h00; mem[390]=8'h00; mem[391]=8'h00; // nop
            mem[392]=8'h3C; mem[393]=8'h06; mem[394]=8'hFF; mem[395]=8'hFF; // lui  r6, 0xffff
            mem[396]=8'h34; mem[397]=8'hC6; mem[398]=8'hFF; mem[399]=8'hFF; // ori  r6, r6, 0xffff
            mem[400]=8'h34; mem[401]=8'h04; mem[402]=8'h00; mem[403]=8'h3D; // ori  r4, r0, 0x003d
            mem[404]=8'h28; mem[405]=8'h67; mem[406]=8'h00; mem[407]=8'h06; // slti r7, r3, 6
            mem[408]=8'h10; mem[409]=8'hE0; mem[410]=8'h00; mem[411]=8'h2F; // beq  r7, r0, 0x00bc
            mem[412]=8'h00; mem[413]=8'h00; mem[414]=8'h00; mem[415]=8'h00; // nop
            mem[416]=8'h00; mem[417]=8'h00; mem[418]=8'h00; mem[419]=8'h00; // nop
            mem[420]=8'h00; mem[421]=8'h00; mem[422]=8'h00; mem[423]=8'h00; // nop
            mem[424]=8'h20; mem[425]=8'h8F; mem[426]=8'h00; mem[427]=8'h01; // addi r15, r4, 1
            mem[428]=8'h01; mem[429]=8'hE1; mem[430]=8'h78; mem[431]=8'h2A; // slt  r15, r15, r1
            mem[432]=8'h20; mem[433]=8'h30; mem[434]=8'h00; mem[435]=8'h0E; // addi r16, r1, 14
            mem[436]=8'h02; mem[437]=8'h04; mem[438]=8'h80; mem[439]=8'h2A; // slt  r16, r16, r4
            mem[440]=8'h01; mem[441]=8'hF0; mem[442]=8'h78; mem[443]=8'h25; // or   r15, r15, r16
            mem[444]=8'h11; mem[445]=8'hE0; mem[446]=8'h00; mem[447]=8'h0D; // beq  r15, r0, 0x0034
            mem[448]=8'h00; mem[449]=8'h00; mem[450]=8'h00; mem[451]=8'h00; // nop
            mem[452]=8'h00; mem[453]=8'h00; mem[454]=8'h00; mem[455]=8'h00; // nop
            mem[456]=8'h00; mem[457]=8'h00; mem[458]=8'h00; mem[459]=8'h00; // nop
            mem[460]=8'h34; mem[461]=8'h14; mem[462]=8'h03; mem[463]=8'hE8; // ori  r20, r0, 0x03e8
            mem[464]=8'h34; mem[465]=8'h03; mem[466]=8'h00; mem[467]=8'h3F; // ori  r3, r0, 0x003f
            mem[468]=8'h34; mem[469]=8'h04; mem[470]=8'h00; mem[471]=8'h1F; // ori  r4, r0, 0x001f
            mem[472]=8'h3C; mem[473]=8'h05; mem[474]=8'hFF; mem[475]=8'hFF; // lui  r5, 0xffff
            mem[476]=8'h34; mem[477]=8'hA5; mem[478]=8'hFF; mem[479]=8'hFF; // ori  r5, r5, 0xffff
            mem[480]=8'h34; mem[481]=8'h06; mem[482]=8'h00; mem[483]=8'h01; // ori  r6, r0, 0x0001
            mem[484]=8'h08; mem[485]=8'h00; mem[486]=8'h00; mem[487]=8'h0A; // j    0x00000028
            mem[488]=8'h00; mem[489]=8'h00; mem[490]=8'h00; mem[491]=8'h00; // nop
            mem[492]=8'h00; mem[493]=8'h00; mem[494]=8'h00; mem[495]=8'h00; // nop
            mem[496]=8'h00; mem[497]=8'h00; mem[498]=8'h00; mem[499]=8'h00; // nop
            mem[500]=8'h00; mem[501]=8'h81; mem[502]=8'h78; mem[503]=8'h22; // sub  r15, r4, r1
            mem[504]=8'h29; mem[505]=8'hF0; mem[506]=8'h00; mem[507]=8'h06; // slti r16, r15, 6
            mem[508]=8'h12; mem[509]=8'h00; mem[510]=8'h00; mem[511]=8'h09; // beq  r16, r0, 0x0024
            mem[512]=8'h00; mem[513]=8'h00; mem[514]=8'h00; mem[515]=8'h00; // nop
            mem[516]=8'h00; mem[517]=8'h00; mem[518]=8'h00; mem[519]=8'h00; // nop
            mem[520]=8'h00; mem[521]=8'h00; mem[522]=8'h00; mem[523]=8'h00; // nop
            mem[524]=8'h3C; mem[525]=8'h06; mem[526]=8'hFF; mem[527]=8'hFF; // lui  r6, 0xffff
            mem[528]=8'h34; mem[529]=8'hC6; mem[530]=8'hFF; mem[531]=8'hFF; // ori  r6, r6, 0xffff
            mem[532]=8'h08; mem[533]=8'h00; mem[534]=8'h00; mem[535]=8'h94; // j    0x00000250
            mem[536]=8'h00; mem[537]=8'h00; mem[538]=8'h00; mem[539]=8'h00; // nop
            mem[540]=8'h00; mem[541]=8'h00; mem[542]=8'h00; mem[543]=8'h00; // nop
            mem[544]=8'h00; mem[545]=8'h00; mem[546]=8'h00; mem[547]=8'h00; // nop
            mem[548]=8'h34; mem[549]=8'h10; mem[550]=8'h00; mem[551]=8'h08; // ori  r16, r0, 0x0008
            mem[552]=8'h02; mem[553]=8'h0F; mem[554]=8'h80; mem[555]=8'h2A; // slt  r16, r16, r15
            mem[556]=8'h34; mem[557]=8'h11; mem[558]=8'h00; mem[559]=8'h08; // ori  r17, r0, 0x0008
            mem[560]=8'h01; mem[561]=8'hF1; mem[562]=8'h88; mem[563]=8'h22; // sub  r17, r15, r17
            mem[564]=8'h2A; mem[565]=8'h31; mem[566]=8'h00; mem[567]=8'h01; // slti r17, r17, 1
            mem[568]=8'h02; mem[569]=8'h11; mem[570]=8'h80; mem[571]=8'h25; // or   r16, r16, r17
            mem[572]=8'h12; mem[573]=8'h00; mem[574]=8'h00; mem[575]=8'h04; // beq  r16, r0, 0x0010
            mem[576]=8'h00; mem[577]=8'h00; mem[578]=8'h00; mem[579]=8'h00; // nop
            mem[580]=8'h00; mem[581]=8'h00; mem[582]=8'h00; mem[583]=8'h00; // nop
            mem[584]=8'h00; mem[585]=8'h00; mem[586]=8'h00; mem[587]=8'h00; // nop
            mem[588]=8'h34; mem[589]=8'h06; mem[590]=8'h00; mem[591]=8'h01; // ori  r6, r0, 0x0001
            mem[592]=8'h00; mem[593]=8'h05; mem[594]=8'h28; mem[595]=8'h22; // sub  r5, r0, r5
            mem[596]=8'h34; mem[597]=8'h03; mem[598]=8'h00; mem[599]=8'h06; // ori  r3, r0, 0x0006
            mem[600]=8'h28; mem[601]=8'h67; mem[602]=8'h00; mem[603]=8'h79; // slti r7, r3, 121
            mem[604]=8'h14; mem[605]=8'hE0; mem[606]=8'h00; mem[607]=8'h2F; // bne  r7, r0, 0x00bc
            mem[608]=8'h00; mem[609]=8'h00; mem[610]=8'h00; mem[611]=8'h00; // nop
            mem[612]=8'h00; mem[613]=8'h00; mem[614]=8'h00; mem[615]=8'h00; // nop
            mem[616]=8'h00; mem[617]=8'h00; mem[618]=8'h00; mem[619]=8'h00; // nop
            mem[620]=8'h20; mem[621]=8'h8F; mem[622]=8'h00; mem[623]=8'h01; // addi r15, r4, 1
            mem[624]=8'h01; mem[625]=8'hE2; mem[626]=8'h78; mem[627]=8'h2A; // slt  r15, r15, r2
            mem[628]=8'h20; mem[629]=8'h50; mem[630]=8'h00; mem[631]=8'h0E; // addi r16, r2, 14
            mem[632]=8'h02; mem[633]=8'h04; mem[634]=8'h80; mem[635]=8'h2A; // slt  r16, r16, r4
            mem[636]=8'h01; mem[637]=8'hF0; mem[638]=8'h78; mem[639]=8'h25; // or   r15, r15, r16
            mem[640]=8'h11; mem[641]=8'hE0; mem[642]=8'h00; mem[643]=8'h0D; // beq  r15, r0, 0x0034
            mem[644]=8'h00; mem[645]=8'h00; mem[646]=8'h00; mem[647]=8'h00; // nop
            mem[648]=8'h00; mem[649]=8'h00; mem[650]=8'h00; mem[651]=8'h00; // nop
            mem[652]=8'h00; mem[653]=8'h00; mem[654]=8'h00; mem[655]=8'h00; // nop
            mem[656]=8'h34; mem[657]=8'h14; mem[658]=8'h03; mem[659]=8'hE8; // ori  r20, r0, 0x03e8
            mem[660]=8'h34; mem[661]=8'h03; mem[662]=8'h00; mem[663]=8'h3F; // ori  r3, r0, 0x003f
            mem[664]=8'h34; mem[665]=8'h04; mem[666]=8'h00; mem[667]=8'h1F; // ori  r4, r0, 0x001f
            mem[668]=8'h3C; mem[669]=8'h05; mem[670]=8'hFF; mem[671]=8'hFF; // lui  r5, 0xffff
            mem[672]=8'h34; mem[673]=8'hA5; mem[674]=8'hFF; mem[675]=8'hFF; // ori  r5, r5, 0xffff
            mem[676]=8'h34; mem[677]=8'h06; mem[678]=8'h00; mem[679]=8'h01; // ori  r6, r0, 0x0001
            mem[680]=8'h08; mem[681]=8'h00; mem[682]=8'h00; mem[683]=8'h0A; // j    0x00000028
            mem[684]=8'h00; mem[685]=8'h00; mem[686]=8'h00; mem[687]=8'h00; // nop
            mem[688]=8'h00; mem[689]=8'h00; mem[690]=8'h00; mem[691]=8'h00; // nop
            mem[692]=8'h00; mem[693]=8'h00; mem[694]=8'h00; mem[695]=8'h00; // nop
            mem[696]=8'h00; mem[697]=8'h82; mem[698]=8'h78; mem[699]=8'h22; // sub  r15, r4, r2
            mem[700]=8'h29; mem[701]=8'hF0; mem[702]=8'h00; mem[703]=8'h06; // slti r16, r15, 6
            mem[704]=8'h12; mem[705]=8'h00; mem[706]=8'h00; mem[707]=8'h09; // beq  r16, r0, 0x0024
            mem[708]=8'h00; mem[709]=8'h00; mem[710]=8'h00; mem[711]=8'h00; // nop
            mem[712]=8'h00; mem[713]=8'h00; mem[714]=8'h00; mem[715]=8'h00; // nop
            mem[716]=8'h00; mem[717]=8'h00; mem[718]=8'h00; mem[719]=8'h00; // nop
            mem[720]=8'h3C; mem[721]=8'h06; mem[722]=8'hFF; mem[723]=8'hFF; // lui  r6, 0xffff
            mem[724]=8'h34; mem[725]=8'hC6; mem[726]=8'hFF; mem[727]=8'hFF; // ori  r6, r6, 0xffff
            mem[728]=8'h08; mem[729]=8'h00; mem[730]=8'h00; mem[731]=8'hC5; // j    0x00000314
            mem[732]=8'h00; mem[733]=8'h00; mem[734]=8'h00; mem[735]=8'h00; // nop
            mem[736]=8'h00; mem[737]=8'h00; mem[738]=8'h00; mem[739]=8'h00; // nop
            mem[740]=8'h00; mem[741]=8'h00; mem[742]=8'h00; mem[743]=8'h00; // nop
            mem[744]=8'h34; mem[745]=8'h10; mem[746]=8'h00; mem[747]=8'h08; // ori  r16, r0, 0x0008
            mem[748]=8'h02; mem[749]=8'h0F; mem[750]=8'h80; mem[751]=8'h2A; // slt  r16, r16, r15
            mem[752]=8'h34; mem[753]=8'h11; mem[754]=8'h00; mem[755]=8'h08; // ori  r17, r0, 0x0008
            mem[756]=8'h01; mem[757]=8'hF1; mem[758]=8'h88; mem[759]=8'h22; // sub  r17, r15, r17
            mem[760]=8'h2A; mem[761]=8'h31; mem[762]=8'h00; mem[763]=8'h01; // slti r17, r17, 1
            mem[764]=8'h02; mem[765]=8'h11; mem[766]=8'h80; mem[767]=8'h25; // or   r16, r16, r17
            mem[768]=8'h12; mem[769]=8'h00; mem[770]=8'h00; mem[771]=8'h04; // beq  r16, r0, 0x0010
            mem[772]=8'h00; mem[773]=8'h00; mem[774]=8'h00; mem[775]=8'h00; // nop
            mem[776]=8'h00; mem[777]=8'h00; mem[778]=8'h00; mem[779]=8'h00; // nop
            mem[780]=8'h00; mem[781]=8'h00; mem[782]=8'h00; mem[783]=8'h00; // nop
            mem[784]=8'h34; mem[785]=8'h06; mem[786]=8'h00; mem[787]=8'h01; // ori  r6, r0, 0x0001
            mem[788]=8'h00; mem[789]=8'h05; mem[790]=8'h28; mem[791]=8'h22; // sub  r5, r0, r5
            mem[792]=8'h34; mem[793]=8'h03; mem[794]=8'h00; mem[795]=8'h78; // ori  r3, r0, 0x0078
            mem[796]=8'h08; mem[797]=8'h00; mem[798]=8'h00; mem[799]=8'h0A; // j    0x00000028
            mem[800]=8'h00; mem[801]=8'h00; mem[802]=8'h00; mem[803]=8'h00; // nop
            mem[804]=8'h00; mem[805]=8'h00; mem[806]=8'h00; mem[807]=8'h00; // nop
            mem[808]=8'h00; mem[809]=8'h00; mem[810]=8'h00; mem[811]=8'h00; // nop
        end
    endtask
    initial load_program;
    always @(posedge reset) load_program;
endmodule