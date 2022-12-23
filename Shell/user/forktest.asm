
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	1b0080e7          	jalr	432(ra) # 1bc <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3e4080e7          	jalr	996(ra) # 400 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	44650513          	addi	a0,a0,1094 # 480 <uptime+0x8>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	388080e7          	jalr	904(ra) # 3d8 <fork>
    if(pid < 0)
  58:	02054763          	bltz	a0,86 <forktest+0x58>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	42c50513          	addi	a0,a0,1068 # 490 <uptime+0x18>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	36a080e7          	jalr	874(ra) # 3e0 <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	362080e7          	jalr	866(ra) # 3e0 <exit>
  if(n == N){
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	354080e7          	jalr	852(ra) # 3e8 <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  for(; n > 0; n--){
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	342080e7          	jalr	834(ra) # 3e8 <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  b4:	00000517          	auipc	a0,0x0
  b8:	42c50513          	addi	a0,a0,1068 # 4e0 <uptime+0x68>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
      print("wait stopped early\n");
  d0:	00000517          	auipc	a0,0x0
  d4:	3e050513          	addi	a0,a0,992 # 4b0 <uptime+0x38>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	2fe080e7          	jalr	766(ra) # 3e0 <exit>
    print("wait got too many\n");
  ea:	00000517          	auipc	a0,0x0
  ee:	3de50513          	addi	a0,a0,990 # 4c8 <uptime+0x50>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	2e4080e7          	jalr	740(ra) # 3e0 <exit>

0000000000000104 <main>:

int
main(void)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  forktest();
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	2ca080e7          	jalr	714(ra) # 3e0 <exit>

000000000000011e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  extern int main();
  main();
 126:	00000097          	auipc	ra,0x0
 12a:	fde080e7          	jalr	-34(ra) # 104 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	2b0080e7          	jalr	688(ra) # 3e0 <exit>

0000000000000138 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0x8>
    ;
  return os;
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cb91                	beqz	a5,172 <strcmp+0x1e>
 160:	0005c703          	lbu	a4,0(a1)
 164:	00f71763          	bne	a4,a5,172 <strcmp+0x1e>
    p++, q++;
 168:	0505                	addi	a0,a0,1
 16a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	fbe5                	bnez	a5,160 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 172:	0005c503          	lbu	a0,0(a1)
}
 176:	40a7853b          	subw	a0,a5,a0
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 186:	ce11                	beqz	a2,1a2 <strncmp+0x22>
 188:	00054783          	lbu	a5,0(a0)
 18c:	cf89                	beqz	a5,1a6 <strncmp+0x26>
 18e:	0005c703          	lbu	a4,0(a1)
 192:	00f71a63          	bne	a4,a5,1a6 <strncmp+0x26>
    n--, p++, q++;
 196:	367d                	addiw	a2,a2,-1
 198:	0505                	addi	a0,a0,1
 19a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 19c:	f675                	bnez	a2,188 <strncmp+0x8>
  if(n == 0)
    return 0;
 19e:	4501                	li	a0,0
 1a0:	a809                	j	1b2 <strncmp+0x32>
 1a2:	4501                	li	a0,0
 1a4:	a039                	j	1b2 <strncmp+0x32>
  if(n == 0)
 1a6:	ca09                	beqz	a2,1b8 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 1a8:	00054503          	lbu	a0,0(a0)
 1ac:	0005c783          	lbu	a5,0(a1)
 1b0:	9d1d                	subw	a0,a0,a5
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret
    return 0;
 1b8:	4501                	li	a0,0
 1ba:	bfe5                	j	1b2 <strncmp+0x32>

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cf91                	beqz	a5,1e2 <strlen+0x26>
 1c8:	0505                	addi	a0,a0,1
 1ca:	87aa                	mv	a5,a0
 1cc:	86be                	mv	a3,a5
 1ce:	0785                	addi	a5,a5,1
 1d0:	fff7c703          	lbu	a4,-1(a5)
 1d4:	ff65                	bnez	a4,1cc <strlen+0x10>
 1d6:	40a6853b          	subw	a0,a3,a0
 1da:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  for(n = 0; s[n]; n++)
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <strlen+0x20>

00000000000001e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ec:	ca19                	beqz	a2,202 <memset+0x1c>
 1ee:	87aa                	mv	a5,a0
 1f0:	1602                	slli	a2,a2,0x20
 1f2:	9201                	srli	a2,a2,0x20
 1f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fc:	0785                	addi	a5,a5,1
 1fe:	fee79de3          	bne	a5,a4,1f8 <memset+0x12>
  }
  return dst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <strchr>:

