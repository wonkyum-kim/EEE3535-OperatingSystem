
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	8fa78793          	addi	a5,a5,-1798 # 910 <malloc+0x122>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8b450513          	addi	a0,a0,-1868 # 8e0 <malloc+0xf2>
  34:	00000097          	auipc	ra,0x0
  38:	702080e7          	jalr	1794(ra) # 736 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	18c080e7          	jalr	396(ra) # 1d4 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	372080e7          	jalr	882(ra) # 3c6 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	89050513          	addi	a0,a0,-1904 # 8f8 <malloc+0x10a>
  70:	00000097          	auipc	ra,0x0
  74:	6c6080e7          	jalr	1734(ra) # 736 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	384080e7          	jalr	900(ra) # 40e <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	34e080e7          	jalr	846(ra) # 3ee <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	348080e7          	jalr	840(ra) # 3f6 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	85250513          	addi	a0,a0,-1966 # 908 <malloc+0x11a>
  be:	00000097          	auipc	ra,0x0
  c2:	678080e7          	jalr	1656(ra) # 736 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	342080e7          	jalr	834(ra) # 40e <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	304080e7          	jalr	772(ra) # 3e6 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	306080e7          	jalr	774(ra) # 3f6 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2dc080e7          	jalr	732(ra) # 3d6 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	2ca080e7          	jalr	714(ra) # 3ce <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	2b0080e7          	jalr	688(ra) # 3ce <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 174:	ce11                	beqz	a2,190 <strncmp+0x22>
 176:	00054783          	lbu	a5,0(a0)
 17a:	cf89                	beqz	a5,194 <strncmp+0x26>
 17c:	0005c703          	lbu	a4,0(a1)
 180:	00f71a63          	bne	a4,a5,194 <strncmp+0x26>
    n--, p++, q++;
 184:	367d                	addiw	a2,a2,-1
 186:	0505                	addi	a0,a0,1
 188:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 18a:	f675                	bnez	a2,176 <strncmp+0x8>
  if(n == 0)
    return 0;
 18c:	4501                	li	a0,0
 18e:	a809                	j	1a0 <strncmp+0x32>
 190:	4501                	li	a0,0
 192:	a039                	j	1a0 <strncmp+0x32>
  if(n == 0)
 194:	ca09                	beqz	a2,1a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 196:	00054503          	lbu	a0,0(a0)
 19a:	0005c783          	lbu	a5,0(a1)
 19e:	9d1d                	subw	a0,a0,a5
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
    return 0;
 1a6:	4501                	li	a0,0
 1a8:	bfe5                	j	1a0 <strncmp+0x32>

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf91                	beqz	a5,1d0 <strlen+0x26>
 1b6:	0505                	addi	a0,a0,1
 1b8:	87aa                	mv	a5,a0
 1ba:	86be                	mv	a3,a5
 1bc:	0785                	addi	a5,a5,1
 1be:	fff7c703          	lbu	a4,-1(a5)
 1c2:	ff65                	bnez	a4,1ba <strlen+0x10>
 1c4:	40a6853b          	subw	a0,a3,a0
 1c8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  for(n = 0; s[n]; n++)
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strlen+0x20>

00000000000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1da:	ca19                	beqz	a2,1f0 <memset+0x1c>
 1dc:	87aa                	mv	a5,a0
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ea:	0785                	addi	a5,a5,1
 1ec:	fee79de3          	bne	a5,a4,1e6 <memset+0x12>
  }
  return dst;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret

00000000000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cb99                	beqz	a5,216 <strchr+0x20>
    if(*s == c)
 202:	00f58763          	beq	a1,a5,210 <strchr+0x1a>
  for(; *s; s++)
 206:	0505                	addi	a0,a0,1
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbfd                	bnez	a5,202 <strchr+0xc>
      return (char*)s;
  return 0;
 20e:	4501                	li	a0,0
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  return 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strchr+0x1a>

