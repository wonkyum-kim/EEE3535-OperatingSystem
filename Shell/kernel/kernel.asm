
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a3010113          	addi	sp,sp,-1488 # 80008a30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	8a070713          	addi	a4,a4,-1888 # 800088f0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	ace78793          	addi	a5,a5,-1330 # 80005b30 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca9f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dc678793          	addi	a5,a5,-570 # 80000e72 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	372080e7          	jalr	882(ra) # 8000249c <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	780080e7          	jalr	1920(ra) # 800008ba <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	711d                	addi	sp,sp,-96
    80000166:	ec86                	sd	ra,88(sp)
    80000168:	e8a2                	sd	s0,80(sp)
    8000016a:	e4a6                	sd	s1,72(sp)
    8000016c:	e0ca                	sd	s2,64(sp)
    8000016e:	fc4e                	sd	s3,56(sp)
    80000170:	f852                	sd	s4,48(sp)
    80000172:	f456                	sd	s5,40(sp)
    80000174:	f05a                	sd	s6,32(sp)
    80000176:	ec5e                	sd	s7,24(sp)
    80000178:	1080                	addi	s0,sp,96
    8000017a:	8aaa                	mv	s5,a0
    8000017c:	8a2e                	mv	s4,a1
    8000017e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000180:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000184:	00011517          	auipc	a0,0x11
    80000188:	8ac50513          	addi	a0,a0,-1876 # 80010a30 <cons>
    8000018c:	00001097          	auipc	ra,0x1
    80000190:	a46080e7          	jalr	-1466(ra) # 80000bd2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000194:	00011497          	auipc	s1,0x11
    80000198:	89c48493          	addi	s1,s1,-1892 # 80010a30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000019c:	00011917          	auipc	s2,0x11
    800001a0:	92c90913          	addi	s2,s2,-1748 # 80010ac8 <cons+0x98>
  while(n > 0){
    800001a4:	09305263          	blez	s3,80000228 <consoleread+0xc4>
    while(cons.r == cons.w){
    800001a8:	0984a783          	lw	a5,152(s1)
    800001ac:	09c4a703          	lw	a4,156(s1)
    800001b0:	02f71763          	bne	a4,a5,800001de <consoleread+0x7a>
      if(killed(myproc())){
    800001b4:	00001097          	auipc	ra,0x1
    800001b8:	7e2080e7          	jalr	2018(ra) # 80001996 <myproc>
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	12a080e7          	jalr	298(ra) # 800022e6 <killed>
    800001c4:	ed2d                	bnez	a0,8000023e <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001c6:	85a6                	mv	a1,s1
    800001c8:	854a                	mv	a0,s2
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	e74080e7          	jalr	-396(ra) # 8000203e <sleep>
    while(cons.r == cons.w){
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fcf70de3          	beq	a4,a5,800001b4 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	85270713          	addi	a4,a4,-1966 # 80010a30 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	06db8463          	beq	s7,a3,80000266 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	00002097          	auipc	ra,0x2
    80000214:	236080e7          	jalr	566(ra) # 80002446 <either_copyout>
    80000218:	57fd                	li	a5,-1
    8000021a:	00f50763          	beq	a0,a5,80000228 <consoleread+0xc4>
      break;

    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000222:	47a9                	li	a5,10
    80000224:	f8fb90e3          	bne	s7,a5,800001a4 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	80850513          	addi	a0,a0,-2040 # 80010a30 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a56080e7          	jalr	-1450(ra) # 80000c86 <release>

  return target - n;
    80000238:	413b053b          	subw	a0,s6,s3
    8000023c:	a811                	j	80000250 <consoleread+0xec>
        release(&cons.lock);
    8000023e:	00010517          	auipc	a0,0x10
    80000242:	7f250513          	addi	a0,a0,2034 # 80010a30 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	a40080e7          	jalr	-1472(ra) # 80000c86 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
}
    80000250:	60e6                	ld	ra,88(sp)
    80000252:	6446                	ld	s0,80(sp)
    80000254:	64a6                	ld	s1,72(sp)
    80000256:	6906                	ld	s2,64(sp)
    80000258:	79e2                	ld	s3,56(sp)
    8000025a:	7a42                	ld	s4,48(sp)
    8000025c:	7aa2                	ld	s5,40(sp)
    8000025e:	7b02                	ld	s6,32(sp)
    80000260:	6be2                	ld	s7,24(sp)
    80000262:	6125                	addi	sp,sp,96
    80000264:	8082                	ret
      if(n < target){
    80000266:	0009871b          	sext.w	a4,s3
    8000026a:	fb677fe3          	bgeu	a4,s6,80000228 <consoleread+0xc4>
        cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	84f72d23          	sw	a5,-1958(a4) # 80010ac8 <cons+0x98>
    80000276:	bf4d                	j	80000228 <consoleread+0xc4>

0000000080000278 <consputc>:
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50a63          	beq	a0,a5,80000298 <consputc+0x20>
    uartputc_sync(c);
    80000288:	00000097          	auipc	ra,0x0
    8000028c:	560080e7          	jalr	1376(ra) # 800007e8 <uartputc_sync>
}
    80000290:	60a2                	ld	ra,8(sp)
    80000292:	6402                	ld	s0,0(sp)
    80000294:	0141                	addi	sp,sp,16
    80000296:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	54e080e7          	jalr	1358(ra) # 800007e8 <uartputc_sync>
    800002a2:	02000513          	li	a0,32
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	542080e7          	jalr	1346(ra) # 800007e8 <uartputc_sync>
    800002ae:	4521                	li	a0,8
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	538080e7          	jalr	1336(ra) # 800007e8 <uartputc_sync>
    800002b8:	bfe1                	j	80000290 <consputc+0x18>

00000000800002ba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ba:	1101                	addi	sp,sp,-32
    800002bc:	ec06                	sd	ra,24(sp)
    800002be:	e822                	sd	s0,16(sp)
    800002c0:	e426                	sd	s1,8(sp)
    800002c2:	e04a                	sd	s2,0(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00010517          	auipc	a0,0x10
    800002cc:	76850513          	addi	a0,a0,1896 # 80010a30 <cons>
    800002d0:	00001097          	auipc	ra,0x1
    800002d4:	902080e7          	jalr	-1790(ra) # 80000bd2 <acquire>

  switch(c){
    800002d8:	47d5                	li	a5,21
    800002da:	0af48663          	beq	s1,a5,80000386 <consoleintr+0xcc>
    800002de:	0297ca63          	blt	a5,s1,80000312 <consoleintr+0x58>
    800002e2:	47a1                	li	a5,8
    800002e4:	0ef48763          	beq	s1,a5,800003d2 <consoleintr+0x118>
    800002e8:	47c1                	li	a5,16
    800002ea:	10f49a63          	bne	s1,a5,800003fe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ee:	00002097          	auipc	ra,0x2
    800002f2:	204080e7          	jalr	516(ra) # 800024f2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f6:	00010517          	auipc	a0,0x10
    800002fa:	73a50513          	addi	a0,a0,1850 # 80010a30 <cons>
    800002fe:	00001097          	auipc	ra,0x1
    80000302:	988080e7          	jalr	-1656(ra) # 80000c86 <release>
}
    80000306:	60e2                	ld	ra,24(sp)
    80000308:	6442                	ld	s0,16(sp)
    8000030a:	64a2                	ld	s1,8(sp)
    8000030c:	6902                	ld	s2,0(sp)
    8000030e:	6105                	addi	sp,sp,32
    80000310:	8082                	ret
  switch(c){
    80000312:	07f00793          	li	a5,127
    80000316:	0af48e63          	beq	s1,a5,800003d2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031a:	00010717          	auipc	a4,0x10
    8000031e:	71670713          	addi	a4,a4,1814 # 80010a30 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09872703          	lw	a4,152(a4)
    8000032a:	9f99                	subw	a5,a5,a4
    8000032c:	07f00713          	li	a4,127
    80000330:	fcf763e3          	bltu	a4,a5,800002f6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000334:	47b5                	li	a5,13
    80000336:	0cf48763          	beq	s1,a5,80000404 <consoleintr+0x14a>
      consputc(c);
    8000033a:	8526                	mv	a0,s1
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f3c080e7          	jalr	-196(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000344:	00010797          	auipc	a5,0x10
    80000348:	6ec78793          	addi	a5,a5,1772 # 80010a30 <cons>
    8000034c:	0a07a683          	lw	a3,160(a5)
    80000350:	0016871b          	addiw	a4,a3,1
    80000354:	0007061b          	sext.w	a2,a4
    80000358:	0ae7a023          	sw	a4,160(a5)
    8000035c:	07f6f693          	andi	a3,a3,127
    80000360:	97b6                	add	a5,a5,a3
    80000362:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000366:	47a9                	li	a5,10
    80000368:	0cf48563          	beq	s1,a5,80000432 <consoleintr+0x178>
    8000036c:	4791                	li	a5,4
    8000036e:	0cf48263          	beq	s1,a5,80000432 <consoleintr+0x178>
    80000372:	00010797          	auipc	a5,0x10
    80000376:	7567a783          	lw	a5,1878(a5) # 80010ac8 <cons+0x98>
    8000037a:	9f1d                	subw	a4,a4,a5
    8000037c:	08000793          	li	a5,128
    80000380:	f6f71be3          	bne	a4,a5,800002f6 <consoleintr+0x3c>
    80000384:	a07d                	j	80000432 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000386:	00010717          	auipc	a4,0x10
    8000038a:	6aa70713          	addi	a4,a4,1706 # 80010a30 <cons>
    8000038e:	0a072783          	lw	a5,160(a4)
    80000392:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000396:	00010497          	auipc	s1,0x10
    8000039a:	69a48493          	addi	s1,s1,1690 # 80010a30 <cons>
    while(cons.e != cons.w &&
    8000039e:	4929                	li	s2,10
    800003a0:	f4f70be3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a4:	37fd                	addiw	a5,a5,-1
    800003a6:	07f7f713          	andi	a4,a5,127
    800003aa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ac:	01874703          	lbu	a4,24(a4)
    800003b0:	f52703e3          	beq	a4,s2,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003b4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b8:	10000513          	li	a0,256
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	ebc080e7          	jalr	-324(ra) # 80000278 <consputc>
    while(cons.e != cons.w &&
    800003c4:	0a04a783          	lw	a5,160(s1)
    800003c8:	09c4a703          	lw	a4,156(s1)
    800003cc:	fcf71ce3          	bne	a4,a5,800003a4 <consoleintr+0xea>
    800003d0:	b71d                	j	800002f6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d2:	00010717          	auipc	a4,0x10
    800003d6:	65e70713          	addi	a4,a4,1630 # 80010a30 <cons>
    800003da:	0a072783          	lw	a5,160(a4)
    800003de:	09c72703          	lw	a4,156(a4)
    800003e2:	f0f70ae3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003e6:	37fd                	addiw	a5,a5,-1
    800003e8:	00010717          	auipc	a4,0x10
    800003ec:	6ef72423          	sw	a5,1768(a4) # 80010ad0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f0:	10000513          	li	a0,256
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	e84080e7          	jalr	-380(ra) # 80000278 <consputc>
    800003fc:	bded                	j	800002f6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003fe:	ee048ce3          	beqz	s1,800002f6 <consoleintr+0x3c>
    80000402:	bf21                	j	8000031a <consoleintr+0x60>
      consputc(c);
    80000404:	4529                	li	a0,10
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	e72080e7          	jalr	-398(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000040e:	00010797          	auipc	a5,0x10
    80000412:	62278793          	addi	a5,a5,1570 # 80010a30 <cons>
    80000416:	0a07a703          	lw	a4,160(a5)
    8000041a:	0017069b          	addiw	a3,a4,1
    8000041e:	0006861b          	sext.w	a2,a3
    80000422:	0ad7a023          	sw	a3,160(a5)
    80000426:	07f77713          	andi	a4,a4,127
    8000042a:	97ba                	add	a5,a5,a4
    8000042c:	4729                	li	a4,10
    8000042e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000432:	00010797          	auipc	a5,0x10
    80000436:	68c7ad23          	sw	a2,1690(a5) # 80010acc <cons+0x9c>
        wakeup(&cons.r);
    8000043a:	00010517          	auipc	a0,0x10
    8000043e:	68e50513          	addi	a0,a0,1678 # 80010ac8 <cons+0x98>
    80000442:	00002097          	auipc	ra,0x2
    80000446:	c60080e7          	jalr	-928(ra) # 800020a2 <wakeup>
    8000044a:	b575                	j	800002f6 <consoleintr+0x3c>

000000008000044c <consoleinit>:

void
consoleinit(void)
{
    8000044c:	1141                	addi	sp,sp,-16
    8000044e:	e406                	sd	ra,8(sp)
    80000450:	e022                	sd	s0,0(sp)
    80000452:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000454:	00008597          	auipc	a1,0x8
    80000458:	bbc58593          	addi	a1,a1,-1092 # 80008010 <etext+0x10>
    8000045c:	00010517          	auipc	a0,0x10
    80000460:	5d450513          	addi	a0,a0,1492 # 80010a30 <cons>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	6de080e7          	jalr	1758(ra) # 80000b42 <initlock>

  uartinit();
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	32c080e7          	jalr	812(ra) # 80000798 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000474:	00020797          	auipc	a5,0x20
    80000478:	75478793          	addi	a5,a5,1876 # 80020bc8 <devsw>
    8000047c:	00000717          	auipc	a4,0x0
    80000480:	ce870713          	addi	a4,a4,-792 # 80000164 <consoleread>
    80000484:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	c7a70713          	addi	a4,a4,-902 # 80000100 <consolewrite>
    8000048e:	ef98                	sd	a4,24(a5)
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	addi	sp,sp,16
    80000496:	8082                	ret

0000000080000498 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000498:	7179                	addi	sp,sp,-48
    8000049a:	f406                	sd	ra,40(sp)
    8000049c:	f022                	sd	s0,32(sp)
    8000049e:	ec26                	sd	s1,24(sp)
    800004a0:	e84a                	sd	s2,16(sp)
    800004a2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a4:	c219                	beqz	a2,800004aa <printint+0x12>
    800004a6:	08054763          	bltz	a0,80000534 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004aa:	2501                	sext.w	a0,a0
    800004ac:	4881                	li	a7,0
    800004ae:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b4:	2581                	sext.w	a1,a1
    800004b6:	00008617          	auipc	a2,0x8
    800004ba:	b8a60613          	addi	a2,a2,-1142 # 80008040 <digits>
    800004be:	883a                	mv	a6,a4
    800004c0:	2705                	addiw	a4,a4,1
    800004c2:	02b577bb          	remuw	a5,a0,a1
    800004c6:	1782                	slli	a5,a5,0x20
    800004c8:	9381                	srli	a5,a5,0x20
    800004ca:	97b2                	add	a5,a5,a2
    800004cc:	0007c783          	lbu	a5,0(a5)
    800004d0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d4:	0005079b          	sext.w	a5,a0
    800004d8:	02b5553b          	divuw	a0,a0,a1
    800004dc:	0685                	addi	a3,a3,1
    800004de:	feb7f0e3          	bgeu	a5,a1,800004be <printint+0x26>

  if(sign)
    800004e2:	00088c63          	beqz	a7,800004fa <printint+0x62>
    buf[i++] = '-';
    800004e6:	fe070793          	addi	a5,a4,-32
    800004ea:	00878733          	add	a4,a5,s0
    800004ee:	02d00793          	li	a5,45
    800004f2:	fef70823          	sb	a5,-16(a4)
    800004f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fa:	02e05763          	blez	a4,80000528 <printint+0x90>
    800004fe:	fd040793          	addi	a5,s0,-48
    80000502:	00e784b3          	add	s1,a5,a4
    80000506:	fff78913          	addi	s2,a5,-1
    8000050a:	993a                	add	s2,s2,a4
    8000050c:	377d                	addiw	a4,a4,-1
    8000050e:	1702                	slli	a4,a4,0x20
    80000510:	9301                	srli	a4,a4,0x20
    80000512:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000516:	fff4c503          	lbu	a0,-1(s1)
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	d5e080e7          	jalr	-674(ra) # 80000278 <consputc>
  while(--i >= 0)
    80000522:	14fd                	addi	s1,s1,-1
    80000524:	ff2499e3          	bne	s1,s2,80000516 <printint+0x7e>
}
    80000528:	70a2                	ld	ra,40(sp)
    8000052a:	7402                	ld	s0,32(sp)
    8000052c:	64e2                	ld	s1,24(sp)
    8000052e:	6942                	ld	s2,16(sp)
    80000530:	6145                	addi	sp,sp,48
    80000532:	8082                	ret
    x = -xx;
    80000534:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000538:	4885                	li	a7,1
    x = -xx;
    8000053a:	bf95                	j	800004ae <printint+0x16>

000000008000053c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053c:	1101                	addi	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	addi	s0,sp,32
    80000546:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000548:	00010797          	auipc	a5,0x10
    8000054c:	5a07a423          	sw	zero,1448(a5) # 80010af0 <pr+0x18>
  printf("panic: ");
    80000550:	00008517          	auipc	a0,0x8
    80000554:	ac850513          	addi	a0,a0,-1336 # 80008018 <etext+0x18>
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	02e080e7          	jalr	46(ra) # 80000586 <printf>
  printf(s);
    80000560:	8526                	mv	a0,s1
    80000562:	00000097          	auipc	ra,0x0
    80000566:	024080e7          	jalr	36(ra) # 80000586 <printf>
  printf("\n");
    8000056a:	00008517          	auipc	a0,0x8
    8000056e:	b7e50513          	addi	a0,a0,-1154 # 800080e8 <digits+0xa8>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	014080e7          	jalr	20(ra) # 80000586 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057a:	4785                	li	a5,1
    8000057c:	00008717          	auipc	a4,0x8
    80000580:	32f72a23          	sw	a5,820(a4) # 800088b0 <panicked>
  for(;;)
    80000584:	a001                	j	80000584 <panic+0x48>

0000000080000586 <printf>:
{
    80000586:	7131                	addi	sp,sp,-192
    80000588:	fc86                	sd	ra,120(sp)
    8000058a:	f8a2                	sd	s0,112(sp)
    8000058c:	f4a6                	sd	s1,104(sp)
    8000058e:	f0ca                	sd	s2,96(sp)
    80000590:	ecce                	sd	s3,88(sp)
    80000592:	e8d2                	sd	s4,80(sp)
    80000594:	e4d6                	sd	s5,72(sp)
    80000596:	e0da                	sd	s6,64(sp)
    80000598:	fc5e                	sd	s7,56(sp)
    8000059a:	f862                	sd	s8,48(sp)
    8000059c:	f466                	sd	s9,40(sp)
    8000059e:	f06a                	sd	s10,32(sp)
    800005a0:	ec6e                	sd	s11,24(sp)
    800005a2:	0100                	addi	s0,sp,128
    800005a4:	8a2a                	mv	s4,a0
    800005a6:	e40c                	sd	a1,8(s0)
    800005a8:	e810                	sd	a2,16(s0)
    800005aa:	ec14                	sd	a3,24(s0)
    800005ac:	f018                	sd	a4,32(s0)
    800005ae:	f41c                	sd	a5,40(s0)
    800005b0:	03043823          	sd	a6,48(s0)
    800005b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b8:	00010d97          	auipc	s11,0x10
    800005bc:	538dad83          	lw	s11,1336(s11) # 80010af0 <pr+0x18>
  if(locking)
    800005c0:	020d9b63          	bnez	s11,800005f6 <printf+0x70>
  if (fmt == 0)
    800005c4:	040a0263          	beqz	s4,80000608 <printf+0x82>
  va_start(ap, fmt);
    800005c8:	00840793          	addi	a5,s0,8
    800005cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d0:	000a4503          	lbu	a0,0(s4)
    800005d4:	14050f63          	beqz	a0,80000732 <printf+0x1ac>
    800005d8:	4981                	li	s3,0
    if(c != '%'){
    800005da:	02500a93          	li	s5,37
    switch(c){
    800005de:	07000b93          	li	s7,112
  consputc('x');
    800005e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e4:	00008b17          	auipc	s6,0x8
    800005e8:	a5cb0b13          	addi	s6,s6,-1444 # 80008040 <digits>
    switch(c){
    800005ec:	07300c93          	li	s9,115
    800005f0:	06400c13          	li	s8,100
    800005f4:	a82d                	j	8000062e <printf+0xa8>
    acquire(&pr.lock);
    800005f6:	00010517          	auipc	a0,0x10
    800005fa:	4e250513          	addi	a0,a0,1250 # 80010ad8 <pr>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	5d4080e7          	jalr	1492(ra) # 80000bd2 <acquire>
    80000606:	bf7d                	j	800005c4 <printf+0x3e>
    panic("null fmt");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a2050513          	addi	a0,a0,-1504 # 80008028 <etext+0x28>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2c080e7          	jalr	-212(ra) # 8000053c <panic>
      consputc(c);
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	c60080e7          	jalr	-928(ra) # 80000278 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c503          	lbu	a0,0(a5)
    8000062a:	10050463          	beqz	a0,80000732 <printf+0x1ac>
    if(c != '%'){
    8000062e:	ff5515e3          	bne	a0,s5,80000618 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000632:	2985                	addiw	s3,s3,1
    80000634:	013a07b3          	add	a5,s4,s3
    80000638:	0007c783          	lbu	a5,0(a5)
    8000063c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000640:	cbed                	beqz	a5,80000732 <printf+0x1ac>
    switch(c){
    80000642:	05778a63          	beq	a5,s7,80000696 <printf+0x110>
    80000646:	02fbf663          	bgeu	s7,a5,80000672 <printf+0xec>
    8000064a:	09978863          	beq	a5,s9,800006da <printf+0x154>
    8000064e:	07800713          	li	a4,120
    80000652:	0ce79563          	bne	a5,a4,8000071c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000656:	f8843783          	ld	a5,-120(s0)
    8000065a:	00878713          	addi	a4,a5,8
    8000065e:	f8e43423          	sd	a4,-120(s0)
    80000662:	4605                	li	a2,1
    80000664:	85ea                	mv	a1,s10
    80000666:	4388                	lw	a0,0(a5)
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	e30080e7          	jalr	-464(ra) # 80000498 <printint>
      break;
    80000670:	bf45                	j	80000620 <printf+0x9a>
    switch(c){
    80000672:	09578f63          	beq	a5,s5,80000710 <printf+0x18a>
    80000676:	0b879363          	bne	a5,s8,8000071c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	addi	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4605                	li	a2,1
    80000688:	45a9                	li	a1,10
    8000068a:	4388                	lw	a0,0(a5)
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	e0c080e7          	jalr	-500(ra) # 80000498 <printint>
      break;
    80000694:	b771                	j	80000620 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a6:	03000513          	li	a0,48
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bce080e7          	jalr	-1074(ra) # 80000278 <consputc>
  consputc('x');
    800006b2:	07800513          	li	a0,120
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bc2080e7          	jalr	-1086(ra) # 80000278 <consputc>
    800006be:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c0:	03c95793          	srli	a5,s2,0x3c
    800006c4:	97da                	add	a5,a5,s6
    800006c6:	0007c503          	lbu	a0,0(a5)
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	bae080e7          	jalr	-1106(ra) # 80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d2:	0912                	slli	s2,s2,0x4
    800006d4:	34fd                	addiw	s1,s1,-1
    800006d6:	f4ed                	bnez	s1,800006c0 <printf+0x13a>
    800006d8:	b7a1                	j	80000620 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006da:	f8843783          	ld	a5,-120(s0)
    800006de:	00878713          	addi	a4,a5,8
    800006e2:	f8e43423          	sd	a4,-120(s0)
    800006e6:	6384                	ld	s1,0(a5)
    800006e8:	cc89                	beqz	s1,80000702 <printf+0x17c>
      for(; *s; s++)
    800006ea:	0004c503          	lbu	a0,0(s1)
    800006ee:	d90d                	beqz	a0,80000620 <printf+0x9a>
        consputc(*s);
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	b88080e7          	jalr	-1144(ra) # 80000278 <consputc>
      for(; *s; s++)
    800006f8:	0485                	addi	s1,s1,1
    800006fa:	0004c503          	lbu	a0,0(s1)
    800006fe:	f96d                	bnez	a0,800006f0 <printf+0x16a>
    80000700:	b705                	j	80000620 <printf+0x9a>
        s = "(null)";
    80000702:	00008497          	auipc	s1,0x8
    80000706:	91e48493          	addi	s1,s1,-1762 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070a:	02800513          	li	a0,40
    8000070e:	b7cd                	j	800006f0 <printf+0x16a>
      consputc('%');
    80000710:	8556                	mv	a0,s5
    80000712:	00000097          	auipc	ra,0x0
    80000716:	b66080e7          	jalr	-1178(ra) # 80000278 <consputc>
      break;
    8000071a:	b719                	j	80000620 <printf+0x9a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b5a080e7          	jalr	-1190(ra) # 80000278 <consputc>
      consputc(c);
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b50080e7          	jalr	-1200(ra) # 80000278 <consputc>
      break;
    80000730:	bdc5                	j	80000620 <printf+0x9a>
  if(locking)
    80000732:	020d9163          	bnez	s11,80000754 <printf+0x1ce>
}
    80000736:	70e6                	ld	ra,120(sp)
    80000738:	7446                	ld	s0,112(sp)
    8000073a:	74a6                	ld	s1,104(sp)
    8000073c:	7906                	ld	s2,96(sp)
    8000073e:	69e6                	ld	s3,88(sp)
    80000740:	6a46                	ld	s4,80(sp)
    80000742:	6aa6                	ld	s5,72(sp)
    80000744:	6b06                	ld	s6,64(sp)
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	7c42                	ld	s8,48(sp)
    8000074a:	7ca2                	ld	s9,40(sp)
    8000074c:	7d02                	ld	s10,32(sp)
    8000074e:	6de2                	ld	s11,24(sp)
    80000750:	6129                	addi	sp,sp,192
    80000752:	8082                	ret
    release(&pr.lock);
    80000754:	00010517          	auipc	a0,0x10
    80000758:	38450513          	addi	a0,a0,900 # 80010ad8 <pr>
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	52a080e7          	jalr	1322(ra) # 80000c86 <release>
}
    80000764:	bfc9                	j	80000736 <printf+0x1b0>

0000000080000766 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000766:	1101                	addi	sp,sp,-32
    80000768:	ec06                	sd	ra,24(sp)
    8000076a:	e822                	sd	s0,16(sp)
    8000076c:	e426                	sd	s1,8(sp)
    8000076e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000770:	00010497          	auipc	s1,0x10
    80000774:	36848493          	addi	s1,s1,872 # 80010ad8 <pr>
    80000778:	00008597          	auipc	a1,0x8
    8000077c:	8c058593          	addi	a1,a1,-1856 # 80008038 <etext+0x38>
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	3c0080e7          	jalr	960(ra) # 80000b42 <initlock>
  pr.locking = 1;
    8000078a:	4785                	li	a5,1
    8000078c:	cc9c                	sw	a5,24(s1)
}
    8000078e:	60e2                	ld	ra,24(sp)
    80000790:	6442                	ld	s0,16(sp)
    80000792:	64a2                	ld	s1,8(sp)
    80000794:	6105                	addi	sp,sp,32
    80000796:	8082                	ret

0000000080000798 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000798:	1141                	addi	sp,sp,-16
    8000079a:	e406                	sd	ra,8(sp)
    8000079c:	e022                	sd	s0,0(sp)
    8000079e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a0:	100007b7          	lui	a5,0x10000
    800007a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a8:	f8000713          	li	a4,-128
    800007ac:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b0:	470d                	li	a4,3
    800007b2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007ba:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007be:	469d                	li	a3,7
    800007c0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c8:	00008597          	auipc	a1,0x8
    800007cc:	89058593          	addi	a1,a1,-1904 # 80008058 <digits+0x18>
    800007d0:	00010517          	auipc	a0,0x10
    800007d4:	32850513          	addi	a0,a0,808 # 80010af8 <uart_tx_lock>
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	36a080e7          	jalr	874(ra) # 80000b42 <initlock>
}
    800007e0:	60a2                	ld	ra,8(sp)
    800007e2:	6402                	ld	s0,0(sp)
    800007e4:	0141                	addi	sp,sp,16
    800007e6:	8082                	ret

00000000800007e8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e8:	1101                	addi	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	1000                	addi	s0,sp,32
    800007f2:	84aa                	mv	s1,a0
  push_off();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	392080e7          	jalr	914(ra) # 80000b86 <push_off>

  if(panicked){
    800007fc:	00008797          	auipc	a5,0x8
    80000800:	0b47a783          	lw	a5,180(a5) # 800088b0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000804:	10000737          	lui	a4,0x10000
  if(panicked){
    80000808:	c391                	beqz	a5,8000080c <uartputc_sync+0x24>
    for(;;)
    8000080a:	a001                	j	8000080a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0207f793          	andi	a5,a5,32
    80000814:	dfe5                	beqz	a5,8000080c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000816:	0ff4f513          	zext.b	a0,s1
    8000081a:	100007b7          	lui	a5,0x10000
    8000081e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	404080e7          	jalr	1028(ra) # 80000c26 <pop_off>
}
    8000082a:	60e2                	ld	ra,24(sp)
    8000082c:	6442                	ld	s0,16(sp)
    8000082e:	64a2                	ld	s1,8(sp)
    80000830:	6105                	addi	sp,sp,32
    80000832:	8082                	ret

0000000080000834 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000834:	00008797          	auipc	a5,0x8
    80000838:	0847b783          	ld	a5,132(a5) # 800088b8 <uart_tx_r>
    8000083c:	00008717          	auipc	a4,0x8
    80000840:	08473703          	ld	a4,132(a4) # 800088c0 <uart_tx_w>
    80000844:	06f70a63          	beq	a4,a5,800008b8 <uartstart+0x84>
{
    80000848:	7139                	addi	sp,sp,-64
    8000084a:	fc06                	sd	ra,56(sp)
    8000084c:	f822                	sd	s0,48(sp)
    8000084e:	f426                	sd	s1,40(sp)
    80000850:	f04a                	sd	s2,32(sp)
    80000852:	ec4e                	sd	s3,24(sp)
    80000854:	e852                	sd	s4,16(sp)
    80000856:	e456                	sd	s5,8(sp)
    80000858:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085e:	00010a17          	auipc	s4,0x10
    80000862:	29aa0a13          	addi	s4,s4,666 # 80010af8 <uart_tx_lock>
    uart_tx_r += 1;
    80000866:	00008497          	auipc	s1,0x8
    8000086a:	05248493          	addi	s1,s1,82 # 800088b8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086e:	00008997          	auipc	s3,0x8
    80000872:	05298993          	addi	s3,s3,82 # 800088c0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000876:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087a:	02077713          	andi	a4,a4,32
    8000087e:	c705                	beqz	a4,800008a6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	01f7f713          	andi	a4,a5,31
    80000884:	9752                	add	a4,a4,s4
    80000886:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088a:	0785                	addi	a5,a5,1
    8000088c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088e:	8526                	mv	a0,s1
    80000890:	00002097          	auipc	ra,0x2
    80000894:	812080e7          	jalr	-2030(ra) # 800020a2 <wakeup>
    
    WriteReg(THR, c);
    80000898:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089c:	609c                	ld	a5,0(s1)
    8000089e:	0009b703          	ld	a4,0(s3)
    800008a2:	fcf71ae3          	bne	a4,a5,80000876 <uartstart+0x42>
  }
}
    800008a6:	70e2                	ld	ra,56(sp)
    800008a8:	7442                	ld	s0,48(sp)
    800008aa:	74a2                	ld	s1,40(sp)
    800008ac:	7902                	ld	s2,32(sp)
    800008ae:	69e2                	ld	s3,24(sp)
    800008b0:	6a42                	ld	s4,16(sp)
    800008b2:	6aa2                	ld	s5,8(sp)
    800008b4:	6121                	addi	sp,sp,64
    800008b6:	8082                	ret
    800008b8:	8082                	ret

00000000800008ba <uartputc>:
{
    800008ba:	7179                	addi	sp,sp,-48
    800008bc:	f406                	sd	ra,40(sp)
    800008be:	f022                	sd	s0,32(sp)
    800008c0:	ec26                	sd	s1,24(sp)
    800008c2:	e84a                	sd	s2,16(sp)
    800008c4:	e44e                	sd	s3,8(sp)
    800008c6:	e052                	sd	s4,0(sp)
    800008c8:	1800                	addi	s0,sp,48
    800008ca:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008cc:	00010517          	auipc	a0,0x10
    800008d0:	22c50513          	addi	a0,a0,556 # 80010af8 <uart_tx_lock>
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	2fe080e7          	jalr	766(ra) # 80000bd2 <acquire>
  if(panicked){
    800008dc:	00008797          	auipc	a5,0x8
    800008e0:	fd47a783          	lw	a5,-44(a5) # 800088b0 <panicked>
    800008e4:	e7c9                	bnez	a5,8000096e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	fda73703          	ld	a4,-38(a4) # 800088c0 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	fca7b783          	ld	a5,-54(a5) # 800088b8 <uart_tx_r>
    800008f6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fa:	00010997          	auipc	s3,0x10
    800008fe:	1fe98993          	addi	s3,s3,510 # 80010af8 <uart_tx_lock>
    80000902:	00008497          	auipc	s1,0x8
    80000906:	fb648493          	addi	s1,s1,-74 # 800088b8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090a:	00008917          	auipc	s2,0x8
    8000090e:	fb690913          	addi	s2,s2,-74 # 800088c0 <uart_tx_w>
    80000912:	00e79f63          	bne	a5,a4,80000930 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00001097          	auipc	ra,0x1
    8000091e:	724080e7          	jalr	1828(ra) # 8000203e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	addi	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00010497          	auipc	s1,0x10
    80000934:	1c848493          	addi	s1,s1,456 # 80010af8 <uart_tx_lock>
    80000938:	01f77793          	andi	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000942:	0705                	addi	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	f6e7be23          	sd	a4,-132(a5) # 800088c0 <uart_tx_w>
  uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee8080e7          	jalr	-280(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	330080e7          	jalr	816(ra) # 80000c86 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret
    for(;;)
    8000096e:	a001                	j	8000096e <uartputc+0xb4>

0000000080000970 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000970:	1141                	addi	sp,sp,-16
    80000972:	e422                	sd	s0,8(sp)
    80000974:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000976:	100007b7          	lui	a5,0x10000
    8000097a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097e:	8b85                	andi	a5,a5,1
    80000980:	cb81                	beqz	a5,80000990 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000982:	100007b7          	lui	a5,0x10000
    80000986:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098a:	6422                	ld	s0,8(sp)
    8000098c:	0141                	addi	sp,sp,16
    8000098e:	8082                	ret
    return -1;
    80000990:	557d                	li	a0,-1
    80000992:	bfe5                	j	8000098a <uartgetc+0x1a>

0000000080000994 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000994:	1101                	addi	sp,sp,-32
    80000996:	ec06                	sd	ra,24(sp)
    80000998:	e822                	sd	s0,16(sp)
    8000099a:	e426                	sd	s1,8(sp)
    8000099c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099e:	54fd                	li	s1,-1
    800009a0:	a029                	j	800009aa <uartintr+0x16>
      break;
    consoleintr(c);
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	918080e7          	jalr	-1768(ra) # 800002ba <consoleintr>
    int c = uartgetc();
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fc6080e7          	jalr	-58(ra) # 80000970 <uartgetc>
    if(c == -1)
    800009b2:	fe9518e3          	bne	a0,s1,800009a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b6:	00010497          	auipc	s1,0x10
    800009ba:	14248493          	addi	s1,s1,322 # 80010af8 <uart_tx_lock>
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	212080e7          	jalr	530(ra) # 80000bd2 <acquire>
  uartstart();
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	e6c080e7          	jalr	-404(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	2b4080e7          	jalr	692(ra) # 80000c86 <release>
}
    800009da:	60e2                	ld	ra,24(sp)
    800009dc:	6442                	ld	s0,16(sp)
    800009de:	64a2                	ld	s1,8(sp)
    800009e0:	6105                	addi	sp,sp,32
    800009e2:	8082                	ret

00000000800009e4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e4:	1101                	addi	sp,sp,-32
    800009e6:	ec06                	sd	ra,24(sp)
    800009e8:	e822                	sd	s0,16(sp)
    800009ea:	e426                	sd	s1,8(sp)
    800009ec:	e04a                	sd	s2,0(sp)
    800009ee:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f0:	03451793          	slli	a5,a0,0x34
    800009f4:	ebb9                	bnez	a5,80000a4a <kfree+0x66>
    800009f6:	84aa                	mv	s1,a0
    800009f8:	00021797          	auipc	a5,0x21
    800009fc:	36878793          	addi	a5,a5,872 # 80021d60 <end>
    80000a00:	04f56563          	bltu	a0,a5,80000a4a <kfree+0x66>
    80000a04:	47c5                	li	a5,17
    80000a06:	07ee                	slli	a5,a5,0x1b
    80000a08:	04f57163          	bgeu	a0,a5,80000a4a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0c:	6605                	lui	a2,0x1
    80000a0e:	4585                	li	a1,1
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	2be080e7          	jalr	702(ra) # 80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a18:	00010917          	auipc	s2,0x10
    80000a1c:	11890913          	addi	s2,s2,280 # 80010b30 <kmem>
    80000a20:	854a                	mv	a0,s2
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	1b0080e7          	jalr	432(ra) # 80000bd2 <acquire>
  r->next = kmem.freelist;
    80000a2a:	01893783          	ld	a5,24(s2)
    80000a2e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a30:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a34:	854a                	mv	a0,s2
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	250080e7          	jalr	592(ra) # 80000c86 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6902                	ld	s2,0(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret
    panic("kfree");
    80000a4a:	00007517          	auipc	a0,0x7
    80000a4e:	61650513          	addi	a0,a0,1558 # 80008060 <digits+0x20>
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	aea080e7          	jalr	-1302(ra) # 8000053c <panic>

0000000080000a5a <freerange>:
{
    80000a5a:	7179                	addi	sp,sp,-48
    80000a5c:	f406                	sd	ra,40(sp)
    80000a5e:	f022                	sd	s0,32(sp)
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e84a                	sd	s2,16(sp)
    80000a64:	e44e                	sd	s3,8(sp)
    80000a66:	e052                	sd	s4,0(sp)
    80000a68:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a70:	00e504b3          	add	s1,a0,a4
    80000a74:	777d                	lui	a4,0xfffff
    80000a76:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a78:	94be                	add	s1,s1,a5
    80000a7a:	0095ee63          	bltu	a1,s1,80000a96 <freerange+0x3c>
    80000a7e:	892e                	mv	s2,a1
    kfree(p);
    80000a80:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a82:	6985                	lui	s3,0x1
    kfree(p);
    80000a84:	01448533          	add	a0,s1,s4
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	f5c080e7          	jalr	-164(ra) # 800009e4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a90:	94ce                	add	s1,s1,s3
    80000a92:	fe9979e3          	bgeu	s2,s1,80000a84 <freerange+0x2a>
}
    80000a96:	70a2                	ld	ra,40(sp)
    80000a98:	7402                	ld	s0,32(sp)
    80000a9a:	64e2                	ld	s1,24(sp)
    80000a9c:	6942                	ld	s2,16(sp)
    80000a9e:	69a2                	ld	s3,8(sp)
    80000aa0:	6a02                	ld	s4,0(sp)
    80000aa2:	6145                	addi	sp,sp,48
    80000aa4:	8082                	ret

0000000080000aa6 <kinit>:
{
    80000aa6:	1141                	addi	sp,sp,-16
    80000aa8:	e406                	sd	ra,8(sp)
    80000aaa:	e022                	sd	s0,0(sp)
    80000aac:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aae:	00007597          	auipc	a1,0x7
    80000ab2:	5ba58593          	addi	a1,a1,1466 # 80008068 <digits+0x28>
    80000ab6:	00010517          	auipc	a0,0x10
    80000aba:	07a50513          	addi	a0,a0,122 # 80010b30 <kmem>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	084080e7          	jalr	132(ra) # 80000b42 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac6:	45c5                	li	a1,17
    80000ac8:	05ee                	slli	a1,a1,0x1b
    80000aca:	00021517          	auipc	a0,0x21
    80000ace:	29650513          	addi	a0,a0,662 # 80021d60 <end>
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f88080e7          	jalr	-120(ra) # 80000a5a <freerange>
}
    80000ada:	60a2                	ld	ra,8(sp)
    80000adc:	6402                	ld	s0,0(sp)
    80000ade:	0141                	addi	sp,sp,16
    80000ae0:	8082                	ret

0000000080000ae2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae2:	1101                	addi	sp,sp,-32
    80000ae4:	ec06                	sd	ra,24(sp)
    80000ae6:	e822                	sd	s0,16(sp)
    80000ae8:	e426                	sd	s1,8(sp)
    80000aea:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aec:	00010497          	auipc	s1,0x10
    80000af0:	04448493          	addi	s1,s1,68 # 80010b30 <kmem>
    80000af4:	8526                	mv	a0,s1
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	0dc080e7          	jalr	220(ra) # 80000bd2 <acquire>
  r = kmem.freelist;
    80000afe:	6c84                	ld	s1,24(s1)
  if(r)
    80000b00:	c885                	beqz	s1,80000b30 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b02:	609c                	ld	a5,0(s1)
    80000b04:	00010517          	auipc	a0,0x10
    80000b08:	02c50513          	addi	a0,a0,44 # 80010b30 <kmem>
    80000b0c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	178080e7          	jalr	376(ra) # 80000c86 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b16:	6605                	lui	a2,0x1
    80000b18:	4595                	li	a1,5
    80000b1a:	8526                	mv	a0,s1
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	1b2080e7          	jalr	434(ra) # 80000cce <memset>
  return (void*)r;
}
    80000b24:	8526                	mv	a0,s1
    80000b26:	60e2                	ld	ra,24(sp)
    80000b28:	6442                	ld	s0,16(sp)
    80000b2a:	64a2                	ld	s1,8(sp)
    80000b2c:	6105                	addi	sp,sp,32
    80000b2e:	8082                	ret
  release(&kmem.lock);
    80000b30:	00010517          	auipc	a0,0x10
    80000b34:	00050513          	mv	a0,a0
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	14e080e7          	jalr	334(ra) # 80000c86 <release>
  if(r)
    80000b40:	b7d5                	j	80000b24 <kalloc+0x42>

0000000080000b42 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b42:	1141                	addi	sp,sp,-16
    80000b44:	e422                	sd	s0,8(sp)
    80000b46:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b48:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4a:	00052023          	sw	zero,0(a0) # 80010b30 <kmem>
  lk->cpu = 0;
    80000b4e:	00053823          	sd	zero,16(a0)
}
    80000b52:	6422                	ld	s0,8(sp)
    80000b54:	0141                	addi	sp,sp,16
    80000b56:	8082                	ret

0000000080000b58 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b58:	411c                	lw	a5,0(a0)
    80000b5a:	e399                	bnez	a5,80000b60 <holding+0x8>
    80000b5c:	4501                	li	a0,0
  return r;
}
    80000b5e:	8082                	ret
{
    80000b60:	1101                	addi	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6a:	6904                	ld	s1,16(a0)
    80000b6c:	00001097          	auipc	ra,0x1
    80000b70:	e0e080e7          	jalr	-498(ra) # 8000197a <mycpu>
    80000b74:	40a48533          	sub	a0,s1,a0
    80000b78:	00153513          	seqz	a0,a0
}
    80000b7c:	60e2                	ld	ra,24(sp)
    80000b7e:	6442                	ld	s0,16(sp)
    80000b80:	64a2                	ld	s1,8(sp)
    80000b82:	6105                	addi	sp,sp,32
    80000b84:	8082                	ret

0000000080000b86 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b86:	1101                	addi	sp,sp,-32
    80000b88:	ec06                	sd	ra,24(sp)
    80000b8a:	e822                	sd	s0,16(sp)
    80000b8c:	e426                	sd	s1,8(sp)
    80000b8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b90:	100024f3          	csrr	s1,sstatus
    80000b94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9e:	00001097          	auipc	ra,0x1
    80000ba2:	ddc080e7          	jalr	-548(ra) # 8000197a <mycpu>
    80000ba6:	5d3c                	lw	a5,120(a0)
    80000ba8:	cf89                	beqz	a5,80000bc2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	dd0080e7          	jalr	-560(ra) # 8000197a <mycpu>
    80000bb2:	5d3c                	lw	a5,120(a0)
    80000bb4:	2785                	addiw	a5,a5,1
    80000bb6:	dd3c                	sw	a5,120(a0)
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret
    mycpu()->intena = old;
    80000bc2:	00001097          	auipc	ra,0x1
    80000bc6:	db8080e7          	jalr	-584(ra) # 8000197a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bca:	8085                	srli	s1,s1,0x1
    80000bcc:	8885                	andi	s1,s1,1
    80000bce:	dd64                	sw	s1,124(a0)
    80000bd0:	bfe9                	j	80000baa <push_off+0x24>

0000000080000bd2 <acquire>:
{
    80000bd2:	1101                	addi	sp,sp,-32
    80000bd4:	ec06                	sd	ra,24(sp)
    80000bd6:	e822                	sd	s0,16(sp)
    80000bd8:	e426                	sd	s1,8(sp)
    80000bda:	1000                	addi	s0,sp,32
    80000bdc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	fa8080e7          	jalr	-88(ra) # 80000b86 <push_off>
  if(holding(lk))
    80000be6:	8526                	mv	a0,s1
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	f70080e7          	jalr	-144(ra) # 80000b58 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf0:	4705                	li	a4,1
  if(holding(lk))
    80000bf2:	e115                	bnez	a0,80000c16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	87ba                	mv	a5,a4
    80000bf6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfa:	2781                	sext.w	a5,a5
    80000bfc:	ffe5                	bnez	a5,80000bf4 <acquire+0x22>
  __sync_synchronize();
    80000bfe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c02:	00001097          	auipc	ra,0x1
    80000c06:	d78080e7          	jalr	-648(ra) # 8000197a <mycpu>
    80000c0a:	e888                	sd	a0,16(s1)
}
    80000c0c:	60e2                	ld	ra,24(sp)
    80000c0e:	6442                	ld	s0,16(sp)
    80000c10:	64a2                	ld	s1,8(sp)
    80000c12:	6105                	addi	sp,sp,32
    80000c14:	8082                	ret
    panic("acquire");
    80000c16:	00007517          	auipc	a0,0x7
    80000c1a:	45a50513          	addi	a0,a0,1114 # 80008070 <digits+0x30>
    80000c1e:	00000097          	auipc	ra,0x0
    80000c22:	91e080e7          	jalr	-1762(ra) # 8000053c <panic>

0000000080000c26 <pop_off>:

void
pop_off(void)
{
    80000c26:	1141                	addi	sp,sp,-16
    80000c28:	e406                	sd	ra,8(sp)
    80000c2a:	e022                	sd	s0,0(sp)
    80000c2c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	d4c080e7          	jalr	-692(ra) # 8000197a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3c:	e78d                	bnez	a5,80000c66 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3e:	5d3c                	lw	a5,120(a0)
    80000c40:	02f05b63          	blez	a5,80000c76 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c44:	37fd                	addiw	a5,a5,-1
    80000c46:	0007871b          	sext.w	a4,a5
    80000c4a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4c:	eb09                	bnez	a4,80000c5e <pop_off+0x38>
    80000c4e:	5d7c                	lw	a5,124(a0)
    80000c50:	c799                	beqz	a5,80000c5e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5e:	60a2                	ld	ra,8(sp)
    80000c60:	6402                	ld	s0,0(sp)
    80000c62:	0141                	addi	sp,sp,16
    80000c64:	8082                	ret
    panic("pop_off - interruptible");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	41250513          	addi	a0,a0,1042 # 80008078 <digits+0x38>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8ce080e7          	jalr	-1842(ra) # 8000053c <panic>
    panic("pop_off");
    80000c76:	00007517          	auipc	a0,0x7
    80000c7a:	41a50513          	addi	a0,a0,1050 # 80008090 <digits+0x50>
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	8be080e7          	jalr	-1858(ra) # 8000053c <panic>

0000000080000c86 <release>:
{
    80000c86:	1101                	addi	sp,sp,-32
    80000c88:	ec06                	sd	ra,24(sp)
    80000c8a:	e822                	sd	s0,16(sp)
    80000c8c:	e426                	sd	s1,8(sp)
    80000c8e:	1000                	addi	s0,sp,32
    80000c90:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	ec6080e7          	jalr	-314(ra) # 80000b58 <holding>
    80000c9a:	c115                	beqz	a0,80000cbe <release+0x38>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca4:	0f50000f          	fence	iorw,ow
    80000ca8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	f7a080e7          	jalr	-134(ra) # 80000c26 <pop_off>
}
    80000cb4:	60e2                	ld	ra,24(sp)
    80000cb6:	6442                	ld	s0,16(sp)
    80000cb8:	64a2                	ld	s1,8(sp)
    80000cba:	6105                	addi	sp,sp,32
    80000cbc:	8082                	ret
    panic("release");
    80000cbe:	00007517          	auipc	a0,0x7
    80000cc2:	3da50513          	addi	a0,a0,986 # 80008098 <digits+0x58>
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	876080e7          	jalr	-1930(ra) # 8000053c <panic>

0000000080000cce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e422                	sd	s0,8(sp)
    80000cd2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd4:	ca19                	beqz	a2,80000cea <memset+0x1c>
    80000cd6:	87aa                	mv	a5,a0
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce4:	0785                	addi	a5,a5,1
    80000ce6:	fee79de3          	bne	a5,a4,80000ce0 <memset+0x12>
  }
  return dst;
}
    80000cea:	6422                	ld	s0,8(sp)
    80000cec:	0141                	addi	sp,sp,16
    80000cee:	8082                	ret

0000000080000cf0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf0:	1141                	addi	sp,sp,-16
    80000cf2:	e422                	sd	s0,8(sp)
    80000cf4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf6:	ca05                	beqz	a2,80000d26 <memcmp+0x36>
    80000cf8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfc:	1682                	slli	a3,a3,0x20
    80000cfe:	9281                	srli	a3,a3,0x20
    80000d00:	0685                	addi	a3,a3,1
    80000d02:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d04:	00054783          	lbu	a5,0(a0)
    80000d08:	0005c703          	lbu	a4,0(a1)
    80000d0c:	00e79863          	bne	a5,a4,80000d1c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d10:	0505                	addi	a0,a0,1
    80000d12:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d14:	fed518e3          	bne	a0,a3,80000d04 <memcmp+0x14>
  }

  return 0;
    80000d18:	4501                	li	a0,0
    80000d1a:	a019                	j	80000d20 <memcmp+0x30>
      return *s1 - *s2;
    80000d1c:	40e7853b          	subw	a0,a5,a4
}
    80000d20:	6422                	ld	s0,8(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret
  return 0;
    80000d26:	4501                	li	a0,0
    80000d28:	bfe5                	j	80000d20 <memcmp+0x30>

0000000080000d2a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d30:	c205                	beqz	a2,80000d50 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d32:	02a5e263          	bltu	a1,a0,80000d56 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d36:	1602                	slli	a2,a2,0x20
    80000d38:	9201                	srli	a2,a2,0x20
    80000d3a:	00c587b3          	add	a5,a1,a2
{
    80000d3e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d40:	0585                	addi	a1,a1,1
    80000d42:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd2a1>
    80000d44:	fff5c683          	lbu	a3,-1(a1)
    80000d48:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4c:	fef59ae3          	bne	a1,a5,80000d40 <memmove+0x16>

  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret
  if(s < d && s + n > d){
    80000d56:	02061693          	slli	a3,a2,0x20
    80000d5a:	9281                	srli	a3,a3,0x20
    80000d5c:	00d58733          	add	a4,a1,a3
    80000d60:	fce57be3          	bgeu	a0,a4,80000d36 <memmove+0xc>
    d += n;
    80000d64:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d66:	fff6079b          	addiw	a5,a2,-1
    80000d6a:	1782                	slli	a5,a5,0x20
    80000d6c:	9381                	srli	a5,a5,0x20
    80000d6e:	fff7c793          	not	a5,a5
    80000d72:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d74:	177d                	addi	a4,a4,-1
    80000d76:	16fd                	addi	a3,a3,-1
    80000d78:	00074603          	lbu	a2,0(a4)
    80000d7c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d80:	fee79ae3          	bne	a5,a4,80000d74 <memmove+0x4a>
    80000d84:	b7f1                	j	80000d50 <memmove+0x26>

0000000080000d86 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d86:	1141                	addi	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	f9c080e7          	jalr	-100(ra) # 80000d2a <memmove>
}
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	addi	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e422                	sd	s0,8(sp)
    80000da2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da4:	ce11                	beqz	a2,80000dc0 <strncmp+0x22>
    80000da6:	00054783          	lbu	a5,0(a0)
    80000daa:	cf89                	beqz	a5,80000dc4 <strncmp+0x26>
    80000dac:	0005c703          	lbu	a4,0(a1)
    80000db0:	00f71a63          	bne	a4,a5,80000dc4 <strncmp+0x26>
    n--, p++, q++;
    80000db4:	367d                	addiw	a2,a2,-1
    80000db6:	0505                	addi	a0,a0,1
    80000db8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dba:	f675                	bnez	a2,80000da6 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dbc:	4501                	li	a0,0
    80000dbe:	a809                	j	80000dd0 <strncmp+0x32>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a039                	j	80000dd0 <strncmp+0x32>
  if(n == 0)
    80000dc4:	ca09                	beqz	a2,80000dd6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dc6:	00054503          	lbu	a0,0(a0)
    80000dca:	0005c783          	lbu	a5,0(a1)
    80000dce:	9d1d                	subw	a0,a0,a5
}
    80000dd0:	6422                	ld	s0,8(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret
    return 0;
    80000dd6:	4501                	li	a0,0
    80000dd8:	bfe5                	j	80000dd0 <strncmp+0x32>

0000000080000dda <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e422                	sd	s0,8(sp)
    80000dde:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de0:	87aa                	mv	a5,a0
    80000de2:	86b2                	mv	a3,a2
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	00d05963          	blez	a3,80000df8 <strncpy+0x1e>
    80000dea:	0785                	addi	a5,a5,1
    80000dec:	0005c703          	lbu	a4,0(a1)
    80000df0:	fee78fa3          	sb	a4,-1(a5)
    80000df4:	0585                	addi	a1,a1,1
    80000df6:	f775                	bnez	a4,80000de2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df8:	873e                	mv	a4,a5
    80000dfa:	9fb5                	addw	a5,a5,a3
    80000dfc:	37fd                	addiw	a5,a5,-1
    80000dfe:	00c05963          	blez	a2,80000e10 <strncpy+0x36>
    *s++ = 0;
    80000e02:	0705                	addi	a4,a4,1
    80000e04:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e08:	40e786bb          	subw	a3,a5,a4
    80000e0c:	fed04be3          	bgtz	a3,80000e02 <strncpy+0x28>
  return os;
}
    80000e10:	6422                	ld	s0,8(sp)
    80000e12:	0141                	addi	sp,sp,16
    80000e14:	8082                	ret

0000000080000e16 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1c:	02c05363          	blez	a2,80000e42 <safestrcpy+0x2c>
    80000e20:	fff6069b          	addiw	a3,a2,-1
    80000e24:	1682                	slli	a3,a3,0x20
    80000e26:	9281                	srli	a3,a3,0x20
    80000e28:	96ae                	add	a3,a3,a1
    80000e2a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2c:	00d58963          	beq	a1,a3,80000e3e <safestrcpy+0x28>
    80000e30:	0585                	addi	a1,a1,1
    80000e32:	0785                	addi	a5,a5,1
    80000e34:	fff5c703          	lbu	a4,-1(a1)
    80000e38:	fee78fa3          	sb	a4,-1(a5)
    80000e3c:	fb65                	bnez	a4,80000e2c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <strlen>:

int
strlen(const char *s)
{
    80000e48:	1141                	addi	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf91                	beqz	a5,80000e6e <strlen+0x26>
    80000e54:	0505                	addi	a0,a0,1
    80000e56:	87aa                	mv	a5,a0
    80000e58:	86be                	mv	a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	ff65                	bnez	a4,80000e58 <strlen+0x10>
    80000e62:	40a6853b          	subw	a0,a3,a0
    80000e66:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strlen+0x20>

0000000080000e72 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e7a:	00001097          	auipc	ra,0x1
    80000e7e:	af0080e7          	jalr	-1296(ra) # 8000196a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	a4670713          	addi	a4,a4,-1466 # 800088c8 <started>
  if(cpuid() == 0){
    80000e8a:	c139                	beqz	a0,80000ed0 <main+0x5e>
    while(started == 0)
    80000e8c:	431c                	lw	a5,0(a4)
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	dff5                	beqz	a5,80000e8c <main+0x1a>
      ;
    __sync_synchronize();
    80000e92:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e96:	00001097          	auipc	ra,0x1
    80000e9a:	ad4080e7          	jalr	-1324(ra) # 8000196a <cpuid>
    80000e9e:	85aa                	mv	a1,a0
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	23850513          	addi	a0,a0,568 # 800080d8 <digits+0x98>
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	6de080e7          	jalr	1758(ra) # 80000586 <printf>
    kvminithart();    // turn on paging
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	0c8080e7          	jalr	200(ra) # 80000f78 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb8:	00001097          	auipc	ra,0x1
    80000ebc:	77c080e7          	jalr	1916(ra) # 80002634 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	cb0080e7          	jalr	-848(ra) # 80005b70 <plicinithart>
  }

  scheduler();        
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	fc4080e7          	jalr	-60(ra) # 80001e8c <scheduler>
    consoleinit();
    80000ed0:	fffff097          	auipc	ra,0xfffff
    80000ed4:	57c080e7          	jalr	1404(ra) # 8000044c <consoleinit>
    printfinit();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	88e080e7          	jalr	-1906(ra) # 80000766 <printfinit>
    printf("\n");
    80000ee0:	00007517          	auipc	a0,0x7
    80000ee4:	20850513          	addi	a0,a0,520 # 800080e8 <digits+0xa8>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	69e080e7          	jalr	1694(ra) # 80000586 <printf>
    printf("EEE3535 Operating Systems: booting xv6-riscv kernel\n");
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1b050513          	addi	a0,a0,432 # 800080a0 <digits+0x60>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	68e080e7          	jalr	1678(ra) # 80000586 <printf>
    kinit();         // physical page allocator
    80000f00:	00000097          	auipc	ra,0x0
    80000f04:	ba6080e7          	jalr	-1114(ra) # 80000aa6 <kinit>
    kvminit();       // create kernel page table
    80000f08:	00000097          	auipc	ra,0x0
    80000f0c:	326080e7          	jalr	806(ra) # 8000122e <kvminit>
    kvminithart();   // turn on paging
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	068080e7          	jalr	104(ra) # 80000f78 <kvminithart>
    procinit();      // process table
    80000f18:	00001097          	auipc	ra,0x1
    80000f1c:	99e080e7          	jalr	-1634(ra) # 800018b6 <procinit>
    trapinit();      // trap vectors
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	6ec080e7          	jalr	1772(ra) # 8000260c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	70c080e7          	jalr	1804(ra) # 80002634 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f30:	00005097          	auipc	ra,0x5
    80000f34:	c2a080e7          	jalr	-982(ra) # 80005b5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	c38080e7          	jalr	-968(ra) # 80005b70 <plicinithart>
    binit();         // buffer cache
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	e34080e7          	jalr	-460(ra) # 80002d74 <binit>
    iinit();         // inode table
    80000f48:	00002097          	auipc	ra,0x2
    80000f4c:	4d2080e7          	jalr	1234(ra) # 8000341a <iinit>
    fileinit();      // file table
    80000f50:	00003097          	auipc	ra,0x3
    80000f54:	448080e7          	jalr	1096(ra) # 80004398 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f58:	00005097          	auipc	ra,0x5
    80000f5c:	d20080e7          	jalr	-736(ra) # 80005c78 <virtio_disk_init>
    userinit();      // first user process
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	d0e080e7          	jalr	-754(ra) # 80001c6e <userinit>
    __sync_synchronize();
    80000f68:	0ff0000f          	fence
    started = 1;
    80000f6c:	4785                	li	a5,1
    80000f6e:	00008717          	auipc	a4,0x8
    80000f72:	94f72d23          	sw	a5,-1702(a4) # 800088c8 <started>
    80000f76:	bf89                	j	80000ec8 <main+0x56>

0000000080000f78 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f78:	1141                	addi	sp,sp,-16
    80000f7a:	e422                	sd	s0,8(sp)
    80000f7c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f7e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f82:	00008797          	auipc	a5,0x8
    80000f86:	94e7b783          	ld	a5,-1714(a5) # 800088d0 <kernel_pagetable>
    80000f8a:	83b1                	srli	a5,a5,0xc
    80000f8c:	577d                	li	a4,-1
    80000f8e:	177e                	slli	a4,a4,0x3f
    80000f90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f92:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f96:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f9a:	6422                	ld	s0,8(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret

0000000080000fa0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa0:	7139                	addi	sp,sp,-64
    80000fa2:	fc06                	sd	ra,56(sp)
    80000fa4:	f822                	sd	s0,48(sp)
    80000fa6:	f426                	sd	s1,40(sp)
    80000fa8:	f04a                	sd	s2,32(sp)
    80000faa:	ec4e                	sd	s3,24(sp)
    80000fac:	e852                	sd	s4,16(sp)
    80000fae:	e456                	sd	s5,8(sp)
    80000fb0:	e05a                	sd	s6,0(sp)
    80000fb2:	0080                	addi	s0,sp,64
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	89ae                	mv	s3,a1
    80000fb8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fba:	57fd                	li	a5,-1
    80000fbc:	83e9                	srli	a5,a5,0x1a
    80000fbe:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc2:	04b7f263          	bgeu	a5,a1,80001006 <walk+0x66>
    panic("walk");
    80000fc6:	00007517          	auipc	a0,0x7
    80000fca:	12a50513          	addi	a0,a0,298 # 800080f0 <digits+0xb0>
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	56e080e7          	jalr	1390(ra) # 8000053c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd6:	060a8663          	beqz	s5,80001042 <walk+0xa2>
    80000fda:	00000097          	auipc	ra,0x0
    80000fde:	b08080e7          	jalr	-1272(ra) # 80000ae2 <kalloc>
    80000fe2:	84aa                	mv	s1,a0
    80000fe4:	c529                	beqz	a0,8000102e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fe6:	6605                	lui	a2,0x1
    80000fe8:	4581                	li	a1,0
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	ce4080e7          	jalr	-796(ra) # 80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff2:	00c4d793          	srli	a5,s1,0xc
    80000ff6:	07aa                	slli	a5,a5,0xa
    80000ff8:	0017e793          	ori	a5,a5,1
    80000ffc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001000:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd297>
    80001002:	036a0063          	beq	s4,s6,80001022 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001006:	0149d933          	srl	s2,s3,s4
    8000100a:	1ff97913          	andi	s2,s2,511
    8000100e:	090e                	slli	s2,s2,0x3
    80001010:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001012:	00093483          	ld	s1,0(s2)
    80001016:	0014f793          	andi	a5,s1,1
    8000101a:	dfd5                	beqz	a5,80000fd6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000101c:	80a9                	srli	s1,s1,0xa
    8000101e:	04b2                	slli	s1,s1,0xc
    80001020:	b7c5                	j	80001000 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001022:	00c9d513          	srli	a0,s3,0xc
    80001026:	1ff57513          	andi	a0,a0,511
    8000102a:	050e                	slli	a0,a0,0x3
    8000102c:	9526                	add	a0,a0,s1
}
    8000102e:	70e2                	ld	ra,56(sp)
    80001030:	7442                	ld	s0,48(sp)
    80001032:	74a2                	ld	s1,40(sp)
    80001034:	7902                	ld	s2,32(sp)
    80001036:	69e2                	ld	s3,24(sp)
    80001038:	6a42                	ld	s4,16(sp)
    8000103a:	6aa2                	ld	s5,8(sp)
    8000103c:	6b02                	ld	s6,0(sp)
    8000103e:	6121                	addi	sp,sp,64
    80001040:	8082                	ret
        return 0;
    80001042:	4501                	li	a0,0
    80001044:	b7ed                	j	8000102e <walk+0x8e>

0000000080001046 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001046:	57fd                	li	a5,-1
    80001048:	83e9                	srli	a5,a5,0x1a
    8000104a:	00b7f463          	bgeu	a5,a1,80001052 <walkaddr+0xc>
    return 0;
    8000104e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001050:	8082                	ret
{
    80001052:	1141                	addi	sp,sp,-16
    80001054:	e406                	sd	ra,8(sp)
    80001056:	e022                	sd	s0,0(sp)
    80001058:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000105a:	4601                	li	a2,0
    8000105c:	00000097          	auipc	ra,0x0
    80001060:	f44080e7          	jalr	-188(ra) # 80000fa0 <walk>
  if(pte == 0)
    80001064:	c105                	beqz	a0,80001084 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001066:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001068:	0117f693          	andi	a3,a5,17
    8000106c:	4745                	li	a4,17
    return 0;
    8000106e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001070:	00e68663          	beq	a3,a4,8000107c <walkaddr+0x36>
}
    80001074:	60a2                	ld	ra,8(sp)
    80001076:	6402                	ld	s0,0(sp)
    80001078:	0141                	addi	sp,sp,16
    8000107a:	8082                	ret
  pa = PTE2PA(*pte);
    8000107c:	83a9                	srli	a5,a5,0xa
    8000107e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001082:	bfcd                	j	80001074 <walkaddr+0x2e>
    return 0;
    80001084:	4501                	li	a0,0
    80001086:	b7fd                	j	80001074 <walkaddr+0x2e>

0000000080001088 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001088:	715d                	addi	sp,sp,-80
    8000108a:	e486                	sd	ra,72(sp)
    8000108c:	e0a2                	sd	s0,64(sp)
    8000108e:	fc26                	sd	s1,56(sp)
    80001090:	f84a                	sd	s2,48(sp)
    80001092:	f44e                	sd	s3,40(sp)
    80001094:	f052                	sd	s4,32(sp)
    80001096:	ec56                	sd	s5,24(sp)
    80001098:	e85a                	sd	s6,16(sp)
    8000109a:	e45e                	sd	s7,8(sp)
    8000109c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000109e:	c639                	beqz	a2,800010ec <mappages+0x64>
    800010a0:	8aaa                	mv	s5,a0
    800010a2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010a4:	777d                	lui	a4,0xfffff
    800010a6:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010aa:	fff58993          	addi	s3,a1,-1
    800010ae:	99b2                	add	s3,s3,a2
    800010b0:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b4:	893e                	mv	s2,a5
    800010b6:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ba:	6b85                	lui	s7,0x1
    800010bc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c0:	4605                	li	a2,1
    800010c2:	85ca                	mv	a1,s2
    800010c4:	8556                	mv	a0,s5
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	eda080e7          	jalr	-294(ra) # 80000fa0 <walk>
    800010ce:	cd1d                	beqz	a0,8000110c <mappages+0x84>
    if(*pte & PTE_V)
    800010d0:	611c                	ld	a5,0(a0)
    800010d2:	8b85                	andi	a5,a5,1
    800010d4:	e785                	bnez	a5,800010fc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010d6:	80b1                	srli	s1,s1,0xc
    800010d8:	04aa                	slli	s1,s1,0xa
    800010da:	0164e4b3          	or	s1,s1,s6
    800010de:	0014e493          	ori	s1,s1,1
    800010e2:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e4:	05390063          	beq	s2,s3,80001124 <mappages+0x9c>
    a += PGSIZE;
    800010e8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ea:	bfc9                	j	800010bc <mappages+0x34>
    panic("mappages: size");
    800010ec:	00007517          	auipc	a0,0x7
    800010f0:	00c50513          	addi	a0,a0,12 # 800080f8 <digits+0xb8>
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	448080e7          	jalr	1096(ra) # 8000053c <panic>
      panic("mappages: remap");
    800010fc:	00007517          	auipc	a0,0x7
    80001100:	00c50513          	addi	a0,a0,12 # 80008108 <digits+0xc8>
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	438080e7          	jalr	1080(ra) # 8000053c <panic>
      return -1;
    8000110c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000110e:	60a6                	ld	ra,72(sp)
    80001110:	6406                	ld	s0,64(sp)
    80001112:	74e2                	ld	s1,56(sp)
    80001114:	7942                	ld	s2,48(sp)
    80001116:	79a2                	ld	s3,40(sp)
    80001118:	7a02                	ld	s4,32(sp)
    8000111a:	6ae2                	ld	s5,24(sp)
    8000111c:	6b42                	ld	s6,16(sp)
    8000111e:	6ba2                	ld	s7,8(sp)
    80001120:	6161                	addi	sp,sp,80
    80001122:	8082                	ret
  return 0;
    80001124:	4501                	li	a0,0
    80001126:	b7e5                	j	8000110e <mappages+0x86>

0000000080001128 <kvmmap>:
{
    80001128:	1141                	addi	sp,sp,-16
    8000112a:	e406                	sd	ra,8(sp)
    8000112c:	e022                	sd	s0,0(sp)
    8000112e:	0800                	addi	s0,sp,16
    80001130:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001132:	86b2                	mv	a3,a2
    80001134:	863e                	mv	a2,a5
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f52080e7          	jalr	-174(ra) # 80001088 <mappages>
    8000113e:	e509                	bnez	a0,80001148 <kvmmap+0x20>
}
    80001140:	60a2                	ld	ra,8(sp)
    80001142:	6402                	ld	s0,0(sp)
    80001144:	0141                	addi	sp,sp,16
    80001146:	8082                	ret
    panic("kvmmap");
    80001148:	00007517          	auipc	a0,0x7
    8000114c:	fd050513          	addi	a0,a0,-48 # 80008118 <digits+0xd8>
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	3ec080e7          	jalr	1004(ra) # 8000053c <panic>

0000000080001158 <kvmmake>:
{
    80001158:	1101                	addi	sp,sp,-32
    8000115a:	ec06                	sd	ra,24(sp)
    8000115c:	e822                	sd	s0,16(sp)
    8000115e:	e426                	sd	s1,8(sp)
    80001160:	e04a                	sd	s2,0(sp)
    80001162:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001164:	00000097          	auipc	ra,0x0
    80001168:	97e080e7          	jalr	-1666(ra) # 80000ae2 <kalloc>
    8000116c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000116e:	6605                	lui	a2,0x1
    80001170:	4581                	li	a1,0
    80001172:	00000097          	auipc	ra,0x0
    80001176:	b5c080e7          	jalr	-1188(ra) # 80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000117a:	4719                	li	a4,6
    8000117c:	6685                	lui	a3,0x1
    8000117e:	10000637          	lui	a2,0x10000
    80001182:	100005b7          	lui	a1,0x10000
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	fa0080e7          	jalr	-96(ra) # 80001128 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10001637          	lui	a2,0x10001
    80001198:	100015b7          	lui	a1,0x10001
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	f8a080e7          	jalr	-118(ra) # 80001128 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	004006b7          	lui	a3,0x400
    800011ac:	0c000637          	lui	a2,0xc000
    800011b0:	0c0005b7          	lui	a1,0xc000
    800011b4:	8526                	mv	a0,s1
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f72080e7          	jalr	-142(ra) # 80001128 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011be:	00007917          	auipc	s2,0x7
    800011c2:	e4290913          	addi	s2,s2,-446 # 80008000 <etext>
    800011c6:	4729                	li	a4,10
    800011c8:	80007697          	auipc	a3,0x80007
    800011cc:	e3868693          	addi	a3,a3,-456 # 8000 <_entry-0x7fff8000>
    800011d0:	4605                	li	a2,1
    800011d2:	067e                	slli	a2,a2,0x1f
    800011d4:	85b2                	mv	a1,a2
    800011d6:	8526                	mv	a0,s1
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f50080e7          	jalr	-176(ra) # 80001128 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011e0:	4719                	li	a4,6
    800011e2:	46c5                	li	a3,17
    800011e4:	06ee                	slli	a3,a3,0x1b
    800011e6:	412686b3          	sub	a3,a3,s2
    800011ea:	864a                	mv	a2,s2
    800011ec:	85ca                	mv	a1,s2
    800011ee:	8526                	mv	a0,s1
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	f38080e7          	jalr	-200(ra) # 80001128 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011f8:	4729                	li	a4,10
    800011fa:	6685                	lui	a3,0x1
    800011fc:	00006617          	auipc	a2,0x6
    80001200:	e0460613          	addi	a2,a2,-508 # 80007000 <_trampoline>
    80001204:	040005b7          	lui	a1,0x4000
    80001208:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000120a:	05b2                	slli	a1,a1,0xc
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f1a080e7          	jalr	-230(ra) # 80001128 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001216:	8526                	mv	a0,s1
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	608080e7          	jalr	1544(ra) # 80001820 <proc_mapstacks>
}
    80001220:	8526                	mv	a0,s1
    80001222:	60e2                	ld	ra,24(sp)
    80001224:	6442                	ld	s0,16(sp)
    80001226:	64a2                	ld	s1,8(sp)
    80001228:	6902                	ld	s2,0(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <kvminit>:
{
    8000122e:	1141                	addi	sp,sp,-16
    80001230:	e406                	sd	ra,8(sp)
    80001232:	e022                	sd	s0,0(sp)
    80001234:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f22080e7          	jalr	-222(ra) # 80001158 <kvmmake>
    8000123e:	00007797          	auipc	a5,0x7
    80001242:	68a7b923          	sd	a0,1682(a5) # 800088d0 <kernel_pagetable>
}
    80001246:	60a2                	ld	ra,8(sp)
    80001248:	6402                	ld	s0,0(sp)
    8000124a:	0141                	addi	sp,sp,16
    8000124c:	8082                	ret

000000008000124e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000124e:	715d                	addi	sp,sp,-80
    80001250:	e486                	sd	ra,72(sp)
    80001252:	e0a2                	sd	s0,64(sp)
    80001254:	fc26                	sd	s1,56(sp)
    80001256:	f84a                	sd	s2,48(sp)
    80001258:	f44e                	sd	s3,40(sp)
    8000125a:	f052                	sd	s4,32(sp)
    8000125c:	ec56                	sd	s5,24(sp)
    8000125e:	e85a                	sd	s6,16(sp)
    80001260:	e45e                	sd	s7,8(sp)
    80001262:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001264:	03459793          	slli	a5,a1,0x34
    80001268:	e795                	bnez	a5,80001294 <uvmunmap+0x46>
    8000126a:	8a2a                	mv	s4,a0
    8000126c:	892e                	mv	s2,a1
    8000126e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001270:	0632                	slli	a2,a2,0xc
    80001272:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001276:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	6b05                	lui	s6,0x1
    8000127a:	0735e263          	bltu	a1,s3,800012de <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000127e:	60a6                	ld	ra,72(sp)
    80001280:	6406                	ld	s0,64(sp)
    80001282:	74e2                	ld	s1,56(sp)
    80001284:	7942                	ld	s2,48(sp)
    80001286:	79a2                	ld	s3,40(sp)
    80001288:	7a02                	ld	s4,32(sp)
    8000128a:	6ae2                	ld	s5,24(sp)
    8000128c:	6b42                	ld	s6,16(sp)
    8000128e:	6ba2                	ld	s7,8(sp)
    80001290:	6161                	addi	sp,sp,80
    80001292:	8082                	ret
    panic("uvmunmap: not aligned");
    80001294:	00007517          	auipc	a0,0x7
    80001298:	e8c50513          	addi	a0,a0,-372 # 80008120 <digits+0xe0>
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	2a0080e7          	jalr	672(ra) # 8000053c <panic>
      panic("uvmunmap: walk");
    800012a4:	00007517          	auipc	a0,0x7
    800012a8:	e9450513          	addi	a0,a0,-364 # 80008138 <digits+0xf8>
    800012ac:	fffff097          	auipc	ra,0xfffff
    800012b0:	290080e7          	jalr	656(ra) # 8000053c <panic>
      panic("uvmunmap: not mapped");
    800012b4:	00007517          	auipc	a0,0x7
    800012b8:	e9450513          	addi	a0,a0,-364 # 80008148 <digits+0x108>
    800012bc:	fffff097          	auipc	ra,0xfffff
    800012c0:	280080e7          	jalr	640(ra) # 8000053c <panic>
      panic("uvmunmap: not a leaf");
    800012c4:	00007517          	auipc	a0,0x7
    800012c8:	e9c50513          	addi	a0,a0,-356 # 80008160 <digits+0x120>
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	270080e7          	jalr	624(ra) # 8000053c <panic>
    *pte = 0;
    800012d4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d8:	995a                	add	s2,s2,s6
    800012da:	fb3972e3          	bgeu	s2,s3,8000127e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012de:	4601                	li	a2,0
    800012e0:	85ca                	mv	a1,s2
    800012e2:	8552                	mv	a0,s4
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	cbc080e7          	jalr	-836(ra) # 80000fa0 <walk>
    800012ec:	84aa                	mv	s1,a0
    800012ee:	d95d                	beqz	a0,800012a4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f0:	6108                	ld	a0,0(a0)
    800012f2:	00157793          	andi	a5,a0,1
    800012f6:	dfdd                	beqz	a5,800012b4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012f8:	3ff57793          	andi	a5,a0,1023
    800012fc:	fd7784e3          	beq	a5,s7,800012c4 <uvmunmap+0x76>
    if(do_free){
    80001300:	fc0a8ae3          	beqz	s5,800012d4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001304:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001306:	0532                	slli	a0,a0,0xc
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	6dc080e7          	jalr	1756(ra) # 800009e4 <kfree>
    80001310:	b7d1                	j	800012d4 <uvmunmap+0x86>

0000000080001312 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001312:	1101                	addi	sp,sp,-32
    80001314:	ec06                	sd	ra,24(sp)
    80001316:	e822                	sd	s0,16(sp)
    80001318:	e426                	sd	s1,8(sp)
    8000131a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	7c6080e7          	jalr	1990(ra) # 80000ae2 <kalloc>
    80001324:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001326:	c519                	beqz	a0,80001334 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001328:	6605                	lui	a2,0x1
    8000132a:	4581                	li	a1,0
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	9a2080e7          	jalr	-1630(ra) # 80000cce <memset>
  return pagetable;
}
    80001334:	8526                	mv	a0,s1
    80001336:	60e2                	ld	ra,24(sp)
    80001338:	6442                	ld	s0,16(sp)
    8000133a:	64a2                	ld	s1,8(sp)
    8000133c:	6105                	addi	sp,sp,32
    8000133e:	8082                	ret

0000000080001340 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001340:	7179                	addi	sp,sp,-48
    80001342:	f406                	sd	ra,40(sp)
    80001344:	f022                	sd	s0,32(sp)
    80001346:	ec26                	sd	s1,24(sp)
    80001348:	e84a                	sd	s2,16(sp)
    8000134a:	e44e                	sd	s3,8(sp)
    8000134c:	e052                	sd	s4,0(sp)
    8000134e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001350:	6785                	lui	a5,0x1
    80001352:	04f67863          	bgeu	a2,a5,800013a2 <uvmfirst+0x62>
    80001356:	8a2a                	mv	s4,a0
    80001358:	89ae                	mv	s3,a1
    8000135a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	786080e7          	jalr	1926(ra) # 80000ae2 <kalloc>
    80001364:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001366:	6605                	lui	a2,0x1
    80001368:	4581                	li	a1,0
    8000136a:	00000097          	auipc	ra,0x0
    8000136e:	964080e7          	jalr	-1692(ra) # 80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001372:	4779                	li	a4,30
    80001374:	86ca                	mv	a3,s2
    80001376:	6605                	lui	a2,0x1
    80001378:	4581                	li	a1,0
    8000137a:	8552                	mv	a0,s4
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	d0c080e7          	jalr	-756(ra) # 80001088 <mappages>
  memmove(mem, src, sz);
    80001384:	8626                	mv	a2,s1
    80001386:	85ce                	mv	a1,s3
    80001388:	854a                	mv	a0,s2
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	9a0080e7          	jalr	-1632(ra) # 80000d2a <memmove>
}
    80001392:	70a2                	ld	ra,40(sp)
    80001394:	7402                	ld	s0,32(sp)
    80001396:	64e2                	ld	s1,24(sp)
    80001398:	6942                	ld	s2,16(sp)
    8000139a:	69a2                	ld	s3,8(sp)
    8000139c:	6a02                	ld	s4,0(sp)
    8000139e:	6145                	addi	sp,sp,48
    800013a0:	8082                	ret
    panic("uvmfirst: more than a page");
    800013a2:	00007517          	auipc	a0,0x7
    800013a6:	dd650513          	addi	a0,a0,-554 # 80008178 <digits+0x138>
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	192080e7          	jalr	402(ra) # 8000053c <panic>

00000000800013b2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b2:	1101                	addi	sp,sp,-32
    800013b4:	ec06                	sd	ra,24(sp)
    800013b6:	e822                	sd	s0,16(sp)
    800013b8:	e426                	sd	s1,8(sp)
    800013ba:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013bc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013be:	00b67d63          	bgeu	a2,a1,800013d8 <uvmdealloc+0x26>
    800013c2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c4:	6785                	lui	a5,0x1
    800013c6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013c8:	00f60733          	add	a4,a2,a5
    800013cc:	76fd                	lui	a3,0xfffff
    800013ce:	8f75                	and	a4,a4,a3
    800013d0:	97ae                	add	a5,a5,a1
    800013d2:	8ff5                	and	a5,a5,a3
    800013d4:	00f76863          	bltu	a4,a5,800013e4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013d8:	8526                	mv	a0,s1
    800013da:	60e2                	ld	ra,24(sp)
    800013dc:	6442                	ld	s0,16(sp)
    800013de:	64a2                	ld	s1,8(sp)
    800013e0:	6105                	addi	sp,sp,32
    800013e2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e4:	8f99                	sub	a5,a5,a4
    800013e6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013e8:	4685                	li	a3,1
    800013ea:	0007861b          	sext.w	a2,a5
    800013ee:	85ba                	mv	a1,a4
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	e5e080e7          	jalr	-418(ra) # 8000124e <uvmunmap>
    800013f8:	b7c5                	j	800013d8 <uvmdealloc+0x26>

00000000800013fa <uvmalloc>:
  if(newsz < oldsz)
    800013fa:	0ab66563          	bltu	a2,a1,800014a4 <uvmalloc+0xaa>
{
    800013fe:	7139                	addi	sp,sp,-64
    80001400:	fc06                	sd	ra,56(sp)
    80001402:	f822                	sd	s0,48(sp)
    80001404:	f426                	sd	s1,40(sp)
    80001406:	f04a                	sd	s2,32(sp)
    80001408:	ec4e                	sd	s3,24(sp)
    8000140a:	e852                	sd	s4,16(sp)
    8000140c:	e456                	sd	s5,8(sp)
    8000140e:	e05a                	sd	s6,0(sp)
    80001410:	0080                	addi	s0,sp,64
    80001412:	8aaa                	mv	s5,a0
    80001414:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001416:	6785                	lui	a5,0x1
    80001418:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000141a:	95be                	add	a1,a1,a5
    8000141c:	77fd                	lui	a5,0xfffff
    8000141e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001422:	08c9f363          	bgeu	s3,a2,800014a8 <uvmalloc+0xae>
    80001426:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001428:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	6b6080e7          	jalr	1718(ra) # 80000ae2 <kalloc>
    80001434:	84aa                	mv	s1,a0
    if(mem == 0){
    80001436:	c51d                	beqz	a0,80001464 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001438:	6605                	lui	a2,0x1
    8000143a:	4581                	li	a1,0
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	892080e7          	jalr	-1902(ra) # 80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001444:	875a                	mv	a4,s6
    80001446:	86a6                	mv	a3,s1
    80001448:	6605                	lui	a2,0x1
    8000144a:	85ca                	mv	a1,s2
    8000144c:	8556                	mv	a0,s5
    8000144e:	00000097          	auipc	ra,0x0
    80001452:	c3a080e7          	jalr	-966(ra) # 80001088 <mappages>
    80001456:	e90d                	bnez	a0,80001488 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001458:	6785                	lui	a5,0x1
    8000145a:	993e                	add	s2,s2,a5
    8000145c:	fd4968e3          	bltu	s2,s4,8000142c <uvmalloc+0x32>
  return newsz;
    80001460:	8552                	mv	a0,s4
    80001462:	a809                	j	80001474 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001464:	864e                	mv	a2,s3
    80001466:	85ca                	mv	a1,s2
    80001468:	8556                	mv	a0,s5
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	f48080e7          	jalr	-184(ra) # 800013b2 <uvmdealloc>
      return 0;
    80001472:	4501                	li	a0,0
}
    80001474:	70e2                	ld	ra,56(sp)
    80001476:	7442                	ld	s0,48(sp)
    80001478:	74a2                	ld	s1,40(sp)
    8000147a:	7902                	ld	s2,32(sp)
    8000147c:	69e2                	ld	s3,24(sp)
    8000147e:	6a42                	ld	s4,16(sp)
    80001480:	6aa2                	ld	s5,8(sp)
    80001482:	6b02                	ld	s6,0(sp)
    80001484:	6121                	addi	sp,sp,64
    80001486:	8082                	ret
      kfree(mem);
    80001488:	8526                	mv	a0,s1
    8000148a:	fffff097          	auipc	ra,0xfffff
    8000148e:	55a080e7          	jalr	1370(ra) # 800009e4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001492:	864e                	mv	a2,s3
    80001494:	85ca                	mv	a1,s2
    80001496:	8556                	mv	a0,s5
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	f1a080e7          	jalr	-230(ra) # 800013b2 <uvmdealloc>
      return 0;
    800014a0:	4501                	li	a0,0
    800014a2:	bfc9                	j	80001474 <uvmalloc+0x7a>
    return oldsz;
    800014a4:	852e                	mv	a0,a1
}
    800014a6:	8082                	ret
  return newsz;
    800014a8:	8532                	mv	a0,a2
    800014aa:	b7e9                	j	80001474 <uvmalloc+0x7a>

00000000800014ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014ac:	7179                	addi	sp,sp,-48
    800014ae:	f406                	sd	ra,40(sp)
    800014b0:	f022                	sd	s0,32(sp)
    800014b2:	ec26                	sd	s1,24(sp)
    800014b4:	e84a                	sd	s2,16(sp)
    800014b6:	e44e                	sd	s3,8(sp)
    800014b8:	e052                	sd	s4,0(sp)
    800014ba:	1800                	addi	s0,sp,48
    800014bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014be:	84aa                	mv	s1,a0
    800014c0:	6905                	lui	s2,0x1
    800014c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014c4:	4985                	li	s3,1
    800014c6:	a829                	j	800014e0 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014ca:	00c79513          	slli	a0,a5,0xc
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	fde080e7          	jalr	-34(ra) # 800014ac <freewalk>
      pagetable[i] = 0;
    800014d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014da:	04a1                	addi	s1,s1,8
    800014dc:	03248163          	beq	s1,s2,800014fe <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014e0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014e2:	00f7f713          	andi	a4,a5,15
    800014e6:	ff3701e3          	beq	a4,s3,800014c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014ea:	8b85                	andi	a5,a5,1
    800014ec:	d7fd                	beqz	a5,800014da <freewalk+0x2e>
      panic("freewalk: leaf");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	caa50513          	addi	a0,a0,-854 # 80008198 <digits+0x158>
    800014f6:	fffff097          	auipc	ra,0xfffff
    800014fa:	046080e7          	jalr	70(ra) # 8000053c <panic>
    }
  }
  kfree((void*)pagetable);
    800014fe:	8552                	mv	a0,s4
    80001500:	fffff097          	auipc	ra,0xfffff
    80001504:	4e4080e7          	jalr	1252(ra) # 800009e4 <kfree>
}
    80001508:	70a2                	ld	ra,40(sp)
    8000150a:	7402                	ld	s0,32(sp)
    8000150c:	64e2                	ld	s1,24(sp)
    8000150e:	6942                	ld	s2,16(sp)
    80001510:	69a2                	ld	s3,8(sp)
    80001512:	6a02                	ld	s4,0(sp)
    80001514:	6145                	addi	sp,sp,48
    80001516:	8082                	ret

0000000080001518 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
    80001522:	84aa                	mv	s1,a0
  if(sz > 0)
    80001524:	e999                	bnez	a1,8000153a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001526:	8526                	mv	a0,s1
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	f84080e7          	jalr	-124(ra) # 800014ac <freewalk>
}
    80001530:	60e2                	ld	ra,24(sp)
    80001532:	6442                	ld	s0,16(sp)
    80001534:	64a2                	ld	s1,8(sp)
    80001536:	6105                	addi	sp,sp,32
    80001538:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000153a:	6785                	lui	a5,0x1
    8000153c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000153e:	95be                	add	a1,a1,a5
    80001540:	4685                	li	a3,1
    80001542:	00c5d613          	srli	a2,a1,0xc
    80001546:	4581                	li	a1,0
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	d06080e7          	jalr	-762(ra) # 8000124e <uvmunmap>
    80001550:	bfd9                	j	80001526 <uvmfree+0xe>

0000000080001552 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001552:	c679                	beqz	a2,80001620 <uvmcopy+0xce>
{
    80001554:	715d                	addi	sp,sp,-80
    80001556:	e486                	sd	ra,72(sp)
    80001558:	e0a2                	sd	s0,64(sp)
    8000155a:	fc26                	sd	s1,56(sp)
    8000155c:	f84a                	sd	s2,48(sp)
    8000155e:	f44e                	sd	s3,40(sp)
    80001560:	f052                	sd	s4,32(sp)
    80001562:	ec56                	sd	s5,24(sp)
    80001564:	e85a                	sd	s6,16(sp)
    80001566:	e45e                	sd	s7,8(sp)
    80001568:	0880                	addi	s0,sp,80
    8000156a:	8b2a                	mv	s6,a0
    8000156c:	8aae                	mv	s5,a1
    8000156e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001570:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001572:	4601                	li	a2,0
    80001574:	85ce                	mv	a1,s3
    80001576:	855a                	mv	a0,s6
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	a28080e7          	jalr	-1496(ra) # 80000fa0 <walk>
    80001580:	c531                	beqz	a0,800015cc <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001582:	6118                	ld	a4,0(a0)
    80001584:	00177793          	andi	a5,a4,1
    80001588:	cbb1                	beqz	a5,800015dc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000158a:	00a75593          	srli	a1,a4,0xa
    8000158e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001592:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001596:	fffff097          	auipc	ra,0xfffff
    8000159a:	54c080e7          	jalr	1356(ra) # 80000ae2 <kalloc>
    8000159e:	892a                	mv	s2,a0
    800015a0:	c939                	beqz	a0,800015f6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015a2:	6605                	lui	a2,0x1
    800015a4:	85de                	mv	a1,s7
    800015a6:	fffff097          	auipc	ra,0xfffff
    800015aa:	784080e7          	jalr	1924(ra) # 80000d2a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015ae:	8726                	mv	a4,s1
    800015b0:	86ca                	mv	a3,s2
    800015b2:	6605                	lui	a2,0x1
    800015b4:	85ce                	mv	a1,s3
    800015b6:	8556                	mv	a0,s5
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	ad0080e7          	jalr	-1328(ra) # 80001088 <mappages>
    800015c0:	e515                	bnez	a0,800015ec <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015c2:	6785                	lui	a5,0x1
    800015c4:	99be                	add	s3,s3,a5
    800015c6:	fb49e6e3          	bltu	s3,s4,80001572 <uvmcopy+0x20>
    800015ca:	a081                	j	8000160a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015cc:	00007517          	auipc	a0,0x7
    800015d0:	bdc50513          	addi	a0,a0,-1060 # 800081a8 <digits+0x168>
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	f68080e7          	jalr	-152(ra) # 8000053c <panic>
      panic("uvmcopy: page not present");
    800015dc:	00007517          	auipc	a0,0x7
    800015e0:	bec50513          	addi	a0,a0,-1044 # 800081c8 <digits+0x188>
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	f58080e7          	jalr	-168(ra) # 8000053c <panic>
      kfree(mem);
    800015ec:	854a                	mv	a0,s2
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	3f6080e7          	jalr	1014(ra) # 800009e4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015f6:	4685                	li	a3,1
    800015f8:	00c9d613          	srli	a2,s3,0xc
    800015fc:	4581                	li	a1,0
    800015fe:	8556                	mv	a0,s5
    80001600:	00000097          	auipc	ra,0x0
    80001604:	c4e080e7          	jalr	-946(ra) # 8000124e <uvmunmap>
  return -1;
    80001608:	557d                	li	a0,-1
}
    8000160a:	60a6                	ld	ra,72(sp)
    8000160c:	6406                	ld	s0,64(sp)
    8000160e:	74e2                	ld	s1,56(sp)
    80001610:	7942                	ld	s2,48(sp)
    80001612:	79a2                	ld	s3,40(sp)
    80001614:	7a02                	ld	s4,32(sp)
    80001616:	6ae2                	ld	s5,24(sp)
    80001618:	6b42                	ld	s6,16(sp)
    8000161a:	6ba2                	ld	s7,8(sp)
    8000161c:	6161                	addi	sp,sp,80
    8000161e:	8082                	ret
  return 0;
    80001620:	4501                	li	a0,0
}
    80001622:	8082                	ret

0000000080001624 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001624:	1141                	addi	sp,sp,-16
    80001626:	e406                	sd	ra,8(sp)
    80001628:	e022                	sd	s0,0(sp)
    8000162a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000162c:	4601                	li	a2,0
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	972080e7          	jalr	-1678(ra) # 80000fa0 <walk>
  if(pte == 0)
    80001636:	c901                	beqz	a0,80001646 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001638:	611c                	ld	a5,0(a0)
    8000163a:	9bbd                	andi	a5,a5,-17
    8000163c:	e11c                	sd	a5,0(a0)
}
    8000163e:	60a2                	ld	ra,8(sp)
    80001640:	6402                	ld	s0,0(sp)
    80001642:	0141                	addi	sp,sp,16
    80001644:	8082                	ret
    panic("uvmclear");
    80001646:	00007517          	auipc	a0,0x7
    8000164a:	ba250513          	addi	a0,a0,-1118 # 800081e8 <digits+0x1a8>
    8000164e:	fffff097          	auipc	ra,0xfffff
    80001652:	eee080e7          	jalr	-274(ra) # 8000053c <panic>

0000000080001656 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001656:	c6bd                	beqz	a3,800016c4 <copyout+0x6e>
{
    80001658:	715d                	addi	sp,sp,-80
    8000165a:	e486                	sd	ra,72(sp)
    8000165c:	e0a2                	sd	s0,64(sp)
    8000165e:	fc26                	sd	s1,56(sp)
    80001660:	f84a                	sd	s2,48(sp)
    80001662:	f44e                	sd	s3,40(sp)
    80001664:	f052                	sd	s4,32(sp)
    80001666:	ec56                	sd	s5,24(sp)
    80001668:	e85a                	sd	s6,16(sp)
    8000166a:	e45e                	sd	s7,8(sp)
    8000166c:	e062                	sd	s8,0(sp)
    8000166e:	0880                	addi	s0,sp,80
    80001670:	8b2a                	mv	s6,a0
    80001672:	8c2e                	mv	s8,a1
    80001674:	8a32                	mv	s4,a2
    80001676:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001678:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000167a:	6a85                	lui	s5,0x1
    8000167c:	a015                	j	800016a0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000167e:	9562                	add	a0,a0,s8
    80001680:	0004861b          	sext.w	a2,s1
    80001684:	85d2                	mv	a1,s4
    80001686:	41250533          	sub	a0,a0,s2
    8000168a:	fffff097          	auipc	ra,0xfffff
    8000168e:	6a0080e7          	jalr	1696(ra) # 80000d2a <memmove>

    len -= n;
    80001692:	409989b3          	sub	s3,s3,s1
    src += n;
    80001696:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001698:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000169c:	02098263          	beqz	s3,800016c0 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016a0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016a4:	85ca                	mv	a1,s2
    800016a6:	855a                	mv	a0,s6
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	99e080e7          	jalr	-1634(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    800016b0:	cd01                	beqz	a0,800016c8 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016b2:	418904b3          	sub	s1,s2,s8
    800016b6:	94d6                	add	s1,s1,s5
    800016b8:	fc99f3e3          	bgeu	s3,s1,8000167e <copyout+0x28>
    800016bc:	84ce                	mv	s1,s3
    800016be:	b7c1                	j	8000167e <copyout+0x28>
  }
  return 0;
    800016c0:	4501                	li	a0,0
    800016c2:	a021                	j	800016ca <copyout+0x74>
    800016c4:	4501                	li	a0,0
}
    800016c6:	8082                	ret
      return -1;
    800016c8:	557d                	li	a0,-1
}
    800016ca:	60a6                	ld	ra,72(sp)
    800016cc:	6406                	ld	s0,64(sp)
    800016ce:	74e2                	ld	s1,56(sp)
    800016d0:	7942                	ld	s2,48(sp)
    800016d2:	79a2                	ld	s3,40(sp)
    800016d4:	7a02                	ld	s4,32(sp)
    800016d6:	6ae2                	ld	s5,24(sp)
    800016d8:	6b42                	ld	s6,16(sp)
    800016da:	6ba2                	ld	s7,8(sp)
    800016dc:	6c02                	ld	s8,0(sp)
    800016de:	6161                	addi	sp,sp,80
    800016e0:	8082                	ret

00000000800016e2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	caa5                	beqz	a3,80001752 <copyin+0x70>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
    800016fe:	8a2e                	mv	s4,a1
    80001700:	8c32                	mv	s8,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001704:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001706:	6a85                	lui	s5,0x1
    80001708:	a01d                	j	8000172e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000170a:	018505b3          	add	a1,a0,s8
    8000170e:	0004861b          	sext.w	a2,s1
    80001712:	412585b3          	sub	a1,a1,s2
    80001716:	8552                	mv	a0,s4
    80001718:	fffff097          	auipc	ra,0xfffff
    8000171c:	612080e7          	jalr	1554(ra) # 80000d2a <memmove>

    len -= n;
    80001720:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001724:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001726:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000172a:	02098263          	beqz	s3,8000174e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000172e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001732:	85ca                	mv	a1,s2
    80001734:	855a                	mv	a0,s6
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	910080e7          	jalr	-1776(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    8000173e:	cd01                	beqz	a0,80001756 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001740:	418904b3          	sub	s1,s2,s8
    80001744:	94d6                	add	s1,s1,s5
    80001746:	fc99f2e3          	bgeu	s3,s1,8000170a <copyin+0x28>
    8000174a:	84ce                	mv	s1,s3
    8000174c:	bf7d                	j	8000170a <copyin+0x28>
  }
  return 0;
    8000174e:	4501                	li	a0,0
    80001750:	a021                	j	80001758 <copyin+0x76>
    80001752:	4501                	li	a0,0
}
    80001754:	8082                	ret
      return -1;
    80001756:	557d                	li	a0,-1
}
    80001758:	60a6                	ld	ra,72(sp)
    8000175a:	6406                	ld	s0,64(sp)
    8000175c:	74e2                	ld	s1,56(sp)
    8000175e:	7942                	ld	s2,48(sp)
    80001760:	79a2                	ld	s3,40(sp)
    80001762:	7a02                	ld	s4,32(sp)
    80001764:	6ae2                	ld	s5,24(sp)
    80001766:	6b42                	ld	s6,16(sp)
    80001768:	6ba2                	ld	s7,8(sp)
    8000176a:	6c02                	ld	s8,0(sp)
    8000176c:	6161                	addi	sp,sp,80
    8000176e:	8082                	ret

0000000080001770 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001770:	c2dd                	beqz	a3,80001816 <copyinstr+0xa6>
{
    80001772:	715d                	addi	sp,sp,-80
    80001774:	e486                	sd	ra,72(sp)
    80001776:	e0a2                	sd	s0,64(sp)
    80001778:	fc26                	sd	s1,56(sp)
    8000177a:	f84a                	sd	s2,48(sp)
    8000177c:	f44e                	sd	s3,40(sp)
    8000177e:	f052                	sd	s4,32(sp)
    80001780:	ec56                	sd	s5,24(sp)
    80001782:	e85a                	sd	s6,16(sp)
    80001784:	e45e                	sd	s7,8(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8a2a                	mv	s4,a0
    8000178a:	8b2e                	mv	s6,a1
    8000178c:	8bb2                	mv	s7,a2
    8000178e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6985                	lui	s3,0x1
    80001794:	a02d                	j	800017be <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001796:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000179a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000179c:	37fd                	addiw	a5,a5,-1
    8000179e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017a2:	60a6                	ld	ra,72(sp)
    800017a4:	6406                	ld	s0,64(sp)
    800017a6:	74e2                	ld	s1,56(sp)
    800017a8:	7942                	ld	s2,48(sp)
    800017aa:	79a2                	ld	s3,40(sp)
    800017ac:	7a02                	ld	s4,32(sp)
    800017ae:	6ae2                	ld	s5,24(sp)
    800017b0:	6b42                	ld	s6,16(sp)
    800017b2:	6ba2                	ld	s7,8(sp)
    800017b4:	6161                	addi	sp,sp,80
    800017b6:	8082                	ret
    srcva = va0 + PGSIZE;
    800017b8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017bc:	c8a9                	beqz	s1,8000180e <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017be:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017c2:	85ca                	mv	a1,s2
    800017c4:	8552                	mv	a0,s4
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	880080e7          	jalr	-1920(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    800017ce:	c131                	beqz	a0,80001812 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017d0:	417906b3          	sub	a3,s2,s7
    800017d4:	96ce                	add	a3,a3,s3
    800017d6:	00d4f363          	bgeu	s1,a3,800017dc <copyinstr+0x6c>
    800017da:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017dc:	955e                	add	a0,a0,s7
    800017de:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017e2:	daf9                	beqz	a3,800017b8 <copyinstr+0x48>
    800017e4:	87da                	mv	a5,s6
    800017e6:	885a                	mv	a6,s6
      if(*p == '\0'){
    800017e8:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800017ec:	96da                	add	a3,a3,s6
    800017ee:	85be                	mv	a1,a5
      if(*p == '\0'){
    800017f0:	00f60733          	add	a4,a2,a5
    800017f4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd2a0>
    800017f8:	df59                	beqz	a4,80001796 <copyinstr+0x26>
        *dst = *p;
    800017fa:	00e78023          	sb	a4,0(a5)
      dst++;
    800017fe:	0785                	addi	a5,a5,1
    while(n > 0){
    80001800:	fed797e3          	bne	a5,a3,800017ee <copyinstr+0x7e>
    80001804:	14fd                	addi	s1,s1,-1
    80001806:	94c2                	add	s1,s1,a6
      --max;
    80001808:	8c8d                	sub	s1,s1,a1
      dst++;
    8000180a:	8b3e                	mv	s6,a5
    8000180c:	b775                	j	800017b8 <copyinstr+0x48>
    8000180e:	4781                	li	a5,0
    80001810:	b771                	j	8000179c <copyinstr+0x2c>
      return -1;
    80001812:	557d                	li	a0,-1
    80001814:	b779                	j	800017a2 <copyinstr+0x32>
  int got_null = 0;
    80001816:	4781                	li	a5,0
  if(got_null){
    80001818:	37fd                	addiw	a5,a5,-1
    8000181a:	0007851b          	sext.w	a0,a5
}
    8000181e:	8082                	ret

0000000080001820 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001820:	7139                	addi	sp,sp,-64
    80001822:	fc06                	sd	ra,56(sp)
    80001824:	f822                	sd	s0,48(sp)
    80001826:	f426                	sd	s1,40(sp)
    80001828:	f04a                	sd	s2,32(sp)
    8000182a:	ec4e                	sd	s3,24(sp)
    8000182c:	e852                	sd	s4,16(sp)
    8000182e:	e456                	sd	s5,8(sp)
    80001830:	e05a                	sd	s6,0(sp)
    80001832:	0080                	addi	s0,sp,64
    80001834:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001836:	0000f497          	auipc	s1,0xf
    8000183a:	74a48493          	addi	s1,s1,1866 # 80010f80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000183e:	8b26                	mv	s6,s1
    80001840:	00006a97          	auipc	s5,0x6
    80001844:	7c0a8a93          	addi	s5,s5,1984 # 80008000 <etext>
    80001848:	04000937          	lui	s2,0x4000
    8000184c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000184e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001850:	00015a17          	auipc	s4,0x15
    80001854:	130a0a13          	addi	s4,s4,304 # 80016980 <tickslock>
    char *pa = kalloc();
    80001858:	fffff097          	auipc	ra,0xfffff
    8000185c:	28a080e7          	jalr	650(ra) # 80000ae2 <kalloc>
    80001860:	862a                	mv	a2,a0
    if(pa == 0)
    80001862:	c131                	beqz	a0,800018a6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001864:	416485b3          	sub	a1,s1,s6
    80001868:	858d                	srai	a1,a1,0x3
    8000186a:	000ab783          	ld	a5,0(s5)
    8000186e:	02f585b3          	mul	a1,a1,a5
    80001872:	2585                	addiw	a1,a1,1
    80001874:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001878:	4719                	li	a4,6
    8000187a:	6685                	lui	a3,0x1
    8000187c:	40b905b3          	sub	a1,s2,a1
    80001880:	854e                	mv	a0,s3
    80001882:	00000097          	auipc	ra,0x0
    80001886:	8a6080e7          	jalr	-1882(ra) # 80001128 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188a:	16848493          	addi	s1,s1,360
    8000188e:	fd4495e3          	bne	s1,s4,80001858 <proc_mapstacks+0x38>
  }
}
    80001892:	70e2                	ld	ra,56(sp)
    80001894:	7442                	ld	s0,48(sp)
    80001896:	74a2                	ld	s1,40(sp)
    80001898:	7902                	ld	s2,32(sp)
    8000189a:	69e2                	ld	s3,24(sp)
    8000189c:	6a42                	ld	s4,16(sp)
    8000189e:	6aa2                	ld	s5,8(sp)
    800018a0:	6b02                	ld	s6,0(sp)
    800018a2:	6121                	addi	sp,sp,64
    800018a4:	8082                	ret
      panic("kalloc");
    800018a6:	00007517          	auipc	a0,0x7
    800018aa:	95250513          	addi	a0,a0,-1710 # 800081f8 <digits+0x1b8>
    800018ae:	fffff097          	auipc	ra,0xfffff
    800018b2:	c8e080e7          	jalr	-882(ra) # 8000053c <panic>

00000000800018b6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018b6:	7139                	addi	sp,sp,-64
    800018b8:	fc06                	sd	ra,56(sp)
    800018ba:	f822                	sd	s0,48(sp)
    800018bc:	f426                	sd	s1,40(sp)
    800018be:	f04a                	sd	s2,32(sp)
    800018c0:	ec4e                	sd	s3,24(sp)
    800018c2:	e852                	sd	s4,16(sp)
    800018c4:	e456                	sd	s5,8(sp)
    800018c6:	e05a                	sd	s6,0(sp)
    800018c8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018ca:	00007597          	auipc	a1,0x7
    800018ce:	93658593          	addi	a1,a1,-1738 # 80008200 <digits+0x1c0>
    800018d2:	0000f517          	auipc	a0,0xf
    800018d6:	27e50513          	addi	a0,a0,638 # 80010b50 <pid_lock>
    800018da:	fffff097          	auipc	ra,0xfffff
    800018de:	268080e7          	jalr	616(ra) # 80000b42 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018e2:	00007597          	auipc	a1,0x7
    800018e6:	92658593          	addi	a1,a1,-1754 # 80008208 <digits+0x1c8>
    800018ea:	0000f517          	auipc	a0,0xf
    800018ee:	27e50513          	addi	a0,a0,638 # 80010b68 <wait_lock>
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	250080e7          	jalr	592(ra) # 80000b42 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fa:	0000f497          	auipc	s1,0xf
    800018fe:	68648493          	addi	s1,s1,1670 # 80010f80 <proc>
      initlock(&p->lock, "proc");
    80001902:	00007b17          	auipc	s6,0x7
    80001906:	916b0b13          	addi	s6,s6,-1770 # 80008218 <digits+0x1d8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000190a:	8aa6                	mv	s5,s1
    8000190c:	00006a17          	auipc	s4,0x6
    80001910:	6f4a0a13          	addi	s4,s4,1780 # 80008000 <etext>
    80001914:	04000937          	lui	s2,0x4000
    80001918:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000191a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000191c:	00015997          	auipc	s3,0x15
    80001920:	06498993          	addi	s3,s3,100 # 80016980 <tickslock>
      initlock(&p->lock, "proc");
    80001924:	85da                	mv	a1,s6
    80001926:	8526                	mv	a0,s1
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	21a080e7          	jalr	538(ra) # 80000b42 <initlock>
      p->state = UNUSED;
    80001930:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001934:	415487b3          	sub	a5,s1,s5
    80001938:	878d                	srai	a5,a5,0x3
    8000193a:	000a3703          	ld	a4,0(s4)
    8000193e:	02e787b3          	mul	a5,a5,a4
    80001942:	2785                	addiw	a5,a5,1
    80001944:	00d7979b          	slliw	a5,a5,0xd
    80001948:	40f907b3          	sub	a5,s2,a5
    8000194c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194e:	16848493          	addi	s1,s1,360
    80001952:	fd3499e3          	bne	s1,s3,80001924 <procinit+0x6e>
  }
}
    80001956:	70e2                	ld	ra,56(sp)
    80001958:	7442                	ld	s0,48(sp)
    8000195a:	74a2                	ld	s1,40(sp)
    8000195c:	7902                	ld	s2,32(sp)
    8000195e:	69e2                	ld	s3,24(sp)
    80001960:	6a42                	ld	s4,16(sp)
    80001962:	6aa2                	ld	s5,8(sp)
    80001964:	6b02                	ld	s6,0(sp)
    80001966:	6121                	addi	sp,sp,64
    80001968:	8082                	ret

000000008000196a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000196a:	1141                	addi	sp,sp,-16
    8000196c:	e422                	sd	s0,8(sp)
    8000196e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001970:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001972:	2501                	sext.w	a0,a0
    80001974:	6422                	ld	s0,8(sp)
    80001976:	0141                	addi	sp,sp,16
    80001978:	8082                	ret

000000008000197a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000197a:	1141                	addi	sp,sp,-16
    8000197c:	e422                	sd	s0,8(sp)
    8000197e:	0800                	addi	s0,sp,16
    80001980:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001982:	2781                	sext.w	a5,a5
    80001984:	079e                	slli	a5,a5,0x7
  return c;
}
    80001986:	0000f517          	auipc	a0,0xf
    8000198a:	1fa50513          	addi	a0,a0,506 # 80010b80 <cpus>
    8000198e:	953e                	add	a0,a0,a5
    80001990:	6422                	ld	s0,8(sp)
    80001992:	0141                	addi	sp,sp,16
    80001994:	8082                	ret

0000000080001996 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	1000                	addi	s0,sp,32
  push_off();
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	1e6080e7          	jalr	486(ra) # 80000b86 <push_off>
    800019a8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019aa:	2781                	sext.w	a5,a5
    800019ac:	079e                	slli	a5,a5,0x7
    800019ae:	0000f717          	auipc	a4,0xf
    800019b2:	1a270713          	addi	a4,a4,418 # 80010b50 <pid_lock>
    800019b6:	97ba                	add	a5,a5,a4
    800019b8:	7b84                	ld	s1,48(a5)
  pop_off();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	26c080e7          	jalr	620(ra) # 80000c26 <pop_off>
  return p;
}
    800019c2:	8526                	mv	a0,s1
    800019c4:	60e2                	ld	ra,24(sp)
    800019c6:	6442                	ld	s0,16(sp)
    800019c8:	64a2                	ld	s1,8(sp)
    800019ca:	6105                	addi	sp,sp,32
    800019cc:	8082                	ret

00000000800019ce <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019ce:	1141                	addi	sp,sp,-16
    800019d0:	e406                	sd	ra,8(sp)
    800019d2:	e022                	sd	s0,0(sp)
    800019d4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019d6:	00000097          	auipc	ra,0x0
    800019da:	fc0080e7          	jalr	-64(ra) # 80001996 <myproc>
    800019de:	fffff097          	auipc	ra,0xfffff
    800019e2:	2a8080e7          	jalr	680(ra) # 80000c86 <release>

  if (first) {
    800019e6:	00007797          	auipc	a5,0x7
    800019ea:	e7a7a783          	lw	a5,-390(a5) # 80008860 <first.1>
    800019ee:	eb89                	bnez	a5,80001a00 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800019f0:	00001097          	auipc	ra,0x1
    800019f4:	c5c080e7          	jalr	-932(ra) # 8000264c <usertrapret>
}
    800019f8:	60a2                	ld	ra,8(sp)
    800019fa:	6402                	ld	s0,0(sp)
    800019fc:	0141                	addi	sp,sp,16
    800019fe:	8082                	ret
    first = 0;
    80001a00:	00007797          	auipc	a5,0x7
    80001a04:	e607a023          	sw	zero,-416(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80001a08:	4505                	li	a0,1
    80001a0a:	00002097          	auipc	ra,0x2
    80001a0e:	990080e7          	jalr	-1648(ra) # 8000339a <fsinit>
    80001a12:	bff9                	j	800019f0 <forkret+0x22>

0000000080001a14 <allocpid>:
{
    80001a14:	1101                	addi	sp,sp,-32
    80001a16:	ec06                	sd	ra,24(sp)
    80001a18:	e822                	sd	s0,16(sp)
    80001a1a:	e426                	sd	s1,8(sp)
    80001a1c:	e04a                	sd	s2,0(sp)
    80001a1e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a20:	0000f917          	auipc	s2,0xf
    80001a24:	13090913          	addi	s2,s2,304 # 80010b50 <pid_lock>
    80001a28:	854a                	mv	a0,s2
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	1a8080e7          	jalr	424(ra) # 80000bd2 <acquire>
  pid = nextpid;
    80001a32:	00007797          	auipc	a5,0x7
    80001a36:	e3278793          	addi	a5,a5,-462 # 80008864 <nextpid>
    80001a3a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a3c:	0014871b          	addiw	a4,s1,1
    80001a40:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a42:	854a                	mv	a0,s2
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	242080e7          	jalr	578(ra) # 80000c86 <release>
}
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	60e2                	ld	ra,24(sp)
    80001a50:	6442                	ld	s0,16(sp)
    80001a52:	64a2                	ld	s1,8(sp)
    80001a54:	6902                	ld	s2,0(sp)
    80001a56:	6105                	addi	sp,sp,32
    80001a58:	8082                	ret

0000000080001a5a <proc_pagetable>:
{
    80001a5a:	1101                	addi	sp,sp,-32
    80001a5c:	ec06                	sd	ra,24(sp)
    80001a5e:	e822                	sd	s0,16(sp)
    80001a60:	e426                	sd	s1,8(sp)
    80001a62:	e04a                	sd	s2,0(sp)
    80001a64:	1000                	addi	s0,sp,32
    80001a66:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a68:	00000097          	auipc	ra,0x0
    80001a6c:	8aa080e7          	jalr	-1878(ra) # 80001312 <uvmcreate>
    80001a70:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a72:	c121                	beqz	a0,80001ab2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a74:	4729                	li	a4,10
    80001a76:	00005697          	auipc	a3,0x5
    80001a7a:	58a68693          	addi	a3,a3,1418 # 80007000 <_trampoline>
    80001a7e:	6605                	lui	a2,0x1
    80001a80:	040005b7          	lui	a1,0x4000
    80001a84:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a86:	05b2                	slli	a1,a1,0xc
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	600080e7          	jalr	1536(ra) # 80001088 <mappages>
    80001a90:	02054863          	bltz	a0,80001ac0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a94:	4719                	li	a4,6
    80001a96:	05893683          	ld	a3,88(s2)
    80001a9a:	6605                	lui	a2,0x1
    80001a9c:	020005b7          	lui	a1,0x2000
    80001aa0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aa2:	05b6                	slli	a1,a1,0xd
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	fffff097          	auipc	ra,0xfffff
    80001aaa:	5e2080e7          	jalr	1506(ra) # 80001088 <mappages>
    80001aae:	02054163          	bltz	a0,80001ad0 <proc_pagetable+0x76>
}
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	60e2                	ld	ra,24(sp)
    80001ab6:	6442                	ld	s0,16(sp)
    80001ab8:	64a2                	ld	s1,8(sp)
    80001aba:	6902                	ld	s2,0(sp)
    80001abc:	6105                	addi	sp,sp,32
    80001abe:	8082                	ret
    uvmfree(pagetable, 0);
    80001ac0:	4581                	li	a1,0
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	00000097          	auipc	ra,0x0
    80001ac8:	a54080e7          	jalr	-1452(ra) # 80001518 <uvmfree>
    return 0;
    80001acc:	4481                	li	s1,0
    80001ace:	b7d5                	j	80001ab2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ad0:	4681                	li	a3,0
    80001ad2:	4605                	li	a2,1
    80001ad4:	040005b7          	lui	a1,0x4000
    80001ad8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ada:	05b2                	slli	a1,a1,0xc
    80001adc:	8526                	mv	a0,s1
    80001ade:	fffff097          	auipc	ra,0xfffff
    80001ae2:	770080e7          	jalr	1904(ra) # 8000124e <uvmunmap>
    uvmfree(pagetable, 0);
    80001ae6:	4581                	li	a1,0
    80001ae8:	8526                	mv	a0,s1
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	a2e080e7          	jalr	-1490(ra) # 80001518 <uvmfree>
    return 0;
    80001af2:	4481                	li	s1,0
    80001af4:	bf7d                	j	80001ab2 <proc_pagetable+0x58>

0000000080001af6 <proc_freepagetable>:
{
    80001af6:	1101                	addi	sp,sp,-32
    80001af8:	ec06                	sd	ra,24(sp)
    80001afa:	e822                	sd	s0,16(sp)
    80001afc:	e426                	sd	s1,8(sp)
    80001afe:	e04a                	sd	s2,0(sp)
    80001b00:	1000                	addi	s0,sp,32
    80001b02:	84aa                	mv	s1,a0
    80001b04:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b06:	4681                	li	a3,0
    80001b08:	4605                	li	a2,1
    80001b0a:	040005b7          	lui	a1,0x4000
    80001b0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b10:	05b2                	slli	a1,a1,0xc
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	73c080e7          	jalr	1852(ra) # 8000124e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b1a:	4681                	li	a3,0
    80001b1c:	4605                	li	a2,1
    80001b1e:	020005b7          	lui	a1,0x2000
    80001b22:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b24:	05b6                	slli	a1,a1,0xd
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	726080e7          	jalr	1830(ra) # 8000124e <uvmunmap>
  uvmfree(pagetable, sz);
    80001b30:	85ca                	mv	a1,s2
    80001b32:	8526                	mv	a0,s1
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	9e4080e7          	jalr	-1564(ra) # 80001518 <uvmfree>
}
    80001b3c:	60e2                	ld	ra,24(sp)
    80001b3e:	6442                	ld	s0,16(sp)
    80001b40:	64a2                	ld	s1,8(sp)
    80001b42:	6902                	ld	s2,0(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret

0000000080001b48 <freeproc>:
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
    80001b52:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b54:	6d28                	ld	a0,88(a0)
    80001b56:	c509                	beqz	a0,80001b60 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	e8c080e7          	jalr	-372(ra) # 800009e4 <kfree>
  p->trapframe = 0;
    80001b60:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b64:	68a8                	ld	a0,80(s1)
    80001b66:	c511                	beqz	a0,80001b72 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b68:	64ac                	ld	a1,72(s1)
    80001b6a:	00000097          	auipc	ra,0x0
    80001b6e:	f8c080e7          	jalr	-116(ra) # 80001af6 <proc_freepagetable>
  p->pagetable = 0;
    80001b72:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b76:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b7a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b7e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b82:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b86:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b8a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b8e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b92:	0004ac23          	sw	zero,24(s1)
}
    80001b96:	60e2                	ld	ra,24(sp)
    80001b98:	6442                	ld	s0,16(sp)
    80001b9a:	64a2                	ld	s1,8(sp)
    80001b9c:	6105                	addi	sp,sp,32
    80001b9e:	8082                	ret

0000000080001ba0 <allocproc>:
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	e04a                	sd	s2,0(sp)
    80001baa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bac:	0000f497          	auipc	s1,0xf
    80001bb0:	3d448493          	addi	s1,s1,980 # 80010f80 <proc>
    80001bb4:	00015917          	auipc	s2,0x15
    80001bb8:	dcc90913          	addi	s2,s2,-564 # 80016980 <tickslock>
    acquire(&p->lock);
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	014080e7          	jalr	20(ra) # 80000bd2 <acquire>
    if(p->state == UNUSED) {
    80001bc6:	4c9c                	lw	a5,24(s1)
    80001bc8:	cf81                	beqz	a5,80001be0 <allocproc+0x40>
      release(&p->lock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	0ba080e7          	jalr	186(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bd4:	16848493          	addi	s1,s1,360
    80001bd8:	ff2492e3          	bne	s1,s2,80001bbc <allocproc+0x1c>
  return 0;
    80001bdc:	4481                	li	s1,0
    80001bde:	a889                	j	80001c30 <allocproc+0x90>
  p->pid = allocpid();
    80001be0:	00000097          	auipc	ra,0x0
    80001be4:	e34080e7          	jalr	-460(ra) # 80001a14 <allocpid>
    80001be8:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bea:	4785                	li	a5,1
    80001bec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	ef4080e7          	jalr	-268(ra) # 80000ae2 <kalloc>
    80001bf6:	892a                	mv	s2,a0
    80001bf8:	eca8                	sd	a0,88(s1)
    80001bfa:	c131                	beqz	a0,80001c3e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00000097          	auipc	ra,0x0
    80001c02:	e5c080e7          	jalr	-420(ra) # 80001a5a <proc_pagetable>
    80001c06:	892a                	mv	s2,a0
    80001c08:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c0a:	c531                	beqz	a0,80001c56 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c0c:	07000613          	li	a2,112
    80001c10:	4581                	li	a1,0
    80001c12:	06048513          	addi	a0,s1,96
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	0b8080e7          	jalr	184(ra) # 80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001c1e:	00000797          	auipc	a5,0x0
    80001c22:	db078793          	addi	a5,a5,-592 # 800019ce <forkret>
    80001c26:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c28:	60bc                	ld	a5,64(s1)
    80001c2a:	6705                	lui	a4,0x1
    80001c2c:	97ba                	add	a5,a5,a4
    80001c2e:	f4bc                	sd	a5,104(s1)
}
    80001c30:	8526                	mv	a0,s1
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6902                	ld	s2,0(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret
    freeproc(p);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00000097          	auipc	ra,0x0
    80001c44:	f08080e7          	jalr	-248(ra) # 80001b48 <freeproc>
    release(&p->lock);
    80001c48:	8526                	mv	a0,s1
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	03c080e7          	jalr	60(ra) # 80000c86 <release>
    return 0;
    80001c52:	84ca                	mv	s1,s2
    80001c54:	bff1                	j	80001c30 <allocproc+0x90>
    freeproc(p);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	ef0080e7          	jalr	-272(ra) # 80001b48 <freeproc>
    release(&p->lock);
    80001c60:	8526                	mv	a0,s1
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	024080e7          	jalr	36(ra) # 80000c86 <release>
    return 0;
    80001c6a:	84ca                	mv	s1,s2
    80001c6c:	b7d1                	j	80001c30 <allocproc+0x90>

0000000080001c6e <userinit>:
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f28080e7          	jalr	-216(ra) # 80001ba0 <allocproc>
    80001c80:	84aa                	mv	s1,a0
  initproc = p;
    80001c82:	00007797          	auipc	a5,0x7
    80001c86:	c4a7bb23          	sd	a0,-938(a5) # 800088d8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001c8a:	03400613          	li	a2,52
    80001c8e:	00007597          	auipc	a1,0x7
    80001c92:	be258593          	addi	a1,a1,-1054 # 80008870 <initcode>
    80001c96:	6928                	ld	a0,80(a0)
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	6a8080e7          	jalr	1704(ra) # 80001340 <uvmfirst>
  p->sz = PGSIZE;
    80001ca0:	6785                	lui	a5,0x1
    80001ca2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ca4:	6cb8                	ld	a4,88(s1)
    80001ca6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001caa:	6cb8                	ld	a4,88(s1)
    80001cac:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cae:	4641                	li	a2,16
    80001cb0:	00006597          	auipc	a1,0x6
    80001cb4:	57058593          	addi	a1,a1,1392 # 80008220 <digits+0x1e0>
    80001cb8:	15848513          	addi	a0,s1,344
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	15a080e7          	jalr	346(ra) # 80000e16 <safestrcpy>
  p->cwd = namei("/");
    80001cc4:	00006517          	auipc	a0,0x6
    80001cc8:	56c50513          	addi	a0,a0,1388 # 80008230 <digits+0x1f0>
    80001ccc:	00002097          	auipc	ra,0x2
    80001cd0:	0ec080e7          	jalr	236(ra) # 80003db8 <namei>
    80001cd4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cd8:	478d                	li	a5,3
    80001cda:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	fa8080e7          	jalr	-88(ra) # 80000c86 <release>
}
    80001ce6:	60e2                	ld	ra,24(sp)
    80001ce8:	6442                	ld	s0,16(sp)
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	6105                	addi	sp,sp,32
    80001cee:	8082                	ret

0000000080001cf0 <growproc>:
{
    80001cf0:	1101                	addi	sp,sp,-32
    80001cf2:	ec06                	sd	ra,24(sp)
    80001cf4:	e822                	sd	s0,16(sp)
    80001cf6:	e426                	sd	s1,8(sp)
    80001cf8:	e04a                	sd	s2,0(sp)
    80001cfa:	1000                	addi	s0,sp,32
    80001cfc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001cfe:	00000097          	auipc	ra,0x0
    80001d02:	c98080e7          	jalr	-872(ra) # 80001996 <myproc>
    80001d06:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d08:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d0a:	01204c63          	bgtz	s2,80001d22 <growproc+0x32>
  } else if(n < 0){
    80001d0e:	02094663          	bltz	s2,80001d3a <growproc+0x4a>
  p->sz = sz;
    80001d12:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d14:	4501                	li	a0,0
}
    80001d16:	60e2                	ld	ra,24(sp)
    80001d18:	6442                	ld	s0,16(sp)
    80001d1a:	64a2                	ld	s1,8(sp)
    80001d1c:	6902                	ld	s2,0(sp)
    80001d1e:	6105                	addi	sp,sp,32
    80001d20:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d22:	4691                	li	a3,4
    80001d24:	00b90633          	add	a2,s2,a1
    80001d28:	6928                	ld	a0,80(a0)
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	6d0080e7          	jalr	1744(ra) # 800013fa <uvmalloc>
    80001d32:	85aa                	mv	a1,a0
    80001d34:	fd79                	bnez	a0,80001d12 <growproc+0x22>
      return -1;
    80001d36:	557d                	li	a0,-1
    80001d38:	bff9                	j	80001d16 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d3a:	00b90633          	add	a2,s2,a1
    80001d3e:	6928                	ld	a0,80(a0)
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	672080e7          	jalr	1650(ra) # 800013b2 <uvmdealloc>
    80001d48:	85aa                	mv	a1,a0
    80001d4a:	b7e1                	j	80001d12 <growproc+0x22>

0000000080001d4c <fork>:
{
    80001d4c:	7139                	addi	sp,sp,-64
    80001d4e:	fc06                	sd	ra,56(sp)
    80001d50:	f822                	sd	s0,48(sp)
    80001d52:	f426                	sd	s1,40(sp)
    80001d54:	f04a                	sd	s2,32(sp)
    80001d56:	ec4e                	sd	s3,24(sp)
    80001d58:	e852                	sd	s4,16(sp)
    80001d5a:	e456                	sd	s5,8(sp)
    80001d5c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	c38080e7          	jalr	-968(ra) # 80001996 <myproc>
    80001d66:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	e38080e7          	jalr	-456(ra) # 80001ba0 <allocproc>
    80001d70:	10050c63          	beqz	a0,80001e88 <fork+0x13c>
    80001d74:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d76:	048ab603          	ld	a2,72(s5)
    80001d7a:	692c                	ld	a1,80(a0)
    80001d7c:	050ab503          	ld	a0,80(s5)
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	7d2080e7          	jalr	2002(ra) # 80001552 <uvmcopy>
    80001d88:	04054863          	bltz	a0,80001dd8 <fork+0x8c>
  np->sz = p->sz;
    80001d8c:	048ab783          	ld	a5,72(s5)
    80001d90:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d94:	058ab683          	ld	a3,88(s5)
    80001d98:	87b6                	mv	a5,a3
    80001d9a:	058a3703          	ld	a4,88(s4)
    80001d9e:	12068693          	addi	a3,a3,288
    80001da2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001da6:	6788                	ld	a0,8(a5)
    80001da8:	6b8c                	ld	a1,16(a5)
    80001daa:	6f90                	ld	a2,24(a5)
    80001dac:	01073023          	sd	a6,0(a4)
    80001db0:	e708                	sd	a0,8(a4)
    80001db2:	eb0c                	sd	a1,16(a4)
    80001db4:	ef10                	sd	a2,24(a4)
    80001db6:	02078793          	addi	a5,a5,32
    80001dba:	02070713          	addi	a4,a4,32
    80001dbe:	fed792e3          	bne	a5,a3,80001da2 <fork+0x56>
  np->trapframe->a0 = 0;
    80001dc2:	058a3783          	ld	a5,88(s4)
    80001dc6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dca:	0d0a8493          	addi	s1,s5,208
    80001dce:	0d0a0913          	addi	s2,s4,208
    80001dd2:	150a8993          	addi	s3,s5,336
    80001dd6:	a00d                	j	80001df8 <fork+0xac>
    freeproc(np);
    80001dd8:	8552                	mv	a0,s4
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	d6e080e7          	jalr	-658(ra) # 80001b48 <freeproc>
    release(&np->lock);
    80001de2:	8552                	mv	a0,s4
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	ea2080e7          	jalr	-350(ra) # 80000c86 <release>
    return -1;
    80001dec:	597d                	li	s2,-1
    80001dee:	a059                	j	80001e74 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001df0:	04a1                	addi	s1,s1,8
    80001df2:	0921                	addi	s2,s2,8
    80001df4:	01348b63          	beq	s1,s3,80001e0a <fork+0xbe>
    if(p->ofile[i])
    80001df8:	6088                	ld	a0,0(s1)
    80001dfa:	d97d                	beqz	a0,80001df0 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dfc:	00002097          	auipc	ra,0x2
    80001e00:	62e080e7          	jalr	1582(ra) # 8000442a <filedup>
    80001e04:	00a93023          	sd	a0,0(s2)
    80001e08:	b7e5                	j	80001df0 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e0a:	150ab503          	ld	a0,336(s5)
    80001e0e:	00001097          	auipc	ra,0x1
    80001e12:	7c6080e7          	jalr	1990(ra) # 800035d4 <idup>
    80001e16:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e1a:	4641                	li	a2,16
    80001e1c:	158a8593          	addi	a1,s5,344
    80001e20:	158a0513          	addi	a0,s4,344
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	ff2080e7          	jalr	-14(ra) # 80000e16 <safestrcpy>
  pid = np->pid;
    80001e2c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e30:	8552                	mv	a0,s4
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	e54080e7          	jalr	-428(ra) # 80000c86 <release>
  acquire(&wait_lock);
    80001e3a:	0000f497          	auipc	s1,0xf
    80001e3e:	d2e48493          	addi	s1,s1,-722 # 80010b68 <wait_lock>
    80001e42:	8526                	mv	a0,s1
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	d8e080e7          	jalr	-626(ra) # 80000bd2 <acquire>
  np->parent = p;
    80001e4c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e50:	8526                	mv	a0,s1
    80001e52:	fffff097          	auipc	ra,0xfffff
    80001e56:	e34080e7          	jalr	-460(ra) # 80000c86 <release>
  acquire(&np->lock);
    80001e5a:	8552                	mv	a0,s4
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	d76080e7          	jalr	-650(ra) # 80000bd2 <acquire>
  np->state = RUNNABLE;
    80001e64:	478d                	li	a5,3
    80001e66:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e6a:	8552                	mv	a0,s4
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	e1a080e7          	jalr	-486(ra) # 80000c86 <release>
}
    80001e74:	854a                	mv	a0,s2
    80001e76:	70e2                	ld	ra,56(sp)
    80001e78:	7442                	ld	s0,48(sp)
    80001e7a:	74a2                	ld	s1,40(sp)
    80001e7c:	7902                	ld	s2,32(sp)
    80001e7e:	69e2                	ld	s3,24(sp)
    80001e80:	6a42                	ld	s4,16(sp)
    80001e82:	6aa2                	ld	s5,8(sp)
    80001e84:	6121                	addi	sp,sp,64
    80001e86:	8082                	ret
    return -1;
    80001e88:	597d                	li	s2,-1
    80001e8a:	b7ed                	j	80001e74 <fork+0x128>

0000000080001e8c <scheduler>:
{
    80001e8c:	7139                	addi	sp,sp,-64
    80001e8e:	fc06                	sd	ra,56(sp)
    80001e90:	f822                	sd	s0,48(sp)
    80001e92:	f426                	sd	s1,40(sp)
    80001e94:	f04a                	sd	s2,32(sp)
    80001e96:	ec4e                	sd	s3,24(sp)
    80001e98:	e852                	sd	s4,16(sp)
    80001e9a:	e456                	sd	s5,8(sp)
    80001e9c:	e05a                	sd	s6,0(sp)
    80001e9e:	0080                	addi	s0,sp,64
    80001ea0:	8792                	mv	a5,tp
  int id = r_tp();
    80001ea2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ea4:	00779a93          	slli	s5,a5,0x7
    80001ea8:	0000f717          	auipc	a4,0xf
    80001eac:	ca870713          	addi	a4,a4,-856 # 80010b50 <pid_lock>
    80001eb0:	9756                	add	a4,a4,s5
    80001eb2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001eb6:	0000f717          	auipc	a4,0xf
    80001eba:	cd270713          	addi	a4,a4,-814 # 80010b88 <cpus+0x8>
    80001ebe:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ec0:	498d                	li	s3,3
        p->state = RUNNING;
    80001ec2:	4b11                	li	s6,4
        c->proc = p;
    80001ec4:	079e                	slli	a5,a5,0x7
    80001ec6:	0000fa17          	auipc	s4,0xf
    80001eca:	c8aa0a13          	addi	s4,s4,-886 # 80010b50 <pid_lock>
    80001ece:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ed0:	00015917          	auipc	s2,0x15
    80001ed4:	ab090913          	addi	s2,s2,-1360 # 80016980 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001edc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ee0:	10079073          	csrw	sstatus,a5
    80001ee4:	0000f497          	auipc	s1,0xf
    80001ee8:	09c48493          	addi	s1,s1,156 # 80010f80 <proc>
    80001eec:	a811                	j	80001f00 <scheduler+0x74>
      release(&p->lock);
    80001eee:	8526                	mv	a0,s1
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	d96080e7          	jalr	-618(ra) # 80000c86 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ef8:	16848493          	addi	s1,s1,360
    80001efc:	fd248ee3          	beq	s1,s2,80001ed8 <scheduler+0x4c>
      acquire(&p->lock);
    80001f00:	8526                	mv	a0,s1
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	cd0080e7          	jalr	-816(ra) # 80000bd2 <acquire>
      if(p->state == RUNNABLE) {
    80001f0a:	4c9c                	lw	a5,24(s1)
    80001f0c:	ff3791e3          	bne	a5,s3,80001eee <scheduler+0x62>
        p->state = RUNNING;
    80001f10:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f14:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f18:	06048593          	addi	a1,s1,96
    80001f1c:	8556                	mv	a0,s5
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	684080e7          	jalr	1668(ra) # 800025a2 <swtch>
        c->proc = 0;
    80001f26:	020a3823          	sd	zero,48(s4)
    80001f2a:	b7d1                	j	80001eee <scheduler+0x62>

0000000080001f2c <sched>:
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f3a:	00000097          	auipc	ra,0x0
    80001f3e:	a5c080e7          	jalr	-1444(ra) # 80001996 <myproc>
    80001f42:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	c14080e7          	jalr	-1004(ra) # 80000b58 <holding>
    80001f4c:	c93d                	beqz	a0,80001fc2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f4e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f50:	2781                	sext.w	a5,a5
    80001f52:	079e                	slli	a5,a5,0x7
    80001f54:	0000f717          	auipc	a4,0xf
    80001f58:	bfc70713          	addi	a4,a4,-1028 # 80010b50 <pid_lock>
    80001f5c:	97ba                	add	a5,a5,a4
    80001f5e:	0a87a703          	lw	a4,168(a5)
    80001f62:	4785                	li	a5,1
    80001f64:	06f71763          	bne	a4,a5,80001fd2 <sched+0xa6>
  if(p->state == RUNNING)
    80001f68:	4c98                	lw	a4,24(s1)
    80001f6a:	4791                	li	a5,4
    80001f6c:	06f70b63          	beq	a4,a5,80001fe2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f74:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f76:	efb5                	bnez	a5,80001ff2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f78:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f7a:	0000f917          	auipc	s2,0xf
    80001f7e:	bd690913          	addi	s2,s2,-1066 # 80010b50 <pid_lock>
    80001f82:	2781                	sext.w	a5,a5
    80001f84:	079e                	slli	a5,a5,0x7
    80001f86:	97ca                	add	a5,a5,s2
    80001f88:	0ac7a983          	lw	s3,172(a5)
    80001f8c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f8e:	2781                	sext.w	a5,a5
    80001f90:	079e                	slli	a5,a5,0x7
    80001f92:	0000f597          	auipc	a1,0xf
    80001f96:	bf658593          	addi	a1,a1,-1034 # 80010b88 <cpus+0x8>
    80001f9a:	95be                	add	a1,a1,a5
    80001f9c:	06048513          	addi	a0,s1,96
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	602080e7          	jalr	1538(ra) # 800025a2 <swtch>
    80001fa8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001faa:	2781                	sext.w	a5,a5
    80001fac:	079e                	slli	a5,a5,0x7
    80001fae:	993e                	add	s2,s2,a5
    80001fb0:	0b392623          	sw	s3,172(s2)
}
    80001fb4:	70a2                	ld	ra,40(sp)
    80001fb6:	7402                	ld	s0,32(sp)
    80001fb8:	64e2                	ld	s1,24(sp)
    80001fba:	6942                	ld	s2,16(sp)
    80001fbc:	69a2                	ld	s3,8(sp)
    80001fbe:	6145                	addi	sp,sp,48
    80001fc0:	8082                	ret
    panic("sched p->lock");
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	27650513          	addi	a0,a0,630 # 80008238 <digits+0x1f8>
    80001fca:	ffffe097          	auipc	ra,0xffffe
    80001fce:	572080e7          	jalr	1394(ra) # 8000053c <panic>
    panic("sched locks");
    80001fd2:	00006517          	auipc	a0,0x6
    80001fd6:	27650513          	addi	a0,a0,630 # 80008248 <digits+0x208>
    80001fda:	ffffe097          	auipc	ra,0xffffe
    80001fde:	562080e7          	jalr	1378(ra) # 8000053c <panic>
    panic("sched running");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	27650513          	addi	a0,a0,630 # 80008258 <digits+0x218>
    80001fea:	ffffe097          	auipc	ra,0xffffe
    80001fee:	552080e7          	jalr	1362(ra) # 8000053c <panic>
    panic("sched interruptible");
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	27650513          	addi	a0,a0,630 # 80008268 <digits+0x228>
    80001ffa:	ffffe097          	auipc	ra,0xffffe
    80001ffe:	542080e7          	jalr	1346(ra) # 8000053c <panic>

0000000080002002 <yield>:
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000200c:	00000097          	auipc	ra,0x0
    80002010:	98a080e7          	jalr	-1654(ra) # 80001996 <myproc>
    80002014:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	bbc080e7          	jalr	-1092(ra) # 80000bd2 <acquire>
  p->state = RUNNABLE;
    8000201e:	478d                	li	a5,3
    80002020:	cc9c                	sw	a5,24(s1)
  sched();
    80002022:	00000097          	auipc	ra,0x0
    80002026:	f0a080e7          	jalr	-246(ra) # 80001f2c <sched>
  release(&p->lock);
    8000202a:	8526                	mv	a0,s1
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	c5a080e7          	jalr	-934(ra) # 80000c86 <release>
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret

000000008000203e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000203e:	7179                	addi	sp,sp,-48
    80002040:	f406                	sd	ra,40(sp)
    80002042:	f022                	sd	s0,32(sp)
    80002044:	ec26                	sd	s1,24(sp)
    80002046:	e84a                	sd	s2,16(sp)
    80002048:	e44e                	sd	s3,8(sp)
    8000204a:	1800                	addi	s0,sp,48
    8000204c:	89aa                	mv	s3,a0
    8000204e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002050:	00000097          	auipc	ra,0x0
    80002054:	946080e7          	jalr	-1722(ra) # 80001996 <myproc>
    80002058:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	b78080e7          	jalr	-1160(ra) # 80000bd2 <acquire>
  release(lk);
    80002062:	854a                	mv	a0,s2
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	c22080e7          	jalr	-990(ra) # 80000c86 <release>

  // Go to sleep.
  p->chan = chan;
    8000206c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002070:	4789                	li	a5,2
    80002072:	cc9c                	sw	a5,24(s1)

  sched();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	eb8080e7          	jalr	-328(ra) # 80001f2c <sched>

  // Tidy up.
  p->chan = 0;
    8000207c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	c04080e7          	jalr	-1020(ra) # 80000c86 <release>
  acquire(lk);
    8000208a:	854a                	mv	a0,s2
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	b46080e7          	jalr	-1210(ra) # 80000bd2 <acquire>
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret

00000000800020a2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020a2:	7139                	addi	sp,sp,-64
    800020a4:	fc06                	sd	ra,56(sp)
    800020a6:	f822                	sd	s0,48(sp)
    800020a8:	f426                	sd	s1,40(sp)
    800020aa:	f04a                	sd	s2,32(sp)
    800020ac:	ec4e                	sd	s3,24(sp)
    800020ae:	e852                	sd	s4,16(sp)
    800020b0:	e456                	sd	s5,8(sp)
    800020b2:	0080                	addi	s0,sp,64
    800020b4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020b6:	0000f497          	auipc	s1,0xf
    800020ba:	eca48493          	addi	s1,s1,-310 # 80010f80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020be:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020c0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020c2:	00015917          	auipc	s2,0x15
    800020c6:	8be90913          	addi	s2,s2,-1858 # 80016980 <tickslock>
    800020ca:	a811                	j	800020de <wakeup+0x3c>
      }
      release(&p->lock);
    800020cc:	8526                	mv	a0,s1
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	bb8080e7          	jalr	-1096(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d6:	16848493          	addi	s1,s1,360
    800020da:	03248663          	beq	s1,s2,80002106 <wakeup+0x64>
    if(p != myproc()){
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	8b8080e7          	jalr	-1864(ra) # 80001996 <myproc>
    800020e6:	fea488e3          	beq	s1,a0,800020d6 <wakeup+0x34>
      acquire(&p->lock);
    800020ea:	8526                	mv	a0,s1
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	ae6080e7          	jalr	-1306(ra) # 80000bd2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800020f4:	4c9c                	lw	a5,24(s1)
    800020f6:	fd379be3          	bne	a5,s3,800020cc <wakeup+0x2a>
    800020fa:	709c                	ld	a5,32(s1)
    800020fc:	fd4798e3          	bne	a5,s4,800020cc <wakeup+0x2a>
        p->state = RUNNABLE;
    80002100:	0154ac23          	sw	s5,24(s1)
    80002104:	b7e1                	j	800020cc <wakeup+0x2a>
    }
  }
}
    80002106:	70e2                	ld	ra,56(sp)
    80002108:	7442                	ld	s0,48(sp)
    8000210a:	74a2                	ld	s1,40(sp)
    8000210c:	7902                	ld	s2,32(sp)
    8000210e:	69e2                	ld	s3,24(sp)
    80002110:	6a42                	ld	s4,16(sp)
    80002112:	6aa2                	ld	s5,8(sp)
    80002114:	6121                	addi	sp,sp,64
    80002116:	8082                	ret

0000000080002118 <reparent>:
{
    80002118:	7179                	addi	sp,sp,-48
    8000211a:	f406                	sd	ra,40(sp)
    8000211c:	f022                	sd	s0,32(sp)
    8000211e:	ec26                	sd	s1,24(sp)
    80002120:	e84a                	sd	s2,16(sp)
    80002122:	e44e                	sd	s3,8(sp)
    80002124:	e052                	sd	s4,0(sp)
    80002126:	1800                	addi	s0,sp,48
    80002128:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000212a:	0000f497          	auipc	s1,0xf
    8000212e:	e5648493          	addi	s1,s1,-426 # 80010f80 <proc>
      pp->parent = initproc;
    80002132:	00006a17          	auipc	s4,0x6
    80002136:	7a6a0a13          	addi	s4,s4,1958 # 800088d8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000213a:	00015997          	auipc	s3,0x15
    8000213e:	84698993          	addi	s3,s3,-1978 # 80016980 <tickslock>
    80002142:	a029                	j	8000214c <reparent+0x34>
    80002144:	16848493          	addi	s1,s1,360
    80002148:	01348d63          	beq	s1,s3,80002162 <reparent+0x4a>
    if(pp->parent == p){
    8000214c:	7c9c                	ld	a5,56(s1)
    8000214e:	ff279be3          	bne	a5,s2,80002144 <reparent+0x2c>
      pp->parent = initproc;
    80002152:	000a3503          	ld	a0,0(s4)
    80002156:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	f4a080e7          	jalr	-182(ra) # 800020a2 <wakeup>
    80002160:	b7d5                	j	80002144 <reparent+0x2c>
}
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6942                	ld	s2,16(sp)
    8000216a:	69a2                	ld	s3,8(sp)
    8000216c:	6a02                	ld	s4,0(sp)
    8000216e:	6145                	addi	sp,sp,48
    80002170:	8082                	ret

0000000080002172 <exit>:
{
    80002172:	7179                	addi	sp,sp,-48
    80002174:	f406                	sd	ra,40(sp)
    80002176:	f022                	sd	s0,32(sp)
    80002178:	ec26                	sd	s1,24(sp)
    8000217a:	e84a                	sd	s2,16(sp)
    8000217c:	e44e                	sd	s3,8(sp)
    8000217e:	e052                	sd	s4,0(sp)
    80002180:	1800                	addi	s0,sp,48
    80002182:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002184:	00000097          	auipc	ra,0x0
    80002188:	812080e7          	jalr	-2030(ra) # 80001996 <myproc>
    8000218c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000218e:	00006797          	auipc	a5,0x6
    80002192:	74a7b783          	ld	a5,1866(a5) # 800088d8 <initproc>
    80002196:	0d050493          	addi	s1,a0,208
    8000219a:	15050913          	addi	s2,a0,336
    8000219e:	02a79363          	bne	a5,a0,800021c4 <exit+0x52>
    panic("init exiting");
    800021a2:	00006517          	auipc	a0,0x6
    800021a6:	0de50513          	addi	a0,a0,222 # 80008280 <digits+0x240>
    800021aa:	ffffe097          	auipc	ra,0xffffe
    800021ae:	392080e7          	jalr	914(ra) # 8000053c <panic>
      fileclose(f);
    800021b2:	00002097          	auipc	ra,0x2
    800021b6:	2ca080e7          	jalr	714(ra) # 8000447c <fileclose>
      p->ofile[fd] = 0;
    800021ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021be:	04a1                	addi	s1,s1,8
    800021c0:	01248563          	beq	s1,s2,800021ca <exit+0x58>
    if(p->ofile[fd]){
    800021c4:	6088                	ld	a0,0(s1)
    800021c6:	f575                	bnez	a0,800021b2 <exit+0x40>
    800021c8:	bfdd                	j	800021be <exit+0x4c>
  begin_op();
    800021ca:	00002097          	auipc	ra,0x2
    800021ce:	dee080e7          	jalr	-530(ra) # 80003fb8 <begin_op>
  iput(p->cwd);
    800021d2:	1509b503          	ld	a0,336(s3)
    800021d6:	00001097          	auipc	ra,0x1
    800021da:	5f6080e7          	jalr	1526(ra) # 800037cc <iput>
  end_op();
    800021de:	00002097          	auipc	ra,0x2
    800021e2:	e54080e7          	jalr	-428(ra) # 80004032 <end_op>
  p->cwd = 0;
    800021e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800021ea:	0000f497          	auipc	s1,0xf
    800021ee:	97e48493          	addi	s1,s1,-1666 # 80010b68 <wait_lock>
    800021f2:	8526                	mv	a0,s1
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	9de080e7          	jalr	-1570(ra) # 80000bd2 <acquire>
  reparent(p);
    800021fc:	854e                	mv	a0,s3
    800021fe:	00000097          	auipc	ra,0x0
    80002202:	f1a080e7          	jalr	-230(ra) # 80002118 <reparent>
  wakeup(p->parent);
    80002206:	0389b503          	ld	a0,56(s3)
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	e98080e7          	jalr	-360(ra) # 800020a2 <wakeup>
  acquire(&p->lock);
    80002212:	854e                	mv	a0,s3
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	9be080e7          	jalr	-1602(ra) # 80000bd2 <acquire>
  p->xstate = status;
    8000221c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002220:	4795                	li	a5,5
    80002222:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002226:	8526                	mv	a0,s1
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	a5e080e7          	jalr	-1442(ra) # 80000c86 <release>
  sched();
    80002230:	00000097          	auipc	ra,0x0
    80002234:	cfc080e7          	jalr	-772(ra) # 80001f2c <sched>
  panic("zombie exit");
    80002238:	00006517          	auipc	a0,0x6
    8000223c:	05850513          	addi	a0,a0,88 # 80008290 <digits+0x250>
    80002240:	ffffe097          	auipc	ra,0xffffe
    80002244:	2fc080e7          	jalr	764(ra) # 8000053c <panic>

0000000080002248 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	1800                	addi	s0,sp,48
    80002256:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002258:	0000f497          	auipc	s1,0xf
    8000225c:	d2848493          	addi	s1,s1,-728 # 80010f80 <proc>
    80002260:	00014997          	auipc	s3,0x14
    80002264:	72098993          	addi	s3,s3,1824 # 80016980 <tickslock>
    acquire(&p->lock);
    80002268:	8526                	mv	a0,s1
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	968080e7          	jalr	-1688(ra) # 80000bd2 <acquire>
    if(p->pid == pid){
    80002272:	589c                	lw	a5,48(s1)
    80002274:	01278d63          	beq	a5,s2,8000228e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002278:	8526                	mv	a0,s1
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	a0c080e7          	jalr	-1524(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002282:	16848493          	addi	s1,s1,360
    80002286:	ff3491e3          	bne	s1,s3,80002268 <kill+0x20>
  }
  return -1;
    8000228a:	557d                	li	a0,-1
    8000228c:	a829                	j	800022a6 <kill+0x5e>
      p->killed = 1;
    8000228e:	4785                	li	a5,1
    80002290:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002292:	4c98                	lw	a4,24(s1)
    80002294:	4789                	li	a5,2
    80002296:	00f70f63          	beq	a4,a5,800022b4 <kill+0x6c>
      release(&p->lock);
    8000229a:	8526                	mv	a0,s1
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	9ea080e7          	jalr	-1558(ra) # 80000c86 <release>
      return 0;
    800022a4:	4501                	li	a0,0
}
    800022a6:	70a2                	ld	ra,40(sp)
    800022a8:	7402                	ld	s0,32(sp)
    800022aa:	64e2                	ld	s1,24(sp)
    800022ac:	6942                	ld	s2,16(sp)
    800022ae:	69a2                	ld	s3,8(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
        p->state = RUNNABLE;
    800022b4:	478d                	li	a5,3
    800022b6:	cc9c                	sw	a5,24(s1)
    800022b8:	b7cd                	j	8000229a <kill+0x52>

00000000800022ba <setkilled>:

void
setkilled(struct proc *p)
{
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	e426                	sd	s1,8(sp)
    800022c2:	1000                	addi	s0,sp,32
    800022c4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	90c080e7          	jalr	-1780(ra) # 80000bd2 <acquire>
  p->killed = 1;
    800022ce:	4785                	li	a5,1
    800022d0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	9b2080e7          	jalr	-1614(ra) # 80000c86 <release>
}
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	64a2                	ld	s1,8(sp)
    800022e2:	6105                	addi	sp,sp,32
    800022e4:	8082                	ret

00000000800022e6 <killed>:

int
killed(struct proc *p)
{
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	e426                	sd	s1,8(sp)
    800022ee:	e04a                	sd	s2,0(sp)
    800022f0:	1000                	addi	s0,sp,32
    800022f2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	8de080e7          	jalr	-1826(ra) # 80000bd2 <acquire>
  k = p->killed;
    800022fc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002300:	8526                	mv	a0,s1
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	984080e7          	jalr	-1660(ra) # 80000c86 <release>
  return k;
}
    8000230a:	854a                	mv	a0,s2
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6902                	ld	s2,0(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret

0000000080002318 <wait>:
{
    80002318:	715d                	addi	sp,sp,-80
    8000231a:	e486                	sd	ra,72(sp)
    8000231c:	e0a2                	sd	s0,64(sp)
    8000231e:	fc26                	sd	s1,56(sp)
    80002320:	f84a                	sd	s2,48(sp)
    80002322:	f44e                	sd	s3,40(sp)
    80002324:	f052                	sd	s4,32(sp)
    80002326:	ec56                	sd	s5,24(sp)
    80002328:	e85a                	sd	s6,16(sp)
    8000232a:	e45e                	sd	s7,8(sp)
    8000232c:	e062                	sd	s8,0(sp)
    8000232e:	0880                	addi	s0,sp,80
    80002330:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	664080e7          	jalr	1636(ra) # 80001996 <myproc>
    8000233a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000233c:	0000f517          	auipc	a0,0xf
    80002340:	82c50513          	addi	a0,a0,-2004 # 80010b68 <wait_lock>
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	88e080e7          	jalr	-1906(ra) # 80000bd2 <acquire>
    havekids = 0;
    8000234c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000234e:	4a15                	li	s4,5
        havekids = 1;
    80002350:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002352:	00014997          	auipc	s3,0x14
    80002356:	62e98993          	addi	s3,s3,1582 # 80016980 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000235a:	0000fc17          	auipc	s8,0xf
    8000235e:	80ec0c13          	addi	s8,s8,-2034 # 80010b68 <wait_lock>
    80002362:	a0d1                	j	80002426 <wait+0x10e>
          pid = pp->pid;
    80002364:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002368:	000b0e63          	beqz	s6,80002384 <wait+0x6c>
    8000236c:	4691                	li	a3,4
    8000236e:	02c48613          	addi	a2,s1,44
    80002372:	85da                	mv	a1,s6
    80002374:	05093503          	ld	a0,80(s2)
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	2de080e7          	jalr	734(ra) # 80001656 <copyout>
    80002380:	04054163          	bltz	a0,800023c2 <wait+0xaa>
          freeproc(pp);
    80002384:	8526                	mv	a0,s1
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	7c2080e7          	jalr	1986(ra) # 80001b48 <freeproc>
          release(&pp->lock);
    8000238e:	8526                	mv	a0,s1
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	8f6080e7          	jalr	-1802(ra) # 80000c86 <release>
          release(&wait_lock);
    80002398:	0000e517          	auipc	a0,0xe
    8000239c:	7d050513          	addi	a0,a0,2000 # 80010b68 <wait_lock>
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	8e6080e7          	jalr	-1818(ra) # 80000c86 <release>
}
    800023a8:	854e                	mv	a0,s3
    800023aa:	60a6                	ld	ra,72(sp)
    800023ac:	6406                	ld	s0,64(sp)
    800023ae:	74e2                	ld	s1,56(sp)
    800023b0:	7942                	ld	s2,48(sp)
    800023b2:	79a2                	ld	s3,40(sp)
    800023b4:	7a02                	ld	s4,32(sp)
    800023b6:	6ae2                	ld	s5,24(sp)
    800023b8:	6b42                	ld	s6,16(sp)
    800023ba:	6ba2                	ld	s7,8(sp)
    800023bc:	6c02                	ld	s8,0(sp)
    800023be:	6161                	addi	sp,sp,80
    800023c0:	8082                	ret
            release(&pp->lock);
    800023c2:	8526                	mv	a0,s1
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	8c2080e7          	jalr	-1854(ra) # 80000c86 <release>
            release(&wait_lock);
    800023cc:	0000e517          	auipc	a0,0xe
    800023d0:	79c50513          	addi	a0,a0,1948 # 80010b68 <wait_lock>
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	8b2080e7          	jalr	-1870(ra) # 80000c86 <release>
            return -1;
    800023dc:	59fd                	li	s3,-1
    800023de:	b7e9                	j	800023a8 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023e0:	16848493          	addi	s1,s1,360
    800023e4:	03348463          	beq	s1,s3,8000240c <wait+0xf4>
      if(pp->parent == p){
    800023e8:	7c9c                	ld	a5,56(s1)
    800023ea:	ff279be3          	bne	a5,s2,800023e0 <wait+0xc8>
        acquire(&pp->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	ffffe097          	auipc	ra,0xffffe
    800023f4:	7e2080e7          	jalr	2018(ra) # 80000bd2 <acquire>
        if(pp->state == ZOMBIE){
    800023f8:	4c9c                	lw	a5,24(s1)
    800023fa:	f74785e3          	beq	a5,s4,80002364 <wait+0x4c>
        release(&pp->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	886080e7          	jalr	-1914(ra) # 80000c86 <release>
        havekids = 1;
    80002408:	8756                	mv	a4,s5
    8000240a:	bfd9                	j	800023e0 <wait+0xc8>
    if(!havekids || killed(p)){
    8000240c:	c31d                	beqz	a4,80002432 <wait+0x11a>
    8000240e:	854a                	mv	a0,s2
    80002410:	00000097          	auipc	ra,0x0
    80002414:	ed6080e7          	jalr	-298(ra) # 800022e6 <killed>
    80002418:	ed09                	bnez	a0,80002432 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000241a:	85e2                	mv	a1,s8
    8000241c:	854a                	mv	a0,s2
    8000241e:	00000097          	auipc	ra,0x0
    80002422:	c20080e7          	jalr	-992(ra) # 8000203e <sleep>
    havekids = 0;
    80002426:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002428:	0000f497          	auipc	s1,0xf
    8000242c:	b5848493          	addi	s1,s1,-1192 # 80010f80 <proc>
    80002430:	bf65                	j	800023e8 <wait+0xd0>
      release(&wait_lock);
    80002432:	0000e517          	auipc	a0,0xe
    80002436:	73650513          	addi	a0,a0,1846 # 80010b68 <wait_lock>
    8000243a:	fffff097          	auipc	ra,0xfffff
    8000243e:	84c080e7          	jalr	-1972(ra) # 80000c86 <release>
      return -1;
    80002442:	59fd                	li	s3,-1
    80002444:	b795                	j	800023a8 <wait+0x90>

0000000080002446 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002446:	7179                	addi	sp,sp,-48
    80002448:	f406                	sd	ra,40(sp)
    8000244a:	f022                	sd	s0,32(sp)
    8000244c:	ec26                	sd	s1,24(sp)
    8000244e:	e84a                	sd	s2,16(sp)
    80002450:	e44e                	sd	s3,8(sp)
    80002452:	e052                	sd	s4,0(sp)
    80002454:	1800                	addi	s0,sp,48
    80002456:	84aa                	mv	s1,a0
    80002458:	892e                	mv	s2,a1
    8000245a:	89b2                	mv	s3,a2
    8000245c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	538080e7          	jalr	1336(ra) # 80001996 <myproc>
  if(user_dst){
    80002466:	c08d                	beqz	s1,80002488 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002468:	86d2                	mv	a3,s4
    8000246a:	864e                	mv	a2,s3
    8000246c:	85ca                	mv	a1,s2
    8000246e:	6928                	ld	a0,80(a0)
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	1e6080e7          	jalr	486(ra) # 80001656 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002478:	70a2                	ld	ra,40(sp)
    8000247a:	7402                	ld	s0,32(sp)
    8000247c:	64e2                	ld	s1,24(sp)
    8000247e:	6942                	ld	s2,16(sp)
    80002480:	69a2                	ld	s3,8(sp)
    80002482:	6a02                	ld	s4,0(sp)
    80002484:	6145                	addi	sp,sp,48
    80002486:	8082                	ret
    memmove((char *)dst, src, len);
    80002488:	000a061b          	sext.w	a2,s4
    8000248c:	85ce                	mv	a1,s3
    8000248e:	854a                	mv	a0,s2
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	89a080e7          	jalr	-1894(ra) # 80000d2a <memmove>
    return 0;
    80002498:	8526                	mv	a0,s1
    8000249a:	bff9                	j	80002478 <either_copyout+0x32>

000000008000249c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000249c:	7179                	addi	sp,sp,-48
    8000249e:	f406                	sd	ra,40(sp)
    800024a0:	f022                	sd	s0,32(sp)
    800024a2:	ec26                	sd	s1,24(sp)
    800024a4:	e84a                	sd	s2,16(sp)
    800024a6:	e44e                	sd	s3,8(sp)
    800024a8:	e052                	sd	s4,0(sp)
    800024aa:	1800                	addi	s0,sp,48
    800024ac:	892a                	mv	s2,a0
    800024ae:	84ae                	mv	s1,a1
    800024b0:	89b2                	mv	s3,a2
    800024b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	4e2080e7          	jalr	1250(ra) # 80001996 <myproc>
  if(user_src){
    800024bc:	c08d                	beqz	s1,800024de <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024be:	86d2                	mv	a3,s4
    800024c0:	864e                	mv	a2,s3
    800024c2:	85ca                	mv	a1,s2
    800024c4:	6928                	ld	a0,80(a0)
    800024c6:	fffff097          	auipc	ra,0xfffff
    800024ca:	21c080e7          	jalr	540(ra) # 800016e2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024ce:	70a2                	ld	ra,40(sp)
    800024d0:	7402                	ld	s0,32(sp)
    800024d2:	64e2                	ld	s1,24(sp)
    800024d4:	6942                	ld	s2,16(sp)
    800024d6:	69a2                	ld	s3,8(sp)
    800024d8:	6a02                	ld	s4,0(sp)
    800024da:	6145                	addi	sp,sp,48
    800024dc:	8082                	ret
    memmove(dst, (char*)src, len);
    800024de:	000a061b          	sext.w	a2,s4
    800024e2:	85ce                	mv	a1,s3
    800024e4:	854a                	mv	a0,s2
    800024e6:	fffff097          	auipc	ra,0xfffff
    800024ea:	844080e7          	jalr	-1980(ra) # 80000d2a <memmove>
    return 0;
    800024ee:	8526                	mv	a0,s1
    800024f0:	bff9                	j	800024ce <either_copyin+0x32>

00000000800024f2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024f2:	715d                	addi	sp,sp,-80
    800024f4:	e486                	sd	ra,72(sp)
    800024f6:	e0a2                	sd	s0,64(sp)
    800024f8:	fc26                	sd	s1,56(sp)
    800024fa:	f84a                	sd	s2,48(sp)
    800024fc:	f44e                	sd	s3,40(sp)
    800024fe:	f052                	sd	s4,32(sp)
    80002500:	ec56                	sd	s5,24(sp)
    80002502:	e85a                	sd	s6,16(sp)
    80002504:	e45e                	sd	s7,8(sp)
    80002506:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	be050513          	addi	a0,a0,-1056 # 800080e8 <digits+0xa8>
    80002510:	ffffe097          	auipc	ra,0xffffe
    80002514:	076080e7          	jalr	118(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002518:	0000f497          	auipc	s1,0xf
    8000251c:	bc048493          	addi	s1,s1,-1088 # 800110d8 <proc+0x158>
    80002520:	00014917          	auipc	s2,0x14
    80002524:	5b890913          	addi	s2,s2,1464 # 80016ad8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002528:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000252a:	00006997          	auipc	s3,0x6
    8000252e:	d7698993          	addi	s3,s3,-650 # 800082a0 <digits+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80002532:	00006a97          	auipc	s5,0x6
    80002536:	d76a8a93          	addi	s5,s5,-650 # 800082a8 <digits+0x268>
    printf("\n");
    8000253a:	00006a17          	auipc	s4,0x6
    8000253e:	baea0a13          	addi	s4,s4,-1106 # 800080e8 <digits+0xa8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002542:	00006b97          	auipc	s7,0x6
    80002546:	da6b8b93          	addi	s7,s7,-602 # 800082e8 <states.0>
    8000254a:	a00d                	j	8000256c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000254c:	ed86a583          	lw	a1,-296(a3)
    80002550:	8556                	mv	a0,s5
    80002552:	ffffe097          	auipc	ra,0xffffe
    80002556:	034080e7          	jalr	52(ra) # 80000586 <printf>
    printf("\n");
    8000255a:	8552                	mv	a0,s4
    8000255c:	ffffe097          	auipc	ra,0xffffe
    80002560:	02a080e7          	jalr	42(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002564:	16848493          	addi	s1,s1,360
    80002568:	03248263          	beq	s1,s2,8000258c <procdump+0x9a>
    if(p->state == UNUSED)
    8000256c:	86a6                	mv	a3,s1
    8000256e:	ec04a783          	lw	a5,-320(s1)
    80002572:	dbed                	beqz	a5,80002564 <procdump+0x72>
      state = "???";
    80002574:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002576:	fcfb6be3          	bltu	s6,a5,8000254c <procdump+0x5a>
    8000257a:	02079713          	slli	a4,a5,0x20
    8000257e:	01d75793          	srli	a5,a4,0x1d
    80002582:	97de                	add	a5,a5,s7
    80002584:	6390                	ld	a2,0(a5)
    80002586:	f279                	bnez	a2,8000254c <procdump+0x5a>
      state = "???";
    80002588:	864e                	mv	a2,s3
    8000258a:	b7c9                	j	8000254c <procdump+0x5a>
  }
}
    8000258c:	60a6                	ld	ra,72(sp)
    8000258e:	6406                	ld	s0,64(sp)
    80002590:	74e2                	ld	s1,56(sp)
    80002592:	7942                	ld	s2,48(sp)
    80002594:	79a2                	ld	s3,40(sp)
    80002596:	7a02                	ld	s4,32(sp)
    80002598:	6ae2                	ld	s5,24(sp)
    8000259a:	6b42                	ld	s6,16(sp)
    8000259c:	6ba2                	ld	s7,8(sp)
    8000259e:	6161                	addi	sp,sp,80
    800025a0:	8082                	ret

00000000800025a2 <swtch>:
    800025a2:	00153023          	sd	ra,0(a0)
    800025a6:	00253423          	sd	sp,8(a0)
    800025aa:	e900                	sd	s0,16(a0)
    800025ac:	ed04                	sd	s1,24(a0)
    800025ae:	03253023          	sd	s2,32(a0)
    800025b2:	03353423          	sd	s3,40(a0)
    800025b6:	03453823          	sd	s4,48(a0)
    800025ba:	03553c23          	sd	s5,56(a0)
    800025be:	05653023          	sd	s6,64(a0)
    800025c2:	05753423          	sd	s7,72(a0)
    800025c6:	05853823          	sd	s8,80(a0)
    800025ca:	05953c23          	sd	s9,88(a0)
    800025ce:	07a53023          	sd	s10,96(a0)
    800025d2:	07b53423          	sd	s11,104(a0)
    800025d6:	0005b083          	ld	ra,0(a1)
    800025da:	0085b103          	ld	sp,8(a1)
    800025de:	6980                	ld	s0,16(a1)
    800025e0:	6d84                	ld	s1,24(a1)
    800025e2:	0205b903          	ld	s2,32(a1)
    800025e6:	0285b983          	ld	s3,40(a1)
    800025ea:	0305ba03          	ld	s4,48(a1)
    800025ee:	0385ba83          	ld	s5,56(a1)
    800025f2:	0405bb03          	ld	s6,64(a1)
    800025f6:	0485bb83          	ld	s7,72(a1)
    800025fa:	0505bc03          	ld	s8,80(a1)
    800025fe:	0585bc83          	ld	s9,88(a1)
    80002602:	0605bd03          	ld	s10,96(a1)
    80002606:	0685bd83          	ld	s11,104(a1)
    8000260a:	8082                	ret

000000008000260c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000260c:	1141                	addi	sp,sp,-16
    8000260e:	e406                	sd	ra,8(sp)
    80002610:	e022                	sd	s0,0(sp)
    80002612:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002614:	00006597          	auipc	a1,0x6
    80002618:	d0458593          	addi	a1,a1,-764 # 80008318 <states.0+0x30>
    8000261c:	00014517          	auipc	a0,0x14
    80002620:	36450513          	addi	a0,a0,868 # 80016980 <tickslock>
    80002624:	ffffe097          	auipc	ra,0xffffe
    80002628:	51e080e7          	jalr	1310(ra) # 80000b42 <initlock>
}
    8000262c:	60a2                	ld	ra,8(sp)
    8000262e:	6402                	ld	s0,0(sp)
    80002630:	0141                	addi	sp,sp,16
    80002632:	8082                	ret

0000000080002634 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002634:	1141                	addi	sp,sp,-16
    80002636:	e422                	sd	s0,8(sp)
    80002638:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000263a:	00003797          	auipc	a5,0x3
    8000263e:	46678793          	addi	a5,a5,1126 # 80005aa0 <kernelvec>
    80002642:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002646:	6422                	ld	s0,8(sp)
    80002648:	0141                	addi	sp,sp,16
    8000264a:	8082                	ret

000000008000264c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000264c:	1141                	addi	sp,sp,-16
    8000264e:	e406                	sd	ra,8(sp)
    80002650:	e022                	sd	s0,0(sp)
    80002652:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002654:	fffff097          	auipc	ra,0xfffff
    80002658:	342080e7          	jalr	834(ra) # 80001996 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002660:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002662:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002666:	00005697          	auipc	a3,0x5
    8000266a:	99a68693          	addi	a3,a3,-1638 # 80007000 <_trampoline>
    8000266e:	00005717          	auipc	a4,0x5
    80002672:	99270713          	addi	a4,a4,-1646 # 80007000 <_trampoline>
    80002676:	8f15                	sub	a4,a4,a3
    80002678:	040007b7          	lui	a5,0x4000
    8000267c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000267e:	07b2                	slli	a5,a5,0xc
    80002680:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002682:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002686:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002688:	18002673          	csrr	a2,satp
    8000268c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000268e:	6d30                	ld	a2,88(a0)
    80002690:	6138                	ld	a4,64(a0)
    80002692:	6585                	lui	a1,0x1
    80002694:	972e                	add	a4,a4,a1
    80002696:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002698:	6d38                	ld	a4,88(a0)
    8000269a:	00000617          	auipc	a2,0x0
    8000269e:	13460613          	addi	a2,a2,308 # 800027ce <usertrap>
    800026a2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026a4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026a6:	8612                	mv	a2,tp
    800026a8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026aa:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026ae:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026b2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026b6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026ba:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026bc:	6f18                	ld	a4,24(a4)
    800026be:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026c2:	6928                	ld	a0,80(a0)
    800026c4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800026c6:	00005717          	auipc	a4,0x5
    800026ca:	9d670713          	addi	a4,a4,-1578 # 8000709c <userret>
    800026ce:	8f15                	sub	a4,a4,a3
    800026d0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800026d2:	577d                	li	a4,-1
    800026d4:	177e                	slli	a4,a4,0x3f
    800026d6:	8d59                	or	a0,a0,a4
    800026d8:	9782                	jalr	a5
}
    800026da:	60a2                	ld	ra,8(sp)
    800026dc:	6402                	ld	s0,0(sp)
    800026de:	0141                	addi	sp,sp,16
    800026e0:	8082                	ret

00000000800026e2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026e2:	1101                	addi	sp,sp,-32
    800026e4:	ec06                	sd	ra,24(sp)
    800026e6:	e822                	sd	s0,16(sp)
    800026e8:	e426                	sd	s1,8(sp)
    800026ea:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026ec:	00014497          	auipc	s1,0x14
    800026f0:	29448493          	addi	s1,s1,660 # 80016980 <tickslock>
    800026f4:	8526                	mv	a0,s1
    800026f6:	ffffe097          	auipc	ra,0xffffe
    800026fa:	4dc080e7          	jalr	1244(ra) # 80000bd2 <acquire>
  ticks++;
    800026fe:	00006517          	auipc	a0,0x6
    80002702:	1e250513          	addi	a0,a0,482 # 800088e0 <ticks>
    80002706:	411c                	lw	a5,0(a0)
    80002708:	2785                	addiw	a5,a5,1
    8000270a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	996080e7          	jalr	-1642(ra) # 800020a2 <wakeup>
  release(&tickslock);
    80002714:	8526                	mv	a0,s1
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	570080e7          	jalr	1392(ra) # 80000c86 <release>
}
    8000271e:	60e2                	ld	ra,24(sp)
    80002720:	6442                	ld	s0,16(sp)
    80002722:	64a2                	ld	s1,8(sp)
    80002724:	6105                	addi	sp,sp,32
    80002726:	8082                	ret

0000000080002728 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002728:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000272c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    8000272e:	0807df63          	bgez	a5,800027cc <devintr+0xa4>
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    8000273c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002740:	46a5                	li	a3,9
    80002742:	00d70d63          	beq	a4,a3,8000275c <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80002746:	577d                	li	a4,-1
    80002748:	177e                	slli	a4,a4,0x3f
    8000274a:	0705                	addi	a4,a4,1
    return 0;
    8000274c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000274e:	04e78e63          	beq	a5,a4,800027aa <devintr+0x82>
  }
}
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret
    int irq = plic_claim();
    8000275c:	00003097          	auipc	ra,0x3
    80002760:	44c080e7          	jalr	1100(ra) # 80005ba8 <plic_claim>
    80002764:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002766:	47a9                	li	a5,10
    80002768:	02f50763          	beq	a0,a5,80002796 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    8000276c:	4785                	li	a5,1
    8000276e:	02f50963          	beq	a0,a5,800027a0 <devintr+0x78>
    return 1;
    80002772:	4505                	li	a0,1
    } else if(irq){
    80002774:	dcf9                	beqz	s1,80002752 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80002776:	85a6                	mv	a1,s1
    80002778:	00006517          	auipc	a0,0x6
    8000277c:	ba850513          	addi	a0,a0,-1112 # 80008320 <states.0+0x38>
    80002780:	ffffe097          	auipc	ra,0xffffe
    80002784:	e06080e7          	jalr	-506(ra) # 80000586 <printf>
      plic_complete(irq);
    80002788:	8526                	mv	a0,s1
    8000278a:	00003097          	auipc	ra,0x3
    8000278e:	442080e7          	jalr	1090(ra) # 80005bcc <plic_complete>
    return 1;
    80002792:	4505                	li	a0,1
    80002794:	bf7d                	j	80002752 <devintr+0x2a>
      uartintr();
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	1fe080e7          	jalr	510(ra) # 80000994 <uartintr>
    if(irq)
    8000279e:	b7ed                	j	80002788 <devintr+0x60>
      virtio_disk_intr();
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	8f2080e7          	jalr	-1806(ra) # 80006092 <virtio_disk_intr>
    if(irq)
    800027a8:	b7c5                	j	80002788 <devintr+0x60>
    if(cpuid() == 0){
    800027aa:	fffff097          	auipc	ra,0xfffff
    800027ae:	1c0080e7          	jalr	448(ra) # 8000196a <cpuid>
    800027b2:	c901                	beqz	a0,800027c2 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027b4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027b8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027ba:	14479073          	csrw	sip,a5
    return 2;
    800027be:	4509                	li	a0,2
    800027c0:	bf49                	j	80002752 <devintr+0x2a>
      clockintr();
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	f20080e7          	jalr	-224(ra) # 800026e2 <clockintr>
    800027ca:	b7ed                	j	800027b4 <devintr+0x8c>
}
    800027cc:	8082                	ret

00000000800027ce <usertrap>:
{
    800027ce:	1101                	addi	sp,sp,-32
    800027d0:	ec06                	sd	ra,24(sp)
    800027d2:	e822                	sd	s0,16(sp)
    800027d4:	e426                	sd	s1,8(sp)
    800027d6:	e04a                	sd	s2,0(sp)
    800027d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027da:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027de:	1007f793          	andi	a5,a5,256
    800027e2:	e3b1                	bnez	a5,80002826 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027e4:	00003797          	auipc	a5,0x3
    800027e8:	2bc78793          	addi	a5,a5,700 # 80005aa0 <kernelvec>
    800027ec:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027f0:	fffff097          	auipc	ra,0xfffff
    800027f4:	1a6080e7          	jalr	422(ra) # 80001996 <myproc>
    800027f8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027fa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027fc:	14102773          	csrr	a4,sepc
    80002800:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002802:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002806:	47a1                	li	a5,8
    80002808:	02f70763          	beq	a4,a5,80002836 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	f1c080e7          	jalr	-228(ra) # 80002728 <devintr>
    80002814:	892a                	mv	s2,a0
    80002816:	c151                	beqz	a0,8000289a <usertrap+0xcc>
  if(killed(p))
    80002818:	8526                	mv	a0,s1
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	acc080e7          	jalr	-1332(ra) # 800022e6 <killed>
    80002822:	c929                	beqz	a0,80002874 <usertrap+0xa6>
    80002824:	a099                	j	8000286a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	b1a50513          	addi	a0,a0,-1254 # 80008340 <states.0+0x58>
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	d0e080e7          	jalr	-754(ra) # 8000053c <panic>
    if(killed(p))
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	ab0080e7          	jalr	-1360(ra) # 800022e6 <killed>
    8000283e:	e921                	bnez	a0,8000288e <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002840:	6cb8                	ld	a4,88(s1)
    80002842:	6f1c                	ld	a5,24(a4)
    80002844:	0791                	addi	a5,a5,4
    80002846:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002848:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000284c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002850:	10079073          	csrw	sstatus,a5
    syscall();
    80002854:	00000097          	auipc	ra,0x0
    80002858:	2d4080e7          	jalr	724(ra) # 80002b28 <syscall>
  if(killed(p))
    8000285c:	8526                	mv	a0,s1
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	a88080e7          	jalr	-1400(ra) # 800022e6 <killed>
    80002866:	c911                	beqz	a0,8000287a <usertrap+0xac>
    80002868:	4901                	li	s2,0
    exit(-1);
    8000286a:	557d                	li	a0,-1
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	906080e7          	jalr	-1786(ra) # 80002172 <exit>
  if(which_dev == 2)
    80002874:	4789                	li	a5,2
    80002876:	04f90f63          	beq	s2,a5,800028d4 <usertrap+0x106>
  usertrapret();
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	dd2080e7          	jalr	-558(ra) # 8000264c <usertrapret>
}
    80002882:	60e2                	ld	ra,24(sp)
    80002884:	6442                	ld	s0,16(sp)
    80002886:	64a2                	ld	s1,8(sp)
    80002888:	6902                	ld	s2,0(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret
      exit(-1);
    8000288e:	557d                	li	a0,-1
    80002890:	00000097          	auipc	ra,0x0
    80002894:	8e2080e7          	jalr	-1822(ra) # 80002172 <exit>
    80002898:	b765                	j	80002840 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000289a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000289e:	5890                	lw	a2,48(s1)
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	ac050513          	addi	a0,a0,-1344 # 80008360 <states.0+0x78>
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	cde080e7          	jalr	-802(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028b0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028b4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028b8:	00006517          	auipc	a0,0x6
    800028bc:	ad850513          	addi	a0,a0,-1320 # 80008390 <states.0+0xa8>
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	cc6080e7          	jalr	-826(ra) # 80000586 <printf>
    setkilled(p);
    800028c8:	8526                	mv	a0,s1
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	9f0080e7          	jalr	-1552(ra) # 800022ba <setkilled>
    800028d2:	b769                	j	8000285c <usertrap+0x8e>
    yield();
    800028d4:	fffff097          	auipc	ra,0xfffff
    800028d8:	72e080e7          	jalr	1838(ra) # 80002002 <yield>
    800028dc:	bf79                	j	8000287a <usertrap+0xac>

00000000800028de <kerneltrap>:
{
    800028de:	7179                	addi	sp,sp,-48
    800028e0:	f406                	sd	ra,40(sp)
    800028e2:	f022                	sd	s0,32(sp)
    800028e4:	ec26                	sd	s1,24(sp)
    800028e6:	e84a                	sd	s2,16(sp)
    800028e8:	e44e                	sd	s3,8(sp)
    800028ea:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028ec:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028f0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028f8:	1004f793          	andi	a5,s1,256
    800028fc:	cb85                	beqz	a5,8000292c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028fe:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002902:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002904:	ef85                	bnez	a5,8000293c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	e22080e7          	jalr	-478(ra) # 80002728 <devintr>
    8000290e:	cd1d                	beqz	a0,8000294c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002910:	4789                	li	a5,2
    80002912:	06f50a63          	beq	a0,a5,80002986 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002916:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000291a:	10049073          	csrw	sstatus,s1
}
    8000291e:	70a2                	ld	ra,40(sp)
    80002920:	7402                	ld	s0,32(sp)
    80002922:	64e2                	ld	s1,24(sp)
    80002924:	6942                	ld	s2,16(sp)
    80002926:	69a2                	ld	s3,8(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000292c:	00006517          	auipc	a0,0x6
    80002930:	a8450513          	addi	a0,a0,-1404 # 800083b0 <states.0+0xc8>
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	c08080e7          	jalr	-1016(ra) # 8000053c <panic>
    panic("kerneltrap: interrupts enabled");
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	a9c50513          	addi	a0,a0,-1380 # 800083d8 <states.0+0xf0>
    80002944:	ffffe097          	auipc	ra,0xffffe
    80002948:	bf8080e7          	jalr	-1032(ra) # 8000053c <panic>
    printf("scause %p\n", scause);
    8000294c:	85ce                	mv	a1,s3
    8000294e:	00006517          	auipc	a0,0x6
    80002952:	aaa50513          	addi	a0,a0,-1366 # 800083f8 <states.0+0x110>
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	c30080e7          	jalr	-976(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000295e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002962:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002966:	00006517          	auipc	a0,0x6
    8000296a:	aa250513          	addi	a0,a0,-1374 # 80008408 <states.0+0x120>
    8000296e:	ffffe097          	auipc	ra,0xffffe
    80002972:	c18080e7          	jalr	-1000(ra) # 80000586 <printf>
    panic("kerneltrap");
    80002976:	00006517          	auipc	a0,0x6
    8000297a:	aaa50513          	addi	a0,a0,-1366 # 80008420 <states.0+0x138>
    8000297e:	ffffe097          	auipc	ra,0xffffe
    80002982:	bbe080e7          	jalr	-1090(ra) # 8000053c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002986:	fffff097          	auipc	ra,0xfffff
    8000298a:	010080e7          	jalr	16(ra) # 80001996 <myproc>
    8000298e:	d541                	beqz	a0,80002916 <kerneltrap+0x38>
    80002990:	fffff097          	auipc	ra,0xfffff
    80002994:	006080e7          	jalr	6(ra) # 80001996 <myproc>
    80002998:	4d18                	lw	a4,24(a0)
    8000299a:	4791                	li	a5,4
    8000299c:	f6f71de3          	bne	a4,a5,80002916 <kerneltrap+0x38>
    yield();
    800029a0:	fffff097          	auipc	ra,0xfffff
    800029a4:	662080e7          	jalr	1634(ra) # 80002002 <yield>
    800029a8:	b7bd                	j	80002916 <kerneltrap+0x38>

00000000800029aa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029aa:	1101                	addi	sp,sp,-32
    800029ac:	ec06                	sd	ra,24(sp)
    800029ae:	e822                	sd	s0,16(sp)
    800029b0:	e426                	sd	s1,8(sp)
    800029b2:	1000                	addi	s0,sp,32
    800029b4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029b6:	fffff097          	auipc	ra,0xfffff
    800029ba:	fe0080e7          	jalr	-32(ra) # 80001996 <myproc>
  switch (n) {
    800029be:	4795                	li	a5,5
    800029c0:	0497e163          	bltu	a5,s1,80002a02 <argraw+0x58>
    800029c4:	048a                	slli	s1,s1,0x2
    800029c6:	00006717          	auipc	a4,0x6
    800029ca:	a9270713          	addi	a4,a4,-1390 # 80008458 <states.0+0x170>
    800029ce:	94ba                	add	s1,s1,a4
    800029d0:	409c                	lw	a5,0(s1)
    800029d2:	97ba                	add	a5,a5,a4
    800029d4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029d6:	6d3c                	ld	a5,88(a0)
    800029d8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret
    return p->trapframe->a1;
    800029e4:	6d3c                	ld	a5,88(a0)
    800029e6:	7fa8                	ld	a0,120(a5)
    800029e8:	bfcd                	j	800029da <argraw+0x30>
    return p->trapframe->a2;
    800029ea:	6d3c                	ld	a5,88(a0)
    800029ec:	63c8                	ld	a0,128(a5)
    800029ee:	b7f5                	j	800029da <argraw+0x30>
    return p->trapframe->a3;
    800029f0:	6d3c                	ld	a5,88(a0)
    800029f2:	67c8                	ld	a0,136(a5)
    800029f4:	b7dd                	j	800029da <argraw+0x30>
    return p->trapframe->a4;
    800029f6:	6d3c                	ld	a5,88(a0)
    800029f8:	6bc8                	ld	a0,144(a5)
    800029fa:	b7c5                	j	800029da <argraw+0x30>
    return p->trapframe->a5;
    800029fc:	6d3c                	ld	a5,88(a0)
    800029fe:	6fc8                	ld	a0,152(a5)
    80002a00:	bfe9                	j	800029da <argraw+0x30>
  panic("argraw");
    80002a02:	00006517          	auipc	a0,0x6
    80002a06:	a2e50513          	addi	a0,a0,-1490 # 80008430 <states.0+0x148>
    80002a0a:	ffffe097          	auipc	ra,0xffffe
    80002a0e:	b32080e7          	jalr	-1230(ra) # 8000053c <panic>

0000000080002a12 <fetchaddr>:
{
    80002a12:	1101                	addi	sp,sp,-32
    80002a14:	ec06                	sd	ra,24(sp)
    80002a16:	e822                	sd	s0,16(sp)
    80002a18:	e426                	sd	s1,8(sp)
    80002a1a:	e04a                	sd	s2,0(sp)
    80002a1c:	1000                	addi	s0,sp,32
    80002a1e:	84aa                	mv	s1,a0
    80002a20:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a22:	fffff097          	auipc	ra,0xfffff
    80002a26:	f74080e7          	jalr	-140(ra) # 80001996 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a2a:	653c                	ld	a5,72(a0)
    80002a2c:	02f4f863          	bgeu	s1,a5,80002a5c <fetchaddr+0x4a>
    80002a30:	00848713          	addi	a4,s1,8
    80002a34:	02e7e663          	bltu	a5,a4,80002a60 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a38:	46a1                	li	a3,8
    80002a3a:	8626                	mv	a2,s1
    80002a3c:	85ca                	mv	a1,s2
    80002a3e:	6928                	ld	a0,80(a0)
    80002a40:	fffff097          	auipc	ra,0xfffff
    80002a44:	ca2080e7          	jalr	-862(ra) # 800016e2 <copyin>
    80002a48:	00a03533          	snez	a0,a0
    80002a4c:	40a00533          	neg	a0,a0
}
    80002a50:	60e2                	ld	ra,24(sp)
    80002a52:	6442                	ld	s0,16(sp)
    80002a54:	64a2                	ld	s1,8(sp)
    80002a56:	6902                	ld	s2,0(sp)
    80002a58:	6105                	addi	sp,sp,32
    80002a5a:	8082                	ret
    return -1;
    80002a5c:	557d                	li	a0,-1
    80002a5e:	bfcd                	j	80002a50 <fetchaddr+0x3e>
    80002a60:	557d                	li	a0,-1
    80002a62:	b7fd                	j	80002a50 <fetchaddr+0x3e>

0000000080002a64 <fetchstr>:
{
    80002a64:	7179                	addi	sp,sp,-48
    80002a66:	f406                	sd	ra,40(sp)
    80002a68:	f022                	sd	s0,32(sp)
    80002a6a:	ec26                	sd	s1,24(sp)
    80002a6c:	e84a                	sd	s2,16(sp)
    80002a6e:	e44e                	sd	s3,8(sp)
    80002a70:	1800                	addi	s0,sp,48
    80002a72:	892a                	mv	s2,a0
    80002a74:	84ae                	mv	s1,a1
    80002a76:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a78:	fffff097          	auipc	ra,0xfffff
    80002a7c:	f1e080e7          	jalr	-226(ra) # 80001996 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002a80:	86ce                	mv	a3,s3
    80002a82:	864a                	mv	a2,s2
    80002a84:	85a6                	mv	a1,s1
    80002a86:	6928                	ld	a0,80(a0)
    80002a88:	fffff097          	auipc	ra,0xfffff
    80002a8c:	ce8080e7          	jalr	-792(ra) # 80001770 <copyinstr>
    80002a90:	00054e63          	bltz	a0,80002aac <fetchstr+0x48>
  return strlen(buf);
    80002a94:	8526                	mv	a0,s1
    80002a96:	ffffe097          	auipc	ra,0xffffe
    80002a9a:	3b2080e7          	jalr	946(ra) # 80000e48 <strlen>
}
    80002a9e:	70a2                	ld	ra,40(sp)
    80002aa0:	7402                	ld	s0,32(sp)
    80002aa2:	64e2                	ld	s1,24(sp)
    80002aa4:	6942                	ld	s2,16(sp)
    80002aa6:	69a2                	ld	s3,8(sp)
    80002aa8:	6145                	addi	sp,sp,48
    80002aaa:	8082                	ret
    return -1;
    80002aac:	557d                	li	a0,-1
    80002aae:	bfc5                	j	80002a9e <fetchstr+0x3a>

0000000080002ab0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	1000                	addi	s0,sp,32
    80002aba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	eee080e7          	jalr	-274(ra) # 800029aa <argraw>
    80002ac4:	c088                	sw	a0,0(s1)
}
    80002ac6:	60e2                	ld	ra,24(sp)
    80002ac8:	6442                	ld	s0,16(sp)
    80002aca:	64a2                	ld	s1,8(sp)
    80002acc:	6105                	addi	sp,sp,32
    80002ace:	8082                	ret

0000000080002ad0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002ad0:	1101                	addi	sp,sp,-32
    80002ad2:	ec06                	sd	ra,24(sp)
    80002ad4:	e822                	sd	s0,16(sp)
    80002ad6:	e426                	sd	s1,8(sp)
    80002ad8:	1000                	addi	s0,sp,32
    80002ada:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	ece080e7          	jalr	-306(ra) # 800029aa <argraw>
    80002ae4:	e088                	sd	a0,0(s1)
}
    80002ae6:	60e2                	ld	ra,24(sp)
    80002ae8:	6442                	ld	s0,16(sp)
    80002aea:	64a2                	ld	s1,8(sp)
    80002aec:	6105                	addi	sp,sp,32
    80002aee:	8082                	ret

0000000080002af0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002af0:	7179                	addi	sp,sp,-48
    80002af2:	f406                	sd	ra,40(sp)
    80002af4:	f022                	sd	s0,32(sp)
    80002af6:	ec26                	sd	s1,24(sp)
    80002af8:	e84a                	sd	s2,16(sp)
    80002afa:	1800                	addi	s0,sp,48
    80002afc:	84ae                	mv	s1,a1
    80002afe:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b00:	fd840593          	addi	a1,s0,-40
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	fcc080e7          	jalr	-52(ra) # 80002ad0 <argaddr>
  return fetchstr(addr, buf, max);
    80002b0c:	864a                	mv	a2,s2
    80002b0e:	85a6                	mv	a1,s1
    80002b10:	fd843503          	ld	a0,-40(s0)
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	f50080e7          	jalr	-176(ra) # 80002a64 <fetchstr>
}
    80002b1c:	70a2                	ld	ra,40(sp)
    80002b1e:	7402                	ld	s0,32(sp)
    80002b20:	64e2                	ld	s1,24(sp)
    80002b22:	6942                	ld	s2,16(sp)
    80002b24:	6145                	addi	sp,sp,48
    80002b26:	8082                	ret

0000000080002b28 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b34:	fffff097          	auipc	ra,0xfffff
    80002b38:	e62080e7          	jalr	-414(ra) # 80001996 <myproc>
    80002b3c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b3e:	05853903          	ld	s2,88(a0)
    80002b42:	0a893783          	ld	a5,168(s2)
    80002b46:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b4a:	37fd                	addiw	a5,a5,-1
    80002b4c:	4751                	li	a4,20
    80002b4e:	00f76f63          	bltu	a4,a5,80002b6c <syscall+0x44>
    80002b52:	00369713          	slli	a4,a3,0x3
    80002b56:	00006797          	auipc	a5,0x6
    80002b5a:	91a78793          	addi	a5,a5,-1766 # 80008470 <syscalls>
    80002b5e:	97ba                	add	a5,a5,a4
    80002b60:	639c                	ld	a5,0(a5)
    80002b62:	c789                	beqz	a5,80002b6c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b64:	9782                	jalr	a5
    80002b66:	06a93823          	sd	a0,112(s2)
    80002b6a:	a839                	j	80002b88 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b6c:	15848613          	addi	a2,s1,344
    80002b70:	588c                	lw	a1,48(s1)
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	8c650513          	addi	a0,a0,-1850 # 80008438 <states.0+0x150>
    80002b7a:	ffffe097          	auipc	ra,0xffffe
    80002b7e:	a0c080e7          	jalr	-1524(ra) # 80000586 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b82:	6cbc                	ld	a5,88(s1)
    80002b84:	577d                	li	a4,-1
    80002b86:	fbb8                	sd	a4,112(a5)
  }
}
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6902                	ld	s2,0(sp)
    80002b90:	6105                	addi	sp,sp,32
    80002b92:	8082                	ret

0000000080002b94 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b94:	1101                	addi	sp,sp,-32
    80002b96:	ec06                	sd	ra,24(sp)
    80002b98:	e822                	sd	s0,16(sp)
    80002b9a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002b9c:	fec40593          	addi	a1,s0,-20
    80002ba0:	4501                	li	a0,0
    80002ba2:	00000097          	auipc	ra,0x0
    80002ba6:	f0e080e7          	jalr	-242(ra) # 80002ab0 <argint>
  exit(n);
    80002baa:	fec42503          	lw	a0,-20(s0)
    80002bae:	fffff097          	auipc	ra,0xfffff
    80002bb2:	5c4080e7          	jalr	1476(ra) # 80002172 <exit>
  return 0;  // not reached
}
    80002bb6:	4501                	li	a0,0
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret

0000000080002bc0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e406                	sd	ra,8(sp)
    80002bc4:	e022                	sd	s0,0(sp)
    80002bc6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	dce080e7          	jalr	-562(ra) # 80001996 <myproc>
}
    80002bd0:	5908                	lw	a0,48(a0)
    80002bd2:	60a2                	ld	ra,8(sp)
    80002bd4:	6402                	ld	s0,0(sp)
    80002bd6:	0141                	addi	sp,sp,16
    80002bd8:	8082                	ret

0000000080002bda <sys_fork>:

uint64
sys_fork(void)
{
    80002bda:	1141                	addi	sp,sp,-16
    80002bdc:	e406                	sd	ra,8(sp)
    80002bde:	e022                	sd	s0,0(sp)
    80002be0:	0800                	addi	s0,sp,16
  return fork();
    80002be2:	fffff097          	auipc	ra,0xfffff
    80002be6:	16a080e7          	jalr	362(ra) # 80001d4c <fork>
}
    80002bea:	60a2                	ld	ra,8(sp)
    80002bec:	6402                	ld	s0,0(sp)
    80002bee:	0141                	addi	sp,sp,16
    80002bf0:	8082                	ret

0000000080002bf2 <sys_wait>:

uint64
sys_wait(void)
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002bfa:	fe840593          	addi	a1,s0,-24
    80002bfe:	4501                	li	a0,0
    80002c00:	00000097          	auipc	ra,0x0
    80002c04:	ed0080e7          	jalr	-304(ra) # 80002ad0 <argaddr>
  return wait(p);
    80002c08:	fe843503          	ld	a0,-24(s0)
    80002c0c:	fffff097          	auipc	ra,0xfffff
    80002c10:	70c080e7          	jalr	1804(ra) # 80002318 <wait>
}
    80002c14:	60e2                	ld	ra,24(sp)
    80002c16:	6442                	ld	s0,16(sp)
    80002c18:	6105                	addi	sp,sp,32
    80002c1a:	8082                	ret

0000000080002c1c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c1c:	7179                	addi	sp,sp,-48
    80002c1e:	f406                	sd	ra,40(sp)
    80002c20:	f022                	sd	s0,32(sp)
    80002c22:	ec26                	sd	s1,24(sp)
    80002c24:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002c26:	fdc40593          	addi	a1,s0,-36
    80002c2a:	4501                	li	a0,0
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	e84080e7          	jalr	-380(ra) # 80002ab0 <argint>
  addr = myproc()->sz;
    80002c34:	fffff097          	auipc	ra,0xfffff
    80002c38:	d62080e7          	jalr	-670(ra) # 80001996 <myproc>
    80002c3c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002c3e:	fdc42503          	lw	a0,-36(s0)
    80002c42:	fffff097          	auipc	ra,0xfffff
    80002c46:	0ae080e7          	jalr	174(ra) # 80001cf0 <growproc>
    80002c4a:	00054863          	bltz	a0,80002c5a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002c4e:	8526                	mv	a0,s1
    80002c50:	70a2                	ld	ra,40(sp)
    80002c52:	7402                	ld	s0,32(sp)
    80002c54:	64e2                	ld	s1,24(sp)
    80002c56:	6145                	addi	sp,sp,48
    80002c58:	8082                	ret
    return -1;
    80002c5a:	54fd                	li	s1,-1
    80002c5c:	bfcd                	j	80002c4e <sys_sbrk+0x32>

0000000080002c5e <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c5e:	7139                	addi	sp,sp,-64
    80002c60:	fc06                	sd	ra,56(sp)
    80002c62:	f822                	sd	s0,48(sp)
    80002c64:	f426                	sd	s1,40(sp)
    80002c66:	f04a                	sd	s2,32(sp)
    80002c68:	ec4e                	sd	s3,24(sp)
    80002c6a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002c6c:	fcc40593          	addi	a1,s0,-52
    80002c70:	4501                	li	a0,0
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	e3e080e7          	jalr	-450(ra) # 80002ab0 <argint>
  acquire(&tickslock);
    80002c7a:	00014517          	auipc	a0,0x14
    80002c7e:	d0650513          	addi	a0,a0,-762 # 80016980 <tickslock>
    80002c82:	ffffe097          	auipc	ra,0xffffe
    80002c86:	f50080e7          	jalr	-176(ra) # 80000bd2 <acquire>
  ticks0 = ticks;
    80002c8a:	00006917          	auipc	s2,0x6
    80002c8e:	c5692903          	lw	s2,-938(s2) # 800088e0 <ticks>
  while(ticks - ticks0 < n){
    80002c92:	fcc42783          	lw	a5,-52(s0)
    80002c96:	cf9d                	beqz	a5,80002cd4 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c98:	00014997          	auipc	s3,0x14
    80002c9c:	ce898993          	addi	s3,s3,-792 # 80016980 <tickslock>
    80002ca0:	00006497          	auipc	s1,0x6
    80002ca4:	c4048493          	addi	s1,s1,-960 # 800088e0 <ticks>
    if(killed(myproc())){
    80002ca8:	fffff097          	auipc	ra,0xfffff
    80002cac:	cee080e7          	jalr	-786(ra) # 80001996 <myproc>
    80002cb0:	fffff097          	auipc	ra,0xfffff
    80002cb4:	636080e7          	jalr	1590(ra) # 800022e6 <killed>
    80002cb8:	ed15                	bnez	a0,80002cf4 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002cba:	85ce                	mv	a1,s3
    80002cbc:	8526                	mv	a0,s1
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	380080e7          	jalr	896(ra) # 8000203e <sleep>
  while(ticks - ticks0 < n){
    80002cc6:	409c                	lw	a5,0(s1)
    80002cc8:	412787bb          	subw	a5,a5,s2
    80002ccc:	fcc42703          	lw	a4,-52(s0)
    80002cd0:	fce7ece3          	bltu	a5,a4,80002ca8 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002cd4:	00014517          	auipc	a0,0x14
    80002cd8:	cac50513          	addi	a0,a0,-852 # 80016980 <tickslock>
    80002cdc:	ffffe097          	auipc	ra,0xffffe
    80002ce0:	faa080e7          	jalr	-86(ra) # 80000c86 <release>
  return 0;
    80002ce4:	4501                	li	a0,0
}
    80002ce6:	70e2                	ld	ra,56(sp)
    80002ce8:	7442                	ld	s0,48(sp)
    80002cea:	74a2                	ld	s1,40(sp)
    80002cec:	7902                	ld	s2,32(sp)
    80002cee:	69e2                	ld	s3,24(sp)
    80002cf0:	6121                	addi	sp,sp,64
    80002cf2:	8082                	ret
      release(&tickslock);
    80002cf4:	00014517          	auipc	a0,0x14
    80002cf8:	c8c50513          	addi	a0,a0,-884 # 80016980 <tickslock>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	f8a080e7          	jalr	-118(ra) # 80000c86 <release>
      return -1;
    80002d04:	557d                	li	a0,-1
    80002d06:	b7c5                	j	80002ce6 <sys_sleep+0x88>

0000000080002d08 <sys_kill>:

uint64
sys_kill(void)
{
    80002d08:	1101                	addi	sp,sp,-32
    80002d0a:	ec06                	sd	ra,24(sp)
    80002d0c:	e822                	sd	s0,16(sp)
    80002d0e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d10:	fec40593          	addi	a1,s0,-20
    80002d14:	4501                	li	a0,0
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	d9a080e7          	jalr	-614(ra) # 80002ab0 <argint>
  return kill(pid);
    80002d1e:	fec42503          	lw	a0,-20(s0)
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	526080e7          	jalr	1318(ra) # 80002248 <kill>
}
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d3c:	00014517          	auipc	a0,0x14
    80002d40:	c4450513          	addi	a0,a0,-956 # 80016980 <tickslock>
    80002d44:	ffffe097          	auipc	ra,0xffffe
    80002d48:	e8e080e7          	jalr	-370(ra) # 80000bd2 <acquire>
  xticks = ticks;
    80002d4c:	00006497          	auipc	s1,0x6
    80002d50:	b944a483          	lw	s1,-1132(s1) # 800088e0 <ticks>
  release(&tickslock);
    80002d54:	00014517          	auipc	a0,0x14
    80002d58:	c2c50513          	addi	a0,a0,-980 # 80016980 <tickslock>
    80002d5c:	ffffe097          	auipc	ra,0xffffe
    80002d60:	f2a080e7          	jalr	-214(ra) # 80000c86 <release>
  return xticks;
}
    80002d64:	02049513          	slli	a0,s1,0x20
    80002d68:	9101                	srli	a0,a0,0x20
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d74:	7179                	addi	sp,sp,-48
    80002d76:	f406                	sd	ra,40(sp)
    80002d78:	f022                	sd	s0,32(sp)
    80002d7a:	ec26                	sd	s1,24(sp)
    80002d7c:	e84a                	sd	s2,16(sp)
    80002d7e:	e44e                	sd	s3,8(sp)
    80002d80:	e052                	sd	s4,0(sp)
    80002d82:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d84:	00005597          	auipc	a1,0x5
    80002d88:	79c58593          	addi	a1,a1,1948 # 80008520 <syscalls+0xb0>
    80002d8c:	00014517          	auipc	a0,0x14
    80002d90:	c0c50513          	addi	a0,a0,-1012 # 80016998 <bcache>
    80002d94:	ffffe097          	auipc	ra,0xffffe
    80002d98:	dae080e7          	jalr	-594(ra) # 80000b42 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d9c:	0001c797          	auipc	a5,0x1c
    80002da0:	bfc78793          	addi	a5,a5,-1028 # 8001e998 <bcache+0x8000>
    80002da4:	0001c717          	auipc	a4,0x1c
    80002da8:	e5c70713          	addi	a4,a4,-420 # 8001ec00 <bcache+0x8268>
    80002dac:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002db0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002db4:	00014497          	auipc	s1,0x14
    80002db8:	bfc48493          	addi	s1,s1,-1028 # 800169b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002dbc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002dbe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002dc0:	00005a17          	auipc	s4,0x5
    80002dc4:	768a0a13          	addi	s4,s4,1896 # 80008528 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002dc8:	2b893783          	ld	a5,696(s2)
    80002dcc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dce:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dd2:	85d2                	mv	a1,s4
    80002dd4:	01048513          	addi	a0,s1,16
    80002dd8:	00001097          	auipc	ra,0x1
    80002ddc:	496080e7          	jalr	1174(ra) # 8000426e <initsleeplock>
    bcache.head.next->prev = b;
    80002de0:	2b893783          	ld	a5,696(s2)
    80002de4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002de6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dea:	45848493          	addi	s1,s1,1112
    80002dee:	fd349de3          	bne	s1,s3,80002dc8 <binit+0x54>
  }
}
    80002df2:	70a2                	ld	ra,40(sp)
    80002df4:	7402                	ld	s0,32(sp)
    80002df6:	64e2                	ld	s1,24(sp)
    80002df8:	6942                	ld	s2,16(sp)
    80002dfa:	69a2                	ld	s3,8(sp)
    80002dfc:	6a02                	ld	s4,0(sp)
    80002dfe:	6145                	addi	sp,sp,48
    80002e00:	8082                	ret

0000000080002e02 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e02:	7179                	addi	sp,sp,-48
    80002e04:	f406                	sd	ra,40(sp)
    80002e06:	f022                	sd	s0,32(sp)
    80002e08:	ec26                	sd	s1,24(sp)
    80002e0a:	e84a                	sd	s2,16(sp)
    80002e0c:	e44e                	sd	s3,8(sp)
    80002e0e:	1800                	addi	s0,sp,48
    80002e10:	892a                	mv	s2,a0
    80002e12:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e14:	00014517          	auipc	a0,0x14
    80002e18:	b8450513          	addi	a0,a0,-1148 # 80016998 <bcache>
    80002e1c:	ffffe097          	auipc	ra,0xffffe
    80002e20:	db6080e7          	jalr	-586(ra) # 80000bd2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e24:	0001c497          	auipc	s1,0x1c
    80002e28:	e2c4b483          	ld	s1,-468(s1) # 8001ec50 <bcache+0x82b8>
    80002e2c:	0001c797          	auipc	a5,0x1c
    80002e30:	dd478793          	addi	a5,a5,-556 # 8001ec00 <bcache+0x8268>
    80002e34:	02f48f63          	beq	s1,a5,80002e72 <bread+0x70>
    80002e38:	873e                	mv	a4,a5
    80002e3a:	a021                	j	80002e42 <bread+0x40>
    80002e3c:	68a4                	ld	s1,80(s1)
    80002e3e:	02e48a63          	beq	s1,a4,80002e72 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e42:	449c                	lw	a5,8(s1)
    80002e44:	ff279ce3          	bne	a5,s2,80002e3c <bread+0x3a>
    80002e48:	44dc                	lw	a5,12(s1)
    80002e4a:	ff3799e3          	bne	a5,s3,80002e3c <bread+0x3a>
      b->refcnt++;
    80002e4e:	40bc                	lw	a5,64(s1)
    80002e50:	2785                	addiw	a5,a5,1
    80002e52:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e54:	00014517          	auipc	a0,0x14
    80002e58:	b4450513          	addi	a0,a0,-1212 # 80016998 <bcache>
    80002e5c:	ffffe097          	auipc	ra,0xffffe
    80002e60:	e2a080e7          	jalr	-470(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80002e64:	01048513          	addi	a0,s1,16
    80002e68:	00001097          	auipc	ra,0x1
    80002e6c:	440080e7          	jalr	1088(ra) # 800042a8 <acquiresleep>
      return b;
    80002e70:	a8b9                	j	80002ece <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e72:	0001c497          	auipc	s1,0x1c
    80002e76:	dd64b483          	ld	s1,-554(s1) # 8001ec48 <bcache+0x82b0>
    80002e7a:	0001c797          	auipc	a5,0x1c
    80002e7e:	d8678793          	addi	a5,a5,-634 # 8001ec00 <bcache+0x8268>
    80002e82:	00f48863          	beq	s1,a5,80002e92 <bread+0x90>
    80002e86:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e88:	40bc                	lw	a5,64(s1)
    80002e8a:	cf81                	beqz	a5,80002ea2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e8c:	64a4                	ld	s1,72(s1)
    80002e8e:	fee49de3          	bne	s1,a4,80002e88 <bread+0x86>
  panic("bget: no buffers");
    80002e92:	00005517          	auipc	a0,0x5
    80002e96:	69e50513          	addi	a0,a0,1694 # 80008530 <syscalls+0xc0>
    80002e9a:	ffffd097          	auipc	ra,0xffffd
    80002e9e:	6a2080e7          	jalr	1698(ra) # 8000053c <panic>
      b->dev = dev;
    80002ea2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002ea6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002eaa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002eae:	4785                	li	a5,1
    80002eb0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002eb2:	00014517          	auipc	a0,0x14
    80002eb6:	ae650513          	addi	a0,a0,-1306 # 80016998 <bcache>
    80002eba:	ffffe097          	auipc	ra,0xffffe
    80002ebe:	dcc080e7          	jalr	-564(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80002ec2:	01048513          	addi	a0,s1,16
    80002ec6:	00001097          	auipc	ra,0x1
    80002eca:	3e2080e7          	jalr	994(ra) # 800042a8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ece:	409c                	lw	a5,0(s1)
    80002ed0:	cb89                	beqz	a5,80002ee2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	70a2                	ld	ra,40(sp)
    80002ed6:	7402                	ld	s0,32(sp)
    80002ed8:	64e2                	ld	s1,24(sp)
    80002eda:	6942                	ld	s2,16(sp)
    80002edc:	69a2                	ld	s3,8(sp)
    80002ede:	6145                	addi	sp,sp,48
    80002ee0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ee2:	4581                	li	a1,0
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	00003097          	auipc	ra,0x3
    80002eea:	f7c080e7          	jalr	-132(ra) # 80005e62 <virtio_disk_rw>
    b->valid = 1;
    80002eee:	4785                	li	a5,1
    80002ef0:	c09c                	sw	a5,0(s1)
  return b;
    80002ef2:	b7c5                	j	80002ed2 <bread+0xd0>

0000000080002ef4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ef4:	1101                	addi	sp,sp,-32
    80002ef6:	ec06                	sd	ra,24(sp)
    80002ef8:	e822                	sd	s0,16(sp)
    80002efa:	e426                	sd	s1,8(sp)
    80002efc:	1000                	addi	s0,sp,32
    80002efe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f00:	0541                	addi	a0,a0,16
    80002f02:	00001097          	auipc	ra,0x1
    80002f06:	440080e7          	jalr	1088(ra) # 80004342 <holdingsleep>
    80002f0a:	cd01                	beqz	a0,80002f22 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f0c:	4585                	li	a1,1
    80002f0e:	8526                	mv	a0,s1
    80002f10:	00003097          	auipc	ra,0x3
    80002f14:	f52080e7          	jalr	-174(ra) # 80005e62 <virtio_disk_rw>
}
    80002f18:	60e2                	ld	ra,24(sp)
    80002f1a:	6442                	ld	s0,16(sp)
    80002f1c:	64a2                	ld	s1,8(sp)
    80002f1e:	6105                	addi	sp,sp,32
    80002f20:	8082                	ret
    panic("bwrite");
    80002f22:	00005517          	auipc	a0,0x5
    80002f26:	62650513          	addi	a0,a0,1574 # 80008548 <syscalls+0xd8>
    80002f2a:	ffffd097          	auipc	ra,0xffffd
    80002f2e:	612080e7          	jalr	1554(ra) # 8000053c <panic>

0000000080002f32 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	e04a                	sd	s2,0(sp)
    80002f3c:	1000                	addi	s0,sp,32
    80002f3e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f40:	01050913          	addi	s2,a0,16
    80002f44:	854a                	mv	a0,s2
    80002f46:	00001097          	auipc	ra,0x1
    80002f4a:	3fc080e7          	jalr	1020(ra) # 80004342 <holdingsleep>
    80002f4e:	c925                	beqz	a0,80002fbe <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f50:	854a                	mv	a0,s2
    80002f52:	00001097          	auipc	ra,0x1
    80002f56:	3ac080e7          	jalr	940(ra) # 800042fe <releasesleep>

  acquire(&bcache.lock);
    80002f5a:	00014517          	auipc	a0,0x14
    80002f5e:	a3e50513          	addi	a0,a0,-1474 # 80016998 <bcache>
    80002f62:	ffffe097          	auipc	ra,0xffffe
    80002f66:	c70080e7          	jalr	-912(ra) # 80000bd2 <acquire>
  b->refcnt--;
    80002f6a:	40bc                	lw	a5,64(s1)
    80002f6c:	37fd                	addiw	a5,a5,-1
    80002f6e:	0007871b          	sext.w	a4,a5
    80002f72:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f74:	e71d                	bnez	a4,80002fa2 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f76:	68b8                	ld	a4,80(s1)
    80002f78:	64bc                	ld	a5,72(s1)
    80002f7a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f7c:	68b8                	ld	a4,80(s1)
    80002f7e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f80:	0001c797          	auipc	a5,0x1c
    80002f84:	a1878793          	addi	a5,a5,-1512 # 8001e998 <bcache+0x8000>
    80002f88:	2b87b703          	ld	a4,696(a5)
    80002f8c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f8e:	0001c717          	auipc	a4,0x1c
    80002f92:	c7270713          	addi	a4,a4,-910 # 8001ec00 <bcache+0x8268>
    80002f96:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f98:	2b87b703          	ld	a4,696(a5)
    80002f9c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f9e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002fa2:	00014517          	auipc	a0,0x14
    80002fa6:	9f650513          	addi	a0,a0,-1546 # 80016998 <bcache>
    80002faa:	ffffe097          	auipc	ra,0xffffe
    80002fae:	cdc080e7          	jalr	-804(ra) # 80000c86 <release>
}
    80002fb2:	60e2                	ld	ra,24(sp)
    80002fb4:	6442                	ld	s0,16(sp)
    80002fb6:	64a2                	ld	s1,8(sp)
    80002fb8:	6902                	ld	s2,0(sp)
    80002fba:	6105                	addi	sp,sp,32
    80002fbc:	8082                	ret
    panic("brelse");
    80002fbe:	00005517          	auipc	a0,0x5
    80002fc2:	59250513          	addi	a0,a0,1426 # 80008550 <syscalls+0xe0>
    80002fc6:	ffffd097          	auipc	ra,0xffffd
    80002fca:	576080e7          	jalr	1398(ra) # 8000053c <panic>

0000000080002fce <bpin>:

void
bpin(struct buf *b) {
    80002fce:	1101                	addi	sp,sp,-32
    80002fd0:	ec06                	sd	ra,24(sp)
    80002fd2:	e822                	sd	s0,16(sp)
    80002fd4:	e426                	sd	s1,8(sp)
    80002fd6:	1000                	addi	s0,sp,32
    80002fd8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fda:	00014517          	auipc	a0,0x14
    80002fde:	9be50513          	addi	a0,a0,-1602 # 80016998 <bcache>
    80002fe2:	ffffe097          	auipc	ra,0xffffe
    80002fe6:	bf0080e7          	jalr	-1040(ra) # 80000bd2 <acquire>
  b->refcnt++;
    80002fea:	40bc                	lw	a5,64(s1)
    80002fec:	2785                	addiw	a5,a5,1
    80002fee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ff0:	00014517          	auipc	a0,0x14
    80002ff4:	9a850513          	addi	a0,a0,-1624 # 80016998 <bcache>
    80002ff8:	ffffe097          	auipc	ra,0xffffe
    80002ffc:	c8e080e7          	jalr	-882(ra) # 80000c86 <release>
}
    80003000:	60e2                	ld	ra,24(sp)
    80003002:	6442                	ld	s0,16(sp)
    80003004:	64a2                	ld	s1,8(sp)
    80003006:	6105                	addi	sp,sp,32
    80003008:	8082                	ret

000000008000300a <bunpin>:

void
bunpin(struct buf *b) {
    8000300a:	1101                	addi	sp,sp,-32
    8000300c:	ec06                	sd	ra,24(sp)
    8000300e:	e822                	sd	s0,16(sp)
    80003010:	e426                	sd	s1,8(sp)
    80003012:	1000                	addi	s0,sp,32
    80003014:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003016:	00014517          	auipc	a0,0x14
    8000301a:	98250513          	addi	a0,a0,-1662 # 80016998 <bcache>
    8000301e:	ffffe097          	auipc	ra,0xffffe
    80003022:	bb4080e7          	jalr	-1100(ra) # 80000bd2 <acquire>
  b->refcnt--;
    80003026:	40bc                	lw	a5,64(s1)
    80003028:	37fd                	addiw	a5,a5,-1
    8000302a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000302c:	00014517          	auipc	a0,0x14
    80003030:	96c50513          	addi	a0,a0,-1684 # 80016998 <bcache>
    80003034:	ffffe097          	auipc	ra,0xffffe
    80003038:	c52080e7          	jalr	-942(ra) # 80000c86 <release>
}
    8000303c:	60e2                	ld	ra,24(sp)
    8000303e:	6442                	ld	s0,16(sp)
    80003040:	64a2                	ld	s1,8(sp)
    80003042:	6105                	addi	sp,sp,32
    80003044:	8082                	ret

0000000080003046 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003046:	1101                	addi	sp,sp,-32
    80003048:	ec06                	sd	ra,24(sp)
    8000304a:	e822                	sd	s0,16(sp)
    8000304c:	e426                	sd	s1,8(sp)
    8000304e:	e04a                	sd	s2,0(sp)
    80003050:	1000                	addi	s0,sp,32
    80003052:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003054:	00d5d59b          	srliw	a1,a1,0xd
    80003058:	0001c797          	auipc	a5,0x1c
    8000305c:	01c7a783          	lw	a5,28(a5) # 8001f074 <sb+0x1c>
    80003060:	9dbd                	addw	a1,a1,a5
    80003062:	00000097          	auipc	ra,0x0
    80003066:	da0080e7          	jalr	-608(ra) # 80002e02 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000306a:	0074f713          	andi	a4,s1,7
    8000306e:	4785                	li	a5,1
    80003070:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003074:	14ce                	slli	s1,s1,0x33
    80003076:	90d9                	srli	s1,s1,0x36
    80003078:	00950733          	add	a4,a0,s1
    8000307c:	05874703          	lbu	a4,88(a4)
    80003080:	00e7f6b3          	and	a3,a5,a4
    80003084:	c69d                	beqz	a3,800030b2 <bfree+0x6c>
    80003086:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003088:	94aa                	add	s1,s1,a0
    8000308a:	fff7c793          	not	a5,a5
    8000308e:	8f7d                	and	a4,a4,a5
    80003090:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003094:	00001097          	auipc	ra,0x1
    80003098:	0f6080e7          	jalr	246(ra) # 8000418a <log_write>
  brelse(bp);
    8000309c:	854a                	mv	a0,s2
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	e94080e7          	jalr	-364(ra) # 80002f32 <brelse>
}
    800030a6:	60e2                	ld	ra,24(sp)
    800030a8:	6442                	ld	s0,16(sp)
    800030aa:	64a2                	ld	s1,8(sp)
    800030ac:	6902                	ld	s2,0(sp)
    800030ae:	6105                	addi	sp,sp,32
    800030b0:	8082                	ret
    panic("freeing free block");
    800030b2:	00005517          	auipc	a0,0x5
    800030b6:	4a650513          	addi	a0,a0,1190 # 80008558 <syscalls+0xe8>
    800030ba:	ffffd097          	auipc	ra,0xffffd
    800030be:	482080e7          	jalr	1154(ra) # 8000053c <panic>

00000000800030c2 <balloc>:
{
    800030c2:	711d                	addi	sp,sp,-96
    800030c4:	ec86                	sd	ra,88(sp)
    800030c6:	e8a2                	sd	s0,80(sp)
    800030c8:	e4a6                	sd	s1,72(sp)
    800030ca:	e0ca                	sd	s2,64(sp)
    800030cc:	fc4e                	sd	s3,56(sp)
    800030ce:	f852                	sd	s4,48(sp)
    800030d0:	f456                	sd	s5,40(sp)
    800030d2:	f05a                	sd	s6,32(sp)
    800030d4:	ec5e                	sd	s7,24(sp)
    800030d6:	e862                	sd	s8,16(sp)
    800030d8:	e466                	sd	s9,8(sp)
    800030da:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030dc:	0001c797          	auipc	a5,0x1c
    800030e0:	f807a783          	lw	a5,-128(a5) # 8001f05c <sb+0x4>
    800030e4:	cff5                	beqz	a5,800031e0 <balloc+0x11e>
    800030e6:	8baa                	mv	s7,a0
    800030e8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030ea:	0001cb17          	auipc	s6,0x1c
    800030ee:	f6eb0b13          	addi	s6,s6,-146 # 8001f058 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030f2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030f4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030f6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030f8:	6c89                	lui	s9,0x2
    800030fa:	a061                	j	80003182 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800030fc:	97ca                	add	a5,a5,s2
    800030fe:	8e55                	or	a2,a2,a3
    80003100:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003104:	854a                	mv	a0,s2
    80003106:	00001097          	auipc	ra,0x1
    8000310a:	084080e7          	jalr	132(ra) # 8000418a <log_write>
        brelse(bp);
    8000310e:	854a                	mv	a0,s2
    80003110:	00000097          	auipc	ra,0x0
    80003114:	e22080e7          	jalr	-478(ra) # 80002f32 <brelse>
  bp = bread(dev, bno);
    80003118:	85a6                	mv	a1,s1
    8000311a:	855e                	mv	a0,s7
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	ce6080e7          	jalr	-794(ra) # 80002e02 <bread>
    80003124:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003126:	40000613          	li	a2,1024
    8000312a:	4581                	li	a1,0
    8000312c:	05850513          	addi	a0,a0,88
    80003130:	ffffe097          	auipc	ra,0xffffe
    80003134:	b9e080e7          	jalr	-1122(ra) # 80000cce <memset>
  log_write(bp);
    80003138:	854a                	mv	a0,s2
    8000313a:	00001097          	auipc	ra,0x1
    8000313e:	050080e7          	jalr	80(ra) # 8000418a <log_write>
  brelse(bp);
    80003142:	854a                	mv	a0,s2
    80003144:	00000097          	auipc	ra,0x0
    80003148:	dee080e7          	jalr	-530(ra) # 80002f32 <brelse>
}
    8000314c:	8526                	mv	a0,s1
    8000314e:	60e6                	ld	ra,88(sp)
    80003150:	6446                	ld	s0,80(sp)
    80003152:	64a6                	ld	s1,72(sp)
    80003154:	6906                	ld	s2,64(sp)
    80003156:	79e2                	ld	s3,56(sp)
    80003158:	7a42                	ld	s4,48(sp)
    8000315a:	7aa2                	ld	s5,40(sp)
    8000315c:	7b02                	ld	s6,32(sp)
    8000315e:	6be2                	ld	s7,24(sp)
    80003160:	6c42                	ld	s8,16(sp)
    80003162:	6ca2                	ld	s9,8(sp)
    80003164:	6125                	addi	sp,sp,96
    80003166:	8082                	ret
    brelse(bp);
    80003168:	854a                	mv	a0,s2
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	dc8080e7          	jalr	-568(ra) # 80002f32 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003172:	015c87bb          	addw	a5,s9,s5
    80003176:	00078a9b          	sext.w	s5,a5
    8000317a:	004b2703          	lw	a4,4(s6)
    8000317e:	06eaf163          	bgeu	s5,a4,800031e0 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003182:	41fad79b          	sraiw	a5,s5,0x1f
    80003186:	0137d79b          	srliw	a5,a5,0x13
    8000318a:	015787bb          	addw	a5,a5,s5
    8000318e:	40d7d79b          	sraiw	a5,a5,0xd
    80003192:	01cb2583          	lw	a1,28(s6)
    80003196:	9dbd                	addw	a1,a1,a5
    80003198:	855e                	mv	a0,s7
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	c68080e7          	jalr	-920(ra) # 80002e02 <bread>
    800031a2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031a4:	004b2503          	lw	a0,4(s6)
    800031a8:	000a849b          	sext.w	s1,s5
    800031ac:	8762                	mv	a4,s8
    800031ae:	faa4fde3          	bgeu	s1,a0,80003168 <balloc+0xa6>
      m = 1 << (bi % 8);
    800031b2:	00777693          	andi	a3,a4,7
    800031b6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031ba:	41f7579b          	sraiw	a5,a4,0x1f
    800031be:	01d7d79b          	srliw	a5,a5,0x1d
    800031c2:	9fb9                	addw	a5,a5,a4
    800031c4:	4037d79b          	sraiw	a5,a5,0x3
    800031c8:	00f90633          	add	a2,s2,a5
    800031cc:	05864603          	lbu	a2,88(a2)
    800031d0:	00c6f5b3          	and	a1,a3,a2
    800031d4:	d585                	beqz	a1,800030fc <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d6:	2705                	addiw	a4,a4,1
    800031d8:	2485                	addiw	s1,s1,1
    800031da:	fd471ae3          	bne	a4,s4,800031ae <balloc+0xec>
    800031de:	b769                	j	80003168 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800031e0:	00005517          	auipc	a0,0x5
    800031e4:	39050513          	addi	a0,a0,912 # 80008570 <syscalls+0x100>
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	39e080e7          	jalr	926(ra) # 80000586 <printf>
  return 0;
    800031f0:	4481                	li	s1,0
    800031f2:	bfa9                	j	8000314c <balloc+0x8a>

00000000800031f4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800031f4:	7179                	addi	sp,sp,-48
    800031f6:	f406                	sd	ra,40(sp)
    800031f8:	f022                	sd	s0,32(sp)
    800031fa:	ec26                	sd	s1,24(sp)
    800031fc:	e84a                	sd	s2,16(sp)
    800031fe:	e44e                	sd	s3,8(sp)
    80003200:	e052                	sd	s4,0(sp)
    80003202:	1800                	addi	s0,sp,48
    80003204:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003206:	47ad                	li	a5,11
    80003208:	02b7e863          	bltu	a5,a1,80003238 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000320c:	02059793          	slli	a5,a1,0x20
    80003210:	01e7d593          	srli	a1,a5,0x1e
    80003214:	00b504b3          	add	s1,a0,a1
    80003218:	0504a903          	lw	s2,80(s1)
    8000321c:	06091e63          	bnez	s2,80003298 <bmap+0xa4>
      addr = balloc(ip->dev);
    80003220:	4108                	lw	a0,0(a0)
    80003222:	00000097          	auipc	ra,0x0
    80003226:	ea0080e7          	jalr	-352(ra) # 800030c2 <balloc>
    8000322a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000322e:	06090563          	beqz	s2,80003298 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003232:	0524a823          	sw	s2,80(s1)
    80003236:	a08d                	j	80003298 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003238:	ff45849b          	addiw	s1,a1,-12
    8000323c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003240:	0ff00793          	li	a5,255
    80003244:	08e7e563          	bltu	a5,a4,800032ce <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003248:	08052903          	lw	s2,128(a0)
    8000324c:	00091d63          	bnez	s2,80003266 <bmap+0x72>
      addr = balloc(ip->dev);
    80003250:	4108                	lw	a0,0(a0)
    80003252:	00000097          	auipc	ra,0x0
    80003256:	e70080e7          	jalr	-400(ra) # 800030c2 <balloc>
    8000325a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000325e:	02090d63          	beqz	s2,80003298 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003262:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003266:	85ca                	mv	a1,s2
    80003268:	0009a503          	lw	a0,0(s3)
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	b96080e7          	jalr	-1130(ra) # 80002e02 <bread>
    80003274:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003276:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000327a:	02049713          	slli	a4,s1,0x20
    8000327e:	01e75593          	srli	a1,a4,0x1e
    80003282:	00b784b3          	add	s1,a5,a1
    80003286:	0004a903          	lw	s2,0(s1)
    8000328a:	02090063          	beqz	s2,800032aa <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000328e:	8552                	mv	a0,s4
    80003290:	00000097          	auipc	ra,0x0
    80003294:	ca2080e7          	jalr	-862(ra) # 80002f32 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003298:	854a                	mv	a0,s2
    8000329a:	70a2                	ld	ra,40(sp)
    8000329c:	7402                	ld	s0,32(sp)
    8000329e:	64e2                	ld	s1,24(sp)
    800032a0:	6942                	ld	s2,16(sp)
    800032a2:	69a2                	ld	s3,8(sp)
    800032a4:	6a02                	ld	s4,0(sp)
    800032a6:	6145                	addi	sp,sp,48
    800032a8:	8082                	ret
      addr = balloc(ip->dev);
    800032aa:	0009a503          	lw	a0,0(s3)
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	e14080e7          	jalr	-492(ra) # 800030c2 <balloc>
    800032b6:	0005091b          	sext.w	s2,a0
      if(addr){
    800032ba:	fc090ae3          	beqz	s2,8000328e <bmap+0x9a>
        a[bn] = addr;
    800032be:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800032c2:	8552                	mv	a0,s4
    800032c4:	00001097          	auipc	ra,0x1
    800032c8:	ec6080e7          	jalr	-314(ra) # 8000418a <log_write>
    800032cc:	b7c9                	j	8000328e <bmap+0x9a>
  panic("bmap: out of range");
    800032ce:	00005517          	auipc	a0,0x5
    800032d2:	2ba50513          	addi	a0,a0,698 # 80008588 <syscalls+0x118>
    800032d6:	ffffd097          	auipc	ra,0xffffd
    800032da:	266080e7          	jalr	614(ra) # 8000053c <panic>

00000000800032de <iget>:
{
    800032de:	7179                	addi	sp,sp,-48
    800032e0:	f406                	sd	ra,40(sp)
    800032e2:	f022                	sd	s0,32(sp)
    800032e4:	ec26                	sd	s1,24(sp)
    800032e6:	e84a                	sd	s2,16(sp)
    800032e8:	e44e                	sd	s3,8(sp)
    800032ea:	e052                	sd	s4,0(sp)
    800032ec:	1800                	addi	s0,sp,48
    800032ee:	89aa                	mv	s3,a0
    800032f0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800032f2:	0001c517          	auipc	a0,0x1c
    800032f6:	d8650513          	addi	a0,a0,-634 # 8001f078 <itable>
    800032fa:	ffffe097          	auipc	ra,0xffffe
    800032fe:	8d8080e7          	jalr	-1832(ra) # 80000bd2 <acquire>
  empty = 0;
    80003302:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003304:	0001c497          	auipc	s1,0x1c
    80003308:	d8c48493          	addi	s1,s1,-628 # 8001f090 <itable+0x18>
    8000330c:	0001e697          	auipc	a3,0x1e
    80003310:	81468693          	addi	a3,a3,-2028 # 80020b20 <log>
    80003314:	a039                	j	80003322 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003316:	02090b63          	beqz	s2,8000334c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000331a:	08848493          	addi	s1,s1,136
    8000331e:	02d48a63          	beq	s1,a3,80003352 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003322:	449c                	lw	a5,8(s1)
    80003324:	fef059e3          	blez	a5,80003316 <iget+0x38>
    80003328:	4098                	lw	a4,0(s1)
    8000332a:	ff3716e3          	bne	a4,s3,80003316 <iget+0x38>
    8000332e:	40d8                	lw	a4,4(s1)
    80003330:	ff4713e3          	bne	a4,s4,80003316 <iget+0x38>
      ip->ref++;
    80003334:	2785                	addiw	a5,a5,1
    80003336:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003338:	0001c517          	auipc	a0,0x1c
    8000333c:	d4050513          	addi	a0,a0,-704 # 8001f078 <itable>
    80003340:	ffffe097          	auipc	ra,0xffffe
    80003344:	946080e7          	jalr	-1722(ra) # 80000c86 <release>
      return ip;
    80003348:	8926                	mv	s2,s1
    8000334a:	a03d                	j	80003378 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000334c:	f7f9                	bnez	a5,8000331a <iget+0x3c>
    8000334e:	8926                	mv	s2,s1
    80003350:	b7e9                	j	8000331a <iget+0x3c>
  if(empty == 0)
    80003352:	02090c63          	beqz	s2,8000338a <iget+0xac>
  ip->dev = dev;
    80003356:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000335a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000335e:	4785                	li	a5,1
    80003360:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003364:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003368:	0001c517          	auipc	a0,0x1c
    8000336c:	d1050513          	addi	a0,a0,-752 # 8001f078 <itable>
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	916080e7          	jalr	-1770(ra) # 80000c86 <release>
}
    80003378:	854a                	mv	a0,s2
    8000337a:	70a2                	ld	ra,40(sp)
    8000337c:	7402                	ld	s0,32(sp)
    8000337e:	64e2                	ld	s1,24(sp)
    80003380:	6942                	ld	s2,16(sp)
    80003382:	69a2                	ld	s3,8(sp)
    80003384:	6a02                	ld	s4,0(sp)
    80003386:	6145                	addi	sp,sp,48
    80003388:	8082                	ret
    panic("iget: no inodes");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	21650513          	addi	a0,a0,534 # 800085a0 <syscalls+0x130>
    80003392:	ffffd097          	auipc	ra,0xffffd
    80003396:	1aa080e7          	jalr	426(ra) # 8000053c <panic>

000000008000339a <fsinit>:
fsinit(int dev) {
    8000339a:	7179                	addi	sp,sp,-48
    8000339c:	f406                	sd	ra,40(sp)
    8000339e:	f022                	sd	s0,32(sp)
    800033a0:	ec26                	sd	s1,24(sp)
    800033a2:	e84a                	sd	s2,16(sp)
    800033a4:	e44e                	sd	s3,8(sp)
    800033a6:	1800                	addi	s0,sp,48
    800033a8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800033aa:	4585                	li	a1,1
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	a56080e7          	jalr	-1450(ra) # 80002e02 <bread>
    800033b4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800033b6:	0001c997          	auipc	s3,0x1c
    800033ba:	ca298993          	addi	s3,s3,-862 # 8001f058 <sb>
    800033be:	02000613          	li	a2,32
    800033c2:	05850593          	addi	a1,a0,88
    800033c6:	854e                	mv	a0,s3
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	962080e7          	jalr	-1694(ra) # 80000d2a <memmove>
  brelse(bp);
    800033d0:	8526                	mv	a0,s1
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	b60080e7          	jalr	-1184(ra) # 80002f32 <brelse>
  if(sb.magic != FSMAGIC)
    800033da:	0009a703          	lw	a4,0(s3)
    800033de:	102037b7          	lui	a5,0x10203
    800033e2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033e6:	02f71263          	bne	a4,a5,8000340a <fsinit+0x70>
  initlog(dev, &sb);
    800033ea:	0001c597          	auipc	a1,0x1c
    800033ee:	c6e58593          	addi	a1,a1,-914 # 8001f058 <sb>
    800033f2:	854a                	mv	a0,s2
    800033f4:	00001097          	auipc	ra,0x1
    800033f8:	b2c080e7          	jalr	-1236(ra) # 80003f20 <initlog>
}
    800033fc:	70a2                	ld	ra,40(sp)
    800033fe:	7402                	ld	s0,32(sp)
    80003400:	64e2                	ld	s1,24(sp)
    80003402:	6942                	ld	s2,16(sp)
    80003404:	69a2                	ld	s3,8(sp)
    80003406:	6145                	addi	sp,sp,48
    80003408:	8082                	ret
    panic("invalid file system");
    8000340a:	00005517          	auipc	a0,0x5
    8000340e:	1a650513          	addi	a0,a0,422 # 800085b0 <syscalls+0x140>
    80003412:	ffffd097          	auipc	ra,0xffffd
    80003416:	12a080e7          	jalr	298(ra) # 8000053c <panic>

000000008000341a <iinit>:
{
    8000341a:	7179                	addi	sp,sp,-48
    8000341c:	f406                	sd	ra,40(sp)
    8000341e:	f022                	sd	s0,32(sp)
    80003420:	ec26                	sd	s1,24(sp)
    80003422:	e84a                	sd	s2,16(sp)
    80003424:	e44e                	sd	s3,8(sp)
    80003426:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003428:	00005597          	auipc	a1,0x5
    8000342c:	1a058593          	addi	a1,a1,416 # 800085c8 <syscalls+0x158>
    80003430:	0001c517          	auipc	a0,0x1c
    80003434:	c4850513          	addi	a0,a0,-952 # 8001f078 <itable>
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	70a080e7          	jalr	1802(ra) # 80000b42 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003440:	0001c497          	auipc	s1,0x1c
    80003444:	c6048493          	addi	s1,s1,-928 # 8001f0a0 <itable+0x28>
    80003448:	0001d997          	auipc	s3,0x1d
    8000344c:	6e898993          	addi	s3,s3,1768 # 80020b30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003450:	00005917          	auipc	s2,0x5
    80003454:	18090913          	addi	s2,s2,384 # 800085d0 <syscalls+0x160>
    80003458:	85ca                	mv	a1,s2
    8000345a:	8526                	mv	a0,s1
    8000345c:	00001097          	auipc	ra,0x1
    80003460:	e12080e7          	jalr	-494(ra) # 8000426e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003464:	08848493          	addi	s1,s1,136
    80003468:	ff3498e3          	bne	s1,s3,80003458 <iinit+0x3e>
}
    8000346c:	70a2                	ld	ra,40(sp)
    8000346e:	7402                	ld	s0,32(sp)
    80003470:	64e2                	ld	s1,24(sp)
    80003472:	6942                	ld	s2,16(sp)
    80003474:	69a2                	ld	s3,8(sp)
    80003476:	6145                	addi	sp,sp,48
    80003478:	8082                	ret

000000008000347a <ialloc>:
{
    8000347a:	7139                	addi	sp,sp,-64
    8000347c:	fc06                	sd	ra,56(sp)
    8000347e:	f822                	sd	s0,48(sp)
    80003480:	f426                	sd	s1,40(sp)
    80003482:	f04a                	sd	s2,32(sp)
    80003484:	ec4e                	sd	s3,24(sp)
    80003486:	e852                	sd	s4,16(sp)
    80003488:	e456                	sd	s5,8(sp)
    8000348a:	e05a                	sd	s6,0(sp)
    8000348c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000348e:	0001c717          	auipc	a4,0x1c
    80003492:	bd672703          	lw	a4,-1066(a4) # 8001f064 <sb+0xc>
    80003496:	4785                	li	a5,1
    80003498:	04e7f863          	bgeu	a5,a4,800034e8 <ialloc+0x6e>
    8000349c:	8aaa                	mv	s5,a0
    8000349e:	8b2e                	mv	s6,a1
    800034a0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800034a2:	0001ca17          	auipc	s4,0x1c
    800034a6:	bb6a0a13          	addi	s4,s4,-1098 # 8001f058 <sb>
    800034aa:	00495593          	srli	a1,s2,0x4
    800034ae:	018a2783          	lw	a5,24(s4)
    800034b2:	9dbd                	addw	a1,a1,a5
    800034b4:	8556                	mv	a0,s5
    800034b6:	00000097          	auipc	ra,0x0
    800034ba:	94c080e7          	jalr	-1716(ra) # 80002e02 <bread>
    800034be:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034c0:	05850993          	addi	s3,a0,88
    800034c4:	00f97793          	andi	a5,s2,15
    800034c8:	079a                	slli	a5,a5,0x6
    800034ca:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034cc:	00099783          	lh	a5,0(s3)
    800034d0:	cf9d                	beqz	a5,8000350e <ialloc+0x94>
    brelse(bp);
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	a60080e7          	jalr	-1440(ra) # 80002f32 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034da:	0905                	addi	s2,s2,1
    800034dc:	00ca2703          	lw	a4,12(s4)
    800034e0:	0009079b          	sext.w	a5,s2
    800034e4:	fce7e3e3          	bltu	a5,a4,800034aa <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800034e8:	00005517          	auipc	a0,0x5
    800034ec:	0f050513          	addi	a0,a0,240 # 800085d8 <syscalls+0x168>
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	096080e7          	jalr	150(ra) # 80000586 <printf>
  return 0;
    800034f8:	4501                	li	a0,0
}
    800034fa:	70e2                	ld	ra,56(sp)
    800034fc:	7442                	ld	s0,48(sp)
    800034fe:	74a2                	ld	s1,40(sp)
    80003500:	7902                	ld	s2,32(sp)
    80003502:	69e2                	ld	s3,24(sp)
    80003504:	6a42                	ld	s4,16(sp)
    80003506:	6aa2                	ld	s5,8(sp)
    80003508:	6b02                	ld	s6,0(sp)
    8000350a:	6121                	addi	sp,sp,64
    8000350c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000350e:	04000613          	li	a2,64
    80003512:	4581                	li	a1,0
    80003514:	854e                	mv	a0,s3
    80003516:	ffffd097          	auipc	ra,0xffffd
    8000351a:	7b8080e7          	jalr	1976(ra) # 80000cce <memset>
      dip->type = type;
    8000351e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003522:	8526                	mv	a0,s1
    80003524:	00001097          	auipc	ra,0x1
    80003528:	c66080e7          	jalr	-922(ra) # 8000418a <log_write>
      brelse(bp);
    8000352c:	8526                	mv	a0,s1
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	a04080e7          	jalr	-1532(ra) # 80002f32 <brelse>
      return iget(dev, inum);
    80003536:	0009059b          	sext.w	a1,s2
    8000353a:	8556                	mv	a0,s5
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	da2080e7          	jalr	-606(ra) # 800032de <iget>
    80003544:	bf5d                	j	800034fa <ialloc+0x80>

0000000080003546 <iupdate>:
{
    80003546:	1101                	addi	sp,sp,-32
    80003548:	ec06                	sd	ra,24(sp)
    8000354a:	e822                	sd	s0,16(sp)
    8000354c:	e426                	sd	s1,8(sp)
    8000354e:	e04a                	sd	s2,0(sp)
    80003550:	1000                	addi	s0,sp,32
    80003552:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003554:	415c                	lw	a5,4(a0)
    80003556:	0047d79b          	srliw	a5,a5,0x4
    8000355a:	0001c597          	auipc	a1,0x1c
    8000355e:	b165a583          	lw	a1,-1258(a1) # 8001f070 <sb+0x18>
    80003562:	9dbd                	addw	a1,a1,a5
    80003564:	4108                	lw	a0,0(a0)
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	89c080e7          	jalr	-1892(ra) # 80002e02 <bread>
    8000356e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003570:	05850793          	addi	a5,a0,88
    80003574:	40d8                	lw	a4,4(s1)
    80003576:	8b3d                	andi	a4,a4,15
    80003578:	071a                	slli	a4,a4,0x6
    8000357a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000357c:	04449703          	lh	a4,68(s1)
    80003580:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003584:	04649703          	lh	a4,70(s1)
    80003588:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000358c:	04849703          	lh	a4,72(s1)
    80003590:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003594:	04a49703          	lh	a4,74(s1)
    80003598:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000359c:	44f8                	lw	a4,76(s1)
    8000359e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800035a0:	03400613          	li	a2,52
    800035a4:	05048593          	addi	a1,s1,80
    800035a8:	00c78513          	addi	a0,a5,12
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	77e080e7          	jalr	1918(ra) # 80000d2a <memmove>
  log_write(bp);
    800035b4:	854a                	mv	a0,s2
    800035b6:	00001097          	auipc	ra,0x1
    800035ba:	bd4080e7          	jalr	-1068(ra) # 8000418a <log_write>
  brelse(bp);
    800035be:	854a                	mv	a0,s2
    800035c0:	00000097          	auipc	ra,0x0
    800035c4:	972080e7          	jalr	-1678(ra) # 80002f32 <brelse>
}
    800035c8:	60e2                	ld	ra,24(sp)
    800035ca:	6442                	ld	s0,16(sp)
    800035cc:	64a2                	ld	s1,8(sp)
    800035ce:	6902                	ld	s2,0(sp)
    800035d0:	6105                	addi	sp,sp,32
    800035d2:	8082                	ret

00000000800035d4 <idup>:
{
    800035d4:	1101                	addi	sp,sp,-32
    800035d6:	ec06                	sd	ra,24(sp)
    800035d8:	e822                	sd	s0,16(sp)
    800035da:	e426                	sd	s1,8(sp)
    800035dc:	1000                	addi	s0,sp,32
    800035de:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035e0:	0001c517          	auipc	a0,0x1c
    800035e4:	a9850513          	addi	a0,a0,-1384 # 8001f078 <itable>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	5ea080e7          	jalr	1514(ra) # 80000bd2 <acquire>
  ip->ref++;
    800035f0:	449c                	lw	a5,8(s1)
    800035f2:	2785                	addiw	a5,a5,1
    800035f4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035f6:	0001c517          	auipc	a0,0x1c
    800035fa:	a8250513          	addi	a0,a0,-1406 # 8001f078 <itable>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	688080e7          	jalr	1672(ra) # 80000c86 <release>
}
    80003606:	8526                	mv	a0,s1
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <ilock>:
{
    80003612:	1101                	addi	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	e426                	sd	s1,8(sp)
    8000361a:	e04a                	sd	s2,0(sp)
    8000361c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000361e:	c115                	beqz	a0,80003642 <ilock+0x30>
    80003620:	84aa                	mv	s1,a0
    80003622:	451c                	lw	a5,8(a0)
    80003624:	00f05f63          	blez	a5,80003642 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003628:	0541                	addi	a0,a0,16
    8000362a:	00001097          	auipc	ra,0x1
    8000362e:	c7e080e7          	jalr	-898(ra) # 800042a8 <acquiresleep>
  if(ip->valid == 0){
    80003632:	40bc                	lw	a5,64(s1)
    80003634:	cf99                	beqz	a5,80003652 <ilock+0x40>
}
    80003636:	60e2                	ld	ra,24(sp)
    80003638:	6442                	ld	s0,16(sp)
    8000363a:	64a2                	ld	s1,8(sp)
    8000363c:	6902                	ld	s2,0(sp)
    8000363e:	6105                	addi	sp,sp,32
    80003640:	8082                	ret
    panic("ilock");
    80003642:	00005517          	auipc	a0,0x5
    80003646:	fae50513          	addi	a0,a0,-82 # 800085f0 <syscalls+0x180>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	ef2080e7          	jalr	-270(ra) # 8000053c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003652:	40dc                	lw	a5,4(s1)
    80003654:	0047d79b          	srliw	a5,a5,0x4
    80003658:	0001c597          	auipc	a1,0x1c
    8000365c:	a185a583          	lw	a1,-1512(a1) # 8001f070 <sb+0x18>
    80003660:	9dbd                	addw	a1,a1,a5
    80003662:	4088                	lw	a0,0(s1)
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	79e080e7          	jalr	1950(ra) # 80002e02 <bread>
    8000366c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000366e:	05850593          	addi	a1,a0,88
    80003672:	40dc                	lw	a5,4(s1)
    80003674:	8bbd                	andi	a5,a5,15
    80003676:	079a                	slli	a5,a5,0x6
    80003678:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000367a:	00059783          	lh	a5,0(a1)
    8000367e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003682:	00259783          	lh	a5,2(a1)
    80003686:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000368a:	00459783          	lh	a5,4(a1)
    8000368e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003692:	00659783          	lh	a5,6(a1)
    80003696:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000369a:	459c                	lw	a5,8(a1)
    8000369c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000369e:	03400613          	li	a2,52
    800036a2:	05b1                	addi	a1,a1,12
    800036a4:	05048513          	addi	a0,s1,80
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	682080e7          	jalr	1666(ra) # 80000d2a <memmove>
    brelse(bp);
    800036b0:	854a                	mv	a0,s2
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	880080e7          	jalr	-1920(ra) # 80002f32 <brelse>
    ip->valid = 1;
    800036ba:	4785                	li	a5,1
    800036bc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036be:	04449783          	lh	a5,68(s1)
    800036c2:	fbb5                	bnez	a5,80003636 <ilock+0x24>
      panic("ilock: no type");
    800036c4:	00005517          	auipc	a0,0x5
    800036c8:	f3450513          	addi	a0,a0,-204 # 800085f8 <syscalls+0x188>
    800036cc:	ffffd097          	auipc	ra,0xffffd
    800036d0:	e70080e7          	jalr	-400(ra) # 8000053c <panic>

00000000800036d4 <iunlock>:
{
    800036d4:	1101                	addi	sp,sp,-32
    800036d6:	ec06                	sd	ra,24(sp)
    800036d8:	e822                	sd	s0,16(sp)
    800036da:	e426                	sd	s1,8(sp)
    800036dc:	e04a                	sd	s2,0(sp)
    800036de:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036e0:	c905                	beqz	a0,80003710 <iunlock+0x3c>
    800036e2:	84aa                	mv	s1,a0
    800036e4:	01050913          	addi	s2,a0,16
    800036e8:	854a                	mv	a0,s2
    800036ea:	00001097          	auipc	ra,0x1
    800036ee:	c58080e7          	jalr	-936(ra) # 80004342 <holdingsleep>
    800036f2:	cd19                	beqz	a0,80003710 <iunlock+0x3c>
    800036f4:	449c                	lw	a5,8(s1)
    800036f6:	00f05d63          	blez	a5,80003710 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036fa:	854a                	mv	a0,s2
    800036fc:	00001097          	auipc	ra,0x1
    80003700:	c02080e7          	jalr	-1022(ra) # 800042fe <releasesleep>
}
    80003704:	60e2                	ld	ra,24(sp)
    80003706:	6442                	ld	s0,16(sp)
    80003708:	64a2                	ld	s1,8(sp)
    8000370a:	6902                	ld	s2,0(sp)
    8000370c:	6105                	addi	sp,sp,32
    8000370e:	8082                	ret
    panic("iunlock");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	ef850513          	addi	a0,a0,-264 # 80008608 <syscalls+0x198>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	e24080e7          	jalr	-476(ra) # 8000053c <panic>

0000000080003720 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003720:	7179                	addi	sp,sp,-48
    80003722:	f406                	sd	ra,40(sp)
    80003724:	f022                	sd	s0,32(sp)
    80003726:	ec26                	sd	s1,24(sp)
    80003728:	e84a                	sd	s2,16(sp)
    8000372a:	e44e                	sd	s3,8(sp)
    8000372c:	e052                	sd	s4,0(sp)
    8000372e:	1800                	addi	s0,sp,48
    80003730:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003732:	05050493          	addi	s1,a0,80
    80003736:	08050913          	addi	s2,a0,128
    8000373a:	a021                	j	80003742 <itrunc+0x22>
    8000373c:	0491                	addi	s1,s1,4
    8000373e:	01248d63          	beq	s1,s2,80003758 <itrunc+0x38>
    if(ip->addrs[i]){
    80003742:	408c                	lw	a1,0(s1)
    80003744:	dde5                	beqz	a1,8000373c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003746:	0009a503          	lw	a0,0(s3)
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	8fc080e7          	jalr	-1796(ra) # 80003046 <bfree>
      ip->addrs[i] = 0;
    80003752:	0004a023          	sw	zero,0(s1)
    80003756:	b7dd                	j	8000373c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003758:	0809a583          	lw	a1,128(s3)
    8000375c:	e185                	bnez	a1,8000377c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000375e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003762:	854e                	mv	a0,s3
    80003764:	00000097          	auipc	ra,0x0
    80003768:	de2080e7          	jalr	-542(ra) # 80003546 <iupdate>
}
    8000376c:	70a2                	ld	ra,40(sp)
    8000376e:	7402                	ld	s0,32(sp)
    80003770:	64e2                	ld	s1,24(sp)
    80003772:	6942                	ld	s2,16(sp)
    80003774:	69a2                	ld	s3,8(sp)
    80003776:	6a02                	ld	s4,0(sp)
    80003778:	6145                	addi	sp,sp,48
    8000377a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000377c:	0009a503          	lw	a0,0(s3)
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	682080e7          	jalr	1666(ra) # 80002e02 <bread>
    80003788:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000378a:	05850493          	addi	s1,a0,88
    8000378e:	45850913          	addi	s2,a0,1112
    80003792:	a021                	j	8000379a <itrunc+0x7a>
    80003794:	0491                	addi	s1,s1,4
    80003796:	01248b63          	beq	s1,s2,800037ac <itrunc+0x8c>
      if(a[j])
    8000379a:	408c                	lw	a1,0(s1)
    8000379c:	dde5                	beqz	a1,80003794 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000379e:	0009a503          	lw	a0,0(s3)
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	8a4080e7          	jalr	-1884(ra) # 80003046 <bfree>
    800037aa:	b7ed                	j	80003794 <itrunc+0x74>
    brelse(bp);
    800037ac:	8552                	mv	a0,s4
    800037ae:	fffff097          	auipc	ra,0xfffff
    800037b2:	784080e7          	jalr	1924(ra) # 80002f32 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800037b6:	0809a583          	lw	a1,128(s3)
    800037ba:	0009a503          	lw	a0,0(s3)
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	888080e7          	jalr	-1912(ra) # 80003046 <bfree>
    ip->addrs[NDIRECT] = 0;
    800037c6:	0809a023          	sw	zero,128(s3)
    800037ca:	bf51                	j	8000375e <itrunc+0x3e>

00000000800037cc <iput>:
{
    800037cc:	1101                	addi	sp,sp,-32
    800037ce:	ec06                	sd	ra,24(sp)
    800037d0:	e822                	sd	s0,16(sp)
    800037d2:	e426                	sd	s1,8(sp)
    800037d4:	e04a                	sd	s2,0(sp)
    800037d6:	1000                	addi	s0,sp,32
    800037d8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037da:	0001c517          	auipc	a0,0x1c
    800037de:	89e50513          	addi	a0,a0,-1890 # 8001f078 <itable>
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	3f0080e7          	jalr	1008(ra) # 80000bd2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037ea:	4498                	lw	a4,8(s1)
    800037ec:	4785                	li	a5,1
    800037ee:	02f70363          	beq	a4,a5,80003814 <iput+0x48>
  ip->ref--;
    800037f2:	449c                	lw	a5,8(s1)
    800037f4:	37fd                	addiw	a5,a5,-1
    800037f6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037f8:	0001c517          	auipc	a0,0x1c
    800037fc:	88050513          	addi	a0,a0,-1920 # 8001f078 <itable>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	486080e7          	jalr	1158(ra) # 80000c86 <release>
}
    80003808:	60e2                	ld	ra,24(sp)
    8000380a:	6442                	ld	s0,16(sp)
    8000380c:	64a2                	ld	s1,8(sp)
    8000380e:	6902                	ld	s2,0(sp)
    80003810:	6105                	addi	sp,sp,32
    80003812:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003814:	40bc                	lw	a5,64(s1)
    80003816:	dff1                	beqz	a5,800037f2 <iput+0x26>
    80003818:	04a49783          	lh	a5,74(s1)
    8000381c:	fbf9                	bnez	a5,800037f2 <iput+0x26>
    acquiresleep(&ip->lock);
    8000381e:	01048913          	addi	s2,s1,16
    80003822:	854a                	mv	a0,s2
    80003824:	00001097          	auipc	ra,0x1
    80003828:	a84080e7          	jalr	-1404(ra) # 800042a8 <acquiresleep>
    release(&itable.lock);
    8000382c:	0001c517          	auipc	a0,0x1c
    80003830:	84c50513          	addi	a0,a0,-1972 # 8001f078 <itable>
    80003834:	ffffd097          	auipc	ra,0xffffd
    80003838:	452080e7          	jalr	1106(ra) # 80000c86 <release>
    itrunc(ip);
    8000383c:	8526                	mv	a0,s1
    8000383e:	00000097          	auipc	ra,0x0
    80003842:	ee2080e7          	jalr	-286(ra) # 80003720 <itrunc>
    ip->type = 0;
    80003846:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000384a:	8526                	mv	a0,s1
    8000384c:	00000097          	auipc	ra,0x0
    80003850:	cfa080e7          	jalr	-774(ra) # 80003546 <iupdate>
    ip->valid = 0;
    80003854:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003858:	854a                	mv	a0,s2
    8000385a:	00001097          	auipc	ra,0x1
    8000385e:	aa4080e7          	jalr	-1372(ra) # 800042fe <releasesleep>
    acquire(&itable.lock);
    80003862:	0001c517          	auipc	a0,0x1c
    80003866:	81650513          	addi	a0,a0,-2026 # 8001f078 <itable>
    8000386a:	ffffd097          	auipc	ra,0xffffd
    8000386e:	368080e7          	jalr	872(ra) # 80000bd2 <acquire>
    80003872:	b741                	j	800037f2 <iput+0x26>

0000000080003874 <iunlockput>:
{
    80003874:	1101                	addi	sp,sp,-32
    80003876:	ec06                	sd	ra,24(sp)
    80003878:	e822                	sd	s0,16(sp)
    8000387a:	e426                	sd	s1,8(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003880:	00000097          	auipc	ra,0x0
    80003884:	e54080e7          	jalr	-428(ra) # 800036d4 <iunlock>
  iput(ip);
    80003888:	8526                	mv	a0,s1
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	f42080e7          	jalr	-190(ra) # 800037cc <iput>
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6105                	addi	sp,sp,32
    8000389a:	8082                	ret

000000008000389c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000389c:	1141                	addi	sp,sp,-16
    8000389e:	e422                	sd	s0,8(sp)
    800038a0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800038a2:	411c                	lw	a5,0(a0)
    800038a4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800038a6:	415c                	lw	a5,4(a0)
    800038a8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800038aa:	04451783          	lh	a5,68(a0)
    800038ae:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800038b2:	04a51783          	lh	a5,74(a0)
    800038b6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800038ba:	04c56783          	lwu	a5,76(a0)
    800038be:	e99c                	sd	a5,16(a1)
}
    800038c0:	6422                	ld	s0,8(sp)
    800038c2:	0141                	addi	sp,sp,16
    800038c4:	8082                	ret

00000000800038c6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038c6:	457c                	lw	a5,76(a0)
    800038c8:	0ed7e963          	bltu	a5,a3,800039ba <readi+0xf4>
{
    800038cc:	7159                	addi	sp,sp,-112
    800038ce:	f486                	sd	ra,104(sp)
    800038d0:	f0a2                	sd	s0,96(sp)
    800038d2:	eca6                	sd	s1,88(sp)
    800038d4:	e8ca                	sd	s2,80(sp)
    800038d6:	e4ce                	sd	s3,72(sp)
    800038d8:	e0d2                	sd	s4,64(sp)
    800038da:	fc56                	sd	s5,56(sp)
    800038dc:	f85a                	sd	s6,48(sp)
    800038de:	f45e                	sd	s7,40(sp)
    800038e0:	f062                	sd	s8,32(sp)
    800038e2:	ec66                	sd	s9,24(sp)
    800038e4:	e86a                	sd	s10,16(sp)
    800038e6:	e46e                	sd	s11,8(sp)
    800038e8:	1880                	addi	s0,sp,112
    800038ea:	8b2a                	mv	s6,a0
    800038ec:	8bae                	mv	s7,a1
    800038ee:	8a32                	mv	s4,a2
    800038f0:	84b6                	mv	s1,a3
    800038f2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800038f4:	9f35                	addw	a4,a4,a3
    return 0;
    800038f6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038f8:	0ad76063          	bltu	a4,a3,80003998 <readi+0xd2>
  if(off + n > ip->size)
    800038fc:	00e7f463          	bgeu	a5,a4,80003904 <readi+0x3e>
    n = ip->size - off;
    80003900:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003904:	0a0a8963          	beqz	s5,800039b6 <readi+0xf0>
    80003908:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000390a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000390e:	5c7d                	li	s8,-1
    80003910:	a82d                	j	8000394a <readi+0x84>
    80003912:	020d1d93          	slli	s11,s10,0x20
    80003916:	020ddd93          	srli	s11,s11,0x20
    8000391a:	05890613          	addi	a2,s2,88
    8000391e:	86ee                	mv	a3,s11
    80003920:	963a                	add	a2,a2,a4
    80003922:	85d2                	mv	a1,s4
    80003924:	855e                	mv	a0,s7
    80003926:	fffff097          	auipc	ra,0xfffff
    8000392a:	b20080e7          	jalr	-1248(ra) # 80002446 <either_copyout>
    8000392e:	05850d63          	beq	a0,s8,80003988 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003932:	854a                	mv	a0,s2
    80003934:	fffff097          	auipc	ra,0xfffff
    80003938:	5fe080e7          	jalr	1534(ra) # 80002f32 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000393c:	013d09bb          	addw	s3,s10,s3
    80003940:	009d04bb          	addw	s1,s10,s1
    80003944:	9a6e                	add	s4,s4,s11
    80003946:	0559f763          	bgeu	s3,s5,80003994 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000394a:	00a4d59b          	srliw	a1,s1,0xa
    8000394e:	855a                	mv	a0,s6
    80003950:	00000097          	auipc	ra,0x0
    80003954:	8a4080e7          	jalr	-1884(ra) # 800031f4 <bmap>
    80003958:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000395c:	cd85                	beqz	a1,80003994 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000395e:	000b2503          	lw	a0,0(s6)
    80003962:	fffff097          	auipc	ra,0xfffff
    80003966:	4a0080e7          	jalr	1184(ra) # 80002e02 <bread>
    8000396a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000396c:	3ff4f713          	andi	a4,s1,1023
    80003970:	40ec87bb          	subw	a5,s9,a4
    80003974:	413a86bb          	subw	a3,s5,s3
    80003978:	8d3e                	mv	s10,a5
    8000397a:	2781                	sext.w	a5,a5
    8000397c:	0006861b          	sext.w	a2,a3
    80003980:	f8f679e3          	bgeu	a2,a5,80003912 <readi+0x4c>
    80003984:	8d36                	mv	s10,a3
    80003986:	b771                	j	80003912 <readi+0x4c>
      brelse(bp);
    80003988:	854a                	mv	a0,s2
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	5a8080e7          	jalr	1448(ra) # 80002f32 <brelse>
      tot = -1;
    80003992:	59fd                	li	s3,-1
  }
  return tot;
    80003994:	0009851b          	sext.w	a0,s3
}
    80003998:	70a6                	ld	ra,104(sp)
    8000399a:	7406                	ld	s0,96(sp)
    8000399c:	64e6                	ld	s1,88(sp)
    8000399e:	6946                	ld	s2,80(sp)
    800039a0:	69a6                	ld	s3,72(sp)
    800039a2:	6a06                	ld	s4,64(sp)
    800039a4:	7ae2                	ld	s5,56(sp)
    800039a6:	7b42                	ld	s6,48(sp)
    800039a8:	7ba2                	ld	s7,40(sp)
    800039aa:	7c02                	ld	s8,32(sp)
    800039ac:	6ce2                	ld	s9,24(sp)
    800039ae:	6d42                	ld	s10,16(sp)
    800039b0:	6da2                	ld	s11,8(sp)
    800039b2:	6165                	addi	sp,sp,112
    800039b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039b6:	89d6                	mv	s3,s5
    800039b8:	bff1                	j	80003994 <readi+0xce>
    return 0;
    800039ba:	4501                	li	a0,0
}
    800039bc:	8082                	ret

00000000800039be <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039be:	457c                	lw	a5,76(a0)
    800039c0:	10d7e863          	bltu	a5,a3,80003ad0 <writei+0x112>
{
    800039c4:	7159                	addi	sp,sp,-112
    800039c6:	f486                	sd	ra,104(sp)
    800039c8:	f0a2                	sd	s0,96(sp)
    800039ca:	eca6                	sd	s1,88(sp)
    800039cc:	e8ca                	sd	s2,80(sp)
    800039ce:	e4ce                	sd	s3,72(sp)
    800039d0:	e0d2                	sd	s4,64(sp)
    800039d2:	fc56                	sd	s5,56(sp)
    800039d4:	f85a                	sd	s6,48(sp)
    800039d6:	f45e                	sd	s7,40(sp)
    800039d8:	f062                	sd	s8,32(sp)
    800039da:	ec66                	sd	s9,24(sp)
    800039dc:	e86a                	sd	s10,16(sp)
    800039de:	e46e                	sd	s11,8(sp)
    800039e0:	1880                	addi	s0,sp,112
    800039e2:	8aaa                	mv	s5,a0
    800039e4:	8bae                	mv	s7,a1
    800039e6:	8a32                	mv	s4,a2
    800039e8:	8936                	mv	s2,a3
    800039ea:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039ec:	00e687bb          	addw	a5,a3,a4
    800039f0:	0ed7e263          	bltu	a5,a3,80003ad4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039f4:	00043737          	lui	a4,0x43
    800039f8:	0ef76063          	bltu	a4,a5,80003ad8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039fc:	0c0b0863          	beqz	s6,80003acc <writei+0x10e>
    80003a00:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a02:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003a06:	5c7d                	li	s8,-1
    80003a08:	a091                	j	80003a4c <writei+0x8e>
    80003a0a:	020d1d93          	slli	s11,s10,0x20
    80003a0e:	020ddd93          	srli	s11,s11,0x20
    80003a12:	05848513          	addi	a0,s1,88
    80003a16:	86ee                	mv	a3,s11
    80003a18:	8652                	mv	a2,s4
    80003a1a:	85de                	mv	a1,s7
    80003a1c:	953a                	add	a0,a0,a4
    80003a1e:	fffff097          	auipc	ra,0xfffff
    80003a22:	a7e080e7          	jalr	-1410(ra) # 8000249c <either_copyin>
    80003a26:	07850263          	beq	a0,s8,80003a8a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	75e080e7          	jalr	1886(ra) # 8000418a <log_write>
    brelse(bp);
    80003a34:	8526                	mv	a0,s1
    80003a36:	fffff097          	auipc	ra,0xfffff
    80003a3a:	4fc080e7          	jalr	1276(ra) # 80002f32 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a3e:	013d09bb          	addw	s3,s10,s3
    80003a42:	012d093b          	addw	s2,s10,s2
    80003a46:	9a6e                	add	s4,s4,s11
    80003a48:	0569f663          	bgeu	s3,s6,80003a94 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003a4c:	00a9559b          	srliw	a1,s2,0xa
    80003a50:	8556                	mv	a0,s5
    80003a52:	fffff097          	auipc	ra,0xfffff
    80003a56:	7a2080e7          	jalr	1954(ra) # 800031f4 <bmap>
    80003a5a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a5e:	c99d                	beqz	a1,80003a94 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003a60:	000aa503          	lw	a0,0(s5)
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	39e080e7          	jalr	926(ra) # 80002e02 <bread>
    80003a6c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a6e:	3ff97713          	andi	a4,s2,1023
    80003a72:	40ec87bb          	subw	a5,s9,a4
    80003a76:	413b06bb          	subw	a3,s6,s3
    80003a7a:	8d3e                	mv	s10,a5
    80003a7c:	2781                	sext.w	a5,a5
    80003a7e:	0006861b          	sext.w	a2,a3
    80003a82:	f8f674e3          	bgeu	a2,a5,80003a0a <writei+0x4c>
    80003a86:	8d36                	mv	s10,a3
    80003a88:	b749                	j	80003a0a <writei+0x4c>
      brelse(bp);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	4a6080e7          	jalr	1190(ra) # 80002f32 <brelse>
  }

  if(off > ip->size)
    80003a94:	04caa783          	lw	a5,76(s5)
    80003a98:	0127f463          	bgeu	a5,s2,80003aa0 <writei+0xe2>
    ip->size = off;
    80003a9c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003aa0:	8556                	mv	a0,s5
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	aa4080e7          	jalr	-1372(ra) # 80003546 <iupdate>

  return tot;
    80003aaa:	0009851b          	sext.w	a0,s3
}
    80003aae:	70a6                	ld	ra,104(sp)
    80003ab0:	7406                	ld	s0,96(sp)
    80003ab2:	64e6                	ld	s1,88(sp)
    80003ab4:	6946                	ld	s2,80(sp)
    80003ab6:	69a6                	ld	s3,72(sp)
    80003ab8:	6a06                	ld	s4,64(sp)
    80003aba:	7ae2                	ld	s5,56(sp)
    80003abc:	7b42                	ld	s6,48(sp)
    80003abe:	7ba2                	ld	s7,40(sp)
    80003ac0:	7c02                	ld	s8,32(sp)
    80003ac2:	6ce2                	ld	s9,24(sp)
    80003ac4:	6d42                	ld	s10,16(sp)
    80003ac6:	6da2                	ld	s11,8(sp)
    80003ac8:	6165                	addi	sp,sp,112
    80003aca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003acc:	89da                	mv	s3,s6
    80003ace:	bfc9                	j	80003aa0 <writei+0xe2>
    return -1;
    80003ad0:	557d                	li	a0,-1
}
    80003ad2:	8082                	ret
    return -1;
    80003ad4:	557d                	li	a0,-1
    80003ad6:	bfe1                	j	80003aae <writei+0xf0>
    return -1;
    80003ad8:	557d                	li	a0,-1
    80003ada:	bfd1                	j	80003aae <writei+0xf0>

0000000080003adc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003adc:	1141                	addi	sp,sp,-16
    80003ade:	e406                	sd	ra,8(sp)
    80003ae0:	e022                	sd	s0,0(sp)
    80003ae2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ae4:	4639                	li	a2,14
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	2b8080e7          	jalr	696(ra) # 80000d9e <strncmp>
}
    80003aee:	60a2                	ld	ra,8(sp)
    80003af0:	6402                	ld	s0,0(sp)
    80003af2:	0141                	addi	sp,sp,16
    80003af4:	8082                	ret

0000000080003af6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003af6:	7139                	addi	sp,sp,-64
    80003af8:	fc06                	sd	ra,56(sp)
    80003afa:	f822                	sd	s0,48(sp)
    80003afc:	f426                	sd	s1,40(sp)
    80003afe:	f04a                	sd	s2,32(sp)
    80003b00:	ec4e                	sd	s3,24(sp)
    80003b02:	e852                	sd	s4,16(sp)
    80003b04:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003b06:	04451703          	lh	a4,68(a0)
    80003b0a:	4785                	li	a5,1
    80003b0c:	00f71a63          	bne	a4,a5,80003b20 <dirlookup+0x2a>
    80003b10:	892a                	mv	s2,a0
    80003b12:	89ae                	mv	s3,a1
    80003b14:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b16:	457c                	lw	a5,76(a0)
    80003b18:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003b1a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b1c:	e79d                	bnez	a5,80003b4a <dirlookup+0x54>
    80003b1e:	a8a5                	j	80003b96 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003b20:	00005517          	auipc	a0,0x5
    80003b24:	af050513          	addi	a0,a0,-1296 # 80008610 <syscalls+0x1a0>
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	a14080e7          	jalr	-1516(ra) # 8000053c <panic>
      panic("dirlookup read");
    80003b30:	00005517          	auipc	a0,0x5
    80003b34:	af850513          	addi	a0,a0,-1288 # 80008628 <syscalls+0x1b8>
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	a04080e7          	jalr	-1532(ra) # 8000053c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b40:	24c1                	addiw	s1,s1,16
    80003b42:	04c92783          	lw	a5,76(s2)
    80003b46:	04f4f763          	bgeu	s1,a5,80003b94 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b4a:	4741                	li	a4,16
    80003b4c:	86a6                	mv	a3,s1
    80003b4e:	fc040613          	addi	a2,s0,-64
    80003b52:	4581                	li	a1,0
    80003b54:	854a                	mv	a0,s2
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	d70080e7          	jalr	-656(ra) # 800038c6 <readi>
    80003b5e:	47c1                	li	a5,16
    80003b60:	fcf518e3          	bne	a0,a5,80003b30 <dirlookup+0x3a>
    if(de.inum == 0)
    80003b64:	fc045783          	lhu	a5,-64(s0)
    80003b68:	dfe1                	beqz	a5,80003b40 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b6a:	fc240593          	addi	a1,s0,-62
    80003b6e:	854e                	mv	a0,s3
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	f6c080e7          	jalr	-148(ra) # 80003adc <namecmp>
    80003b78:	f561                	bnez	a0,80003b40 <dirlookup+0x4a>
      if(poff)
    80003b7a:	000a0463          	beqz	s4,80003b82 <dirlookup+0x8c>
        *poff = off;
    80003b7e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b82:	fc045583          	lhu	a1,-64(s0)
    80003b86:	00092503          	lw	a0,0(s2)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	754080e7          	jalr	1876(ra) # 800032de <iget>
    80003b92:	a011                	j	80003b96 <dirlookup+0xa0>
  return 0;
    80003b94:	4501                	li	a0,0
}
    80003b96:	70e2                	ld	ra,56(sp)
    80003b98:	7442                	ld	s0,48(sp)
    80003b9a:	74a2                	ld	s1,40(sp)
    80003b9c:	7902                	ld	s2,32(sp)
    80003b9e:	69e2                	ld	s3,24(sp)
    80003ba0:	6a42                	ld	s4,16(sp)
    80003ba2:	6121                	addi	sp,sp,64
    80003ba4:	8082                	ret

0000000080003ba6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ba6:	711d                	addi	sp,sp,-96
    80003ba8:	ec86                	sd	ra,88(sp)
    80003baa:	e8a2                	sd	s0,80(sp)
    80003bac:	e4a6                	sd	s1,72(sp)
    80003bae:	e0ca                	sd	s2,64(sp)
    80003bb0:	fc4e                	sd	s3,56(sp)
    80003bb2:	f852                	sd	s4,48(sp)
    80003bb4:	f456                	sd	s5,40(sp)
    80003bb6:	f05a                	sd	s6,32(sp)
    80003bb8:	ec5e                	sd	s7,24(sp)
    80003bba:	e862                	sd	s8,16(sp)
    80003bbc:	e466                	sd	s9,8(sp)
    80003bbe:	1080                	addi	s0,sp,96
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	8b2e                	mv	s6,a1
    80003bc4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003bc6:	00054703          	lbu	a4,0(a0)
    80003bca:	02f00793          	li	a5,47
    80003bce:	02f70263          	beq	a4,a5,80003bf2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bd2:	ffffe097          	auipc	ra,0xffffe
    80003bd6:	dc4080e7          	jalr	-572(ra) # 80001996 <myproc>
    80003bda:	15053503          	ld	a0,336(a0)
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	9f6080e7          	jalr	-1546(ra) # 800035d4 <idup>
    80003be6:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003be8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003bec:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bee:	4b85                	li	s7,1
    80003bf0:	a875                	j	80003cac <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003bf2:	4585                	li	a1,1
    80003bf4:	4505                	li	a0,1
    80003bf6:	fffff097          	auipc	ra,0xfffff
    80003bfa:	6e8080e7          	jalr	1768(ra) # 800032de <iget>
    80003bfe:	8a2a                	mv	s4,a0
    80003c00:	b7e5                	j	80003be8 <namex+0x42>
      iunlockput(ip);
    80003c02:	8552                	mv	a0,s4
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	c70080e7          	jalr	-912(ra) # 80003874 <iunlockput>
      return 0;
    80003c0c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003c0e:	8552                	mv	a0,s4
    80003c10:	60e6                	ld	ra,88(sp)
    80003c12:	6446                	ld	s0,80(sp)
    80003c14:	64a6                	ld	s1,72(sp)
    80003c16:	6906                	ld	s2,64(sp)
    80003c18:	79e2                	ld	s3,56(sp)
    80003c1a:	7a42                	ld	s4,48(sp)
    80003c1c:	7aa2                	ld	s5,40(sp)
    80003c1e:	7b02                	ld	s6,32(sp)
    80003c20:	6be2                	ld	s7,24(sp)
    80003c22:	6c42                	ld	s8,16(sp)
    80003c24:	6ca2                	ld	s9,8(sp)
    80003c26:	6125                	addi	sp,sp,96
    80003c28:	8082                	ret
      iunlock(ip);
    80003c2a:	8552                	mv	a0,s4
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	aa8080e7          	jalr	-1368(ra) # 800036d4 <iunlock>
      return ip;
    80003c34:	bfe9                	j	80003c0e <namex+0x68>
      iunlockput(ip);
    80003c36:	8552                	mv	a0,s4
    80003c38:	00000097          	auipc	ra,0x0
    80003c3c:	c3c080e7          	jalr	-964(ra) # 80003874 <iunlockput>
      return 0;
    80003c40:	8a4e                	mv	s4,s3
    80003c42:	b7f1                	j	80003c0e <namex+0x68>
  len = path - s;
    80003c44:	40998633          	sub	a2,s3,s1
    80003c48:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003c4c:	099c5863          	bge	s8,s9,80003cdc <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003c50:	4639                	li	a2,14
    80003c52:	85a6                	mv	a1,s1
    80003c54:	8556                	mv	a0,s5
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	0d4080e7          	jalr	212(ra) # 80000d2a <memmove>
    80003c5e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003c60:	0004c783          	lbu	a5,0(s1)
    80003c64:	01279763          	bne	a5,s2,80003c72 <namex+0xcc>
    path++;
    80003c68:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c6a:	0004c783          	lbu	a5,0(s1)
    80003c6e:	ff278de3          	beq	a5,s2,80003c68 <namex+0xc2>
    ilock(ip);
    80003c72:	8552                	mv	a0,s4
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	99e080e7          	jalr	-1634(ra) # 80003612 <ilock>
    if(ip->type != T_DIR){
    80003c7c:	044a1783          	lh	a5,68(s4)
    80003c80:	f97791e3          	bne	a5,s7,80003c02 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003c84:	000b0563          	beqz	s6,80003c8e <namex+0xe8>
    80003c88:	0004c783          	lbu	a5,0(s1)
    80003c8c:	dfd9                	beqz	a5,80003c2a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c8e:	4601                	li	a2,0
    80003c90:	85d6                	mv	a1,s5
    80003c92:	8552                	mv	a0,s4
    80003c94:	00000097          	auipc	ra,0x0
    80003c98:	e62080e7          	jalr	-414(ra) # 80003af6 <dirlookup>
    80003c9c:	89aa                	mv	s3,a0
    80003c9e:	dd41                	beqz	a0,80003c36 <namex+0x90>
    iunlockput(ip);
    80003ca0:	8552                	mv	a0,s4
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	bd2080e7          	jalr	-1070(ra) # 80003874 <iunlockput>
    ip = next;
    80003caa:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003cac:	0004c783          	lbu	a5,0(s1)
    80003cb0:	01279763          	bne	a5,s2,80003cbe <namex+0x118>
    path++;
    80003cb4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003cb6:	0004c783          	lbu	a5,0(s1)
    80003cba:	ff278de3          	beq	a5,s2,80003cb4 <namex+0x10e>
  if(*path == 0)
    80003cbe:	cb9d                	beqz	a5,80003cf4 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003cc0:	0004c783          	lbu	a5,0(s1)
    80003cc4:	89a6                	mv	s3,s1
  len = path - s;
    80003cc6:	4c81                	li	s9,0
    80003cc8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003cca:	01278963          	beq	a5,s2,80003cdc <namex+0x136>
    80003cce:	dbbd                	beqz	a5,80003c44 <namex+0x9e>
    path++;
    80003cd0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003cd2:	0009c783          	lbu	a5,0(s3)
    80003cd6:	ff279ce3          	bne	a5,s2,80003cce <namex+0x128>
    80003cda:	b7ad                	j	80003c44 <namex+0x9e>
    memmove(name, s, len);
    80003cdc:	2601                	sext.w	a2,a2
    80003cde:	85a6                	mv	a1,s1
    80003ce0:	8556                	mv	a0,s5
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	048080e7          	jalr	72(ra) # 80000d2a <memmove>
    name[len] = 0;
    80003cea:	9cd6                	add	s9,s9,s5
    80003cec:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003cf0:	84ce                	mv	s1,s3
    80003cf2:	b7bd                	j	80003c60 <namex+0xba>
  if(nameiparent){
    80003cf4:	f00b0de3          	beqz	s6,80003c0e <namex+0x68>
    iput(ip);
    80003cf8:	8552                	mv	a0,s4
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	ad2080e7          	jalr	-1326(ra) # 800037cc <iput>
    return 0;
    80003d02:	4a01                	li	s4,0
    80003d04:	b729                	j	80003c0e <namex+0x68>

0000000080003d06 <dirlink>:
{
    80003d06:	7139                	addi	sp,sp,-64
    80003d08:	fc06                	sd	ra,56(sp)
    80003d0a:	f822                	sd	s0,48(sp)
    80003d0c:	f426                	sd	s1,40(sp)
    80003d0e:	f04a                	sd	s2,32(sp)
    80003d10:	ec4e                	sd	s3,24(sp)
    80003d12:	e852                	sd	s4,16(sp)
    80003d14:	0080                	addi	s0,sp,64
    80003d16:	892a                	mv	s2,a0
    80003d18:	8a2e                	mv	s4,a1
    80003d1a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d1c:	4601                	li	a2,0
    80003d1e:	00000097          	auipc	ra,0x0
    80003d22:	dd8080e7          	jalr	-552(ra) # 80003af6 <dirlookup>
    80003d26:	e93d                	bnez	a0,80003d9c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d28:	04c92483          	lw	s1,76(s2)
    80003d2c:	c49d                	beqz	s1,80003d5a <dirlink+0x54>
    80003d2e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d30:	4741                	li	a4,16
    80003d32:	86a6                	mv	a3,s1
    80003d34:	fc040613          	addi	a2,s0,-64
    80003d38:	4581                	li	a1,0
    80003d3a:	854a                	mv	a0,s2
    80003d3c:	00000097          	auipc	ra,0x0
    80003d40:	b8a080e7          	jalr	-1142(ra) # 800038c6 <readi>
    80003d44:	47c1                	li	a5,16
    80003d46:	06f51163          	bne	a0,a5,80003da8 <dirlink+0xa2>
    if(de.inum == 0)
    80003d4a:	fc045783          	lhu	a5,-64(s0)
    80003d4e:	c791                	beqz	a5,80003d5a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d50:	24c1                	addiw	s1,s1,16
    80003d52:	04c92783          	lw	a5,76(s2)
    80003d56:	fcf4ede3          	bltu	s1,a5,80003d30 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d5a:	4639                	li	a2,14
    80003d5c:	85d2                	mv	a1,s4
    80003d5e:	fc240513          	addi	a0,s0,-62
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	078080e7          	jalr	120(ra) # 80000dda <strncpy>
  de.inum = inum;
    80003d6a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d6e:	4741                	li	a4,16
    80003d70:	86a6                	mv	a3,s1
    80003d72:	fc040613          	addi	a2,s0,-64
    80003d76:	4581                	li	a1,0
    80003d78:	854a                	mv	a0,s2
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	c44080e7          	jalr	-956(ra) # 800039be <writei>
    80003d82:	1541                	addi	a0,a0,-16
    80003d84:	00a03533          	snez	a0,a0
    80003d88:	40a00533          	neg	a0,a0
}
    80003d8c:	70e2                	ld	ra,56(sp)
    80003d8e:	7442                	ld	s0,48(sp)
    80003d90:	74a2                	ld	s1,40(sp)
    80003d92:	7902                	ld	s2,32(sp)
    80003d94:	69e2                	ld	s3,24(sp)
    80003d96:	6a42                	ld	s4,16(sp)
    80003d98:	6121                	addi	sp,sp,64
    80003d9a:	8082                	ret
    iput(ip);
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	a30080e7          	jalr	-1488(ra) # 800037cc <iput>
    return -1;
    80003da4:	557d                	li	a0,-1
    80003da6:	b7dd                	j	80003d8c <dirlink+0x86>
      panic("dirlink read");
    80003da8:	00005517          	auipc	a0,0x5
    80003dac:	89050513          	addi	a0,a0,-1904 # 80008638 <syscalls+0x1c8>
    80003db0:	ffffc097          	auipc	ra,0xffffc
    80003db4:	78c080e7          	jalr	1932(ra) # 8000053c <panic>

0000000080003db8 <namei>:

struct inode*
namei(char *path)
{
    80003db8:	1101                	addi	sp,sp,-32
    80003dba:	ec06                	sd	ra,24(sp)
    80003dbc:	e822                	sd	s0,16(sp)
    80003dbe:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003dc0:	fe040613          	addi	a2,s0,-32
    80003dc4:	4581                	li	a1,0
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	de0080e7          	jalr	-544(ra) # 80003ba6 <namex>
}
    80003dce:	60e2                	ld	ra,24(sp)
    80003dd0:	6442                	ld	s0,16(sp)
    80003dd2:	6105                	addi	sp,sp,32
    80003dd4:	8082                	ret

0000000080003dd6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dd6:	1141                	addi	sp,sp,-16
    80003dd8:	e406                	sd	ra,8(sp)
    80003dda:	e022                	sd	s0,0(sp)
    80003ddc:	0800                	addi	s0,sp,16
    80003dde:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003de0:	4585                	li	a1,1
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	dc4080e7          	jalr	-572(ra) # 80003ba6 <namex>
}
    80003dea:	60a2                	ld	ra,8(sp)
    80003dec:	6402                	ld	s0,0(sp)
    80003dee:	0141                	addi	sp,sp,16
    80003df0:	8082                	ret

0000000080003df2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003df2:	1101                	addi	sp,sp,-32
    80003df4:	ec06                	sd	ra,24(sp)
    80003df6:	e822                	sd	s0,16(sp)
    80003df8:	e426                	sd	s1,8(sp)
    80003dfa:	e04a                	sd	s2,0(sp)
    80003dfc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dfe:	0001d917          	auipc	s2,0x1d
    80003e02:	d2290913          	addi	s2,s2,-734 # 80020b20 <log>
    80003e06:	01892583          	lw	a1,24(s2)
    80003e0a:	02892503          	lw	a0,40(s2)
    80003e0e:	fffff097          	auipc	ra,0xfffff
    80003e12:	ff4080e7          	jalr	-12(ra) # 80002e02 <bread>
    80003e16:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e18:	02c92603          	lw	a2,44(s2)
    80003e1c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e1e:	00c05f63          	blez	a2,80003e3c <write_head+0x4a>
    80003e22:	0001d717          	auipc	a4,0x1d
    80003e26:	d2e70713          	addi	a4,a4,-722 # 80020b50 <log+0x30>
    80003e2a:	87aa                	mv	a5,a0
    80003e2c:	060a                	slli	a2,a2,0x2
    80003e2e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003e30:	4314                	lw	a3,0(a4)
    80003e32:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003e34:	0711                	addi	a4,a4,4
    80003e36:	0791                	addi	a5,a5,4
    80003e38:	fec79ce3          	bne	a5,a2,80003e30 <write_head+0x3e>
  }
  bwrite(buf);
    80003e3c:	8526                	mv	a0,s1
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	0b6080e7          	jalr	182(ra) # 80002ef4 <bwrite>
  brelse(buf);
    80003e46:	8526                	mv	a0,s1
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	0ea080e7          	jalr	234(ra) # 80002f32 <brelse>
}
    80003e50:	60e2                	ld	ra,24(sp)
    80003e52:	6442                	ld	s0,16(sp)
    80003e54:	64a2                	ld	s1,8(sp)
    80003e56:	6902                	ld	s2,0(sp)
    80003e58:	6105                	addi	sp,sp,32
    80003e5a:	8082                	ret

0000000080003e5c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e5c:	0001d797          	auipc	a5,0x1d
    80003e60:	cf07a783          	lw	a5,-784(a5) # 80020b4c <log+0x2c>
    80003e64:	0af05d63          	blez	a5,80003f1e <install_trans+0xc2>
{
    80003e68:	7139                	addi	sp,sp,-64
    80003e6a:	fc06                	sd	ra,56(sp)
    80003e6c:	f822                	sd	s0,48(sp)
    80003e6e:	f426                	sd	s1,40(sp)
    80003e70:	f04a                	sd	s2,32(sp)
    80003e72:	ec4e                	sd	s3,24(sp)
    80003e74:	e852                	sd	s4,16(sp)
    80003e76:	e456                	sd	s5,8(sp)
    80003e78:	e05a                	sd	s6,0(sp)
    80003e7a:	0080                	addi	s0,sp,64
    80003e7c:	8b2a                	mv	s6,a0
    80003e7e:	0001da97          	auipc	s5,0x1d
    80003e82:	cd2a8a93          	addi	s5,s5,-814 # 80020b50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e86:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e88:	0001d997          	auipc	s3,0x1d
    80003e8c:	c9898993          	addi	s3,s3,-872 # 80020b20 <log>
    80003e90:	a00d                	j	80003eb2 <install_trans+0x56>
    brelse(lbuf);
    80003e92:	854a                	mv	a0,s2
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	09e080e7          	jalr	158(ra) # 80002f32 <brelse>
    brelse(dbuf);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	fffff097          	auipc	ra,0xfffff
    80003ea2:	094080e7          	jalr	148(ra) # 80002f32 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ea6:	2a05                	addiw	s4,s4,1
    80003ea8:	0a91                	addi	s5,s5,4
    80003eaa:	02c9a783          	lw	a5,44(s3)
    80003eae:	04fa5e63          	bge	s4,a5,80003f0a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003eb2:	0189a583          	lw	a1,24(s3)
    80003eb6:	014585bb          	addw	a1,a1,s4
    80003eba:	2585                	addiw	a1,a1,1
    80003ebc:	0289a503          	lw	a0,40(s3)
    80003ec0:	fffff097          	auipc	ra,0xfffff
    80003ec4:	f42080e7          	jalr	-190(ra) # 80002e02 <bread>
    80003ec8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003eca:	000aa583          	lw	a1,0(s5)
    80003ece:	0289a503          	lw	a0,40(s3)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	f30080e7          	jalr	-208(ra) # 80002e02 <bread>
    80003eda:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003edc:	40000613          	li	a2,1024
    80003ee0:	05890593          	addi	a1,s2,88
    80003ee4:	05850513          	addi	a0,a0,88
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	e42080e7          	jalr	-446(ra) # 80000d2a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	fffff097          	auipc	ra,0xfffff
    80003ef6:	002080e7          	jalr	2(ra) # 80002ef4 <bwrite>
    if(recovering == 0)
    80003efa:	f80b1ce3          	bnez	s6,80003e92 <install_trans+0x36>
      bunpin(dbuf);
    80003efe:	8526                	mv	a0,s1
    80003f00:	fffff097          	auipc	ra,0xfffff
    80003f04:	10a080e7          	jalr	266(ra) # 8000300a <bunpin>
    80003f08:	b769                	j	80003e92 <install_trans+0x36>
}
    80003f0a:	70e2                	ld	ra,56(sp)
    80003f0c:	7442                	ld	s0,48(sp)
    80003f0e:	74a2                	ld	s1,40(sp)
    80003f10:	7902                	ld	s2,32(sp)
    80003f12:	69e2                	ld	s3,24(sp)
    80003f14:	6a42                	ld	s4,16(sp)
    80003f16:	6aa2                	ld	s5,8(sp)
    80003f18:	6b02                	ld	s6,0(sp)
    80003f1a:	6121                	addi	sp,sp,64
    80003f1c:	8082                	ret
    80003f1e:	8082                	ret

0000000080003f20 <initlog>:
{
    80003f20:	7179                	addi	sp,sp,-48
    80003f22:	f406                	sd	ra,40(sp)
    80003f24:	f022                	sd	s0,32(sp)
    80003f26:	ec26                	sd	s1,24(sp)
    80003f28:	e84a                	sd	s2,16(sp)
    80003f2a:	e44e                	sd	s3,8(sp)
    80003f2c:	1800                	addi	s0,sp,48
    80003f2e:	892a                	mv	s2,a0
    80003f30:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f32:	0001d497          	auipc	s1,0x1d
    80003f36:	bee48493          	addi	s1,s1,-1042 # 80020b20 <log>
    80003f3a:	00004597          	auipc	a1,0x4
    80003f3e:	70e58593          	addi	a1,a1,1806 # 80008648 <syscalls+0x1d8>
    80003f42:	8526                	mv	a0,s1
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	bfe080e7          	jalr	-1026(ra) # 80000b42 <initlock>
  log.start = sb->logstart;
    80003f4c:	0149a583          	lw	a1,20(s3)
    80003f50:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f52:	0109a783          	lw	a5,16(s3)
    80003f56:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f58:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	ea4080e7          	jalr	-348(ra) # 80002e02 <bread>
  log.lh.n = lh->n;
    80003f66:	4d30                	lw	a2,88(a0)
    80003f68:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f6a:	00c05f63          	blez	a2,80003f88 <initlog+0x68>
    80003f6e:	87aa                	mv	a5,a0
    80003f70:	0001d717          	auipc	a4,0x1d
    80003f74:	be070713          	addi	a4,a4,-1056 # 80020b50 <log+0x30>
    80003f78:	060a                	slli	a2,a2,0x2
    80003f7a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f7c:	4ff4                	lw	a3,92(a5)
    80003f7e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f80:	0791                	addi	a5,a5,4
    80003f82:	0711                	addi	a4,a4,4
    80003f84:	fec79ce3          	bne	a5,a2,80003f7c <initlog+0x5c>
  brelse(buf);
    80003f88:	fffff097          	auipc	ra,0xfffff
    80003f8c:	faa080e7          	jalr	-86(ra) # 80002f32 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f90:	4505                	li	a0,1
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	eca080e7          	jalr	-310(ra) # 80003e5c <install_trans>
  log.lh.n = 0;
    80003f9a:	0001d797          	auipc	a5,0x1d
    80003f9e:	ba07a923          	sw	zero,-1102(a5) # 80020b4c <log+0x2c>
  write_head(); // clear the log
    80003fa2:	00000097          	auipc	ra,0x0
    80003fa6:	e50080e7          	jalr	-432(ra) # 80003df2 <write_head>
}
    80003faa:	70a2                	ld	ra,40(sp)
    80003fac:	7402                	ld	s0,32(sp)
    80003fae:	64e2                	ld	s1,24(sp)
    80003fb0:	6942                	ld	s2,16(sp)
    80003fb2:	69a2                	ld	s3,8(sp)
    80003fb4:	6145                	addi	sp,sp,48
    80003fb6:	8082                	ret

0000000080003fb8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003fb8:	1101                	addi	sp,sp,-32
    80003fba:	ec06                	sd	ra,24(sp)
    80003fbc:	e822                	sd	s0,16(sp)
    80003fbe:	e426                	sd	s1,8(sp)
    80003fc0:	e04a                	sd	s2,0(sp)
    80003fc2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003fc4:	0001d517          	auipc	a0,0x1d
    80003fc8:	b5c50513          	addi	a0,a0,-1188 # 80020b20 <log>
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	c06080e7          	jalr	-1018(ra) # 80000bd2 <acquire>
  while(1){
    if(log.committing){
    80003fd4:	0001d497          	auipc	s1,0x1d
    80003fd8:	b4c48493          	addi	s1,s1,-1204 # 80020b20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fdc:	4979                	li	s2,30
    80003fde:	a039                	j	80003fec <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fe0:	85a6                	mv	a1,s1
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	ffffe097          	auipc	ra,0xffffe
    80003fe8:	05a080e7          	jalr	90(ra) # 8000203e <sleep>
    if(log.committing){
    80003fec:	50dc                	lw	a5,36(s1)
    80003fee:	fbed                	bnez	a5,80003fe0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ff0:	5098                	lw	a4,32(s1)
    80003ff2:	2705                	addiw	a4,a4,1
    80003ff4:	0027179b          	slliw	a5,a4,0x2
    80003ff8:	9fb9                	addw	a5,a5,a4
    80003ffa:	0017979b          	slliw	a5,a5,0x1
    80003ffe:	54d4                	lw	a3,44(s1)
    80004000:	9fb5                	addw	a5,a5,a3
    80004002:	00f95963          	bge	s2,a5,80004014 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004006:	85a6                	mv	a1,s1
    80004008:	8526                	mv	a0,s1
    8000400a:	ffffe097          	auipc	ra,0xffffe
    8000400e:	034080e7          	jalr	52(ra) # 8000203e <sleep>
    80004012:	bfe9                	j	80003fec <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004014:	0001d517          	auipc	a0,0x1d
    80004018:	b0c50513          	addi	a0,a0,-1268 # 80020b20 <log>
    8000401c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	c68080e7          	jalr	-920(ra) # 80000c86 <release>
      break;
    }
  }
}
    80004026:	60e2                	ld	ra,24(sp)
    80004028:	6442                	ld	s0,16(sp)
    8000402a:	64a2                	ld	s1,8(sp)
    8000402c:	6902                	ld	s2,0(sp)
    8000402e:	6105                	addi	sp,sp,32
    80004030:	8082                	ret

0000000080004032 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004032:	7139                	addi	sp,sp,-64
    80004034:	fc06                	sd	ra,56(sp)
    80004036:	f822                	sd	s0,48(sp)
    80004038:	f426                	sd	s1,40(sp)
    8000403a:	f04a                	sd	s2,32(sp)
    8000403c:	ec4e                	sd	s3,24(sp)
    8000403e:	e852                	sd	s4,16(sp)
    80004040:	e456                	sd	s5,8(sp)
    80004042:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004044:	0001d497          	auipc	s1,0x1d
    80004048:	adc48493          	addi	s1,s1,-1316 # 80020b20 <log>
    8000404c:	8526                	mv	a0,s1
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	b84080e7          	jalr	-1148(ra) # 80000bd2 <acquire>
  log.outstanding -= 1;
    80004056:	509c                	lw	a5,32(s1)
    80004058:	37fd                	addiw	a5,a5,-1
    8000405a:	0007891b          	sext.w	s2,a5
    8000405e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004060:	50dc                	lw	a5,36(s1)
    80004062:	e7b9                	bnez	a5,800040b0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004064:	04091e63          	bnez	s2,800040c0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004068:	0001d497          	auipc	s1,0x1d
    8000406c:	ab848493          	addi	s1,s1,-1352 # 80020b20 <log>
    80004070:	4785                	li	a5,1
    80004072:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004074:	8526                	mv	a0,s1
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	c10080e7          	jalr	-1008(ra) # 80000c86 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000407e:	54dc                	lw	a5,44(s1)
    80004080:	06f04763          	bgtz	a5,800040ee <end_op+0xbc>
    acquire(&log.lock);
    80004084:	0001d497          	auipc	s1,0x1d
    80004088:	a9c48493          	addi	s1,s1,-1380 # 80020b20 <log>
    8000408c:	8526                	mv	a0,s1
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	b44080e7          	jalr	-1212(ra) # 80000bd2 <acquire>
    log.committing = 0;
    80004096:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000409a:	8526                	mv	a0,s1
    8000409c:	ffffe097          	auipc	ra,0xffffe
    800040a0:	006080e7          	jalr	6(ra) # 800020a2 <wakeup>
    release(&log.lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	be0080e7          	jalr	-1056(ra) # 80000c86 <release>
}
    800040ae:	a03d                	j	800040dc <end_op+0xaa>
    panic("log.committing");
    800040b0:	00004517          	auipc	a0,0x4
    800040b4:	5a050513          	addi	a0,a0,1440 # 80008650 <syscalls+0x1e0>
    800040b8:	ffffc097          	auipc	ra,0xffffc
    800040bc:	484080e7          	jalr	1156(ra) # 8000053c <panic>
    wakeup(&log);
    800040c0:	0001d497          	auipc	s1,0x1d
    800040c4:	a6048493          	addi	s1,s1,-1440 # 80020b20 <log>
    800040c8:	8526                	mv	a0,s1
    800040ca:	ffffe097          	auipc	ra,0xffffe
    800040ce:	fd8080e7          	jalr	-40(ra) # 800020a2 <wakeup>
  release(&log.lock);
    800040d2:	8526                	mv	a0,s1
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	bb2080e7          	jalr	-1102(ra) # 80000c86 <release>
}
    800040dc:	70e2                	ld	ra,56(sp)
    800040de:	7442                	ld	s0,48(sp)
    800040e0:	74a2                	ld	s1,40(sp)
    800040e2:	7902                	ld	s2,32(sp)
    800040e4:	69e2                	ld	s3,24(sp)
    800040e6:	6a42                	ld	s4,16(sp)
    800040e8:	6aa2                	ld	s5,8(sp)
    800040ea:	6121                	addi	sp,sp,64
    800040ec:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800040ee:	0001da97          	auipc	s5,0x1d
    800040f2:	a62a8a93          	addi	s5,s5,-1438 # 80020b50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800040f6:	0001da17          	auipc	s4,0x1d
    800040fa:	a2aa0a13          	addi	s4,s4,-1494 # 80020b20 <log>
    800040fe:	018a2583          	lw	a1,24(s4)
    80004102:	012585bb          	addw	a1,a1,s2
    80004106:	2585                	addiw	a1,a1,1
    80004108:	028a2503          	lw	a0,40(s4)
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	cf6080e7          	jalr	-778(ra) # 80002e02 <bread>
    80004114:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004116:	000aa583          	lw	a1,0(s5)
    8000411a:	028a2503          	lw	a0,40(s4)
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	ce4080e7          	jalr	-796(ra) # 80002e02 <bread>
    80004126:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004128:	40000613          	li	a2,1024
    8000412c:	05850593          	addi	a1,a0,88
    80004130:	05848513          	addi	a0,s1,88
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	bf6080e7          	jalr	-1034(ra) # 80000d2a <memmove>
    bwrite(to);  // write the log
    8000413c:	8526                	mv	a0,s1
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	db6080e7          	jalr	-586(ra) # 80002ef4 <bwrite>
    brelse(from);
    80004146:	854e                	mv	a0,s3
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	dea080e7          	jalr	-534(ra) # 80002f32 <brelse>
    brelse(to);
    80004150:	8526                	mv	a0,s1
    80004152:	fffff097          	auipc	ra,0xfffff
    80004156:	de0080e7          	jalr	-544(ra) # 80002f32 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415a:	2905                	addiw	s2,s2,1
    8000415c:	0a91                	addi	s5,s5,4
    8000415e:	02ca2783          	lw	a5,44(s4)
    80004162:	f8f94ee3          	blt	s2,a5,800040fe <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004166:	00000097          	auipc	ra,0x0
    8000416a:	c8c080e7          	jalr	-884(ra) # 80003df2 <write_head>
    install_trans(0); // Now install writes to home locations
    8000416e:	4501                	li	a0,0
    80004170:	00000097          	auipc	ra,0x0
    80004174:	cec080e7          	jalr	-788(ra) # 80003e5c <install_trans>
    log.lh.n = 0;
    80004178:	0001d797          	auipc	a5,0x1d
    8000417c:	9c07aa23          	sw	zero,-1580(a5) # 80020b4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004180:	00000097          	auipc	ra,0x0
    80004184:	c72080e7          	jalr	-910(ra) # 80003df2 <write_head>
    80004188:	bdf5                	j	80004084 <end_op+0x52>

000000008000418a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000418a:	1101                	addi	sp,sp,-32
    8000418c:	ec06                	sd	ra,24(sp)
    8000418e:	e822                	sd	s0,16(sp)
    80004190:	e426                	sd	s1,8(sp)
    80004192:	e04a                	sd	s2,0(sp)
    80004194:	1000                	addi	s0,sp,32
    80004196:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004198:	0001d917          	auipc	s2,0x1d
    8000419c:	98890913          	addi	s2,s2,-1656 # 80020b20 <log>
    800041a0:	854a                	mv	a0,s2
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	a30080e7          	jalr	-1488(ra) # 80000bd2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800041aa:	02c92603          	lw	a2,44(s2)
    800041ae:	47f5                	li	a5,29
    800041b0:	06c7c563          	blt	a5,a2,8000421a <log_write+0x90>
    800041b4:	0001d797          	auipc	a5,0x1d
    800041b8:	9887a783          	lw	a5,-1656(a5) # 80020b3c <log+0x1c>
    800041bc:	37fd                	addiw	a5,a5,-1
    800041be:	04f65e63          	bge	a2,a5,8000421a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800041c2:	0001d797          	auipc	a5,0x1d
    800041c6:	97e7a783          	lw	a5,-1666(a5) # 80020b40 <log+0x20>
    800041ca:	06f05063          	blez	a5,8000422a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800041ce:	4781                	li	a5,0
    800041d0:	06c05563          	blez	a2,8000423a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800041d4:	44cc                	lw	a1,12(s1)
    800041d6:	0001d717          	auipc	a4,0x1d
    800041da:	97a70713          	addi	a4,a4,-1670 # 80020b50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041de:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800041e0:	4314                	lw	a3,0(a4)
    800041e2:	04b68c63          	beq	a3,a1,8000423a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800041e6:	2785                	addiw	a5,a5,1
    800041e8:	0711                	addi	a4,a4,4
    800041ea:	fef61be3          	bne	a2,a5,800041e0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800041ee:	0621                	addi	a2,a2,8
    800041f0:	060a                	slli	a2,a2,0x2
    800041f2:	0001d797          	auipc	a5,0x1d
    800041f6:	92e78793          	addi	a5,a5,-1746 # 80020b20 <log>
    800041fa:	97b2                	add	a5,a5,a2
    800041fc:	44d8                	lw	a4,12(s1)
    800041fe:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004200:	8526                	mv	a0,s1
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	dcc080e7          	jalr	-564(ra) # 80002fce <bpin>
    log.lh.n++;
    8000420a:	0001d717          	auipc	a4,0x1d
    8000420e:	91670713          	addi	a4,a4,-1770 # 80020b20 <log>
    80004212:	575c                	lw	a5,44(a4)
    80004214:	2785                	addiw	a5,a5,1
    80004216:	d75c                	sw	a5,44(a4)
    80004218:	a82d                	j	80004252 <log_write+0xc8>
    panic("too big a transaction");
    8000421a:	00004517          	auipc	a0,0x4
    8000421e:	44650513          	addi	a0,a0,1094 # 80008660 <syscalls+0x1f0>
    80004222:	ffffc097          	auipc	ra,0xffffc
    80004226:	31a080e7          	jalr	794(ra) # 8000053c <panic>
    panic("log_write outside of trans");
    8000422a:	00004517          	auipc	a0,0x4
    8000422e:	44e50513          	addi	a0,a0,1102 # 80008678 <syscalls+0x208>
    80004232:	ffffc097          	auipc	ra,0xffffc
    80004236:	30a080e7          	jalr	778(ra) # 8000053c <panic>
  log.lh.block[i] = b->blockno;
    8000423a:	00878693          	addi	a3,a5,8
    8000423e:	068a                	slli	a3,a3,0x2
    80004240:	0001d717          	auipc	a4,0x1d
    80004244:	8e070713          	addi	a4,a4,-1824 # 80020b20 <log>
    80004248:	9736                	add	a4,a4,a3
    8000424a:	44d4                	lw	a3,12(s1)
    8000424c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000424e:	faf609e3          	beq	a2,a5,80004200 <log_write+0x76>
  }
  release(&log.lock);
    80004252:	0001d517          	auipc	a0,0x1d
    80004256:	8ce50513          	addi	a0,a0,-1842 # 80020b20 <log>
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	a2c080e7          	jalr	-1492(ra) # 80000c86 <release>
}
    80004262:	60e2                	ld	ra,24(sp)
    80004264:	6442                	ld	s0,16(sp)
    80004266:	64a2                	ld	s1,8(sp)
    80004268:	6902                	ld	s2,0(sp)
    8000426a:	6105                	addi	sp,sp,32
    8000426c:	8082                	ret

000000008000426e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000426e:	1101                	addi	sp,sp,-32
    80004270:	ec06                	sd	ra,24(sp)
    80004272:	e822                	sd	s0,16(sp)
    80004274:	e426                	sd	s1,8(sp)
    80004276:	e04a                	sd	s2,0(sp)
    80004278:	1000                	addi	s0,sp,32
    8000427a:	84aa                	mv	s1,a0
    8000427c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000427e:	00004597          	auipc	a1,0x4
    80004282:	41a58593          	addi	a1,a1,1050 # 80008698 <syscalls+0x228>
    80004286:	0521                	addi	a0,a0,8
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	8ba080e7          	jalr	-1862(ra) # 80000b42 <initlock>
  lk->name = name;
    80004290:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004294:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004298:	0204a423          	sw	zero,40(s1)
}
    8000429c:	60e2                	ld	ra,24(sp)
    8000429e:	6442                	ld	s0,16(sp)
    800042a0:	64a2                	ld	s1,8(sp)
    800042a2:	6902                	ld	s2,0(sp)
    800042a4:	6105                	addi	sp,sp,32
    800042a6:	8082                	ret

00000000800042a8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042a8:	1101                	addi	sp,sp,-32
    800042aa:	ec06                	sd	ra,24(sp)
    800042ac:	e822                	sd	s0,16(sp)
    800042ae:	e426                	sd	s1,8(sp)
    800042b0:	e04a                	sd	s2,0(sp)
    800042b2:	1000                	addi	s0,sp,32
    800042b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042b6:	00850913          	addi	s2,a0,8
    800042ba:	854a                	mv	a0,s2
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	916080e7          	jalr	-1770(ra) # 80000bd2 <acquire>
  while (lk->locked) {
    800042c4:	409c                	lw	a5,0(s1)
    800042c6:	cb89                	beqz	a5,800042d8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042c8:	85ca                	mv	a1,s2
    800042ca:	8526                	mv	a0,s1
    800042cc:	ffffe097          	auipc	ra,0xffffe
    800042d0:	d72080e7          	jalr	-654(ra) # 8000203e <sleep>
  while (lk->locked) {
    800042d4:	409c                	lw	a5,0(s1)
    800042d6:	fbed                	bnez	a5,800042c8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042d8:	4785                	li	a5,1
    800042da:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042dc:	ffffd097          	auipc	ra,0xffffd
    800042e0:	6ba080e7          	jalr	1722(ra) # 80001996 <myproc>
    800042e4:	591c                	lw	a5,48(a0)
    800042e6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800042e8:	854a                	mv	a0,s2
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	99c080e7          	jalr	-1636(ra) # 80000c86 <release>
}
    800042f2:	60e2                	ld	ra,24(sp)
    800042f4:	6442                	ld	s0,16(sp)
    800042f6:	64a2                	ld	s1,8(sp)
    800042f8:	6902                	ld	s2,0(sp)
    800042fa:	6105                	addi	sp,sp,32
    800042fc:	8082                	ret

00000000800042fe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800042fe:	1101                	addi	sp,sp,-32
    80004300:	ec06                	sd	ra,24(sp)
    80004302:	e822                	sd	s0,16(sp)
    80004304:	e426                	sd	s1,8(sp)
    80004306:	e04a                	sd	s2,0(sp)
    80004308:	1000                	addi	s0,sp,32
    8000430a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000430c:	00850913          	addi	s2,a0,8
    80004310:	854a                	mv	a0,s2
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	8c0080e7          	jalr	-1856(ra) # 80000bd2 <acquire>
  lk->locked = 0;
    8000431a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000431e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004322:	8526                	mv	a0,s1
    80004324:	ffffe097          	auipc	ra,0xffffe
    80004328:	d7e080e7          	jalr	-642(ra) # 800020a2 <wakeup>
  release(&lk->lk);
    8000432c:	854a                	mv	a0,s2
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	958080e7          	jalr	-1704(ra) # 80000c86 <release>
}
    80004336:	60e2                	ld	ra,24(sp)
    80004338:	6442                	ld	s0,16(sp)
    8000433a:	64a2                	ld	s1,8(sp)
    8000433c:	6902                	ld	s2,0(sp)
    8000433e:	6105                	addi	sp,sp,32
    80004340:	8082                	ret

0000000080004342 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004342:	7179                	addi	sp,sp,-48
    80004344:	f406                	sd	ra,40(sp)
    80004346:	f022                	sd	s0,32(sp)
    80004348:	ec26                	sd	s1,24(sp)
    8000434a:	e84a                	sd	s2,16(sp)
    8000434c:	e44e                	sd	s3,8(sp)
    8000434e:	1800                	addi	s0,sp,48
    80004350:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004352:	00850913          	addi	s2,a0,8
    80004356:	854a                	mv	a0,s2
    80004358:	ffffd097          	auipc	ra,0xffffd
    8000435c:	87a080e7          	jalr	-1926(ra) # 80000bd2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004360:	409c                	lw	a5,0(s1)
    80004362:	ef99                	bnez	a5,80004380 <holdingsleep+0x3e>
    80004364:	4481                	li	s1,0
  release(&lk->lk);
    80004366:	854a                	mv	a0,s2
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	91e080e7          	jalr	-1762(ra) # 80000c86 <release>
  return r;
}
    80004370:	8526                	mv	a0,s1
    80004372:	70a2                	ld	ra,40(sp)
    80004374:	7402                	ld	s0,32(sp)
    80004376:	64e2                	ld	s1,24(sp)
    80004378:	6942                	ld	s2,16(sp)
    8000437a:	69a2                	ld	s3,8(sp)
    8000437c:	6145                	addi	sp,sp,48
    8000437e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004380:	0284a983          	lw	s3,40(s1)
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	612080e7          	jalr	1554(ra) # 80001996 <myproc>
    8000438c:	5904                	lw	s1,48(a0)
    8000438e:	413484b3          	sub	s1,s1,s3
    80004392:	0014b493          	seqz	s1,s1
    80004396:	bfc1                	j	80004366 <holdingsleep+0x24>

0000000080004398 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004398:	1141                	addi	sp,sp,-16
    8000439a:	e406                	sd	ra,8(sp)
    8000439c:	e022                	sd	s0,0(sp)
    8000439e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043a0:	00004597          	auipc	a1,0x4
    800043a4:	30858593          	addi	a1,a1,776 # 800086a8 <syscalls+0x238>
    800043a8:	0001d517          	auipc	a0,0x1d
    800043ac:	8c050513          	addi	a0,a0,-1856 # 80020c68 <ftable>
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	792080e7          	jalr	1938(ra) # 80000b42 <initlock>
}
    800043b8:	60a2                	ld	ra,8(sp)
    800043ba:	6402                	ld	s0,0(sp)
    800043bc:	0141                	addi	sp,sp,16
    800043be:	8082                	ret

00000000800043c0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043c0:	1101                	addi	sp,sp,-32
    800043c2:	ec06                	sd	ra,24(sp)
    800043c4:	e822                	sd	s0,16(sp)
    800043c6:	e426                	sd	s1,8(sp)
    800043c8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043ca:	0001d517          	auipc	a0,0x1d
    800043ce:	89e50513          	addi	a0,a0,-1890 # 80020c68 <ftable>
    800043d2:	ffffd097          	auipc	ra,0xffffd
    800043d6:	800080e7          	jalr	-2048(ra) # 80000bd2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043da:	0001d497          	auipc	s1,0x1d
    800043de:	8a648493          	addi	s1,s1,-1882 # 80020c80 <ftable+0x18>
    800043e2:	0001e717          	auipc	a4,0x1e
    800043e6:	83e70713          	addi	a4,a4,-1986 # 80021c20 <disk>
    if(f->ref == 0){
    800043ea:	40dc                	lw	a5,4(s1)
    800043ec:	cf99                	beqz	a5,8000440a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043ee:	02848493          	addi	s1,s1,40
    800043f2:	fee49ce3          	bne	s1,a4,800043ea <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800043f6:	0001d517          	auipc	a0,0x1d
    800043fa:	87250513          	addi	a0,a0,-1934 # 80020c68 <ftable>
    800043fe:	ffffd097          	auipc	ra,0xffffd
    80004402:	888080e7          	jalr	-1912(ra) # 80000c86 <release>
  return 0;
    80004406:	4481                	li	s1,0
    80004408:	a819                	j	8000441e <filealloc+0x5e>
      f->ref = 1;
    8000440a:	4785                	li	a5,1
    8000440c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000440e:	0001d517          	auipc	a0,0x1d
    80004412:	85a50513          	addi	a0,a0,-1958 # 80020c68 <ftable>
    80004416:	ffffd097          	auipc	ra,0xffffd
    8000441a:	870080e7          	jalr	-1936(ra) # 80000c86 <release>
}
    8000441e:	8526                	mv	a0,s1
    80004420:	60e2                	ld	ra,24(sp)
    80004422:	6442                	ld	s0,16(sp)
    80004424:	64a2                	ld	s1,8(sp)
    80004426:	6105                	addi	sp,sp,32
    80004428:	8082                	ret

000000008000442a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000442a:	1101                	addi	sp,sp,-32
    8000442c:	ec06                	sd	ra,24(sp)
    8000442e:	e822                	sd	s0,16(sp)
    80004430:	e426                	sd	s1,8(sp)
    80004432:	1000                	addi	s0,sp,32
    80004434:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004436:	0001d517          	auipc	a0,0x1d
    8000443a:	83250513          	addi	a0,a0,-1998 # 80020c68 <ftable>
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	794080e7          	jalr	1940(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    80004446:	40dc                	lw	a5,4(s1)
    80004448:	02f05263          	blez	a5,8000446c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000444c:	2785                	addiw	a5,a5,1
    8000444e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004450:	0001d517          	auipc	a0,0x1d
    80004454:	81850513          	addi	a0,a0,-2024 # 80020c68 <ftable>
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	82e080e7          	jalr	-2002(ra) # 80000c86 <release>
  return f;
}
    80004460:	8526                	mv	a0,s1
    80004462:	60e2                	ld	ra,24(sp)
    80004464:	6442                	ld	s0,16(sp)
    80004466:	64a2                	ld	s1,8(sp)
    80004468:	6105                	addi	sp,sp,32
    8000446a:	8082                	ret
    panic("filedup");
    8000446c:	00004517          	auipc	a0,0x4
    80004470:	24450513          	addi	a0,a0,580 # 800086b0 <syscalls+0x240>
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	0c8080e7          	jalr	200(ra) # 8000053c <panic>

000000008000447c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000447c:	7139                	addi	sp,sp,-64
    8000447e:	fc06                	sd	ra,56(sp)
    80004480:	f822                	sd	s0,48(sp)
    80004482:	f426                	sd	s1,40(sp)
    80004484:	f04a                	sd	s2,32(sp)
    80004486:	ec4e                	sd	s3,24(sp)
    80004488:	e852                	sd	s4,16(sp)
    8000448a:	e456                	sd	s5,8(sp)
    8000448c:	0080                	addi	s0,sp,64
    8000448e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004490:	0001c517          	auipc	a0,0x1c
    80004494:	7d850513          	addi	a0,a0,2008 # 80020c68 <ftable>
    80004498:	ffffc097          	auipc	ra,0xffffc
    8000449c:	73a080e7          	jalr	1850(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    800044a0:	40dc                	lw	a5,4(s1)
    800044a2:	06f05163          	blez	a5,80004504 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800044a6:	37fd                	addiw	a5,a5,-1
    800044a8:	0007871b          	sext.w	a4,a5
    800044ac:	c0dc                	sw	a5,4(s1)
    800044ae:	06e04363          	bgtz	a4,80004514 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044b2:	0004a903          	lw	s2,0(s1)
    800044b6:	0094ca83          	lbu	s5,9(s1)
    800044ba:	0104ba03          	ld	s4,16(s1)
    800044be:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044c2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044c6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044ca:	0001c517          	auipc	a0,0x1c
    800044ce:	79e50513          	addi	a0,a0,1950 # 80020c68 <ftable>
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	7b4080e7          	jalr	1972(ra) # 80000c86 <release>

  if(ff.type == FD_PIPE){
    800044da:	4785                	li	a5,1
    800044dc:	04f90d63          	beq	s2,a5,80004536 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044e0:	3979                	addiw	s2,s2,-2
    800044e2:	4785                	li	a5,1
    800044e4:	0527e063          	bltu	a5,s2,80004524 <fileclose+0xa8>
    begin_op();
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	ad0080e7          	jalr	-1328(ra) # 80003fb8 <begin_op>
    iput(ff.ip);
    800044f0:	854e                	mv	a0,s3
    800044f2:	fffff097          	auipc	ra,0xfffff
    800044f6:	2da080e7          	jalr	730(ra) # 800037cc <iput>
    end_op();
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	b38080e7          	jalr	-1224(ra) # 80004032 <end_op>
    80004502:	a00d                	j	80004524 <fileclose+0xa8>
    panic("fileclose");
    80004504:	00004517          	auipc	a0,0x4
    80004508:	1b450513          	addi	a0,a0,436 # 800086b8 <syscalls+0x248>
    8000450c:	ffffc097          	auipc	ra,0xffffc
    80004510:	030080e7          	jalr	48(ra) # 8000053c <panic>
    release(&ftable.lock);
    80004514:	0001c517          	auipc	a0,0x1c
    80004518:	75450513          	addi	a0,a0,1876 # 80020c68 <ftable>
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	76a080e7          	jalr	1898(ra) # 80000c86 <release>
  }
}
    80004524:	70e2                	ld	ra,56(sp)
    80004526:	7442                	ld	s0,48(sp)
    80004528:	74a2                	ld	s1,40(sp)
    8000452a:	7902                	ld	s2,32(sp)
    8000452c:	69e2                	ld	s3,24(sp)
    8000452e:	6a42                	ld	s4,16(sp)
    80004530:	6aa2                	ld	s5,8(sp)
    80004532:	6121                	addi	sp,sp,64
    80004534:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004536:	85d6                	mv	a1,s5
    80004538:	8552                	mv	a0,s4
    8000453a:	00000097          	auipc	ra,0x0
    8000453e:	348080e7          	jalr	840(ra) # 80004882 <pipeclose>
    80004542:	b7cd                	j	80004524 <fileclose+0xa8>

0000000080004544 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004544:	715d                	addi	sp,sp,-80
    80004546:	e486                	sd	ra,72(sp)
    80004548:	e0a2                	sd	s0,64(sp)
    8000454a:	fc26                	sd	s1,56(sp)
    8000454c:	f84a                	sd	s2,48(sp)
    8000454e:	f44e                	sd	s3,40(sp)
    80004550:	0880                	addi	s0,sp,80
    80004552:	84aa                	mv	s1,a0
    80004554:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004556:	ffffd097          	auipc	ra,0xffffd
    8000455a:	440080e7          	jalr	1088(ra) # 80001996 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000455e:	409c                	lw	a5,0(s1)
    80004560:	37f9                	addiw	a5,a5,-2
    80004562:	4705                	li	a4,1
    80004564:	04f76763          	bltu	a4,a5,800045b2 <filestat+0x6e>
    80004568:	892a                	mv	s2,a0
    ilock(f->ip);
    8000456a:	6c88                	ld	a0,24(s1)
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	0a6080e7          	jalr	166(ra) # 80003612 <ilock>
    stati(f->ip, &st);
    80004574:	fb840593          	addi	a1,s0,-72
    80004578:	6c88                	ld	a0,24(s1)
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	322080e7          	jalr	802(ra) # 8000389c <stati>
    iunlock(f->ip);
    80004582:	6c88                	ld	a0,24(s1)
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	150080e7          	jalr	336(ra) # 800036d4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000458c:	46e1                	li	a3,24
    8000458e:	fb840613          	addi	a2,s0,-72
    80004592:	85ce                	mv	a1,s3
    80004594:	05093503          	ld	a0,80(s2)
    80004598:	ffffd097          	auipc	ra,0xffffd
    8000459c:	0be080e7          	jalr	190(ra) # 80001656 <copyout>
    800045a0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045a4:	60a6                	ld	ra,72(sp)
    800045a6:	6406                	ld	s0,64(sp)
    800045a8:	74e2                	ld	s1,56(sp)
    800045aa:	7942                	ld	s2,48(sp)
    800045ac:	79a2                	ld	s3,40(sp)
    800045ae:	6161                	addi	sp,sp,80
    800045b0:	8082                	ret
  return -1;
    800045b2:	557d                	li	a0,-1
    800045b4:	bfc5                	j	800045a4 <filestat+0x60>

00000000800045b6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045b6:	7179                	addi	sp,sp,-48
    800045b8:	f406                	sd	ra,40(sp)
    800045ba:	f022                	sd	s0,32(sp)
    800045bc:	ec26                	sd	s1,24(sp)
    800045be:	e84a                	sd	s2,16(sp)
    800045c0:	e44e                	sd	s3,8(sp)
    800045c2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045c4:	00854783          	lbu	a5,8(a0)
    800045c8:	c3d5                	beqz	a5,8000466c <fileread+0xb6>
    800045ca:	84aa                	mv	s1,a0
    800045cc:	89ae                	mv	s3,a1
    800045ce:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045d0:	411c                	lw	a5,0(a0)
    800045d2:	4705                	li	a4,1
    800045d4:	04e78963          	beq	a5,a4,80004626 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045d8:	470d                	li	a4,3
    800045da:	04e78d63          	beq	a5,a4,80004634 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045de:	4709                	li	a4,2
    800045e0:	06e79e63          	bne	a5,a4,8000465c <fileread+0xa6>
    ilock(f->ip);
    800045e4:	6d08                	ld	a0,24(a0)
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	02c080e7          	jalr	44(ra) # 80003612 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800045ee:	874a                	mv	a4,s2
    800045f0:	5094                	lw	a3,32(s1)
    800045f2:	864e                	mv	a2,s3
    800045f4:	4585                	li	a1,1
    800045f6:	6c88                	ld	a0,24(s1)
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	2ce080e7          	jalr	718(ra) # 800038c6 <readi>
    80004600:	892a                	mv	s2,a0
    80004602:	00a05563          	blez	a0,8000460c <fileread+0x56>
      f->off += r;
    80004606:	509c                	lw	a5,32(s1)
    80004608:	9fa9                	addw	a5,a5,a0
    8000460a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000460c:	6c88                	ld	a0,24(s1)
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	0c6080e7          	jalr	198(ra) # 800036d4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004616:	854a                	mv	a0,s2
    80004618:	70a2                	ld	ra,40(sp)
    8000461a:	7402                	ld	s0,32(sp)
    8000461c:	64e2                	ld	s1,24(sp)
    8000461e:	6942                	ld	s2,16(sp)
    80004620:	69a2                	ld	s3,8(sp)
    80004622:	6145                	addi	sp,sp,48
    80004624:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004626:	6908                	ld	a0,16(a0)
    80004628:	00000097          	auipc	ra,0x0
    8000462c:	3c2080e7          	jalr	962(ra) # 800049ea <piperead>
    80004630:	892a                	mv	s2,a0
    80004632:	b7d5                	j	80004616 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004634:	02451783          	lh	a5,36(a0)
    80004638:	03079693          	slli	a3,a5,0x30
    8000463c:	92c1                	srli	a3,a3,0x30
    8000463e:	4725                	li	a4,9
    80004640:	02d76863          	bltu	a4,a3,80004670 <fileread+0xba>
    80004644:	0792                	slli	a5,a5,0x4
    80004646:	0001c717          	auipc	a4,0x1c
    8000464a:	58270713          	addi	a4,a4,1410 # 80020bc8 <devsw>
    8000464e:	97ba                	add	a5,a5,a4
    80004650:	639c                	ld	a5,0(a5)
    80004652:	c38d                	beqz	a5,80004674 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004654:	4505                	li	a0,1
    80004656:	9782                	jalr	a5
    80004658:	892a                	mv	s2,a0
    8000465a:	bf75                	j	80004616 <fileread+0x60>
    panic("fileread");
    8000465c:	00004517          	auipc	a0,0x4
    80004660:	06c50513          	addi	a0,a0,108 # 800086c8 <syscalls+0x258>
    80004664:	ffffc097          	auipc	ra,0xffffc
    80004668:	ed8080e7          	jalr	-296(ra) # 8000053c <panic>
    return -1;
    8000466c:	597d                	li	s2,-1
    8000466e:	b765                	j	80004616 <fileread+0x60>
      return -1;
    80004670:	597d                	li	s2,-1
    80004672:	b755                	j	80004616 <fileread+0x60>
    80004674:	597d                	li	s2,-1
    80004676:	b745                	j	80004616 <fileread+0x60>

0000000080004678 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004678:	00954783          	lbu	a5,9(a0)
    8000467c:	10078e63          	beqz	a5,80004798 <filewrite+0x120>
{
    80004680:	715d                	addi	sp,sp,-80
    80004682:	e486                	sd	ra,72(sp)
    80004684:	e0a2                	sd	s0,64(sp)
    80004686:	fc26                	sd	s1,56(sp)
    80004688:	f84a                	sd	s2,48(sp)
    8000468a:	f44e                	sd	s3,40(sp)
    8000468c:	f052                	sd	s4,32(sp)
    8000468e:	ec56                	sd	s5,24(sp)
    80004690:	e85a                	sd	s6,16(sp)
    80004692:	e45e                	sd	s7,8(sp)
    80004694:	e062                	sd	s8,0(sp)
    80004696:	0880                	addi	s0,sp,80
    80004698:	892a                	mv	s2,a0
    8000469a:	8b2e                	mv	s6,a1
    8000469c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000469e:	411c                	lw	a5,0(a0)
    800046a0:	4705                	li	a4,1
    800046a2:	02e78263          	beq	a5,a4,800046c6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046a6:	470d                	li	a4,3
    800046a8:	02e78563          	beq	a5,a4,800046d2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046ac:	4709                	li	a4,2
    800046ae:	0ce79d63          	bne	a5,a4,80004788 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046b2:	0ac05b63          	blez	a2,80004768 <filewrite+0xf0>
    int i = 0;
    800046b6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800046b8:	6b85                	lui	s7,0x1
    800046ba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046be:	6c05                	lui	s8,0x1
    800046c0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046c4:	a851                	j	80004758 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046c6:	6908                	ld	a0,16(a0)
    800046c8:	00000097          	auipc	ra,0x0
    800046cc:	22a080e7          	jalr	554(ra) # 800048f2 <pipewrite>
    800046d0:	a045                	j	80004770 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046d2:	02451783          	lh	a5,36(a0)
    800046d6:	03079693          	slli	a3,a5,0x30
    800046da:	92c1                	srli	a3,a3,0x30
    800046dc:	4725                	li	a4,9
    800046de:	0ad76f63          	bltu	a4,a3,8000479c <filewrite+0x124>
    800046e2:	0792                	slli	a5,a5,0x4
    800046e4:	0001c717          	auipc	a4,0x1c
    800046e8:	4e470713          	addi	a4,a4,1252 # 80020bc8 <devsw>
    800046ec:	97ba                	add	a5,a5,a4
    800046ee:	679c                	ld	a5,8(a5)
    800046f0:	cbc5                	beqz	a5,800047a0 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800046f2:	4505                	li	a0,1
    800046f4:	9782                	jalr	a5
    800046f6:	a8ad                	j	80004770 <filewrite+0xf8>
      if(n1 > max)
    800046f8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	8bc080e7          	jalr	-1860(ra) # 80003fb8 <begin_op>
      ilock(f->ip);
    80004704:	01893503          	ld	a0,24(s2)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	f0a080e7          	jalr	-246(ra) # 80003612 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004710:	8756                	mv	a4,s5
    80004712:	02092683          	lw	a3,32(s2)
    80004716:	01698633          	add	a2,s3,s6
    8000471a:	4585                	li	a1,1
    8000471c:	01893503          	ld	a0,24(s2)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	29e080e7          	jalr	670(ra) # 800039be <writei>
    80004728:	84aa                	mv	s1,a0
    8000472a:	00a05763          	blez	a0,80004738 <filewrite+0xc0>
        f->off += r;
    8000472e:	02092783          	lw	a5,32(s2)
    80004732:	9fa9                	addw	a5,a5,a0
    80004734:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004738:	01893503          	ld	a0,24(s2)
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	f98080e7          	jalr	-104(ra) # 800036d4 <iunlock>
      end_op();
    80004744:	00000097          	auipc	ra,0x0
    80004748:	8ee080e7          	jalr	-1810(ra) # 80004032 <end_op>

      if(r != n1){
    8000474c:	009a9f63          	bne	s5,s1,8000476a <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80004750:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004754:	0149db63          	bge	s3,s4,8000476a <filewrite+0xf2>
      int n1 = n - i;
    80004758:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000475c:	0004879b          	sext.w	a5,s1
    80004760:	f8fbdce3          	bge	s7,a5,800046f8 <filewrite+0x80>
    80004764:	84e2                	mv	s1,s8
    80004766:	bf49                	j	800046f8 <filewrite+0x80>
    int i = 0;
    80004768:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000476a:	033a1d63          	bne	s4,s3,800047a4 <filewrite+0x12c>
    8000476e:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004770:	60a6                	ld	ra,72(sp)
    80004772:	6406                	ld	s0,64(sp)
    80004774:	74e2                	ld	s1,56(sp)
    80004776:	7942                	ld	s2,48(sp)
    80004778:	79a2                	ld	s3,40(sp)
    8000477a:	7a02                	ld	s4,32(sp)
    8000477c:	6ae2                	ld	s5,24(sp)
    8000477e:	6b42                	ld	s6,16(sp)
    80004780:	6ba2                	ld	s7,8(sp)
    80004782:	6c02                	ld	s8,0(sp)
    80004784:	6161                	addi	sp,sp,80
    80004786:	8082                	ret
    panic("filewrite");
    80004788:	00004517          	auipc	a0,0x4
    8000478c:	f5050513          	addi	a0,a0,-176 # 800086d8 <syscalls+0x268>
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	dac080e7          	jalr	-596(ra) # 8000053c <panic>
    return -1;
    80004798:	557d                	li	a0,-1
}
    8000479a:	8082                	ret
      return -1;
    8000479c:	557d                	li	a0,-1
    8000479e:	bfc9                	j	80004770 <filewrite+0xf8>
    800047a0:	557d                	li	a0,-1
    800047a2:	b7f9                	j	80004770 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    800047a4:	557d                	li	a0,-1
    800047a6:	b7e9                	j	80004770 <filewrite+0xf8>

00000000800047a8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047a8:	7179                	addi	sp,sp,-48
    800047aa:	f406                	sd	ra,40(sp)
    800047ac:	f022                	sd	s0,32(sp)
    800047ae:	ec26                	sd	s1,24(sp)
    800047b0:	e84a                	sd	s2,16(sp)
    800047b2:	e44e                	sd	s3,8(sp)
    800047b4:	e052                	sd	s4,0(sp)
    800047b6:	1800                	addi	s0,sp,48
    800047b8:	84aa                	mv	s1,a0
    800047ba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047bc:	0005b023          	sd	zero,0(a1)
    800047c0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	bfc080e7          	jalr	-1028(ra) # 800043c0 <filealloc>
    800047cc:	e088                	sd	a0,0(s1)
    800047ce:	c551                	beqz	a0,8000485a <pipealloc+0xb2>
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	bf0080e7          	jalr	-1040(ra) # 800043c0 <filealloc>
    800047d8:	00aa3023          	sd	a0,0(s4)
    800047dc:	c92d                	beqz	a0,8000484e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047de:	ffffc097          	auipc	ra,0xffffc
    800047e2:	304080e7          	jalr	772(ra) # 80000ae2 <kalloc>
    800047e6:	892a                	mv	s2,a0
    800047e8:	c125                	beqz	a0,80004848 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800047ea:	4985                	li	s3,1
    800047ec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047f0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047f4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800047f8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800047fc:	00004597          	auipc	a1,0x4
    80004800:	eec58593          	addi	a1,a1,-276 # 800086e8 <syscalls+0x278>
    80004804:	ffffc097          	auipc	ra,0xffffc
    80004808:	33e080e7          	jalr	830(ra) # 80000b42 <initlock>
  (*f0)->type = FD_PIPE;
    8000480c:	609c                	ld	a5,0(s1)
    8000480e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004812:	609c                	ld	a5,0(s1)
    80004814:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004818:	609c                	ld	a5,0(s1)
    8000481a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000481e:	609c                	ld	a5,0(s1)
    80004820:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004824:	000a3783          	ld	a5,0(s4)
    80004828:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000482c:	000a3783          	ld	a5,0(s4)
    80004830:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004834:	000a3783          	ld	a5,0(s4)
    80004838:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000483c:	000a3783          	ld	a5,0(s4)
    80004840:	0127b823          	sd	s2,16(a5)
  return 0;
    80004844:	4501                	li	a0,0
    80004846:	a025                	j	8000486e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004848:	6088                	ld	a0,0(s1)
    8000484a:	e501                	bnez	a0,80004852 <pipealloc+0xaa>
    8000484c:	a039                	j	8000485a <pipealloc+0xb2>
    8000484e:	6088                	ld	a0,0(s1)
    80004850:	c51d                	beqz	a0,8000487e <pipealloc+0xd6>
    fileclose(*f0);
    80004852:	00000097          	auipc	ra,0x0
    80004856:	c2a080e7          	jalr	-982(ra) # 8000447c <fileclose>
  if(*f1)
    8000485a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000485e:	557d                	li	a0,-1
  if(*f1)
    80004860:	c799                	beqz	a5,8000486e <pipealloc+0xc6>
    fileclose(*f1);
    80004862:	853e                	mv	a0,a5
    80004864:	00000097          	auipc	ra,0x0
    80004868:	c18080e7          	jalr	-1000(ra) # 8000447c <fileclose>
  return -1;
    8000486c:	557d                	li	a0,-1
}
    8000486e:	70a2                	ld	ra,40(sp)
    80004870:	7402                	ld	s0,32(sp)
    80004872:	64e2                	ld	s1,24(sp)
    80004874:	6942                	ld	s2,16(sp)
    80004876:	69a2                	ld	s3,8(sp)
    80004878:	6a02                	ld	s4,0(sp)
    8000487a:	6145                	addi	sp,sp,48
    8000487c:	8082                	ret
  return -1;
    8000487e:	557d                	li	a0,-1
    80004880:	b7fd                	j	8000486e <pipealloc+0xc6>

0000000080004882 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004882:	1101                	addi	sp,sp,-32
    80004884:	ec06                	sd	ra,24(sp)
    80004886:	e822                	sd	s0,16(sp)
    80004888:	e426                	sd	s1,8(sp)
    8000488a:	e04a                	sd	s2,0(sp)
    8000488c:	1000                	addi	s0,sp,32
    8000488e:	84aa                	mv	s1,a0
    80004890:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004892:	ffffc097          	auipc	ra,0xffffc
    80004896:	340080e7          	jalr	832(ra) # 80000bd2 <acquire>
  if(writable){
    8000489a:	02090d63          	beqz	s2,800048d4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000489e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048a2:	21848513          	addi	a0,s1,536
    800048a6:	ffffd097          	auipc	ra,0xffffd
    800048aa:	7fc080e7          	jalr	2044(ra) # 800020a2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048ae:	2204b783          	ld	a5,544(s1)
    800048b2:	eb95                	bnez	a5,800048e6 <pipeclose+0x64>
    release(&pi->lock);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	3d0080e7          	jalr	976(ra) # 80000c86 <release>
    kfree((char*)pi);
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	124080e7          	jalr	292(ra) # 800009e4 <kfree>
  } else
    release(&pi->lock);
}
    800048c8:	60e2                	ld	ra,24(sp)
    800048ca:	6442                	ld	s0,16(sp)
    800048cc:	64a2                	ld	s1,8(sp)
    800048ce:	6902                	ld	s2,0(sp)
    800048d0:	6105                	addi	sp,sp,32
    800048d2:	8082                	ret
    pi->readopen = 0;
    800048d4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048d8:	21c48513          	addi	a0,s1,540
    800048dc:	ffffd097          	auipc	ra,0xffffd
    800048e0:	7c6080e7          	jalr	1990(ra) # 800020a2 <wakeup>
    800048e4:	b7e9                	j	800048ae <pipeclose+0x2c>
    release(&pi->lock);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffc097          	auipc	ra,0xffffc
    800048ec:	39e080e7          	jalr	926(ra) # 80000c86 <release>
}
    800048f0:	bfe1                	j	800048c8 <pipeclose+0x46>

00000000800048f2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800048f2:	711d                	addi	sp,sp,-96
    800048f4:	ec86                	sd	ra,88(sp)
    800048f6:	e8a2                	sd	s0,80(sp)
    800048f8:	e4a6                	sd	s1,72(sp)
    800048fa:	e0ca                	sd	s2,64(sp)
    800048fc:	fc4e                	sd	s3,56(sp)
    800048fe:	f852                	sd	s4,48(sp)
    80004900:	f456                	sd	s5,40(sp)
    80004902:	f05a                	sd	s6,32(sp)
    80004904:	ec5e                	sd	s7,24(sp)
    80004906:	e862                	sd	s8,16(sp)
    80004908:	1080                	addi	s0,sp,96
    8000490a:	84aa                	mv	s1,a0
    8000490c:	8aae                	mv	s5,a1
    8000490e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004910:	ffffd097          	auipc	ra,0xffffd
    80004914:	086080e7          	jalr	134(ra) # 80001996 <myproc>
    80004918:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffc097          	auipc	ra,0xffffc
    80004920:	2b6080e7          	jalr	694(ra) # 80000bd2 <acquire>
  while(i < n){
    80004924:	0b405663          	blez	s4,800049d0 <pipewrite+0xde>
  int i = 0;
    80004928:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000492a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000492c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004930:	21c48b93          	addi	s7,s1,540
    80004934:	a089                	j	80004976 <pipewrite+0x84>
      release(&pi->lock);
    80004936:	8526                	mv	a0,s1
    80004938:	ffffc097          	auipc	ra,0xffffc
    8000493c:	34e080e7          	jalr	846(ra) # 80000c86 <release>
      return -1;
    80004940:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004942:	854a                	mv	a0,s2
    80004944:	60e6                	ld	ra,88(sp)
    80004946:	6446                	ld	s0,80(sp)
    80004948:	64a6                	ld	s1,72(sp)
    8000494a:	6906                	ld	s2,64(sp)
    8000494c:	79e2                	ld	s3,56(sp)
    8000494e:	7a42                	ld	s4,48(sp)
    80004950:	7aa2                	ld	s5,40(sp)
    80004952:	7b02                	ld	s6,32(sp)
    80004954:	6be2                	ld	s7,24(sp)
    80004956:	6c42                	ld	s8,16(sp)
    80004958:	6125                	addi	sp,sp,96
    8000495a:	8082                	ret
      wakeup(&pi->nread);
    8000495c:	8562                	mv	a0,s8
    8000495e:	ffffd097          	auipc	ra,0xffffd
    80004962:	744080e7          	jalr	1860(ra) # 800020a2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004966:	85a6                	mv	a1,s1
    80004968:	855e                	mv	a0,s7
    8000496a:	ffffd097          	auipc	ra,0xffffd
    8000496e:	6d4080e7          	jalr	1748(ra) # 8000203e <sleep>
  while(i < n){
    80004972:	07495063          	bge	s2,s4,800049d2 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004976:	2204a783          	lw	a5,544(s1)
    8000497a:	dfd5                	beqz	a5,80004936 <pipewrite+0x44>
    8000497c:	854e                	mv	a0,s3
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	968080e7          	jalr	-1688(ra) # 800022e6 <killed>
    80004986:	f945                	bnez	a0,80004936 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004988:	2184a783          	lw	a5,536(s1)
    8000498c:	21c4a703          	lw	a4,540(s1)
    80004990:	2007879b          	addiw	a5,a5,512
    80004994:	fcf704e3          	beq	a4,a5,8000495c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004998:	4685                	li	a3,1
    8000499a:	01590633          	add	a2,s2,s5
    8000499e:	faf40593          	addi	a1,s0,-81
    800049a2:	0509b503          	ld	a0,80(s3)
    800049a6:	ffffd097          	auipc	ra,0xffffd
    800049aa:	d3c080e7          	jalr	-708(ra) # 800016e2 <copyin>
    800049ae:	03650263          	beq	a0,s6,800049d2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049b2:	21c4a783          	lw	a5,540(s1)
    800049b6:	0017871b          	addiw	a4,a5,1
    800049ba:	20e4ae23          	sw	a4,540(s1)
    800049be:	1ff7f793          	andi	a5,a5,511
    800049c2:	97a6                	add	a5,a5,s1
    800049c4:	faf44703          	lbu	a4,-81(s0)
    800049c8:	00e78c23          	sb	a4,24(a5)
      i++;
    800049cc:	2905                	addiw	s2,s2,1
    800049ce:	b755                	j	80004972 <pipewrite+0x80>
  int i = 0;
    800049d0:	4901                	li	s2,0
  wakeup(&pi->nread);
    800049d2:	21848513          	addi	a0,s1,536
    800049d6:	ffffd097          	auipc	ra,0xffffd
    800049da:	6cc080e7          	jalr	1740(ra) # 800020a2 <wakeup>
  release(&pi->lock);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffc097          	auipc	ra,0xffffc
    800049e4:	2a6080e7          	jalr	678(ra) # 80000c86 <release>
  return i;
    800049e8:	bfa9                	j	80004942 <pipewrite+0x50>

00000000800049ea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049ea:	715d                	addi	sp,sp,-80
    800049ec:	e486                	sd	ra,72(sp)
    800049ee:	e0a2                	sd	s0,64(sp)
    800049f0:	fc26                	sd	s1,56(sp)
    800049f2:	f84a                	sd	s2,48(sp)
    800049f4:	f44e                	sd	s3,40(sp)
    800049f6:	f052                	sd	s4,32(sp)
    800049f8:	ec56                	sd	s5,24(sp)
    800049fa:	e85a                	sd	s6,16(sp)
    800049fc:	0880                	addi	s0,sp,80
    800049fe:	84aa                	mv	s1,a0
    80004a00:	892e                	mv	s2,a1
    80004a02:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a04:	ffffd097          	auipc	ra,0xffffd
    80004a08:	f92080e7          	jalr	-110(ra) # 80001996 <myproc>
    80004a0c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffc097          	auipc	ra,0xffffc
    80004a14:	1c2080e7          	jalr	450(ra) # 80000bd2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a18:	2184a703          	lw	a4,536(s1)
    80004a1c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a20:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a24:	02f71763          	bne	a4,a5,80004a52 <piperead+0x68>
    80004a28:	2244a783          	lw	a5,548(s1)
    80004a2c:	c39d                	beqz	a5,80004a52 <piperead+0x68>
    if(killed(pr)){
    80004a2e:	8552                	mv	a0,s4
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	8b6080e7          	jalr	-1866(ra) # 800022e6 <killed>
    80004a38:	e949                	bnez	a0,80004aca <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a3a:	85a6                	mv	a1,s1
    80004a3c:	854e                	mv	a0,s3
    80004a3e:	ffffd097          	auipc	ra,0xffffd
    80004a42:	600080e7          	jalr	1536(ra) # 8000203e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a46:	2184a703          	lw	a4,536(s1)
    80004a4a:	21c4a783          	lw	a5,540(s1)
    80004a4e:	fcf70de3          	beq	a4,a5,80004a28 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a52:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a54:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a56:	05505463          	blez	s5,80004a9e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004a5a:	2184a783          	lw	a5,536(s1)
    80004a5e:	21c4a703          	lw	a4,540(s1)
    80004a62:	02f70e63          	beq	a4,a5,80004a9e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a66:	0017871b          	addiw	a4,a5,1
    80004a6a:	20e4ac23          	sw	a4,536(s1)
    80004a6e:	1ff7f793          	andi	a5,a5,511
    80004a72:	97a6                	add	a5,a5,s1
    80004a74:	0187c783          	lbu	a5,24(a5)
    80004a78:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a7c:	4685                	li	a3,1
    80004a7e:	fbf40613          	addi	a2,s0,-65
    80004a82:	85ca                	mv	a1,s2
    80004a84:	050a3503          	ld	a0,80(s4)
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	bce080e7          	jalr	-1074(ra) # 80001656 <copyout>
    80004a90:	01650763          	beq	a0,s6,80004a9e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a94:	2985                	addiw	s3,s3,1
    80004a96:	0905                	addi	s2,s2,1
    80004a98:	fd3a91e3          	bne	s5,s3,80004a5a <piperead+0x70>
    80004a9c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a9e:	21c48513          	addi	a0,s1,540
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	600080e7          	jalr	1536(ra) # 800020a2 <wakeup>
  release(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	1da080e7          	jalr	474(ra) # 80000c86 <release>
  return i;
}
    80004ab4:	854e                	mv	a0,s3
    80004ab6:	60a6                	ld	ra,72(sp)
    80004ab8:	6406                	ld	s0,64(sp)
    80004aba:	74e2                	ld	s1,56(sp)
    80004abc:	7942                	ld	s2,48(sp)
    80004abe:	79a2                	ld	s3,40(sp)
    80004ac0:	7a02                	ld	s4,32(sp)
    80004ac2:	6ae2                	ld	s5,24(sp)
    80004ac4:	6b42                	ld	s6,16(sp)
    80004ac6:	6161                	addi	sp,sp,80
    80004ac8:	8082                	ret
      release(&pi->lock);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffc097          	auipc	ra,0xffffc
    80004ad0:	1ba080e7          	jalr	442(ra) # 80000c86 <release>
      return -1;
    80004ad4:	59fd                	li	s3,-1
    80004ad6:	bff9                	j	80004ab4 <piperead+0xca>

0000000080004ad8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004ad8:	1141                	addi	sp,sp,-16
    80004ada:	e422                	sd	s0,8(sp)
    80004adc:	0800                	addi	s0,sp,16
    80004ade:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004ae0:	8905                	andi	a0,a0,1
    80004ae2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004ae4:	8b89                	andi	a5,a5,2
    80004ae6:	c399                	beqz	a5,80004aec <flags2perm+0x14>
      perm |= PTE_W;
    80004ae8:	00456513          	ori	a0,a0,4
    return perm;
}
    80004aec:	6422                	ld	s0,8(sp)
    80004aee:	0141                	addi	sp,sp,16
    80004af0:	8082                	ret

0000000080004af2 <exec>:

int
exec(char *path, char **argv)
{
    80004af2:	df010113          	addi	sp,sp,-528
    80004af6:	20113423          	sd	ra,520(sp)
    80004afa:	20813023          	sd	s0,512(sp)
    80004afe:	ffa6                	sd	s1,504(sp)
    80004b00:	fbca                	sd	s2,496(sp)
    80004b02:	f7ce                	sd	s3,488(sp)
    80004b04:	f3d2                	sd	s4,480(sp)
    80004b06:	efd6                	sd	s5,472(sp)
    80004b08:	ebda                	sd	s6,464(sp)
    80004b0a:	e7de                	sd	s7,456(sp)
    80004b0c:	e3e2                	sd	s8,448(sp)
    80004b0e:	ff66                	sd	s9,440(sp)
    80004b10:	fb6a                	sd	s10,432(sp)
    80004b12:	f76e                	sd	s11,424(sp)
    80004b14:	0c00                	addi	s0,sp,528
    80004b16:	892a                	mv	s2,a0
    80004b18:	dea43c23          	sd	a0,-520(s0)
    80004b1c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b20:	ffffd097          	auipc	ra,0xffffd
    80004b24:	e76080e7          	jalr	-394(ra) # 80001996 <myproc>
    80004b28:	84aa                	mv	s1,a0

  begin_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	48e080e7          	jalr	1166(ra) # 80003fb8 <begin_op>

  if((ip = namei(path)) == 0){
    80004b32:	854a                	mv	a0,s2
    80004b34:	fffff097          	auipc	ra,0xfffff
    80004b38:	284080e7          	jalr	644(ra) # 80003db8 <namei>
    80004b3c:	c92d                	beqz	a0,80004bae <exec+0xbc>
    80004b3e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	ad2080e7          	jalr	-1326(ra) # 80003612 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b48:	04000713          	li	a4,64
    80004b4c:	4681                	li	a3,0
    80004b4e:	e5040613          	addi	a2,s0,-432
    80004b52:	4581                	li	a1,0
    80004b54:	8552                	mv	a0,s4
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	d70080e7          	jalr	-656(ra) # 800038c6 <readi>
    80004b5e:	04000793          	li	a5,64
    80004b62:	00f51a63          	bne	a0,a5,80004b76 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004b66:	e5042703          	lw	a4,-432(s0)
    80004b6a:	464c47b7          	lui	a5,0x464c4
    80004b6e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b72:	04f70463          	beq	a4,a5,80004bba <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b76:	8552                	mv	a0,s4
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	cfc080e7          	jalr	-772(ra) # 80003874 <iunlockput>
    end_op();
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	4b2080e7          	jalr	1202(ra) # 80004032 <end_op>
  }
  return -1;
    80004b88:	557d                	li	a0,-1
}
    80004b8a:	20813083          	ld	ra,520(sp)
    80004b8e:	20013403          	ld	s0,512(sp)
    80004b92:	74fe                	ld	s1,504(sp)
    80004b94:	795e                	ld	s2,496(sp)
    80004b96:	79be                	ld	s3,488(sp)
    80004b98:	7a1e                	ld	s4,480(sp)
    80004b9a:	6afe                	ld	s5,472(sp)
    80004b9c:	6b5e                	ld	s6,464(sp)
    80004b9e:	6bbe                	ld	s7,456(sp)
    80004ba0:	6c1e                	ld	s8,448(sp)
    80004ba2:	7cfa                	ld	s9,440(sp)
    80004ba4:	7d5a                	ld	s10,432(sp)
    80004ba6:	7dba                	ld	s11,424(sp)
    80004ba8:	21010113          	addi	sp,sp,528
    80004bac:	8082                	ret
    end_op();
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	484080e7          	jalr	1156(ra) # 80004032 <end_op>
    return -1;
    80004bb6:	557d                	li	a0,-1
    80004bb8:	bfc9                	j	80004b8a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004bba:	8526                	mv	a0,s1
    80004bbc:	ffffd097          	auipc	ra,0xffffd
    80004bc0:	e9e080e7          	jalr	-354(ra) # 80001a5a <proc_pagetable>
    80004bc4:	8b2a                	mv	s6,a0
    80004bc6:	d945                	beqz	a0,80004b76 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bc8:	e7042d03          	lw	s10,-400(s0)
    80004bcc:	e8845783          	lhu	a5,-376(s0)
    80004bd0:	10078463          	beqz	a5,80004cd8 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004bd4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bd6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004bd8:	6c85                	lui	s9,0x1
    80004bda:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004bde:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004be2:	6a85                	lui	s5,0x1
    80004be4:	a0b5                	j	80004c50 <exec+0x15e>
      panic("loadseg: address should exist");
    80004be6:	00004517          	auipc	a0,0x4
    80004bea:	b0a50513          	addi	a0,a0,-1270 # 800086f0 <syscalls+0x280>
    80004bee:	ffffc097          	auipc	ra,0xffffc
    80004bf2:	94e080e7          	jalr	-1714(ra) # 8000053c <panic>
    if(sz - i < PGSIZE)
    80004bf6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004bf8:	8726                	mv	a4,s1
    80004bfa:	012c06bb          	addw	a3,s8,s2
    80004bfe:	4581                	li	a1,0
    80004c00:	8552                	mv	a0,s4
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	cc4080e7          	jalr	-828(ra) # 800038c6 <readi>
    80004c0a:	2501                	sext.w	a0,a0
    80004c0c:	24a49863          	bne	s1,a0,80004e5c <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004c10:	012a893b          	addw	s2,s5,s2
    80004c14:	03397563          	bgeu	s2,s3,80004c3e <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004c18:	02091593          	slli	a1,s2,0x20
    80004c1c:	9181                	srli	a1,a1,0x20
    80004c1e:	95de                	add	a1,a1,s7
    80004c20:	855a                	mv	a0,s6
    80004c22:	ffffc097          	auipc	ra,0xffffc
    80004c26:	424080e7          	jalr	1060(ra) # 80001046 <walkaddr>
    80004c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80004c2c:	dd4d                	beqz	a0,80004be6 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004c2e:	412984bb          	subw	s1,s3,s2
    80004c32:	0004879b          	sext.w	a5,s1
    80004c36:	fcfcf0e3          	bgeu	s9,a5,80004bf6 <exec+0x104>
    80004c3a:	84d6                	mv	s1,s5
    80004c3c:	bf6d                	j	80004bf6 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c3e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c42:	2d85                	addiw	s11,s11,1
    80004c44:	038d0d1b          	addiw	s10,s10,56
    80004c48:	e8845783          	lhu	a5,-376(s0)
    80004c4c:	08fdd763          	bge	s11,a5,80004cda <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c50:	2d01                	sext.w	s10,s10
    80004c52:	03800713          	li	a4,56
    80004c56:	86ea                	mv	a3,s10
    80004c58:	e1840613          	addi	a2,s0,-488
    80004c5c:	4581                	li	a1,0
    80004c5e:	8552                	mv	a0,s4
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	c66080e7          	jalr	-922(ra) # 800038c6 <readi>
    80004c68:	03800793          	li	a5,56
    80004c6c:	1ef51663          	bne	a0,a5,80004e58 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004c70:	e1842783          	lw	a5,-488(s0)
    80004c74:	4705                	li	a4,1
    80004c76:	fce796e3          	bne	a5,a4,80004c42 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004c7a:	e4043483          	ld	s1,-448(s0)
    80004c7e:	e3843783          	ld	a5,-456(s0)
    80004c82:	1ef4e863          	bltu	s1,a5,80004e72 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c86:	e2843783          	ld	a5,-472(s0)
    80004c8a:	94be                	add	s1,s1,a5
    80004c8c:	1ef4e663          	bltu	s1,a5,80004e78 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004c90:	df043703          	ld	a4,-528(s0)
    80004c94:	8ff9                	and	a5,a5,a4
    80004c96:	1e079463          	bnez	a5,80004e7e <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c9a:	e1c42503          	lw	a0,-484(s0)
    80004c9e:	00000097          	auipc	ra,0x0
    80004ca2:	e3a080e7          	jalr	-454(ra) # 80004ad8 <flags2perm>
    80004ca6:	86aa                	mv	a3,a0
    80004ca8:	8626                	mv	a2,s1
    80004caa:	85ca                	mv	a1,s2
    80004cac:	855a                	mv	a0,s6
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	74c080e7          	jalr	1868(ra) # 800013fa <uvmalloc>
    80004cb6:	e0a43423          	sd	a0,-504(s0)
    80004cba:	1c050563          	beqz	a0,80004e84 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cbe:	e2843b83          	ld	s7,-472(s0)
    80004cc2:	e2042c03          	lw	s8,-480(s0)
    80004cc6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004cca:	00098463          	beqz	s3,80004cd2 <exec+0x1e0>
    80004cce:	4901                	li	s2,0
    80004cd0:	b7a1                	j	80004c18 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004cd2:	e0843903          	ld	s2,-504(s0)
    80004cd6:	b7b5                	j	80004c42 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cd8:	4901                	li	s2,0
  iunlockput(ip);
    80004cda:	8552                	mv	a0,s4
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	b98080e7          	jalr	-1128(ra) # 80003874 <iunlockput>
  end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	34e080e7          	jalr	846(ra) # 80004032 <end_op>
  p = myproc();
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	caa080e7          	jalr	-854(ra) # 80001996 <myproc>
    80004cf4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004cf6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004cfa:	6985                	lui	s3,0x1
    80004cfc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004cfe:	99ca                	add	s3,s3,s2
    80004d00:	77fd                	lui	a5,0xfffff
    80004d02:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004d06:	4691                	li	a3,4
    80004d08:	6609                	lui	a2,0x2
    80004d0a:	964e                	add	a2,a2,s3
    80004d0c:	85ce                	mv	a1,s3
    80004d0e:	855a                	mv	a0,s6
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	6ea080e7          	jalr	1770(ra) # 800013fa <uvmalloc>
    80004d18:	892a                	mv	s2,a0
    80004d1a:	e0a43423          	sd	a0,-504(s0)
    80004d1e:	e509                	bnez	a0,80004d28 <exec+0x236>
  if(pagetable)
    80004d20:	e1343423          	sd	s3,-504(s0)
    80004d24:	4a01                	li	s4,0
    80004d26:	aa1d                	j	80004e5c <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d28:	75f9                	lui	a1,0xffffe
    80004d2a:	95aa                	add	a1,a1,a0
    80004d2c:	855a                	mv	a0,s6
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	8f6080e7          	jalr	-1802(ra) # 80001624 <uvmclear>
  stackbase = sp - PGSIZE;
    80004d36:	7bfd                	lui	s7,0xfffff
    80004d38:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004d3a:	e0043783          	ld	a5,-512(s0)
    80004d3e:	6388                	ld	a0,0(a5)
    80004d40:	c52d                	beqz	a0,80004daa <exec+0x2b8>
    80004d42:	e9040993          	addi	s3,s0,-368
    80004d46:	f9040c13          	addi	s8,s0,-112
    80004d4a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	0fc080e7          	jalr	252(ra) # 80000e48 <strlen>
    80004d54:	0015079b          	addiw	a5,a0,1
    80004d58:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d5c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004d60:	13796563          	bltu	s2,s7,80004e8a <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d64:	e0043d03          	ld	s10,-512(s0)
    80004d68:	000d3a03          	ld	s4,0(s10)
    80004d6c:	8552                	mv	a0,s4
    80004d6e:	ffffc097          	auipc	ra,0xffffc
    80004d72:	0da080e7          	jalr	218(ra) # 80000e48 <strlen>
    80004d76:	0015069b          	addiw	a3,a0,1
    80004d7a:	8652                	mv	a2,s4
    80004d7c:	85ca                	mv	a1,s2
    80004d7e:	855a                	mv	a0,s6
    80004d80:	ffffd097          	auipc	ra,0xffffd
    80004d84:	8d6080e7          	jalr	-1834(ra) # 80001656 <copyout>
    80004d88:	10054363          	bltz	a0,80004e8e <exec+0x39c>
    ustack[argc] = sp;
    80004d8c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d90:	0485                	addi	s1,s1,1
    80004d92:	008d0793          	addi	a5,s10,8
    80004d96:	e0f43023          	sd	a5,-512(s0)
    80004d9a:	008d3503          	ld	a0,8(s10)
    80004d9e:	c909                	beqz	a0,80004db0 <exec+0x2be>
    if(argc >= MAXARG)
    80004da0:	09a1                	addi	s3,s3,8
    80004da2:	fb8995e3          	bne	s3,s8,80004d4c <exec+0x25a>
  ip = 0;
    80004da6:	4a01                	li	s4,0
    80004da8:	a855                	j	80004e5c <exec+0x36a>
  sp = sz;
    80004daa:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004dae:	4481                	li	s1,0
  ustack[argc] = 0;
    80004db0:	00349793          	slli	a5,s1,0x3
    80004db4:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd230>
    80004db8:	97a2                	add	a5,a5,s0
    80004dba:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004dbe:	00148693          	addi	a3,s1,1
    80004dc2:	068e                	slli	a3,a3,0x3
    80004dc4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004dc8:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004dcc:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004dd0:	f57968e3          	bltu	s2,s7,80004d20 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004dd4:	e9040613          	addi	a2,s0,-368
    80004dd8:	85ca                	mv	a1,s2
    80004dda:	855a                	mv	a0,s6
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	87a080e7          	jalr	-1926(ra) # 80001656 <copyout>
    80004de4:	0a054763          	bltz	a0,80004e92 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004de8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004dec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004df0:	df843783          	ld	a5,-520(s0)
    80004df4:	0007c703          	lbu	a4,0(a5)
    80004df8:	cf11                	beqz	a4,80004e14 <exec+0x322>
    80004dfa:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004dfc:	02f00693          	li	a3,47
    80004e00:	a039                	j	80004e0e <exec+0x31c>
      last = s+1;
    80004e02:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004e06:	0785                	addi	a5,a5,1
    80004e08:	fff7c703          	lbu	a4,-1(a5)
    80004e0c:	c701                	beqz	a4,80004e14 <exec+0x322>
    if(*s == '/')
    80004e0e:	fed71ce3          	bne	a4,a3,80004e06 <exec+0x314>
    80004e12:	bfc5                	j	80004e02 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e14:	4641                	li	a2,16
    80004e16:	df843583          	ld	a1,-520(s0)
    80004e1a:	158a8513          	addi	a0,s5,344
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	ff8080e7          	jalr	-8(ra) # 80000e16 <safestrcpy>
  oldpagetable = p->pagetable;
    80004e26:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004e2a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004e2e:	e0843783          	ld	a5,-504(s0)
    80004e32:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004e36:	058ab783          	ld	a5,88(s5)
    80004e3a:	e6843703          	ld	a4,-408(s0)
    80004e3e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e40:	058ab783          	ld	a5,88(s5)
    80004e44:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e48:	85e6                	mv	a1,s9
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	cac080e7          	jalr	-852(ra) # 80001af6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e52:	0004851b          	sext.w	a0,s1
    80004e56:	bb15                	j	80004b8a <exec+0x98>
    80004e58:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004e5c:	e0843583          	ld	a1,-504(s0)
    80004e60:	855a                	mv	a0,s6
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	c94080e7          	jalr	-876(ra) # 80001af6 <proc_freepagetable>
  return -1;
    80004e6a:	557d                	li	a0,-1
  if(ip){
    80004e6c:	d00a0fe3          	beqz	s4,80004b8a <exec+0x98>
    80004e70:	b319                	j	80004b76 <exec+0x84>
    80004e72:	e1243423          	sd	s2,-504(s0)
    80004e76:	b7dd                	j	80004e5c <exec+0x36a>
    80004e78:	e1243423          	sd	s2,-504(s0)
    80004e7c:	b7c5                	j	80004e5c <exec+0x36a>
    80004e7e:	e1243423          	sd	s2,-504(s0)
    80004e82:	bfe9                	j	80004e5c <exec+0x36a>
    80004e84:	e1243423          	sd	s2,-504(s0)
    80004e88:	bfd1                	j	80004e5c <exec+0x36a>
  ip = 0;
    80004e8a:	4a01                	li	s4,0
    80004e8c:	bfc1                	j	80004e5c <exec+0x36a>
    80004e8e:	4a01                	li	s4,0
  if(pagetable)
    80004e90:	b7f1                	j	80004e5c <exec+0x36a>
  sz = sz1;
    80004e92:	e0843983          	ld	s3,-504(s0)
    80004e96:	b569                	j	80004d20 <exec+0x22e>

0000000080004e98 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e98:	7179                	addi	sp,sp,-48
    80004e9a:	f406                	sd	ra,40(sp)
    80004e9c:	f022                	sd	s0,32(sp)
    80004e9e:	ec26                	sd	s1,24(sp)
    80004ea0:	e84a                	sd	s2,16(sp)
    80004ea2:	1800                	addi	s0,sp,48
    80004ea4:	892e                	mv	s2,a1
    80004ea6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004ea8:	fdc40593          	addi	a1,s0,-36
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	c04080e7          	jalr	-1020(ra) # 80002ab0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004eb4:	fdc42703          	lw	a4,-36(s0)
    80004eb8:	47bd                	li	a5,15
    80004eba:	02e7eb63          	bltu	a5,a4,80004ef0 <argfd+0x58>
    80004ebe:	ffffd097          	auipc	ra,0xffffd
    80004ec2:	ad8080e7          	jalr	-1320(ra) # 80001996 <myproc>
    80004ec6:	fdc42703          	lw	a4,-36(s0)
    80004eca:	01a70793          	addi	a5,a4,26
    80004ece:	078e                	slli	a5,a5,0x3
    80004ed0:	953e                	add	a0,a0,a5
    80004ed2:	611c                	ld	a5,0(a0)
    80004ed4:	c385                	beqz	a5,80004ef4 <argfd+0x5c>
    return -1;
  if(pfd)
    80004ed6:	00090463          	beqz	s2,80004ede <argfd+0x46>
    *pfd = fd;
    80004eda:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ede:	4501                	li	a0,0
  if(pf)
    80004ee0:	c091                	beqz	s1,80004ee4 <argfd+0x4c>
    *pf = f;
    80004ee2:	e09c                	sd	a5,0(s1)
}
    80004ee4:	70a2                	ld	ra,40(sp)
    80004ee6:	7402                	ld	s0,32(sp)
    80004ee8:	64e2                	ld	s1,24(sp)
    80004eea:	6942                	ld	s2,16(sp)
    80004eec:	6145                	addi	sp,sp,48
    80004eee:	8082                	ret
    return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	bfcd                	j	80004ee4 <argfd+0x4c>
    80004ef4:	557d                	li	a0,-1
    80004ef6:	b7fd                	j	80004ee4 <argfd+0x4c>

0000000080004ef8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ef8:	1101                	addi	sp,sp,-32
    80004efa:	ec06                	sd	ra,24(sp)
    80004efc:	e822                	sd	s0,16(sp)
    80004efe:	e426                	sd	s1,8(sp)
    80004f00:	1000                	addi	s0,sp,32
    80004f02:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	a92080e7          	jalr	-1390(ra) # 80001996 <myproc>
    80004f0c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f0e:	0d050793          	addi	a5,a0,208
    80004f12:	4501                	li	a0,0
    80004f14:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f16:	6398                	ld	a4,0(a5)
    80004f18:	cb19                	beqz	a4,80004f2e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f1a:	2505                	addiw	a0,a0,1
    80004f1c:	07a1                	addi	a5,a5,8
    80004f1e:	fed51ce3          	bne	a0,a3,80004f16 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f22:	557d                	li	a0,-1
}
    80004f24:	60e2                	ld	ra,24(sp)
    80004f26:	6442                	ld	s0,16(sp)
    80004f28:	64a2                	ld	s1,8(sp)
    80004f2a:	6105                	addi	sp,sp,32
    80004f2c:	8082                	ret
      p->ofile[fd] = f;
    80004f2e:	01a50793          	addi	a5,a0,26
    80004f32:	078e                	slli	a5,a5,0x3
    80004f34:	963e                	add	a2,a2,a5
    80004f36:	e204                	sd	s1,0(a2)
      return fd;
    80004f38:	b7f5                	j	80004f24 <fdalloc+0x2c>

0000000080004f3a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f3a:	715d                	addi	sp,sp,-80
    80004f3c:	e486                	sd	ra,72(sp)
    80004f3e:	e0a2                	sd	s0,64(sp)
    80004f40:	fc26                	sd	s1,56(sp)
    80004f42:	f84a                	sd	s2,48(sp)
    80004f44:	f44e                	sd	s3,40(sp)
    80004f46:	f052                	sd	s4,32(sp)
    80004f48:	ec56                	sd	s5,24(sp)
    80004f4a:	e85a                	sd	s6,16(sp)
    80004f4c:	0880                	addi	s0,sp,80
    80004f4e:	8b2e                	mv	s6,a1
    80004f50:	89b2                	mv	s3,a2
    80004f52:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f54:	fb040593          	addi	a1,s0,-80
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	e7e080e7          	jalr	-386(ra) # 80003dd6 <nameiparent>
    80004f60:	84aa                	mv	s1,a0
    80004f62:	14050b63          	beqz	a0,800050b8 <create+0x17e>
    return 0;

  ilock(dp);
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	6ac080e7          	jalr	1708(ra) # 80003612 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f6e:	4601                	li	a2,0
    80004f70:	fb040593          	addi	a1,s0,-80
    80004f74:	8526                	mv	a0,s1
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	b80080e7          	jalr	-1152(ra) # 80003af6 <dirlookup>
    80004f7e:	8aaa                	mv	s5,a0
    80004f80:	c921                	beqz	a0,80004fd0 <create+0x96>
    iunlockput(dp);
    80004f82:	8526                	mv	a0,s1
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	8f0080e7          	jalr	-1808(ra) # 80003874 <iunlockput>
    ilock(ip);
    80004f8c:	8556                	mv	a0,s5
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	684080e7          	jalr	1668(ra) # 80003612 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f96:	4789                	li	a5,2
    80004f98:	02fb1563          	bne	s6,a5,80004fc2 <create+0x88>
    80004f9c:	044ad783          	lhu	a5,68(s5)
    80004fa0:	37f9                	addiw	a5,a5,-2
    80004fa2:	17c2                	slli	a5,a5,0x30
    80004fa4:	93c1                	srli	a5,a5,0x30
    80004fa6:	4705                	li	a4,1
    80004fa8:	00f76d63          	bltu	a4,a5,80004fc2 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004fac:	8556                	mv	a0,s5
    80004fae:	60a6                	ld	ra,72(sp)
    80004fb0:	6406                	ld	s0,64(sp)
    80004fb2:	74e2                	ld	s1,56(sp)
    80004fb4:	7942                	ld	s2,48(sp)
    80004fb6:	79a2                	ld	s3,40(sp)
    80004fb8:	7a02                	ld	s4,32(sp)
    80004fba:	6ae2                	ld	s5,24(sp)
    80004fbc:	6b42                	ld	s6,16(sp)
    80004fbe:	6161                	addi	sp,sp,80
    80004fc0:	8082                	ret
    iunlockput(ip);
    80004fc2:	8556                	mv	a0,s5
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	8b0080e7          	jalr	-1872(ra) # 80003874 <iunlockput>
    return 0;
    80004fcc:	4a81                	li	s5,0
    80004fce:	bff9                	j	80004fac <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004fd0:	85da                	mv	a1,s6
    80004fd2:	4088                	lw	a0,0(s1)
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	4a6080e7          	jalr	1190(ra) # 8000347a <ialloc>
    80004fdc:	8a2a                	mv	s4,a0
    80004fde:	c529                	beqz	a0,80005028 <create+0xee>
  ilock(ip);
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	632080e7          	jalr	1586(ra) # 80003612 <ilock>
  ip->major = major;
    80004fe8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004fec:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ff0:	4905                	li	s2,1
    80004ff2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004ff6:	8552                	mv	a0,s4
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	54e080e7          	jalr	1358(ra) # 80003546 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005000:	032b0b63          	beq	s6,s2,80005036 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005004:	004a2603          	lw	a2,4(s4)
    80005008:	fb040593          	addi	a1,s0,-80
    8000500c:	8526                	mv	a0,s1
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	cf8080e7          	jalr	-776(ra) # 80003d06 <dirlink>
    80005016:	06054f63          	bltz	a0,80005094 <create+0x15a>
  iunlockput(dp);
    8000501a:	8526                	mv	a0,s1
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	858080e7          	jalr	-1960(ra) # 80003874 <iunlockput>
  return ip;
    80005024:	8ad2                	mv	s5,s4
    80005026:	b759                	j	80004fac <create+0x72>
    iunlockput(dp);
    80005028:	8526                	mv	a0,s1
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	84a080e7          	jalr	-1974(ra) # 80003874 <iunlockput>
    return 0;
    80005032:	8ad2                	mv	s5,s4
    80005034:	bfa5                	j	80004fac <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005036:	004a2603          	lw	a2,4(s4)
    8000503a:	00003597          	auipc	a1,0x3
    8000503e:	6d658593          	addi	a1,a1,1750 # 80008710 <syscalls+0x2a0>
    80005042:	8552                	mv	a0,s4
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	cc2080e7          	jalr	-830(ra) # 80003d06 <dirlink>
    8000504c:	04054463          	bltz	a0,80005094 <create+0x15a>
    80005050:	40d0                	lw	a2,4(s1)
    80005052:	00003597          	auipc	a1,0x3
    80005056:	6c658593          	addi	a1,a1,1734 # 80008718 <syscalls+0x2a8>
    8000505a:	8552                	mv	a0,s4
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	caa080e7          	jalr	-854(ra) # 80003d06 <dirlink>
    80005064:	02054863          	bltz	a0,80005094 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80005068:	004a2603          	lw	a2,4(s4)
    8000506c:	fb040593          	addi	a1,s0,-80
    80005070:	8526                	mv	a0,s1
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	c94080e7          	jalr	-876(ra) # 80003d06 <dirlink>
    8000507a:	00054d63          	bltz	a0,80005094 <create+0x15a>
    dp->nlink++;  // for ".."
    8000507e:	04a4d783          	lhu	a5,74(s1)
    80005082:	2785                	addiw	a5,a5,1
    80005084:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005088:	8526                	mv	a0,s1
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	4bc080e7          	jalr	1212(ra) # 80003546 <iupdate>
    80005092:	b761                	j	8000501a <create+0xe0>
  ip->nlink = 0;
    80005094:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005098:	8552                	mv	a0,s4
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	4ac080e7          	jalr	1196(ra) # 80003546 <iupdate>
  iunlockput(ip);
    800050a2:	8552                	mv	a0,s4
    800050a4:	ffffe097          	auipc	ra,0xffffe
    800050a8:	7d0080e7          	jalr	2000(ra) # 80003874 <iunlockput>
  iunlockput(dp);
    800050ac:	8526                	mv	a0,s1
    800050ae:	ffffe097          	auipc	ra,0xffffe
    800050b2:	7c6080e7          	jalr	1990(ra) # 80003874 <iunlockput>
  return 0;
    800050b6:	bddd                	j	80004fac <create+0x72>
    return 0;
    800050b8:	8aaa                	mv	s5,a0
    800050ba:	bdcd                	j	80004fac <create+0x72>

00000000800050bc <sys_dup>:
{
    800050bc:	7179                	addi	sp,sp,-48
    800050be:	f406                	sd	ra,40(sp)
    800050c0:	f022                	sd	s0,32(sp)
    800050c2:	ec26                	sd	s1,24(sp)
    800050c4:	e84a                	sd	s2,16(sp)
    800050c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050c8:	fd840613          	addi	a2,s0,-40
    800050cc:	4581                	li	a1,0
    800050ce:	4501                	li	a0,0
    800050d0:	00000097          	auipc	ra,0x0
    800050d4:	dc8080e7          	jalr	-568(ra) # 80004e98 <argfd>
    return -1;
    800050d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050da:	02054363          	bltz	a0,80005100 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800050de:	fd843903          	ld	s2,-40(s0)
    800050e2:	854a                	mv	a0,s2
    800050e4:	00000097          	auipc	ra,0x0
    800050e8:	e14080e7          	jalr	-492(ra) # 80004ef8 <fdalloc>
    800050ec:	84aa                	mv	s1,a0
    return -1;
    800050ee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800050f0:	00054863          	bltz	a0,80005100 <sys_dup+0x44>
  filedup(f);
    800050f4:	854a                	mv	a0,s2
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	334080e7          	jalr	820(ra) # 8000442a <filedup>
  return fd;
    800050fe:	87a6                	mv	a5,s1
}
    80005100:	853e                	mv	a0,a5
    80005102:	70a2                	ld	ra,40(sp)
    80005104:	7402                	ld	s0,32(sp)
    80005106:	64e2                	ld	s1,24(sp)
    80005108:	6942                	ld	s2,16(sp)
    8000510a:	6145                	addi	sp,sp,48
    8000510c:	8082                	ret

000000008000510e <sys_read>:
{
    8000510e:	7179                	addi	sp,sp,-48
    80005110:	f406                	sd	ra,40(sp)
    80005112:	f022                	sd	s0,32(sp)
    80005114:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005116:	fd840593          	addi	a1,s0,-40
    8000511a:	4505                	li	a0,1
    8000511c:	ffffe097          	auipc	ra,0xffffe
    80005120:	9b4080e7          	jalr	-1612(ra) # 80002ad0 <argaddr>
  argint(2, &n);
    80005124:	fe440593          	addi	a1,s0,-28
    80005128:	4509                	li	a0,2
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	986080e7          	jalr	-1658(ra) # 80002ab0 <argint>
  if(argfd(0, 0, &f) < 0)
    80005132:	fe840613          	addi	a2,s0,-24
    80005136:	4581                	li	a1,0
    80005138:	4501                	li	a0,0
    8000513a:	00000097          	auipc	ra,0x0
    8000513e:	d5e080e7          	jalr	-674(ra) # 80004e98 <argfd>
    80005142:	87aa                	mv	a5,a0
    return -1;
    80005144:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005146:	0007cc63          	bltz	a5,8000515e <sys_read+0x50>
  return fileread(f, p, n);
    8000514a:	fe442603          	lw	a2,-28(s0)
    8000514e:	fd843583          	ld	a1,-40(s0)
    80005152:	fe843503          	ld	a0,-24(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	460080e7          	jalr	1120(ra) # 800045b6 <fileread>
}
    8000515e:	70a2                	ld	ra,40(sp)
    80005160:	7402                	ld	s0,32(sp)
    80005162:	6145                	addi	sp,sp,48
    80005164:	8082                	ret

0000000080005166 <sys_write>:
{
    80005166:	7179                	addi	sp,sp,-48
    80005168:	f406                	sd	ra,40(sp)
    8000516a:	f022                	sd	s0,32(sp)
    8000516c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000516e:	fd840593          	addi	a1,s0,-40
    80005172:	4505                	li	a0,1
    80005174:	ffffe097          	auipc	ra,0xffffe
    80005178:	95c080e7          	jalr	-1700(ra) # 80002ad0 <argaddr>
  argint(2, &n);
    8000517c:	fe440593          	addi	a1,s0,-28
    80005180:	4509                	li	a0,2
    80005182:	ffffe097          	auipc	ra,0xffffe
    80005186:	92e080e7          	jalr	-1746(ra) # 80002ab0 <argint>
  if(argfd(0, 0, &f) < 0)
    8000518a:	fe840613          	addi	a2,s0,-24
    8000518e:	4581                	li	a1,0
    80005190:	4501                	li	a0,0
    80005192:	00000097          	auipc	ra,0x0
    80005196:	d06080e7          	jalr	-762(ra) # 80004e98 <argfd>
    8000519a:	87aa                	mv	a5,a0
    return -1;
    8000519c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000519e:	0007cc63          	bltz	a5,800051b6 <sys_write+0x50>
  return filewrite(f, p, n);
    800051a2:	fe442603          	lw	a2,-28(s0)
    800051a6:	fd843583          	ld	a1,-40(s0)
    800051aa:	fe843503          	ld	a0,-24(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	4ca080e7          	jalr	1226(ra) # 80004678 <filewrite>
}
    800051b6:	70a2                	ld	ra,40(sp)
    800051b8:	7402                	ld	s0,32(sp)
    800051ba:	6145                	addi	sp,sp,48
    800051bc:	8082                	ret

00000000800051be <sys_close>:
{
    800051be:	1101                	addi	sp,sp,-32
    800051c0:	ec06                	sd	ra,24(sp)
    800051c2:	e822                	sd	s0,16(sp)
    800051c4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051c6:	fe040613          	addi	a2,s0,-32
    800051ca:	fec40593          	addi	a1,s0,-20
    800051ce:	4501                	li	a0,0
    800051d0:	00000097          	auipc	ra,0x0
    800051d4:	cc8080e7          	jalr	-824(ra) # 80004e98 <argfd>
    return -1;
    800051d8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051da:	02054463          	bltz	a0,80005202 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800051de:	ffffc097          	auipc	ra,0xffffc
    800051e2:	7b8080e7          	jalr	1976(ra) # 80001996 <myproc>
    800051e6:	fec42783          	lw	a5,-20(s0)
    800051ea:	07e9                	addi	a5,a5,26
    800051ec:	078e                	slli	a5,a5,0x3
    800051ee:	953e                	add	a0,a0,a5
    800051f0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800051f4:	fe043503          	ld	a0,-32(s0)
    800051f8:	fffff097          	auipc	ra,0xfffff
    800051fc:	284080e7          	jalr	644(ra) # 8000447c <fileclose>
  return 0;
    80005200:	4781                	li	a5,0
}
    80005202:	853e                	mv	a0,a5
    80005204:	60e2                	ld	ra,24(sp)
    80005206:	6442                	ld	s0,16(sp)
    80005208:	6105                	addi	sp,sp,32
    8000520a:	8082                	ret

000000008000520c <sys_fstat>:
{
    8000520c:	1101                	addi	sp,sp,-32
    8000520e:	ec06                	sd	ra,24(sp)
    80005210:	e822                	sd	s0,16(sp)
    80005212:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005214:	fe040593          	addi	a1,s0,-32
    80005218:	4505                	li	a0,1
    8000521a:	ffffe097          	auipc	ra,0xffffe
    8000521e:	8b6080e7          	jalr	-1866(ra) # 80002ad0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005222:	fe840613          	addi	a2,s0,-24
    80005226:	4581                	li	a1,0
    80005228:	4501                	li	a0,0
    8000522a:	00000097          	auipc	ra,0x0
    8000522e:	c6e080e7          	jalr	-914(ra) # 80004e98 <argfd>
    80005232:	87aa                	mv	a5,a0
    return -1;
    80005234:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005236:	0007ca63          	bltz	a5,8000524a <sys_fstat+0x3e>
  return filestat(f, st);
    8000523a:	fe043583          	ld	a1,-32(s0)
    8000523e:	fe843503          	ld	a0,-24(s0)
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	302080e7          	jalr	770(ra) # 80004544 <filestat>
}
    8000524a:	60e2                	ld	ra,24(sp)
    8000524c:	6442                	ld	s0,16(sp)
    8000524e:	6105                	addi	sp,sp,32
    80005250:	8082                	ret

0000000080005252 <sys_link>:
{
    80005252:	7169                	addi	sp,sp,-304
    80005254:	f606                	sd	ra,296(sp)
    80005256:	f222                	sd	s0,288(sp)
    80005258:	ee26                	sd	s1,280(sp)
    8000525a:	ea4a                	sd	s2,272(sp)
    8000525c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000525e:	08000613          	li	a2,128
    80005262:	ed040593          	addi	a1,s0,-304
    80005266:	4501                	li	a0,0
    80005268:	ffffe097          	auipc	ra,0xffffe
    8000526c:	888080e7          	jalr	-1912(ra) # 80002af0 <argstr>
    return -1;
    80005270:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005272:	10054e63          	bltz	a0,8000538e <sys_link+0x13c>
    80005276:	08000613          	li	a2,128
    8000527a:	f5040593          	addi	a1,s0,-176
    8000527e:	4505                	li	a0,1
    80005280:	ffffe097          	auipc	ra,0xffffe
    80005284:	870080e7          	jalr	-1936(ra) # 80002af0 <argstr>
    return -1;
    80005288:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000528a:	10054263          	bltz	a0,8000538e <sys_link+0x13c>
  begin_op();
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	d2a080e7          	jalr	-726(ra) # 80003fb8 <begin_op>
  if((ip = namei(old)) == 0){
    80005296:	ed040513          	addi	a0,s0,-304
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	b1e080e7          	jalr	-1250(ra) # 80003db8 <namei>
    800052a2:	84aa                	mv	s1,a0
    800052a4:	c551                	beqz	a0,80005330 <sys_link+0xde>
  ilock(ip);
    800052a6:	ffffe097          	auipc	ra,0xffffe
    800052aa:	36c080e7          	jalr	876(ra) # 80003612 <ilock>
  if(ip->type == T_DIR){
    800052ae:	04449703          	lh	a4,68(s1)
    800052b2:	4785                	li	a5,1
    800052b4:	08f70463          	beq	a4,a5,8000533c <sys_link+0xea>
  ip->nlink++;
    800052b8:	04a4d783          	lhu	a5,74(s1)
    800052bc:	2785                	addiw	a5,a5,1
    800052be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052c2:	8526                	mv	a0,s1
    800052c4:	ffffe097          	auipc	ra,0xffffe
    800052c8:	282080e7          	jalr	642(ra) # 80003546 <iupdate>
  iunlock(ip);
    800052cc:	8526                	mv	a0,s1
    800052ce:	ffffe097          	auipc	ra,0xffffe
    800052d2:	406080e7          	jalr	1030(ra) # 800036d4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052d6:	fd040593          	addi	a1,s0,-48
    800052da:	f5040513          	addi	a0,s0,-176
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	af8080e7          	jalr	-1288(ra) # 80003dd6 <nameiparent>
    800052e6:	892a                	mv	s2,a0
    800052e8:	c935                	beqz	a0,8000535c <sys_link+0x10a>
  ilock(dp);
    800052ea:	ffffe097          	auipc	ra,0xffffe
    800052ee:	328080e7          	jalr	808(ra) # 80003612 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800052f2:	00092703          	lw	a4,0(s2)
    800052f6:	409c                	lw	a5,0(s1)
    800052f8:	04f71d63          	bne	a4,a5,80005352 <sys_link+0x100>
    800052fc:	40d0                	lw	a2,4(s1)
    800052fe:	fd040593          	addi	a1,s0,-48
    80005302:	854a                	mv	a0,s2
    80005304:	fffff097          	auipc	ra,0xfffff
    80005308:	a02080e7          	jalr	-1534(ra) # 80003d06 <dirlink>
    8000530c:	04054363          	bltz	a0,80005352 <sys_link+0x100>
  iunlockput(dp);
    80005310:	854a                	mv	a0,s2
    80005312:	ffffe097          	auipc	ra,0xffffe
    80005316:	562080e7          	jalr	1378(ra) # 80003874 <iunlockput>
  iput(ip);
    8000531a:	8526                	mv	a0,s1
    8000531c:	ffffe097          	auipc	ra,0xffffe
    80005320:	4b0080e7          	jalr	1200(ra) # 800037cc <iput>
  end_op();
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	d0e080e7          	jalr	-754(ra) # 80004032 <end_op>
  return 0;
    8000532c:	4781                	li	a5,0
    8000532e:	a085                	j	8000538e <sys_link+0x13c>
    end_op();
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	d02080e7          	jalr	-766(ra) # 80004032 <end_op>
    return -1;
    80005338:	57fd                	li	a5,-1
    8000533a:	a891                	j	8000538e <sys_link+0x13c>
    iunlockput(ip);
    8000533c:	8526                	mv	a0,s1
    8000533e:	ffffe097          	auipc	ra,0xffffe
    80005342:	536080e7          	jalr	1334(ra) # 80003874 <iunlockput>
    end_op();
    80005346:	fffff097          	auipc	ra,0xfffff
    8000534a:	cec080e7          	jalr	-788(ra) # 80004032 <end_op>
    return -1;
    8000534e:	57fd                	li	a5,-1
    80005350:	a83d                	j	8000538e <sys_link+0x13c>
    iunlockput(dp);
    80005352:	854a                	mv	a0,s2
    80005354:	ffffe097          	auipc	ra,0xffffe
    80005358:	520080e7          	jalr	1312(ra) # 80003874 <iunlockput>
  ilock(ip);
    8000535c:	8526                	mv	a0,s1
    8000535e:	ffffe097          	auipc	ra,0xffffe
    80005362:	2b4080e7          	jalr	692(ra) # 80003612 <ilock>
  ip->nlink--;
    80005366:	04a4d783          	lhu	a5,74(s1)
    8000536a:	37fd                	addiw	a5,a5,-1
    8000536c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005370:	8526                	mv	a0,s1
    80005372:	ffffe097          	auipc	ra,0xffffe
    80005376:	1d4080e7          	jalr	468(ra) # 80003546 <iupdate>
  iunlockput(ip);
    8000537a:	8526                	mv	a0,s1
    8000537c:	ffffe097          	auipc	ra,0xffffe
    80005380:	4f8080e7          	jalr	1272(ra) # 80003874 <iunlockput>
  end_op();
    80005384:	fffff097          	auipc	ra,0xfffff
    80005388:	cae080e7          	jalr	-850(ra) # 80004032 <end_op>
  return -1;
    8000538c:	57fd                	li	a5,-1
}
    8000538e:	853e                	mv	a0,a5
    80005390:	70b2                	ld	ra,296(sp)
    80005392:	7412                	ld	s0,288(sp)
    80005394:	64f2                	ld	s1,280(sp)
    80005396:	6952                	ld	s2,272(sp)
    80005398:	6155                	addi	sp,sp,304
    8000539a:	8082                	ret

000000008000539c <sys_unlink>:
{
    8000539c:	7151                	addi	sp,sp,-240
    8000539e:	f586                	sd	ra,232(sp)
    800053a0:	f1a2                	sd	s0,224(sp)
    800053a2:	eda6                	sd	s1,216(sp)
    800053a4:	e9ca                	sd	s2,208(sp)
    800053a6:	e5ce                	sd	s3,200(sp)
    800053a8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053aa:	08000613          	li	a2,128
    800053ae:	f3040593          	addi	a1,s0,-208
    800053b2:	4501                	li	a0,0
    800053b4:	ffffd097          	auipc	ra,0xffffd
    800053b8:	73c080e7          	jalr	1852(ra) # 80002af0 <argstr>
    800053bc:	18054163          	bltz	a0,8000553e <sys_unlink+0x1a2>
  begin_op();
    800053c0:	fffff097          	auipc	ra,0xfffff
    800053c4:	bf8080e7          	jalr	-1032(ra) # 80003fb8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800053c8:	fb040593          	addi	a1,s0,-80
    800053cc:	f3040513          	addi	a0,s0,-208
    800053d0:	fffff097          	auipc	ra,0xfffff
    800053d4:	a06080e7          	jalr	-1530(ra) # 80003dd6 <nameiparent>
    800053d8:	84aa                	mv	s1,a0
    800053da:	c979                	beqz	a0,800054b0 <sys_unlink+0x114>
  ilock(dp);
    800053dc:	ffffe097          	auipc	ra,0xffffe
    800053e0:	236080e7          	jalr	566(ra) # 80003612 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800053e4:	00003597          	auipc	a1,0x3
    800053e8:	32c58593          	addi	a1,a1,812 # 80008710 <syscalls+0x2a0>
    800053ec:	fb040513          	addi	a0,s0,-80
    800053f0:	ffffe097          	auipc	ra,0xffffe
    800053f4:	6ec080e7          	jalr	1772(ra) # 80003adc <namecmp>
    800053f8:	14050a63          	beqz	a0,8000554c <sys_unlink+0x1b0>
    800053fc:	00003597          	auipc	a1,0x3
    80005400:	31c58593          	addi	a1,a1,796 # 80008718 <syscalls+0x2a8>
    80005404:	fb040513          	addi	a0,s0,-80
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	6d4080e7          	jalr	1748(ra) # 80003adc <namecmp>
    80005410:	12050e63          	beqz	a0,8000554c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005414:	f2c40613          	addi	a2,s0,-212
    80005418:	fb040593          	addi	a1,s0,-80
    8000541c:	8526                	mv	a0,s1
    8000541e:	ffffe097          	auipc	ra,0xffffe
    80005422:	6d8080e7          	jalr	1752(ra) # 80003af6 <dirlookup>
    80005426:	892a                	mv	s2,a0
    80005428:	12050263          	beqz	a0,8000554c <sys_unlink+0x1b0>
  ilock(ip);
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	1e6080e7          	jalr	486(ra) # 80003612 <ilock>
  if(ip->nlink < 1)
    80005434:	04a91783          	lh	a5,74(s2)
    80005438:	08f05263          	blez	a5,800054bc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000543c:	04491703          	lh	a4,68(s2)
    80005440:	4785                	li	a5,1
    80005442:	08f70563          	beq	a4,a5,800054cc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005446:	4641                	li	a2,16
    80005448:	4581                	li	a1,0
    8000544a:	fc040513          	addi	a0,s0,-64
    8000544e:	ffffc097          	auipc	ra,0xffffc
    80005452:	880080e7          	jalr	-1920(ra) # 80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005456:	4741                	li	a4,16
    80005458:	f2c42683          	lw	a3,-212(s0)
    8000545c:	fc040613          	addi	a2,s0,-64
    80005460:	4581                	li	a1,0
    80005462:	8526                	mv	a0,s1
    80005464:	ffffe097          	auipc	ra,0xffffe
    80005468:	55a080e7          	jalr	1370(ra) # 800039be <writei>
    8000546c:	47c1                	li	a5,16
    8000546e:	0af51563          	bne	a0,a5,80005518 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005472:	04491703          	lh	a4,68(s2)
    80005476:	4785                	li	a5,1
    80005478:	0af70863          	beq	a4,a5,80005528 <sys_unlink+0x18c>
  iunlockput(dp);
    8000547c:	8526                	mv	a0,s1
    8000547e:	ffffe097          	auipc	ra,0xffffe
    80005482:	3f6080e7          	jalr	1014(ra) # 80003874 <iunlockput>
  ip->nlink--;
    80005486:	04a95783          	lhu	a5,74(s2)
    8000548a:	37fd                	addiw	a5,a5,-1
    8000548c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005490:	854a                	mv	a0,s2
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	0b4080e7          	jalr	180(ra) # 80003546 <iupdate>
  iunlockput(ip);
    8000549a:	854a                	mv	a0,s2
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	3d8080e7          	jalr	984(ra) # 80003874 <iunlockput>
  end_op();
    800054a4:	fffff097          	auipc	ra,0xfffff
    800054a8:	b8e080e7          	jalr	-1138(ra) # 80004032 <end_op>
  return 0;
    800054ac:	4501                	li	a0,0
    800054ae:	a84d                	j	80005560 <sys_unlink+0x1c4>
    end_op();
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	b82080e7          	jalr	-1150(ra) # 80004032 <end_op>
    return -1;
    800054b8:	557d                	li	a0,-1
    800054ba:	a05d                	j	80005560 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800054bc:	00003517          	auipc	a0,0x3
    800054c0:	26450513          	addi	a0,a0,612 # 80008720 <syscalls+0x2b0>
    800054c4:	ffffb097          	auipc	ra,0xffffb
    800054c8:	078080e7          	jalr	120(ra) # 8000053c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054cc:	04c92703          	lw	a4,76(s2)
    800054d0:	02000793          	li	a5,32
    800054d4:	f6e7f9e3          	bgeu	a5,a4,80005446 <sys_unlink+0xaa>
    800054d8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800054dc:	4741                	li	a4,16
    800054de:	86ce                	mv	a3,s3
    800054e0:	f1840613          	addi	a2,s0,-232
    800054e4:	4581                	li	a1,0
    800054e6:	854a                	mv	a0,s2
    800054e8:	ffffe097          	auipc	ra,0xffffe
    800054ec:	3de080e7          	jalr	990(ra) # 800038c6 <readi>
    800054f0:	47c1                	li	a5,16
    800054f2:	00f51b63          	bne	a0,a5,80005508 <sys_unlink+0x16c>
    if(de.inum != 0)
    800054f6:	f1845783          	lhu	a5,-232(s0)
    800054fa:	e7a1                	bnez	a5,80005542 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054fc:	29c1                	addiw	s3,s3,16
    800054fe:	04c92783          	lw	a5,76(s2)
    80005502:	fcf9ede3          	bltu	s3,a5,800054dc <sys_unlink+0x140>
    80005506:	b781                	j	80005446 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	23050513          	addi	a0,a0,560 # 80008738 <syscalls+0x2c8>
    80005510:	ffffb097          	auipc	ra,0xffffb
    80005514:	02c080e7          	jalr	44(ra) # 8000053c <panic>
    panic("unlink: writei");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	23850513          	addi	a0,a0,568 # 80008750 <syscalls+0x2e0>
    80005520:	ffffb097          	auipc	ra,0xffffb
    80005524:	01c080e7          	jalr	28(ra) # 8000053c <panic>
    dp->nlink--;
    80005528:	04a4d783          	lhu	a5,74(s1)
    8000552c:	37fd                	addiw	a5,a5,-1
    8000552e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005532:	8526                	mv	a0,s1
    80005534:	ffffe097          	auipc	ra,0xffffe
    80005538:	012080e7          	jalr	18(ra) # 80003546 <iupdate>
    8000553c:	b781                	j	8000547c <sys_unlink+0xe0>
    return -1;
    8000553e:	557d                	li	a0,-1
    80005540:	a005                	j	80005560 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005542:	854a                	mv	a0,s2
    80005544:	ffffe097          	auipc	ra,0xffffe
    80005548:	330080e7          	jalr	816(ra) # 80003874 <iunlockput>
  iunlockput(dp);
    8000554c:	8526                	mv	a0,s1
    8000554e:	ffffe097          	auipc	ra,0xffffe
    80005552:	326080e7          	jalr	806(ra) # 80003874 <iunlockput>
  end_op();
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	adc080e7          	jalr	-1316(ra) # 80004032 <end_op>
  return -1;
    8000555e:	557d                	li	a0,-1
}
    80005560:	70ae                	ld	ra,232(sp)
    80005562:	740e                	ld	s0,224(sp)
    80005564:	64ee                	ld	s1,216(sp)
    80005566:	694e                	ld	s2,208(sp)
    80005568:	69ae                	ld	s3,200(sp)
    8000556a:	616d                	addi	sp,sp,240
    8000556c:	8082                	ret

000000008000556e <sys_open>:

uint64
sys_open(void)
{
    8000556e:	7131                	addi	sp,sp,-192
    80005570:	fd06                	sd	ra,184(sp)
    80005572:	f922                	sd	s0,176(sp)
    80005574:	f526                	sd	s1,168(sp)
    80005576:	f14a                	sd	s2,160(sp)
    80005578:	ed4e                	sd	s3,152(sp)
    8000557a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000557c:	f4c40593          	addi	a1,s0,-180
    80005580:	4505                	li	a0,1
    80005582:	ffffd097          	auipc	ra,0xffffd
    80005586:	52e080e7          	jalr	1326(ra) # 80002ab0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000558a:	08000613          	li	a2,128
    8000558e:	f5040593          	addi	a1,s0,-176
    80005592:	4501                	li	a0,0
    80005594:	ffffd097          	auipc	ra,0xffffd
    80005598:	55c080e7          	jalr	1372(ra) # 80002af0 <argstr>
    8000559c:	87aa                	mv	a5,a0
    return -1;
    8000559e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800055a0:	0a07c863          	bltz	a5,80005650 <sys_open+0xe2>

  begin_op();
    800055a4:	fffff097          	auipc	ra,0xfffff
    800055a8:	a14080e7          	jalr	-1516(ra) # 80003fb8 <begin_op>

  if(omode & O_CREATE){
    800055ac:	f4c42783          	lw	a5,-180(s0)
    800055b0:	2007f793          	andi	a5,a5,512
    800055b4:	cbdd                	beqz	a5,8000566a <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800055b6:	4681                	li	a3,0
    800055b8:	4601                	li	a2,0
    800055ba:	4589                	li	a1,2
    800055bc:	f5040513          	addi	a0,s0,-176
    800055c0:	00000097          	auipc	ra,0x0
    800055c4:	97a080e7          	jalr	-1670(ra) # 80004f3a <create>
    800055c8:	84aa                	mv	s1,a0
    if(ip == 0){
    800055ca:	c951                	beqz	a0,8000565e <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055cc:	04449703          	lh	a4,68(s1)
    800055d0:	478d                	li	a5,3
    800055d2:	00f71763          	bne	a4,a5,800055e0 <sys_open+0x72>
    800055d6:	0464d703          	lhu	a4,70(s1)
    800055da:	47a5                	li	a5,9
    800055dc:	0ce7ec63          	bltu	a5,a4,800056b4 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	de0080e7          	jalr	-544(ra) # 800043c0 <filealloc>
    800055e8:	892a                	mv	s2,a0
    800055ea:	c56d                	beqz	a0,800056d4 <sys_open+0x166>
    800055ec:	00000097          	auipc	ra,0x0
    800055f0:	90c080e7          	jalr	-1780(ra) # 80004ef8 <fdalloc>
    800055f4:	89aa                	mv	s3,a0
    800055f6:	0c054a63          	bltz	a0,800056ca <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800055fa:	04449703          	lh	a4,68(s1)
    800055fe:	478d                	li	a5,3
    80005600:	0ef70563          	beq	a4,a5,800056ea <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005604:	4789                	li	a5,2
    80005606:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000560a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000560e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005612:	f4c42783          	lw	a5,-180(s0)
    80005616:	0017c713          	xori	a4,a5,1
    8000561a:	8b05                	andi	a4,a4,1
    8000561c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005620:	0037f713          	andi	a4,a5,3
    80005624:	00e03733          	snez	a4,a4
    80005628:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000562c:	4007f793          	andi	a5,a5,1024
    80005630:	c791                	beqz	a5,8000563c <sys_open+0xce>
    80005632:	04449703          	lh	a4,68(s1)
    80005636:	4789                	li	a5,2
    80005638:	0cf70063          	beq	a4,a5,800056f8 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    8000563c:	8526                	mv	a0,s1
    8000563e:	ffffe097          	auipc	ra,0xffffe
    80005642:	096080e7          	jalr	150(ra) # 800036d4 <iunlock>
  end_op();
    80005646:	fffff097          	auipc	ra,0xfffff
    8000564a:	9ec080e7          	jalr	-1556(ra) # 80004032 <end_op>

  return fd;
    8000564e:	854e                	mv	a0,s3
}
    80005650:	70ea                	ld	ra,184(sp)
    80005652:	744a                	ld	s0,176(sp)
    80005654:	74aa                	ld	s1,168(sp)
    80005656:	790a                	ld	s2,160(sp)
    80005658:	69ea                	ld	s3,152(sp)
    8000565a:	6129                	addi	sp,sp,192
    8000565c:	8082                	ret
      end_op();
    8000565e:	fffff097          	auipc	ra,0xfffff
    80005662:	9d4080e7          	jalr	-1580(ra) # 80004032 <end_op>
      return -1;
    80005666:	557d                	li	a0,-1
    80005668:	b7e5                	j	80005650 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000566a:	f5040513          	addi	a0,s0,-176
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	74a080e7          	jalr	1866(ra) # 80003db8 <namei>
    80005676:	84aa                	mv	s1,a0
    80005678:	c905                	beqz	a0,800056a8 <sys_open+0x13a>
    ilock(ip);
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	f98080e7          	jalr	-104(ra) # 80003612 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005682:	04449703          	lh	a4,68(s1)
    80005686:	4785                	li	a5,1
    80005688:	f4f712e3          	bne	a4,a5,800055cc <sys_open+0x5e>
    8000568c:	f4c42783          	lw	a5,-180(s0)
    80005690:	dba1                	beqz	a5,800055e0 <sys_open+0x72>
      iunlockput(ip);
    80005692:	8526                	mv	a0,s1
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	1e0080e7          	jalr	480(ra) # 80003874 <iunlockput>
      end_op();
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	996080e7          	jalr	-1642(ra) # 80004032 <end_op>
      return -1;
    800056a4:	557d                	li	a0,-1
    800056a6:	b76d                	j	80005650 <sys_open+0xe2>
      end_op();
    800056a8:	fffff097          	auipc	ra,0xfffff
    800056ac:	98a080e7          	jalr	-1654(ra) # 80004032 <end_op>
      return -1;
    800056b0:	557d                	li	a0,-1
    800056b2:	bf79                	j	80005650 <sys_open+0xe2>
    iunlockput(ip);
    800056b4:	8526                	mv	a0,s1
    800056b6:	ffffe097          	auipc	ra,0xffffe
    800056ba:	1be080e7          	jalr	446(ra) # 80003874 <iunlockput>
    end_op();
    800056be:	fffff097          	auipc	ra,0xfffff
    800056c2:	974080e7          	jalr	-1676(ra) # 80004032 <end_op>
    return -1;
    800056c6:	557d                	li	a0,-1
    800056c8:	b761                	j	80005650 <sys_open+0xe2>
      fileclose(f);
    800056ca:	854a                	mv	a0,s2
    800056cc:	fffff097          	auipc	ra,0xfffff
    800056d0:	db0080e7          	jalr	-592(ra) # 8000447c <fileclose>
    iunlockput(ip);
    800056d4:	8526                	mv	a0,s1
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	19e080e7          	jalr	414(ra) # 80003874 <iunlockput>
    end_op();
    800056de:	fffff097          	auipc	ra,0xfffff
    800056e2:	954080e7          	jalr	-1708(ra) # 80004032 <end_op>
    return -1;
    800056e6:	557d                	li	a0,-1
    800056e8:	b7a5                	j	80005650 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800056ea:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800056ee:	04649783          	lh	a5,70(s1)
    800056f2:	02f91223          	sh	a5,36(s2)
    800056f6:	bf21                	j	8000560e <sys_open+0xa0>
    itrunc(ip);
    800056f8:	8526                	mv	a0,s1
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	026080e7          	jalr	38(ra) # 80003720 <itrunc>
    80005702:	bf2d                	j	8000563c <sys_open+0xce>

0000000080005704 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005704:	7175                	addi	sp,sp,-144
    80005706:	e506                	sd	ra,136(sp)
    80005708:	e122                	sd	s0,128(sp)
    8000570a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000570c:	fffff097          	auipc	ra,0xfffff
    80005710:	8ac080e7          	jalr	-1876(ra) # 80003fb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005714:	08000613          	li	a2,128
    80005718:	f7040593          	addi	a1,s0,-144
    8000571c:	4501                	li	a0,0
    8000571e:	ffffd097          	auipc	ra,0xffffd
    80005722:	3d2080e7          	jalr	978(ra) # 80002af0 <argstr>
    80005726:	02054963          	bltz	a0,80005758 <sys_mkdir+0x54>
    8000572a:	4681                	li	a3,0
    8000572c:	4601                	li	a2,0
    8000572e:	4585                	li	a1,1
    80005730:	f7040513          	addi	a0,s0,-144
    80005734:	00000097          	auipc	ra,0x0
    80005738:	806080e7          	jalr	-2042(ra) # 80004f3a <create>
    8000573c:	cd11                	beqz	a0,80005758 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000573e:	ffffe097          	auipc	ra,0xffffe
    80005742:	136080e7          	jalr	310(ra) # 80003874 <iunlockput>
  end_op();
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	8ec080e7          	jalr	-1812(ra) # 80004032 <end_op>
  return 0;
    8000574e:	4501                	li	a0,0
}
    80005750:	60aa                	ld	ra,136(sp)
    80005752:	640a                	ld	s0,128(sp)
    80005754:	6149                	addi	sp,sp,144
    80005756:	8082                	ret
    end_op();
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	8da080e7          	jalr	-1830(ra) # 80004032 <end_op>
    return -1;
    80005760:	557d                	li	a0,-1
    80005762:	b7fd                	j	80005750 <sys_mkdir+0x4c>

0000000080005764 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005764:	7135                	addi	sp,sp,-160
    80005766:	ed06                	sd	ra,152(sp)
    80005768:	e922                	sd	s0,144(sp)
    8000576a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000576c:	fffff097          	auipc	ra,0xfffff
    80005770:	84c080e7          	jalr	-1972(ra) # 80003fb8 <begin_op>
  argint(1, &major);
    80005774:	f6c40593          	addi	a1,s0,-148
    80005778:	4505                	li	a0,1
    8000577a:	ffffd097          	auipc	ra,0xffffd
    8000577e:	336080e7          	jalr	822(ra) # 80002ab0 <argint>
  argint(2, &minor);
    80005782:	f6840593          	addi	a1,s0,-152
    80005786:	4509                	li	a0,2
    80005788:	ffffd097          	auipc	ra,0xffffd
    8000578c:	328080e7          	jalr	808(ra) # 80002ab0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005790:	08000613          	li	a2,128
    80005794:	f7040593          	addi	a1,s0,-144
    80005798:	4501                	li	a0,0
    8000579a:	ffffd097          	auipc	ra,0xffffd
    8000579e:	356080e7          	jalr	854(ra) # 80002af0 <argstr>
    800057a2:	02054b63          	bltz	a0,800057d8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057a6:	f6841683          	lh	a3,-152(s0)
    800057aa:	f6c41603          	lh	a2,-148(s0)
    800057ae:	458d                	li	a1,3
    800057b0:	f7040513          	addi	a0,s0,-144
    800057b4:	fffff097          	auipc	ra,0xfffff
    800057b8:	786080e7          	jalr	1926(ra) # 80004f3a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057bc:	cd11                	beqz	a0,800057d8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800057be:	ffffe097          	auipc	ra,0xffffe
    800057c2:	0b6080e7          	jalr	182(ra) # 80003874 <iunlockput>
  end_op();
    800057c6:	fffff097          	auipc	ra,0xfffff
    800057ca:	86c080e7          	jalr	-1940(ra) # 80004032 <end_op>
  return 0;
    800057ce:	4501                	li	a0,0
}
    800057d0:	60ea                	ld	ra,152(sp)
    800057d2:	644a                	ld	s0,144(sp)
    800057d4:	610d                	addi	sp,sp,160
    800057d6:	8082                	ret
    end_op();
    800057d8:	fffff097          	auipc	ra,0xfffff
    800057dc:	85a080e7          	jalr	-1958(ra) # 80004032 <end_op>
    return -1;
    800057e0:	557d                	li	a0,-1
    800057e2:	b7fd                	j	800057d0 <sys_mknod+0x6c>

00000000800057e4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800057e4:	7135                	addi	sp,sp,-160
    800057e6:	ed06                	sd	ra,152(sp)
    800057e8:	e922                	sd	s0,144(sp)
    800057ea:	e526                	sd	s1,136(sp)
    800057ec:	e14a                	sd	s2,128(sp)
    800057ee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	1a6080e7          	jalr	422(ra) # 80001996 <myproc>
    800057f8:	892a                	mv	s2,a0
  
  begin_op();
    800057fa:	ffffe097          	auipc	ra,0xffffe
    800057fe:	7be080e7          	jalr	1982(ra) # 80003fb8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005802:	08000613          	li	a2,128
    80005806:	f6040593          	addi	a1,s0,-160
    8000580a:	4501                	li	a0,0
    8000580c:	ffffd097          	auipc	ra,0xffffd
    80005810:	2e4080e7          	jalr	740(ra) # 80002af0 <argstr>
    80005814:	04054b63          	bltz	a0,8000586a <sys_chdir+0x86>
    80005818:	f6040513          	addi	a0,s0,-160
    8000581c:	ffffe097          	auipc	ra,0xffffe
    80005820:	59c080e7          	jalr	1436(ra) # 80003db8 <namei>
    80005824:	84aa                	mv	s1,a0
    80005826:	c131                	beqz	a0,8000586a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	dea080e7          	jalr	-534(ra) # 80003612 <ilock>
  if(ip->type != T_DIR){
    80005830:	04449703          	lh	a4,68(s1)
    80005834:	4785                	li	a5,1
    80005836:	04f71063          	bne	a4,a5,80005876 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000583a:	8526                	mv	a0,s1
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	e98080e7          	jalr	-360(ra) # 800036d4 <iunlock>
  iput(p->cwd);
    80005844:	15093503          	ld	a0,336(s2)
    80005848:	ffffe097          	auipc	ra,0xffffe
    8000584c:	f84080e7          	jalr	-124(ra) # 800037cc <iput>
  end_op();
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	7e2080e7          	jalr	2018(ra) # 80004032 <end_op>
  p->cwd = ip;
    80005858:	14993823          	sd	s1,336(s2)
  return 0;
    8000585c:	4501                	li	a0,0
}
    8000585e:	60ea                	ld	ra,152(sp)
    80005860:	644a                	ld	s0,144(sp)
    80005862:	64aa                	ld	s1,136(sp)
    80005864:	690a                	ld	s2,128(sp)
    80005866:	610d                	addi	sp,sp,160
    80005868:	8082                	ret
    end_op();
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	7c8080e7          	jalr	1992(ra) # 80004032 <end_op>
    return -1;
    80005872:	557d                	li	a0,-1
    80005874:	b7ed                	j	8000585e <sys_chdir+0x7a>
    iunlockput(ip);
    80005876:	8526                	mv	a0,s1
    80005878:	ffffe097          	auipc	ra,0xffffe
    8000587c:	ffc080e7          	jalr	-4(ra) # 80003874 <iunlockput>
    end_op();
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	7b2080e7          	jalr	1970(ra) # 80004032 <end_op>
    return -1;
    80005888:	557d                	li	a0,-1
    8000588a:	bfd1                	j	8000585e <sys_chdir+0x7a>

000000008000588c <sys_exec>:

uint64
sys_exec(void)
{
    8000588c:	7121                	addi	sp,sp,-448
    8000588e:	ff06                	sd	ra,440(sp)
    80005890:	fb22                	sd	s0,432(sp)
    80005892:	f726                	sd	s1,424(sp)
    80005894:	f34a                	sd	s2,416(sp)
    80005896:	ef4e                	sd	s3,408(sp)
    80005898:	eb52                	sd	s4,400(sp)
    8000589a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000589c:	e4840593          	addi	a1,s0,-440
    800058a0:	4505                	li	a0,1
    800058a2:	ffffd097          	auipc	ra,0xffffd
    800058a6:	22e080e7          	jalr	558(ra) # 80002ad0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800058aa:	08000613          	li	a2,128
    800058ae:	f5040593          	addi	a1,s0,-176
    800058b2:	4501                	li	a0,0
    800058b4:	ffffd097          	auipc	ra,0xffffd
    800058b8:	23c080e7          	jalr	572(ra) # 80002af0 <argstr>
    800058bc:	87aa                	mv	a5,a0
    return -1;
    800058be:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800058c0:	0c07c263          	bltz	a5,80005984 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800058c4:	10000613          	li	a2,256
    800058c8:	4581                	li	a1,0
    800058ca:	e5040513          	addi	a0,s0,-432
    800058ce:	ffffb097          	auipc	ra,0xffffb
    800058d2:	400080e7          	jalr	1024(ra) # 80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800058d6:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800058da:	89a6                	mv	s3,s1
    800058dc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800058de:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800058e2:	00391513          	slli	a0,s2,0x3
    800058e6:	e4040593          	addi	a1,s0,-448
    800058ea:	e4843783          	ld	a5,-440(s0)
    800058ee:	953e                	add	a0,a0,a5
    800058f0:	ffffd097          	auipc	ra,0xffffd
    800058f4:	122080e7          	jalr	290(ra) # 80002a12 <fetchaddr>
    800058f8:	02054a63          	bltz	a0,8000592c <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800058fc:	e4043783          	ld	a5,-448(s0)
    80005900:	c3b9                	beqz	a5,80005946 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005902:	ffffb097          	auipc	ra,0xffffb
    80005906:	1e0080e7          	jalr	480(ra) # 80000ae2 <kalloc>
    8000590a:	85aa                	mv	a1,a0
    8000590c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005910:	cd11                	beqz	a0,8000592c <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005912:	6605                	lui	a2,0x1
    80005914:	e4043503          	ld	a0,-448(s0)
    80005918:	ffffd097          	auipc	ra,0xffffd
    8000591c:	14c080e7          	jalr	332(ra) # 80002a64 <fetchstr>
    80005920:	00054663          	bltz	a0,8000592c <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005924:	0905                	addi	s2,s2,1
    80005926:	09a1                	addi	s3,s3,8
    80005928:	fb491de3          	bne	s2,s4,800058e2 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000592c:	f5040913          	addi	s2,s0,-176
    80005930:	6088                	ld	a0,0(s1)
    80005932:	c921                	beqz	a0,80005982 <sys_exec+0xf6>
    kfree(argv[i]);
    80005934:	ffffb097          	auipc	ra,0xffffb
    80005938:	0b0080e7          	jalr	176(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000593c:	04a1                	addi	s1,s1,8
    8000593e:	ff2499e3          	bne	s1,s2,80005930 <sys_exec+0xa4>
  return -1;
    80005942:	557d                	li	a0,-1
    80005944:	a081                	j	80005984 <sys_exec+0xf8>
      argv[i] = 0;
    80005946:	0009079b          	sext.w	a5,s2
    8000594a:	078e                	slli	a5,a5,0x3
    8000594c:	fd078793          	addi	a5,a5,-48
    80005950:	97a2                	add	a5,a5,s0
    80005952:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005956:	e5040593          	addi	a1,s0,-432
    8000595a:	f5040513          	addi	a0,s0,-176
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	194080e7          	jalr	404(ra) # 80004af2 <exec>
    80005966:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005968:	f5040993          	addi	s3,s0,-176
    8000596c:	6088                	ld	a0,0(s1)
    8000596e:	c901                	beqz	a0,8000597e <sys_exec+0xf2>
    kfree(argv[i]);
    80005970:	ffffb097          	auipc	ra,0xffffb
    80005974:	074080e7          	jalr	116(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005978:	04a1                	addi	s1,s1,8
    8000597a:	ff3499e3          	bne	s1,s3,8000596c <sys_exec+0xe0>
  return ret;
    8000597e:	854a                	mv	a0,s2
    80005980:	a011                	j	80005984 <sys_exec+0xf8>
  return -1;
    80005982:	557d                	li	a0,-1
}
    80005984:	70fa                	ld	ra,440(sp)
    80005986:	745a                	ld	s0,432(sp)
    80005988:	74ba                	ld	s1,424(sp)
    8000598a:	791a                	ld	s2,416(sp)
    8000598c:	69fa                	ld	s3,408(sp)
    8000598e:	6a5a                	ld	s4,400(sp)
    80005990:	6139                	addi	sp,sp,448
    80005992:	8082                	ret

0000000080005994 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005994:	7139                	addi	sp,sp,-64
    80005996:	fc06                	sd	ra,56(sp)
    80005998:	f822                	sd	s0,48(sp)
    8000599a:	f426                	sd	s1,40(sp)
    8000599c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000599e:	ffffc097          	auipc	ra,0xffffc
    800059a2:	ff8080e7          	jalr	-8(ra) # 80001996 <myproc>
    800059a6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800059a8:	fd840593          	addi	a1,s0,-40
    800059ac:	4501                	li	a0,0
    800059ae:	ffffd097          	auipc	ra,0xffffd
    800059b2:	122080e7          	jalr	290(ra) # 80002ad0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800059b6:	fc840593          	addi	a1,s0,-56
    800059ba:	fd040513          	addi	a0,s0,-48
    800059be:	fffff097          	auipc	ra,0xfffff
    800059c2:	dea080e7          	jalr	-534(ra) # 800047a8 <pipealloc>
    return -1;
    800059c6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800059c8:	0c054463          	bltz	a0,80005a90 <sys_pipe+0xfc>
  fd0 = -1;
    800059cc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800059d0:	fd043503          	ld	a0,-48(s0)
    800059d4:	fffff097          	auipc	ra,0xfffff
    800059d8:	524080e7          	jalr	1316(ra) # 80004ef8 <fdalloc>
    800059dc:	fca42223          	sw	a0,-60(s0)
    800059e0:	08054b63          	bltz	a0,80005a76 <sys_pipe+0xe2>
    800059e4:	fc843503          	ld	a0,-56(s0)
    800059e8:	fffff097          	auipc	ra,0xfffff
    800059ec:	510080e7          	jalr	1296(ra) # 80004ef8 <fdalloc>
    800059f0:	fca42023          	sw	a0,-64(s0)
    800059f4:	06054863          	bltz	a0,80005a64 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800059f8:	4691                	li	a3,4
    800059fa:	fc440613          	addi	a2,s0,-60
    800059fe:	fd843583          	ld	a1,-40(s0)
    80005a02:	68a8                	ld	a0,80(s1)
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	c52080e7          	jalr	-942(ra) # 80001656 <copyout>
    80005a0c:	02054063          	bltz	a0,80005a2c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a10:	4691                	li	a3,4
    80005a12:	fc040613          	addi	a2,s0,-64
    80005a16:	fd843583          	ld	a1,-40(s0)
    80005a1a:	0591                	addi	a1,a1,4
    80005a1c:	68a8                	ld	a0,80(s1)
    80005a1e:	ffffc097          	auipc	ra,0xffffc
    80005a22:	c38080e7          	jalr	-968(ra) # 80001656 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a26:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a28:	06055463          	bgez	a0,80005a90 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005a2c:	fc442783          	lw	a5,-60(s0)
    80005a30:	07e9                	addi	a5,a5,26
    80005a32:	078e                	slli	a5,a5,0x3
    80005a34:	97a6                	add	a5,a5,s1
    80005a36:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a3a:	fc042783          	lw	a5,-64(s0)
    80005a3e:	07e9                	addi	a5,a5,26
    80005a40:	078e                	slli	a5,a5,0x3
    80005a42:	94be                	add	s1,s1,a5
    80005a44:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005a48:	fd043503          	ld	a0,-48(s0)
    80005a4c:	fffff097          	auipc	ra,0xfffff
    80005a50:	a30080e7          	jalr	-1488(ra) # 8000447c <fileclose>
    fileclose(wf);
    80005a54:	fc843503          	ld	a0,-56(s0)
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	a24080e7          	jalr	-1500(ra) # 8000447c <fileclose>
    return -1;
    80005a60:	57fd                	li	a5,-1
    80005a62:	a03d                	j	80005a90 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005a64:	fc442783          	lw	a5,-60(s0)
    80005a68:	0007c763          	bltz	a5,80005a76 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005a6c:	07e9                	addi	a5,a5,26
    80005a6e:	078e                	slli	a5,a5,0x3
    80005a70:	97a6                	add	a5,a5,s1
    80005a72:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005a76:	fd043503          	ld	a0,-48(s0)
    80005a7a:	fffff097          	auipc	ra,0xfffff
    80005a7e:	a02080e7          	jalr	-1534(ra) # 8000447c <fileclose>
    fileclose(wf);
    80005a82:	fc843503          	ld	a0,-56(s0)
    80005a86:	fffff097          	auipc	ra,0xfffff
    80005a8a:	9f6080e7          	jalr	-1546(ra) # 8000447c <fileclose>
    return -1;
    80005a8e:	57fd                	li	a5,-1
}
    80005a90:	853e                	mv	a0,a5
    80005a92:	70e2                	ld	ra,56(sp)
    80005a94:	7442                	ld	s0,48(sp)
    80005a96:	74a2                	ld	s1,40(sp)
    80005a98:	6121                	addi	sp,sp,64
    80005a9a:	8082                	ret
    80005a9c:	0000                	unimp
	...

0000000080005aa0 <kernelvec>:
    80005aa0:	7111                	addi	sp,sp,-256
    80005aa2:	e006                	sd	ra,0(sp)
    80005aa4:	e40a                	sd	sp,8(sp)
    80005aa6:	e80e                	sd	gp,16(sp)
    80005aa8:	ec12                	sd	tp,24(sp)
    80005aaa:	f016                	sd	t0,32(sp)
    80005aac:	f41a                	sd	t1,40(sp)
    80005aae:	f81e                	sd	t2,48(sp)
    80005ab0:	fc22                	sd	s0,56(sp)
    80005ab2:	e0a6                	sd	s1,64(sp)
    80005ab4:	e4aa                	sd	a0,72(sp)
    80005ab6:	e8ae                	sd	a1,80(sp)
    80005ab8:	ecb2                	sd	a2,88(sp)
    80005aba:	f0b6                	sd	a3,96(sp)
    80005abc:	f4ba                	sd	a4,104(sp)
    80005abe:	f8be                	sd	a5,112(sp)
    80005ac0:	fcc2                	sd	a6,120(sp)
    80005ac2:	e146                	sd	a7,128(sp)
    80005ac4:	e54a                	sd	s2,136(sp)
    80005ac6:	e94e                	sd	s3,144(sp)
    80005ac8:	ed52                	sd	s4,152(sp)
    80005aca:	f156                	sd	s5,160(sp)
    80005acc:	f55a                	sd	s6,168(sp)
    80005ace:	f95e                	sd	s7,176(sp)
    80005ad0:	fd62                	sd	s8,184(sp)
    80005ad2:	e1e6                	sd	s9,192(sp)
    80005ad4:	e5ea                	sd	s10,200(sp)
    80005ad6:	e9ee                	sd	s11,208(sp)
    80005ad8:	edf2                	sd	t3,216(sp)
    80005ada:	f1f6                	sd	t4,224(sp)
    80005adc:	f5fa                	sd	t5,232(sp)
    80005ade:	f9fe                	sd	t6,240(sp)
    80005ae0:	dfffc0ef          	jal	ra,800028de <kerneltrap>
    80005ae4:	6082                	ld	ra,0(sp)
    80005ae6:	6122                	ld	sp,8(sp)
    80005ae8:	61c2                	ld	gp,16(sp)
    80005aea:	7282                	ld	t0,32(sp)
    80005aec:	7322                	ld	t1,40(sp)
    80005aee:	73c2                	ld	t2,48(sp)
    80005af0:	7462                	ld	s0,56(sp)
    80005af2:	6486                	ld	s1,64(sp)
    80005af4:	6526                	ld	a0,72(sp)
    80005af6:	65c6                	ld	a1,80(sp)
    80005af8:	6666                	ld	a2,88(sp)
    80005afa:	7686                	ld	a3,96(sp)
    80005afc:	7726                	ld	a4,104(sp)
    80005afe:	77c6                	ld	a5,112(sp)
    80005b00:	7866                	ld	a6,120(sp)
    80005b02:	688a                	ld	a7,128(sp)
    80005b04:	692a                	ld	s2,136(sp)
    80005b06:	69ca                	ld	s3,144(sp)
    80005b08:	6a6a                	ld	s4,152(sp)
    80005b0a:	7a8a                	ld	s5,160(sp)
    80005b0c:	7b2a                	ld	s6,168(sp)
    80005b0e:	7bca                	ld	s7,176(sp)
    80005b10:	7c6a                	ld	s8,184(sp)
    80005b12:	6c8e                	ld	s9,192(sp)
    80005b14:	6d2e                	ld	s10,200(sp)
    80005b16:	6dce                	ld	s11,208(sp)
    80005b18:	6e6e                	ld	t3,216(sp)
    80005b1a:	7e8e                	ld	t4,224(sp)
    80005b1c:	7f2e                	ld	t5,232(sp)
    80005b1e:	7fce                	ld	t6,240(sp)
    80005b20:	6111                	addi	sp,sp,256
    80005b22:	10200073          	sret
    80005b26:	00000013          	nop
    80005b2a:	00000013          	nop
    80005b2e:	0001                	nop

0000000080005b30 <timervec>:
    80005b30:	34051573          	csrrw	a0,mscratch,a0
    80005b34:	e10c                	sd	a1,0(a0)
    80005b36:	e510                	sd	a2,8(a0)
    80005b38:	e914                	sd	a3,16(a0)
    80005b3a:	6d0c                	ld	a1,24(a0)
    80005b3c:	7110                	ld	a2,32(a0)
    80005b3e:	6194                	ld	a3,0(a1)
    80005b40:	96b2                	add	a3,a3,a2
    80005b42:	e194                	sd	a3,0(a1)
    80005b44:	4589                	li	a1,2
    80005b46:	14459073          	csrw	sip,a1
    80005b4a:	6914                	ld	a3,16(a0)
    80005b4c:	6510                	ld	a2,8(a0)
    80005b4e:	610c                	ld	a1,0(a0)
    80005b50:	34051573          	csrrw	a0,mscratch,a0
    80005b54:	30200073          	mret
	...

0000000080005b5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005b5a:	1141                	addi	sp,sp,-16
    80005b5c:	e422                	sd	s0,8(sp)
    80005b5e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005b60:	0c0007b7          	lui	a5,0xc000
    80005b64:	4705                	li	a4,1
    80005b66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005b68:	c3d8                	sw	a4,4(a5)
}
    80005b6a:	6422                	ld	s0,8(sp)
    80005b6c:	0141                	addi	sp,sp,16
    80005b6e:	8082                	ret

0000000080005b70 <plicinithart>:

void
plicinithart(void)
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	df2080e7          	jalr	-526(ra) # 8000196a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005b80:	0085171b          	slliw	a4,a0,0x8
    80005b84:	0c0027b7          	lui	a5,0xc002
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	40200713          	li	a4,1026
    80005b8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005b92:	00d5151b          	slliw	a0,a0,0xd
    80005b96:	0c2017b7          	lui	a5,0xc201
    80005b9a:	97aa                	add	a5,a5,a0
    80005b9c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005ba0:	60a2                	ld	ra,8(sp)
    80005ba2:	6402                	ld	s0,0(sp)
    80005ba4:	0141                	addi	sp,sp,16
    80005ba6:	8082                	ret

0000000080005ba8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ba8:	1141                	addi	sp,sp,-16
    80005baa:	e406                	sd	ra,8(sp)
    80005bac:	e022                	sd	s0,0(sp)
    80005bae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	dba080e7          	jalr	-582(ra) # 8000196a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005bb8:	00d5151b          	slliw	a0,a0,0xd
    80005bbc:	0c2017b7          	lui	a5,0xc201
    80005bc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005bc2:	43c8                	lw	a0,4(a5)
    80005bc4:	60a2                	ld	ra,8(sp)
    80005bc6:	6402                	ld	s0,0(sp)
    80005bc8:	0141                	addi	sp,sp,16
    80005bca:	8082                	ret

0000000080005bcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005bcc:	1101                	addi	sp,sp,-32
    80005bce:	ec06                	sd	ra,24(sp)
    80005bd0:	e822                	sd	s0,16(sp)
    80005bd2:	e426                	sd	s1,8(sp)
    80005bd4:	1000                	addi	s0,sp,32
    80005bd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005bd8:	ffffc097          	auipc	ra,0xffffc
    80005bdc:	d92080e7          	jalr	-622(ra) # 8000196a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005be0:	00d5151b          	slliw	a0,a0,0xd
    80005be4:	0c2017b7          	lui	a5,0xc201
    80005be8:	97aa                	add	a5,a5,a0
    80005bea:	c3c4                	sw	s1,4(a5)
}
    80005bec:	60e2                	ld	ra,24(sp)
    80005bee:	6442                	ld	s0,16(sp)
    80005bf0:	64a2                	ld	s1,8(sp)
    80005bf2:	6105                	addi	sp,sp,32
    80005bf4:	8082                	ret

0000000080005bf6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e406                	sd	ra,8(sp)
    80005bfa:	e022                	sd	s0,0(sp)
    80005bfc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005bfe:	479d                	li	a5,7
    80005c00:	04a7cc63          	blt	a5,a0,80005c58 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005c04:	0001c797          	auipc	a5,0x1c
    80005c08:	01c78793          	addi	a5,a5,28 # 80021c20 <disk>
    80005c0c:	97aa                	add	a5,a5,a0
    80005c0e:	0187c783          	lbu	a5,24(a5)
    80005c12:	ebb9                	bnez	a5,80005c68 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005c14:	00451693          	slli	a3,a0,0x4
    80005c18:	0001c797          	auipc	a5,0x1c
    80005c1c:	00878793          	addi	a5,a5,8 # 80021c20 <disk>
    80005c20:	6398                	ld	a4,0(a5)
    80005c22:	9736                	add	a4,a4,a3
    80005c24:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005c28:	6398                	ld	a4,0(a5)
    80005c2a:	9736                	add	a4,a4,a3
    80005c2c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005c30:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005c34:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005c38:	97aa                	add	a5,a5,a0
    80005c3a:	4705                	li	a4,1
    80005c3c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005c40:	0001c517          	auipc	a0,0x1c
    80005c44:	ff850513          	addi	a0,a0,-8 # 80021c38 <disk+0x18>
    80005c48:	ffffc097          	auipc	ra,0xffffc
    80005c4c:	45a080e7          	jalr	1114(ra) # 800020a2 <wakeup>
}
    80005c50:	60a2                	ld	ra,8(sp)
    80005c52:	6402                	ld	s0,0(sp)
    80005c54:	0141                	addi	sp,sp,16
    80005c56:	8082                	ret
    panic("free_desc 1");
    80005c58:	00003517          	auipc	a0,0x3
    80005c5c:	b0850513          	addi	a0,a0,-1272 # 80008760 <syscalls+0x2f0>
    80005c60:	ffffb097          	auipc	ra,0xffffb
    80005c64:	8dc080e7          	jalr	-1828(ra) # 8000053c <panic>
    panic("free_desc 2");
    80005c68:	00003517          	auipc	a0,0x3
    80005c6c:	b0850513          	addi	a0,a0,-1272 # 80008770 <syscalls+0x300>
    80005c70:	ffffb097          	auipc	ra,0xffffb
    80005c74:	8cc080e7          	jalr	-1844(ra) # 8000053c <panic>

0000000080005c78 <virtio_disk_init>:
{
    80005c78:	1101                	addi	sp,sp,-32
    80005c7a:	ec06                	sd	ra,24(sp)
    80005c7c:	e822                	sd	s0,16(sp)
    80005c7e:	e426                	sd	s1,8(sp)
    80005c80:	e04a                	sd	s2,0(sp)
    80005c82:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005c84:	00003597          	auipc	a1,0x3
    80005c88:	afc58593          	addi	a1,a1,-1284 # 80008780 <syscalls+0x310>
    80005c8c:	0001c517          	auipc	a0,0x1c
    80005c90:	0bc50513          	addi	a0,a0,188 # 80021d48 <disk+0x128>
    80005c94:	ffffb097          	auipc	ra,0xffffb
    80005c98:	eae080e7          	jalr	-338(ra) # 80000b42 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005c9c:	100017b7          	lui	a5,0x10001
    80005ca0:	4398                	lw	a4,0(a5)
    80005ca2:	2701                	sext.w	a4,a4
    80005ca4:	747277b7          	lui	a5,0x74727
    80005ca8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005cac:	14f71b63          	bne	a4,a5,80005e02 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cb0:	100017b7          	lui	a5,0x10001
    80005cb4:	43dc                	lw	a5,4(a5)
    80005cb6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005cb8:	4709                	li	a4,2
    80005cba:	14e79463          	bne	a5,a4,80005e02 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cbe:	100017b7          	lui	a5,0x10001
    80005cc2:	479c                	lw	a5,8(a5)
    80005cc4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cc6:	12e79e63          	bne	a5,a4,80005e02 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005cca:	100017b7          	lui	a5,0x10001
    80005cce:	47d8                	lw	a4,12(a5)
    80005cd0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cd2:	554d47b7          	lui	a5,0x554d4
    80005cd6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005cda:	12f71463          	bne	a4,a5,80005e02 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cde:	100017b7          	lui	a5,0x10001
    80005ce2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ce6:	4705                	li	a4,1
    80005ce8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cea:	470d                	li	a4,3
    80005cec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005cee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005cf0:	c7ffe6b7          	lui	a3,0xc7ffe
    80005cf4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ff>
    80005cf8:	8f75                	and	a4,a4,a3
    80005cfa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cfc:	472d                	li	a4,11
    80005cfe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005d00:	5bbc                	lw	a5,112(a5)
    80005d02:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005d06:	8ba1                	andi	a5,a5,8
    80005d08:	10078563          	beqz	a5,80005e12 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d0c:	100017b7          	lui	a5,0x10001
    80005d10:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005d14:	43fc                	lw	a5,68(a5)
    80005d16:	2781                	sext.w	a5,a5
    80005d18:	10079563          	bnez	a5,80005e22 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d1c:	100017b7          	lui	a5,0x10001
    80005d20:	5bdc                	lw	a5,52(a5)
    80005d22:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d24:	10078763          	beqz	a5,80005e32 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005d28:	471d                	li	a4,7
    80005d2a:	10f77c63          	bgeu	a4,a5,80005e42 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005d2e:	ffffb097          	auipc	ra,0xffffb
    80005d32:	db4080e7          	jalr	-588(ra) # 80000ae2 <kalloc>
    80005d36:	0001c497          	auipc	s1,0x1c
    80005d3a:	eea48493          	addi	s1,s1,-278 # 80021c20 <disk>
    80005d3e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005d40:	ffffb097          	auipc	ra,0xffffb
    80005d44:	da2080e7          	jalr	-606(ra) # 80000ae2 <kalloc>
    80005d48:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005d4a:	ffffb097          	auipc	ra,0xffffb
    80005d4e:	d98080e7          	jalr	-616(ra) # 80000ae2 <kalloc>
    80005d52:	87aa                	mv	a5,a0
    80005d54:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005d56:	6088                	ld	a0,0(s1)
    80005d58:	cd6d                	beqz	a0,80005e52 <virtio_disk_init+0x1da>
    80005d5a:	0001c717          	auipc	a4,0x1c
    80005d5e:	ece73703          	ld	a4,-306(a4) # 80021c28 <disk+0x8>
    80005d62:	cb65                	beqz	a4,80005e52 <virtio_disk_init+0x1da>
    80005d64:	c7fd                	beqz	a5,80005e52 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005d66:	6605                	lui	a2,0x1
    80005d68:	4581                	li	a1,0
    80005d6a:	ffffb097          	auipc	ra,0xffffb
    80005d6e:	f64080e7          	jalr	-156(ra) # 80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    80005d72:	0001c497          	auipc	s1,0x1c
    80005d76:	eae48493          	addi	s1,s1,-338 # 80021c20 <disk>
    80005d7a:	6605                	lui	a2,0x1
    80005d7c:	4581                	li	a1,0
    80005d7e:	6488                	ld	a0,8(s1)
    80005d80:	ffffb097          	auipc	ra,0xffffb
    80005d84:	f4e080e7          	jalr	-178(ra) # 80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    80005d88:	6605                	lui	a2,0x1
    80005d8a:	4581                	li	a1,0
    80005d8c:	6888                	ld	a0,16(s1)
    80005d8e:	ffffb097          	auipc	ra,0xffffb
    80005d92:	f40080e7          	jalr	-192(ra) # 80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d96:	100017b7          	lui	a5,0x10001
    80005d9a:	4721                	li	a4,8
    80005d9c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005d9e:	4098                	lw	a4,0(s1)
    80005da0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005da4:	40d8                	lw	a4,4(s1)
    80005da6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005daa:	6498                	ld	a4,8(s1)
    80005dac:	0007069b          	sext.w	a3,a4
    80005db0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005db4:	9701                	srai	a4,a4,0x20
    80005db6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005dba:	6898                	ld	a4,16(s1)
    80005dbc:	0007069b          	sext.w	a3,a4
    80005dc0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005dc4:	9701                	srai	a4,a4,0x20
    80005dc6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005dca:	4705                	li	a4,1
    80005dcc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005dce:	00e48c23          	sb	a4,24(s1)
    80005dd2:	00e48ca3          	sb	a4,25(s1)
    80005dd6:	00e48d23          	sb	a4,26(s1)
    80005dda:	00e48da3          	sb	a4,27(s1)
    80005dde:	00e48e23          	sb	a4,28(s1)
    80005de2:	00e48ea3          	sb	a4,29(s1)
    80005de6:	00e48f23          	sb	a4,30(s1)
    80005dea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005dee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df2:	0727a823          	sw	s2,112(a5)
}
    80005df6:	60e2                	ld	ra,24(sp)
    80005df8:	6442                	ld	s0,16(sp)
    80005dfa:	64a2                	ld	s1,8(sp)
    80005dfc:	6902                	ld	s2,0(sp)
    80005dfe:	6105                	addi	sp,sp,32
    80005e00:	8082                	ret
    panic("could not find virtio disk");
    80005e02:	00003517          	auipc	a0,0x3
    80005e06:	98e50513          	addi	a0,a0,-1650 # 80008790 <syscalls+0x320>
    80005e0a:	ffffa097          	auipc	ra,0xffffa
    80005e0e:	732080e7          	jalr	1842(ra) # 8000053c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005e12:	00003517          	auipc	a0,0x3
    80005e16:	99e50513          	addi	a0,a0,-1634 # 800087b0 <syscalls+0x340>
    80005e1a:	ffffa097          	auipc	ra,0xffffa
    80005e1e:	722080e7          	jalr	1826(ra) # 8000053c <panic>
    panic("virtio disk should not be ready");
    80005e22:	00003517          	auipc	a0,0x3
    80005e26:	9ae50513          	addi	a0,a0,-1618 # 800087d0 <syscalls+0x360>
    80005e2a:	ffffa097          	auipc	ra,0xffffa
    80005e2e:	712080e7          	jalr	1810(ra) # 8000053c <panic>
    panic("virtio disk has no queue 0");
    80005e32:	00003517          	auipc	a0,0x3
    80005e36:	9be50513          	addi	a0,a0,-1602 # 800087f0 <syscalls+0x380>
    80005e3a:	ffffa097          	auipc	ra,0xffffa
    80005e3e:	702080e7          	jalr	1794(ra) # 8000053c <panic>
    panic("virtio disk max queue too short");
    80005e42:	00003517          	auipc	a0,0x3
    80005e46:	9ce50513          	addi	a0,a0,-1586 # 80008810 <syscalls+0x3a0>
    80005e4a:	ffffa097          	auipc	ra,0xffffa
    80005e4e:	6f2080e7          	jalr	1778(ra) # 8000053c <panic>
    panic("virtio disk kalloc");
    80005e52:	00003517          	auipc	a0,0x3
    80005e56:	9de50513          	addi	a0,a0,-1570 # 80008830 <syscalls+0x3c0>
    80005e5a:	ffffa097          	auipc	ra,0xffffa
    80005e5e:	6e2080e7          	jalr	1762(ra) # 8000053c <panic>

0000000080005e62 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e62:	7159                	addi	sp,sp,-112
    80005e64:	f486                	sd	ra,104(sp)
    80005e66:	f0a2                	sd	s0,96(sp)
    80005e68:	eca6                	sd	s1,88(sp)
    80005e6a:	e8ca                	sd	s2,80(sp)
    80005e6c:	e4ce                	sd	s3,72(sp)
    80005e6e:	e0d2                	sd	s4,64(sp)
    80005e70:	fc56                	sd	s5,56(sp)
    80005e72:	f85a                	sd	s6,48(sp)
    80005e74:	f45e                	sd	s7,40(sp)
    80005e76:	f062                	sd	s8,32(sp)
    80005e78:	ec66                	sd	s9,24(sp)
    80005e7a:	e86a                	sd	s10,16(sp)
    80005e7c:	1880                	addi	s0,sp,112
    80005e7e:	8a2a                	mv	s4,a0
    80005e80:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e82:	00c52c83          	lw	s9,12(a0)
    80005e86:	001c9c9b          	slliw	s9,s9,0x1
    80005e8a:	1c82                	slli	s9,s9,0x20
    80005e8c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005e90:	0001c517          	auipc	a0,0x1c
    80005e94:	eb850513          	addi	a0,a0,-328 # 80021d48 <disk+0x128>
    80005e98:	ffffb097          	auipc	ra,0xffffb
    80005e9c:	d3a080e7          	jalr	-710(ra) # 80000bd2 <acquire>
  for(int i = 0; i < 3; i++){
    80005ea0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005ea2:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ea4:	0001cb17          	auipc	s6,0x1c
    80005ea8:	d7cb0b13          	addi	s6,s6,-644 # 80021c20 <disk>
  for(int i = 0; i < 3; i++){
    80005eac:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005eae:	0001cc17          	auipc	s8,0x1c
    80005eb2:	e9ac0c13          	addi	s8,s8,-358 # 80021d48 <disk+0x128>
    80005eb6:	a095                	j	80005f1a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005eb8:	00fb0733          	add	a4,s6,a5
    80005ebc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005ec0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005ec2:	0207c563          	bltz	a5,80005eec <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005ec6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005ec8:	0591                	addi	a1,a1,4
    80005eca:	05560d63          	beq	a2,s5,80005f24 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005ece:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005ed0:	0001c717          	auipc	a4,0x1c
    80005ed4:	d5070713          	addi	a4,a4,-688 # 80021c20 <disk>
    80005ed8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005eda:	01874683          	lbu	a3,24(a4)
    80005ede:	fee9                	bnez	a3,80005eb8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005ee0:	2785                	addiw	a5,a5,1
    80005ee2:	0705                	addi	a4,a4,1
    80005ee4:	fe979be3          	bne	a5,s1,80005eda <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005ee8:	57fd                	li	a5,-1
    80005eea:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005eec:	00c05e63          	blez	a2,80005f08 <virtio_disk_rw+0xa6>
    80005ef0:	060a                	slli	a2,a2,0x2
    80005ef2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005ef6:	0009a503          	lw	a0,0(s3)
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	cfc080e7          	jalr	-772(ra) # 80005bf6 <free_desc>
      for(int j = 0; j < i; j++)
    80005f02:	0991                	addi	s3,s3,4
    80005f04:	ffa999e3          	bne	s3,s10,80005ef6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005f08:	85e2                	mv	a1,s8
    80005f0a:	0001c517          	auipc	a0,0x1c
    80005f0e:	d2e50513          	addi	a0,a0,-722 # 80021c38 <disk+0x18>
    80005f12:	ffffc097          	auipc	ra,0xffffc
    80005f16:	12c080e7          	jalr	300(ra) # 8000203e <sleep>
  for(int i = 0; i < 3; i++){
    80005f1a:	f9040993          	addi	s3,s0,-112
{
    80005f1e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005f20:	864a                	mv	a2,s2
    80005f22:	b775                	j	80005ece <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f24:	f9042503          	lw	a0,-112(s0)
    80005f28:	00a50713          	addi	a4,a0,10
    80005f2c:	0712                	slli	a4,a4,0x4

  if(write)
    80005f2e:	0001c797          	auipc	a5,0x1c
    80005f32:	cf278793          	addi	a5,a5,-782 # 80021c20 <disk>
    80005f36:	00e786b3          	add	a3,a5,a4
    80005f3a:	01703633          	snez	a2,s7
    80005f3e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005f40:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005f44:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f48:	f6070613          	addi	a2,a4,-160
    80005f4c:	6394                	ld	a3,0(a5)
    80005f4e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f50:	00870593          	addi	a1,a4,8
    80005f54:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f56:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005f58:	0007b803          	ld	a6,0(a5)
    80005f5c:	9642                	add	a2,a2,a6
    80005f5e:	46c1                	li	a3,16
    80005f60:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005f62:	4585                	li	a1,1
    80005f64:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005f68:	f9442683          	lw	a3,-108(s0)
    80005f6c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005f70:	0692                	slli	a3,a3,0x4
    80005f72:	9836                	add	a6,a6,a3
    80005f74:	058a0613          	addi	a2,s4,88
    80005f78:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005f7c:	0007b803          	ld	a6,0(a5)
    80005f80:	96c2                	add	a3,a3,a6
    80005f82:	40000613          	li	a2,1024
    80005f86:	c690                	sw	a2,8(a3)
  if(write)
    80005f88:	001bb613          	seqz	a2,s7
    80005f8c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f90:	00166613          	ori	a2,a2,1
    80005f94:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005f98:	f9842603          	lw	a2,-104(s0)
    80005f9c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005fa0:	00250693          	addi	a3,a0,2
    80005fa4:	0692                	slli	a3,a3,0x4
    80005fa6:	96be                	add	a3,a3,a5
    80005fa8:	58fd                	li	a7,-1
    80005faa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005fae:	0612                	slli	a2,a2,0x4
    80005fb0:	9832                	add	a6,a6,a2
    80005fb2:	f9070713          	addi	a4,a4,-112
    80005fb6:	973e                	add	a4,a4,a5
    80005fb8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005fbc:	6398                	ld	a4,0(a5)
    80005fbe:	9732                	add	a4,a4,a2
    80005fc0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005fc2:	4609                	li	a2,2
    80005fc4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005fc8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005fcc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005fd0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005fd4:	6794                	ld	a3,8(a5)
    80005fd6:	0026d703          	lhu	a4,2(a3)
    80005fda:	8b1d                	andi	a4,a4,7
    80005fdc:	0706                	slli	a4,a4,0x1
    80005fde:	96ba                	add	a3,a3,a4
    80005fe0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005fe4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005fe8:	6798                	ld	a4,8(a5)
    80005fea:	00275783          	lhu	a5,2(a4)
    80005fee:	2785                	addiw	a5,a5,1
    80005ff0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005ff4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ff8:	100017b7          	lui	a5,0x10001
    80005ffc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006000:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006004:	0001c917          	auipc	s2,0x1c
    80006008:	d4490913          	addi	s2,s2,-700 # 80021d48 <disk+0x128>
  while(b->disk == 1) {
    8000600c:	4485                	li	s1,1
    8000600e:	00b79c63          	bne	a5,a1,80006026 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006012:	85ca                	mv	a1,s2
    80006014:	8552                	mv	a0,s4
    80006016:	ffffc097          	auipc	ra,0xffffc
    8000601a:	028080e7          	jalr	40(ra) # 8000203e <sleep>
  while(b->disk == 1) {
    8000601e:	004a2783          	lw	a5,4(s4)
    80006022:	fe9788e3          	beq	a5,s1,80006012 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006026:	f9042903          	lw	s2,-112(s0)
    8000602a:	00290713          	addi	a4,s2,2
    8000602e:	0712                	slli	a4,a4,0x4
    80006030:	0001c797          	auipc	a5,0x1c
    80006034:	bf078793          	addi	a5,a5,-1040 # 80021c20 <disk>
    80006038:	97ba                	add	a5,a5,a4
    8000603a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000603e:	0001c997          	auipc	s3,0x1c
    80006042:	be298993          	addi	s3,s3,-1054 # 80021c20 <disk>
    80006046:	00491713          	slli	a4,s2,0x4
    8000604a:	0009b783          	ld	a5,0(s3)
    8000604e:	97ba                	add	a5,a5,a4
    80006050:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006054:	854a                	mv	a0,s2
    80006056:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	b9c080e7          	jalr	-1124(ra) # 80005bf6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006062:	8885                	andi	s1,s1,1
    80006064:	f0ed                	bnez	s1,80006046 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006066:	0001c517          	auipc	a0,0x1c
    8000606a:	ce250513          	addi	a0,a0,-798 # 80021d48 <disk+0x128>
    8000606e:	ffffb097          	auipc	ra,0xffffb
    80006072:	c18080e7          	jalr	-1000(ra) # 80000c86 <release>
}
    80006076:	70a6                	ld	ra,104(sp)
    80006078:	7406                	ld	s0,96(sp)
    8000607a:	64e6                	ld	s1,88(sp)
    8000607c:	6946                	ld	s2,80(sp)
    8000607e:	69a6                	ld	s3,72(sp)
    80006080:	6a06                	ld	s4,64(sp)
    80006082:	7ae2                	ld	s5,56(sp)
    80006084:	7b42                	ld	s6,48(sp)
    80006086:	7ba2                	ld	s7,40(sp)
    80006088:	7c02                	ld	s8,32(sp)
    8000608a:	6ce2                	ld	s9,24(sp)
    8000608c:	6d42                	ld	s10,16(sp)
    8000608e:	6165                	addi	sp,sp,112
    80006090:	8082                	ret

0000000080006092 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006092:	1101                	addi	sp,sp,-32
    80006094:	ec06                	sd	ra,24(sp)
    80006096:	e822                	sd	s0,16(sp)
    80006098:	e426                	sd	s1,8(sp)
    8000609a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000609c:	0001c497          	auipc	s1,0x1c
    800060a0:	b8448493          	addi	s1,s1,-1148 # 80021c20 <disk>
    800060a4:	0001c517          	auipc	a0,0x1c
    800060a8:	ca450513          	addi	a0,a0,-860 # 80021d48 <disk+0x128>
    800060ac:	ffffb097          	auipc	ra,0xffffb
    800060b0:	b26080e7          	jalr	-1242(ra) # 80000bd2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800060b4:	10001737          	lui	a4,0x10001
    800060b8:	533c                	lw	a5,96(a4)
    800060ba:	8b8d                	andi	a5,a5,3
    800060bc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800060be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800060c2:	689c                	ld	a5,16(s1)
    800060c4:	0204d703          	lhu	a4,32(s1)
    800060c8:	0027d783          	lhu	a5,2(a5)
    800060cc:	04f70863          	beq	a4,a5,8000611c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800060d0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800060d4:	6898                	ld	a4,16(s1)
    800060d6:	0204d783          	lhu	a5,32(s1)
    800060da:	8b9d                	andi	a5,a5,7
    800060dc:	078e                	slli	a5,a5,0x3
    800060de:	97ba                	add	a5,a5,a4
    800060e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800060e2:	00278713          	addi	a4,a5,2
    800060e6:	0712                	slli	a4,a4,0x4
    800060e8:	9726                	add	a4,a4,s1
    800060ea:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800060ee:	e721                	bnez	a4,80006136 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800060f0:	0789                	addi	a5,a5,2
    800060f2:	0792                	slli	a5,a5,0x4
    800060f4:	97a6                	add	a5,a5,s1
    800060f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800060f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800060fc:	ffffc097          	auipc	ra,0xffffc
    80006100:	fa6080e7          	jalr	-90(ra) # 800020a2 <wakeup>

    disk.used_idx += 1;
    80006104:	0204d783          	lhu	a5,32(s1)
    80006108:	2785                	addiw	a5,a5,1
    8000610a:	17c2                	slli	a5,a5,0x30
    8000610c:	93c1                	srli	a5,a5,0x30
    8000610e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006112:	6898                	ld	a4,16(s1)
    80006114:	00275703          	lhu	a4,2(a4)
    80006118:	faf71ce3          	bne	a4,a5,800060d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000611c:	0001c517          	auipc	a0,0x1c
    80006120:	c2c50513          	addi	a0,a0,-980 # 80021d48 <disk+0x128>
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	b62080e7          	jalr	-1182(ra) # 80000c86 <release>
}
    8000612c:	60e2                	ld	ra,24(sp)
    8000612e:	6442                	ld	s0,16(sp)
    80006130:	64a2                	ld	s1,8(sp)
    80006132:	6105                	addi	sp,sp,32
    80006134:	8082                	ret
      panic("virtio_disk_intr status");
    80006136:	00002517          	auipc	a0,0x2
    8000613a:	71250513          	addi	a0,a0,1810 # 80008848 <syscalls+0x3d8>
    8000613e:	ffffa097          	auipc	ra,0xffffa
    80006142:	3fe080e7          	jalr	1022(ra) # 8000053c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