char*
strchr(const char *s, char c)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20e:	00054783          	lbu	a5,0(a0)
 212:	cb99                	beqz	a5,228 <strchr+0x20>
    if(*s == c)
 214:	00f58763          	beq	a1,a5,222 <strchr+0x1a>
  for(; *s; s++)
 218:	0505                	addi	a0,a0,1
 21a:	00054783          	lbu	a5,0(a0)
 21e:	fbfd                	bnez	a5,214 <strchr+0xc>
      return (char*)s;
  return 0;
 220:	4501                	li	a0,0
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  return 0;
 228:	4501                	li	a0,0
 22a:	bfe5                	j	222 <strchr+0x1a>

000000000000022c <gets>:

char*
gets(char *buf, int max)
{
 22c:	711d                	addi	sp,sp,-96
 22e:	ec86                	sd	ra,88(sp)
 230:	e8a2                	sd	s0,80(sp)
 232:	e4a6                	sd	s1,72(sp)
 234:	e0ca                	sd	s2,64(sp)
 236:	fc4e                	sd	s3,56(sp)
 238:	f852                	sd	s4,48(sp)
 23a:	f456                	sd	s5,40(sp)
 23c:	f05a                	sd	s6,32(sp)
 23e:	ec5e                	sd	s7,24(sp)
 240:	1080                	addi	s0,sp,96
 242:	8baa                	mv	s7,a0
 244:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	892a                	mv	s2,a0
 248:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24a:	4aa9                	li	s5,10
 24c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24e:	89a6                	mv	s3,s1
 250:	2485                	addiw	s1,s1,1
 252:	0344d863          	bge	s1,s4,282 <gets+0x56>
    cc = read(0, &c, 1);
 256:	4605                	li	a2,1
 258:	faf40593          	addi	a1,s0,-81
 25c:	4501                	li	a0,0
 25e:	00000097          	auipc	ra,0x0
 262:	19a080e7          	jalr	410(ra) # 3f8 <read>
    if(cc < 1)
 266:	00a05e63          	blez	a0,282 <gets+0x56>
    buf[i++] = c;
 26a:	faf44783          	lbu	a5,-81(s0)
 26e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 272:	01578763          	beq	a5,s5,280 <gets+0x54>
 276:	0905                	addi	s2,s2,1
 278:	fd679be3          	bne	a5,s6,24e <gets+0x22>
  for(i=0; i+1 < max; ){
 27c:	89a6                	mv	s3,s1
 27e:	a011                	j	282 <gets+0x56>
 280:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 282:	99de                	add	s3,s3,s7
 284:	00098023          	sb	zero,0(s3)
  return buf;
}
 288:	855e                	mv	a0,s7
 28a:	60e6                	ld	ra,88(sp)
 28c:	6446                	ld	s0,80(sp)
 28e:	64a6                	ld	s1,72(sp)
 290:	6906                	ld	s2,64(sp)
 292:	79e2                	ld	s3,56(sp)
 294:	7a42                	ld	s4,48(sp)
 296:	7aa2                	ld	s5,40(sp)
 298:	7b02                	ld	s6,32(sp)
 29a:	6be2                	ld	s7,24(sp)
 29c:	6125                	addi	sp,sp,96
 29e:	8082                	ret

00000000000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a0:	1101                	addi	sp,sp,-32
 2a2:	ec06                	sd	ra,24(sp)
 2a4:	e822                	sd	s0,16(sp)
 2a6:	e426                	sd	s1,8(sp)
 2a8:	e04a                	sd	s2,0(sp)
 2aa:	1000                	addi	s0,sp,32
 2ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	4581                	li	a1,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	170080e7          	jalr	368(ra) # 420 <open>
  if(fd < 0)
 2b8:	02054563          	bltz	a0,2e2 <stat+0x42>
 2bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2be:	85ca                	mv	a1,s2
 2c0:	00000097          	auipc	ra,0x0
 2c4:	178080e7          	jalr	376(ra) # 438 <fstat>
 2c8:	892a                	mv	s2,a0
  close(fd);
 2ca:	8526                	mv	a0,s1
 2cc:	00000097          	auipc	ra,0x0
 2d0:	13c080e7          	jalr	316(ra) # 408 <close>
  return r;
}
 2d4:	854a                	mv	a0,s2
 2d6:	60e2                	ld	ra,24(sp)
 2d8:	6442                	ld	s0,16(sp)
 2da:	64a2                	ld	s1,8(sp)
 2dc:	6902                	ld	s2,0(sp)
 2de:	6105                	addi	sp,sp,32
 2e0:	8082                	ret
    return -1;
 2e2:	597d                	li	s2,-1
 2e4:	bfc5                	j	2d4 <stat+0x34>