000000000000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	711d                	addi	sp,sp,-96
 21c:	ec86                	sd	ra,88(sp)
 21e:	e8a2                	sd	s0,80(sp)
 220:	e4a6                	sd	s1,72(sp)
 222:	e0ca                	sd	s2,64(sp)
 224:	fc4e                	sd	s3,56(sp)
 226:	f852                	sd	s4,48(sp)
 228:	f456                	sd	s5,40(sp)
 22a:	f05a                	sd	s6,32(sp)
 22c:	ec5e                	sd	s7,24(sp)
 22e:	1080                	addi	s0,sp,96
 230:	8baa                	mv	s7,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 238:	4aa9                	li	s5,10
 23a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
 23e:	2485                	addiw	s1,s1,1
 240:	0344d863          	bge	s1,s4,270 <gets+0x56>
    cc = read(0, &c, 1);
 244:	4605                	li	a2,1
 246:	faf40593          	addi	a1,s0,-81
 24a:	4501                	li	a0,0
 24c:	00000097          	auipc	ra,0x0
 250:	19a080e7          	jalr	410(ra) # 3e6 <read>
    if(cc < 1)
 254:	00a05e63          	blez	a0,270 <gets+0x56>
    buf[i++] = c;
 258:	faf44783          	lbu	a5,-81(s0)
 25c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 260:	01578763          	beq	a5,s5,26e <gets+0x54>
 264:	0905                	addi	s2,s2,1
 266:	fd679be3          	bne	a5,s6,23c <gets+0x22>
  for(i=0; i+1 < max; ){
 26a:	89a6                	mv	s3,s1
 26c:	a011                	j	270 <gets+0x56>
 26e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 270:	99de                	add	s3,s3,s7
 272:	00098023          	sb	zero,0(s3)
  return buf;
}
 276:	855e                	mv	a0,s7
 278:	60e6                	ld	ra,88(sp)
 27a:	6446                	ld	s0,80(sp)
 27c:	64a6                	ld	s1,72(sp)
 27e:	6906                	ld	s2,64(sp)
 280:	79e2                	ld	s3,56(sp)
 282:	7a42                	ld	s4,48(sp)
 284:	7aa2                	ld	s5,40(sp)
 286:	7b02                	ld	s6,32(sp)
 288:	6be2                	ld	s7,24(sp)
 28a:	6125                	addi	sp,sp,96
 28c:	8082                	ret

000000000000028e <stat>:

int
stat(const char *n, struct stat *st)
{
 28e:	1101                	addi	sp,sp,-32
 290:	ec06                	sd	ra,24(sp)
 292:	e822                	sd	s0,16(sp)
 294:	e426                	sd	s1,8(sp)
 296:	e04a                	sd	s2,0(sp)
 298:	1000                	addi	s0,sp,32
 29a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29c:	4581                	li	a1,0
 29e:	00000097          	auipc	ra,0x0
 2a2:	170080e7          	jalr	368(ra) # 40e <open>
  if(fd < 0)
 2a6:	02054563          	bltz	a0,2d0 <stat+0x42>
 2aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ac:	85ca                	mv	a1,s2
 2ae:	00000097          	auipc	ra,0x0
 2b2:	178080e7          	jalr	376(ra) # 426 <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	00000097          	auipc	ra,0x0
 2be:	13c080e7          	jalr	316(ra) # 3f6 <close>
  return r;
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	64a2                	ld	s1,8(sp)
 2ca:	6902                	ld	s2,0(sp)
 2cc:	6105                	addi	sp,sp,32
 2ce:	8082                	ret
    return -1;
 2d0:	597d                	li	s2,-1
 2d2:	bfc5                	j	2c2 <stat+0x34>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2da:	00054683          	lbu	a3,0(a0)
 2de:	fd06879b          	addiw	a5,a3,-48
 2e2:	0ff7f793          	zext.b	a5,a5
 2e6:	4625                	li	a2,9
 2e8:	02f66863          	bltu	a2,a5,318 <atoi+0x44>
 2ec:	872a                	mv	a4,a0
  n = 0;
 2ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f0:	0705                	addi	a4,a4,1
 2f2:	0025179b          	slliw	a5,a0,0x2
 2f6:	9fa9                	addw	a5,a5,a0
 2f8:	0017979b          	slliw	a5,a5,0x1
 2fc:	9fb5                	addw	a5,a5,a3
 2fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 302:	00074683          	lbu	a3,0(a4)
 306:	fd06879b          	addiw	a5,a3,-48
 30a:	0ff7f793          	zext.b	a5,a5
 30e:	fef671e3          	bgeu	a2,a5,2f0 <atoi+0x1c>
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <atoi+0x3e>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 322:	02b57463          	bgeu	a0,a1,34a <memmove+0x2e>
    while(n-- > 0)
 326:	00c05f63          	blez	a2,344 <memmove+0x28>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 332:	872a                	mv	a4,a0
      *dst++ = *src++;
 334:	0585                	addi	a1,a1,1
 336:	0705                	addi	a4,a4,1
 338:	fff5c683          	lbu	a3,-1(a1)
 33c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 340:	fee79ae3          	bne	a5,a4,334 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
    dst += n;
 34a:	00c50733          	add	a4,a0,a2
    src += n;
 34e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 350:	fec05ae3          	blez	a2,344 <memmove+0x28>
 354:	fff6079b          	addiw	a5,a2,-1
 358:	1782                	slli	a5,a5,0x20
 35a:	9381                	srli	a5,a5,0x20
 35c:	fff7c793          	not	a5,a5
 360:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 362:	15fd                	addi	a1,a1,-1
 364:	177d                	addi	a4,a4,-1
 366:	0005c683          	lbu	a3,0(a1)
 36a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36e:	fee79ae3          	bne	a5,a4,362 <memmove+0x46>
 372:	bfc9                	j	344 <memmove+0x28>

0000000000000374 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37a:	ca05                	beqz	a2,3aa <memcmp+0x36>
 37c:	fff6069b          	addiw	a3,a2,-1
 380:	1682                	slli	a3,a3,0x20
 382:	9281                	srli	a3,a3,0x20
 384:	0685                	addi	a3,a3,1
 386:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 388:	00054783          	lbu	a5,0(a0)
 38c:	0005c703          	lbu	a4,0(a1)
 390:	00e79863          	bne	a5,a4,3a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 394:	0505                	addi	a0,a0,1
    p2++;
 396:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 398:	fed518e3          	bne	a0,a3,388 <memcmp+0x14>
  }
  return 0;
 39c:	4501                	li	a0,0
 39e:	a019                	j	3a4 <memcmp+0x30>
      return *p1 - *p2;
 3a0:	40e7853b          	subw	a0,a5,a4
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <memcmp+0x30>

00000000000003ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f66080e7          	jalr	-154(ra) # 31c <memmove>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c6:	4885                	li	a7,1
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ce:	4889                	li	a7,2
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d6:	488d                	li	a7,3
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3de:	4891                	li	a7,4
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <read>:
.global read
read:
 li a7, SYS_read
 3e6:	4895                	li	a7,5
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <write>:
.global write
write:
 li a7, SYS_write
 3ee:	48c1                	li	a7,16
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <close>:
.global close
close:
 li a7, SYS_close
 3f6:	48d5                	li	a7,21
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fe:	4899                	li	a7,6
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <exec>:
.global exec
exec:
 li a7, SYS_exec
 406:	489d                	li	a7,7
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <open>:
.global open
open:
 li a7, SYS_open
 40e:	48bd                	li	a7,15
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 416:	48c5                	li	a7,17
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41e:	48c9                	li	a7,18
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 426:	48a1                	li	a7,8
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <link>:
.global link
link:
 li a7, SYS_link
 42e:	48cd                	li	a7,19
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 436:	48d1                	li	a7,20
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43e:	48a5                	li	a7,9
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <dup>:
.global dup
dup:
 li a7, SYS_dup
 446:	48a9                	li	a7,10
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44e:	48ad                	li	a7,11
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 456:	48b1                	li	a7,12
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45e:	48b5                	li	a7,13
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 466:	48b9                	li	a7,14
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46e:	1101                	addi	sp,sp,-32
 470:	ec06                	sd	ra,24(sp)
 472:	e822                	sd	s0,16(sp)
 474:	1000                	addi	s0,sp,32
 476:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47a:	4605                	li	a2,1
 47c:	fef40593          	addi	a1,s0,-17
 480:	00000097          	auipc	ra,0x0
 484:	f6e080e7          	jalr	-146(ra) # 3ee <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	f426                	sd	s1,40(sp)
 498:	f04a                	sd	s2,32(sp)
 49a:	ec4e                	sd	s3,24(sp)
 49c:	0080                	addi	s0,sp,64
 49e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a0:	c299                	beqz	a3,4a6 <printint+0x16>
 4a2:	0805c963          	bltz	a1,534 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a6:	2581                	sext.w	a1,a1
  neg = 0;
 4a8:	4881                	li	a7,0
 4aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b0:	2601                	sext.w	a2,a2
 4b2:	00000517          	auipc	a0,0x0
 4b6:	4ce50513          	addi	a0,a0,1230 # 980 <digits>
 4ba:	883a                	mv	a6,a4
 4bc:	2705                	addiw	a4,a4,1
 4be:	02c5f7bb          	remuw	a5,a1,a2
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	97aa                	add	a5,a5,a0
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d0:	0005879b          	sext.w	a5,a1
 4d4:	02c5d5bb          	divuw	a1,a1,a2
 4d8:	0685                	addi	a3,a3,1
 4da:	fec7f0e3          	bgeu	a5,a2,4ba <printint+0x2a>
  if(neg)
 4de:	00088c63          	beqz	a7,4f6 <printint+0x66>
    buf[i++] = '-';
 4e2:	fd070793          	addi	a5,a4,-48
 4e6:	00878733          	add	a4,a5,s0
 4ea:	02d00793          	li	a5,45
 4ee:	fef70823          	sb	a5,-16(a4)
 4f2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f6:	02e05863          	blez	a4,526 <printint+0x96>
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	00000097          	auipc	ra,0x0
 51c:	f56080e7          	jalr	-170(ra) # 46e <putc>
  while(--i >= 0)
 520:	197d                	addi	s2,s2,-1
 522:	ff3918e3          	bne	s2,s3,512 <printint+0x82>
}
 526:	70e2                	ld	ra,56(sp)
 528:	7442                	ld	s0,48(sp)
 52a:	74a2                	ld	s1,40(sp)
 52c:	7902                	ld	s2,32(sp)
 52e:	69e2                	ld	s3,24(sp)
 530:	6121                	addi	sp,sp,64
 532:	8082                	ret
    x = -xx;
 534:	40b005bb          	negw	a1,a1
    neg = 1;
 538:	4885                	li	a7,1
    x = -xx;
 53a:	bf85                	j	4aa <printint+0x1a>

000000000000053c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53c:	715d                	addi	sp,sp,-80
 53e:	e486                	sd	ra,72(sp)
 540:	e0a2                	sd	s0,64(sp)
 542:	fc26                	sd	s1,56(sp)
 544:	f84a                	sd	s2,48(sp)
 546:	f44e                	sd	s3,40(sp)
 548:	f052                	sd	s4,32(sp)
 54a:	ec56                	sd	s5,24(sp)
 54c:	e85a                	sd	s6,16(sp)
 54e:	e45e                	sd	s7,8(sp)
 550:	e062                	sd	s8,0(sp)
 552:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 554:	0005c903          	lbu	s2,0(a1)
 558:	18090c63          	beqz	s2,6f0 <vprintf+0x1b4>
 55c:	8aaa                	mv	s5,a0
 55e:	8bb2                	mv	s7,a2
 560:	00158493          	addi	s1,a1,1
  state = 0;
 564:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 566:	02500a13          	li	s4,37
 56a:	4b55                	li	s6,21
 56c:	a839                	j	58a <vprintf+0x4e>
        putc(fd, c);
 56e:	85ca                	mv	a1,s2
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	efc080e7          	jalr	-260(ra) # 46e <putc>
 57a:	a019                	j	580 <vprintf+0x44>
    } else if(state == '%'){
 57c:	01498d63          	beq	s3,s4,596 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 580:	0485                	addi	s1,s1,1
 582:	fff4c903          	lbu	s2,-1(s1)
 586:	16090563          	beqz	s2,6f0 <vprintf+0x1b4>
    if(state == 0){
 58a:	fe0999e3          	bnez	s3,57c <vprintf+0x40>
      if(c == '%'){
 58e:	ff4910e3          	bne	s2,s4,56e <vprintf+0x32>
        state = '%';
 592:	89d2                	mv	s3,s4
 594:	b7f5                	j	580 <vprintf+0x44>
      if(c == 'd'){
 596:	13490263          	beq	s2,s4,6ba <vprintf+0x17e>
 59a:	f9d9079b          	addiw	a5,s2,-99
 59e:	0ff7f793          	zext.b	a5,a5
 5a2:	12fb6563          	bltu	s6,a5,6cc <vprintf+0x190>
 5a6:	f9d9079b          	addiw	a5,s2,-99
 5aa:	0ff7f713          	zext.b	a4,a5
 5ae:	10eb6f63          	bltu	s6,a4,6cc <vprintf+0x190>
 5b2:	00271793          	slli	a5,a4,0x2
 5b6:	00000717          	auipc	a4,0x0
 5ba:	37270713          	addi	a4,a4,882 # 928 <malloc+0x13a>
 5be:	97ba                	add	a5,a5,a4
 5c0:	439c                	lw	a5,0(a5)
 5c2:	97ba                	add	a5,a5,a4
 5c4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	ebc080e7          	jalr	-324(ra) # 490 <printint>
 5dc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b745                	j	580 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	ea0080e7          	jalr	-352(ra) # 490 <printint>
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b751                	j	580 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000ba583          	lw	a1,0(s7)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e84080e7          	jalr	-380(ra) # 490 <printint>
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b7a5                	j	580 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 61a:	008b8c13          	addi	s8,s7,8
 61e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 622:	03000593          	li	a1,48
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e46080e7          	jalr	-442(ra) # 46e <putc>
  putc(fd, 'x');
 630:	07800593          	li	a1,120
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e38080e7          	jalr	-456(ra) # 46e <putc>
 63e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 640:	00000b97          	auipc	s7,0x0
 644:	340b8b93          	addi	s7,s7,832 # 980 <digits>
 648:	03c9d793          	srli	a5,s3,0x3c
 64c:	97de                	add	a5,a5,s7
 64e:	0007c583          	lbu	a1,0(a5)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e1a080e7          	jalr	-486(ra) # 46e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	397d                	addiw	s2,s2,-1
 660:	fe0914e3          	bnez	s2,648 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 664:	8be2                	mv	s7,s8
      state = 0;
 666:	4981                	li	s3,0
 668:	bf21                	j	580 <vprintf+0x44>
        s = va_arg(ap, char*);
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 672:	02090163          	beqz	s2,694 <vprintf+0x158>
        while(*s != 0){
 676:	00094583          	lbu	a1,0(s2)
 67a:	c9a5                	beqz	a1,6ea <vprintf+0x1ae>
          putc(fd, *s);
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	df0080e7          	jalr	-528(ra) # 46e <putc>
          s++;
 686:	0905                	addi	s2,s2,1
        while(*s != 0){
 688:	00094583          	lbu	a1,0(s2)
 68c:	f9e5                	bnez	a1,67c <vprintf+0x140>
        s = va_arg(ap, char*);
 68e:	8bce                	mv	s7,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	b5fd                	j	580 <vprintf+0x44>
          s = "(null)";
 694:	00000917          	auipc	s2,0x0
 698:	28c90913          	addi	s2,s2,652 # 920 <malloc+0x132>
        while(*s != 0){
 69c:	02800593          	li	a1,40
 6a0:	bff1                	j	67c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	000bc583          	lbu	a1,0(s7)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dc2080e7          	jalr	-574(ra) # 46e <putc>
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b5e1                	j	580 <vprintf+0x44>
        putc(fd, c);
 6ba:	02500593          	li	a1,37
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	dae080e7          	jalr	-594(ra) # 46e <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd5d                	j	580 <vprintf+0x44>
        putc(fd, '%');
 6cc:	02500593          	li	a1,37
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	d9c080e7          	jalr	-612(ra) # 46e <putc>
        putc(fd, c);
 6da:	85ca                	mv	a1,s2
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	d90080e7          	jalr	-624(ra) # 46e <putc>
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd61                	j	580 <vprintf+0x44>
        s = va_arg(ap, char*);
 6ea:	8bce                	mv	s7,s3
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bd49                	j	580 <vprintf+0x44>
    }
  }
}
 6f0:	60a6                	ld	ra,72(sp)
 6f2:	6406                	ld	s0,64(sp)
 6f4:	74e2                	ld	s1,56(sp)
 6f6:	7942                	ld	s2,48(sp)
 6f8:	79a2                	ld	s3,40(sp)
 6fa:	7a02                	ld	s4,32(sp)
 6fc:	6ae2                	ld	s5,24(sp)
 6fe:	6b42                	ld	s6,16(sp)
 700:	6ba2                	ld	s7,8(sp)
 702:	6c02                	ld	s8,0(sp)
 704:	6161                	addi	sp,sp,80
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	00000097          	auipc	ra,0x0
 72a:	e16080e7          	jalr	-490(ra) # 53c <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret

0000000000000736 <printf>:

void
printf(const char *fmt, ...)
{
 736:	711d                	addi	sp,sp,-96
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e40c                	sd	a1,8(s0)
 740:	e810                	sd	a2,16(s0)
 742:	ec14                	sd	a3,24(s0)
 744:	f018                	sd	a4,32(s0)
 746:	f41c                	sd	a5,40(s0)
 748:	03043823          	sd	a6,48(s0)
 74c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	00840613          	addi	a2,s0,8
 754:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 758:	85aa                	mv	a1,a0
 75a:	4505                	li	a0,1
 75c:	00000097          	auipc	ra,0x0
 760:	de0080e7          	jalr	-544(ra) # 53c <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e422                	sd	s0,8(sp)
 770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	00001797          	auipc	a5,0x1
 77a:	88a7b783          	ld	a5,-1910(a5) # 1000 <freep>
 77e:	a02d                	j	7a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 780:	4618                	lw	a4,8(a2)
 782:	9f2d                	addw	a4,a4,a1
 784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	6398                	ld	a4,0(a5)
 78a:	6310                	ld	a2,0(a4)
 78c:	a83d                	j	7ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9f31                	addw	a4,a4,a2
 794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053683          	ld	a3,-16(a0)
 79a:	a091                	j	7de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	6398                	ld	a4,0(a5)
 79e:	00e7e463          	bltu	a5,a4,7a6 <free+0x3a>
 7a2:	00e6ea63          	bltu	a3,a4,7b6 <free+0x4a>
{
 7a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	fed7fae3          	bgeu	a5,a3,79c <free+0x30>
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e6e463          	bltu	a3,a4,7b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	fee7eae3          	bltu	a5,a4,7a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b6:	ff852583          	lw	a1,-8(a0)
 7ba:	6390                	ld	a2,0(a5)
 7bc:	02059813          	slli	a6,a1,0x20
 7c0:	01c85713          	srli	a4,a6,0x1c
 7c4:	9736                	add	a4,a4,a3
 7c6:	fae60de3          	beq	a2,a4,780 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ce:	4790                	lw	a2,8(a5)
 7d0:	02061593          	slli	a1,a2,0x20
 7d4:	01c5d713          	srli	a4,a1,0x1c
 7d8:	973e                	add	a4,a4,a5
 7da:	fae68ae3          	beq	a3,a4,78e <free+0x22>
    p->s.ptr = bp->s.ptr;
 7de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82f73023          	sd	a5,-2016(a4) # 1000 <freep>
}
 7e8:	6422                	ld	s0,8(sp)
 7ea:	0141                	addi	sp,sp,16
 7ec:	8082                	ret

00000000000007ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ee:	7139                	addi	sp,sp,-64
 7f0:	fc06                	sd	ra,56(sp)
 7f2:	f822                	sd	s0,48(sp)
 7f4:	f426                	sd	s1,40(sp)
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	ec4e                	sd	s3,24(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
 800:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 802:	02051493          	slli	s1,a0,0x20
 806:	9081                	srli	s1,s1,0x20
 808:	04bd                	addi	s1,s1,15
 80a:	8091                	srli	s1,s1,0x4
 80c:	0014899b          	addiw	s3,s1,1
 810:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 812:	00000517          	auipc	a0,0x0
 816:	7ee53503          	ld	a0,2030(a0) # 1000 <freep>
 81a:	c515                	beqz	a0,846 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	02977f63          	bgeu	a4,s1,85e <malloc+0x70>
  if(nu < 4096)
 824:	8a4e                	mv	s4,s3
 826:	0009871b          	sext.w	a4,s3
 82a:	6685                	lui	a3,0x1
 82c:	00d77363          	bgeu	a4,a3,832 <malloc+0x44>
 830:	6a05                	lui	s4,0x1
 832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83a:	00000917          	auipc	s2,0x0
 83e:	7c690913          	addi	s2,s2,1990 # 1000 <freep>
  if(p == (char*)-1)
 842:	5afd                	li	s5,-1
 844:	a895                	j	8b8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 846:	00000797          	auipc	a5,0x0
 84a:	7ca78793          	addi	a5,a5,1994 # 1010 <base>
 84e:	00000717          	auipc	a4,0x0
 852:	7af73923          	sd	a5,1970(a4) # 1000 <freep>
 856:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 858:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85c:	b7e1                	j	824 <malloc+0x36>
      if(p->s.size == nunits)
 85e:	02e48c63          	beq	s1,a4,896 <malloc+0xa8>
        p->s.size -= nunits;
 862:	4137073b          	subw	a4,a4,s3
 866:	c798                	sw	a4,8(a5)
        p += p->s.size;
 868:	02071693          	slli	a3,a4,0x20
 86c:	01c6d713          	srli	a4,a3,0x1c
 870:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 872:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 876:	00000717          	auipc	a4,0x0
 87a:	78a73523          	sd	a0,1930(a4) # 1000 <freep>
      return (void*)(p + 1);
 87e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	74a2                	ld	s1,40(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	6121                	addi	sp,sp,64
 894:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	e118                	sd	a4,0(a0)
 89a:	bff1                	j	876 <malloc+0x88>
  hp->s.size = nu;
 89c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a0:	0541                	addi	a0,a0,16
 8a2:	00000097          	auipc	ra,0x0
 8a6:	eca080e7          	jalr	-310(ra) # 76c <free>
  return freep;
 8aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ae:	d971                	beqz	a0,882 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b2:	4798                	lw	a4,8(a5)
 8b4:	fa9775e3          	bgeu	a4,s1,85e <malloc+0x70>
    if(p == freep)
 8b8:	00093703          	ld	a4,0(s2)
 8bc:	853e                	mv	a0,a5
 8be:	fef719e3          	bne	a4,a5,8b0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8c2:	8552                	mv	a0,s4
 8c4:	00000097          	auipc	ra,0x0
 8c8:	b92080e7          	jalr	-1134(ra) # 456 <sbrk>
  if(p == (char*)-1)
 8cc:	fd5518e3          	bne	a0,s5,89c <malloc+0xae>
        return 0;
 8d0:	4501                	li	a0,0
 8d2:	bf45                	j	882 <malloc+0x94>