00000000000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ec:	00054683          	lbu	a3,0(a0)
 2f0:	fd06879b          	addiw	a5,a3,-48
 2f4:	0ff7f793          	zext.b	a5,a5
 2f8:	4625                	li	a2,9
 2fa:	02f66863          	bltu	a2,a5,32a <atoi+0x44>
 2fe:	872a                	mv	a4,a0
  n = 0;
 300:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 302:	0705                	addi	a4,a4,1
 304:	0025179b          	slliw	a5,a0,0x2
 308:	9fa9                	addw	a5,a5,a0
 30a:	0017979b          	slliw	a5,a5,0x1
 30e:	9fb5                	addw	a5,a5,a3
 310:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 314:	00074683          	lbu	a3,0(a4)
 318:	fd06879b          	addiw	a5,a3,-48
 31c:	0ff7f793          	zext.b	a5,a5
 320:	fef671e3          	bgeu	a2,a5,302 <atoi+0x1c>
  return n;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  n = 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <atoi+0x3e>

000000000000032e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 334:	02b57463          	bgeu	a0,a1,35c <memmove+0x2e>
    while(n-- > 0)
 338:	00c05f63          	blez	a2,356 <memmove+0x28>
 33c:	1602                	slli	a2,a2,0x20
 33e:	9201                	srli	a2,a2,0x20
 340:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 344:	872a                	mv	a4,a0
      *dst++ = *src++;
 346:	0585                	addi	a1,a1,1
 348:	0705                	addi	a4,a4,1
 34a:	fff5c683          	lbu	a3,-1(a1)
 34e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 352:	fee79ae3          	bne	a5,a4,346 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
    dst += n;
 35c:	00c50733          	add	a4,a0,a2
    src += n;
 360:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 362:	fec05ae3          	blez	a2,356 <memmove+0x28>
 366:	fff6079b          	addiw	a5,a2,-1
 36a:	1782                	slli	a5,a5,0x20
 36c:	9381                	srli	a5,a5,0x20
 36e:	fff7c793          	not	a5,a5
 372:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 374:	15fd                	addi	a1,a1,-1
 376:	177d                	addi	a4,a4,-1
 378:	0005c683          	lbu	a3,0(a1)
 37c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 380:	fee79ae3          	bne	a5,a4,374 <memmove+0x46>
 384:	bfc9                	j	356 <memmove+0x28>

0000000000000386 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 38c:	ca05                	beqz	a2,3bc <memcmp+0x36>
 38e:	fff6069b          	addiw	a3,a2,-1
 392:	1682                	slli	a3,a3,0x20
 394:	9281                	srli	a3,a3,0x20
 396:	0685                	addi	a3,a3,1
 398:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 39a:	00054783          	lbu	a5,0(a0)
 39e:	0005c703          	lbu	a4,0(a1)
 3a2:	00e79863          	bne	a5,a4,3b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a6:	0505                	addi	a0,a0,1
    p2++;
 3a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3aa:	fed518e3          	bne	a0,a3,39a <memcmp+0x14>
  }
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	a019                	j	3b6 <memcmp+0x30>
      return *p1 - *p2;
 3b2:	40e7853b          	subw	a0,a5,a4
}
 3b6:	6422                	ld	s0,8(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret
  return 0;
 3bc:	4501                	li	a0,0
 3be:	bfe5                	j	3b6 <memcmp+0x30>

00000000000003c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c8:	00000097          	auipc	ra,0x0
 3cc:	f66080e7          	jalr	-154(ra) # 32e <memmove>
}
 3d0:	60a2                	ld	ra,8(sp)
 3d2:	6402                	ld	s0,0(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret

00000000000003d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d8:	4885                	li	a7,1
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e0:	4889                	li	a7,2
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e8:	488d                	li	a7,3
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f0:	4891                	li	a7,4
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <read>:
.global read
read:
 li a7, SYS_read
 3f8:	4895                	li	a7,5
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <write>:
.global write
write:
 li a7, SYS_write
 400:	48c1                	li	a7,16
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <close>:
.global close
close:
 li a7, SYS_close
 408:	48d5                	li	a7,21
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <kill>:
.global kill
kill:
 li a7, SYS_kill
 410:	4899                	li	a7,6
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <exec>:
.global exec
exec:
 li a7, SYS_exec
 418:	489d                	li	a7,7
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <open>:
.global open
open:
 li a7, SYS_open
 420:	48bd                	li	a7,15
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 428:	48c5                	li	a7,17
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 430:	48c9                	li	a7,18
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 438:	48a1                	li	a7,8
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <link>:
.global link
link:
 li a7, SYS_link
 440:	48cd                	li	a7,19
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 448:	48d1                	li	a7,20
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 450:	48a5                	li	a7,9
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <dup>:
.global dup
dup:
 li a7, SYS_dup
 458:	48a9                	li	a7,10
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 460:	48ad                	li	a7,11
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 468:	48b1                	li	a7,12
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 470:	48b5                	li	a7,13
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 478:	48b9                	li	a7,14
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret
