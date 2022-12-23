
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	378080e7          	jalr	888(ra) # 3a0 <mkdir>
  30:	02054463          	bltz	a0,58 <main+0x58>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a80d                	j	6c <main+0x6c>
    fprintf(2, "Usage: mkdir files...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	80458593          	addi	a1,a1,-2044 # 840 <malloc+0xe8>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	62c080e7          	jalr	1580(ra) # 672 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	2e8080e7          	jalr	744(ra) # 338 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  58:	6090                	ld	a2,0(s1)
  5a:	00000597          	auipc	a1,0x0
  5e:	7fe58593          	addi	a1,a1,2046 # 858 <malloc+0x100>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	60e080e7          	jalr	1550(ra) # 672 <fprintf>
      break;
    }
  }

  exit(0);
  6c:	4501                	li	a0,0
  6e:	00000097          	auipc	ra,0x0
  72:	2ca080e7          	jalr	714(ra) # 338 <exit>

0000000000000076 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  7e:	00000097          	auipc	ra,0x0
  82:	f82080e7          	jalr	-126(ra) # 0 <main>
  exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2b0080e7          	jalr	688(ra) # 338 <exit>

0000000000000090 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0x8>
    ;
  return os;
}
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cb91                	beqz	a5,ca <strcmp+0x1e>
  b8:	0005c703          	lbu	a4,0(a1)
  bc:	00f71763          	bne	a4,a5,ca <strcmp+0x1e>
    p++, q++;
  c0:	0505                	addi	a0,a0,1
  c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	fbe5                	bnez	a5,b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ca:	0005c503          	lbu	a0,0(a1)
}
  ce:	40a7853b          	subw	a0,a5,a0
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
  de:	ce11                	beqz	a2,fa <strncmp+0x22>
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf89                	beqz	a5,fe <strncmp+0x26>
  e6:	0005c703          	lbu	a4,0(a1)
  ea:	00f71a63          	bne	a4,a5,fe <strncmp+0x26>
    n--, p++, q++;
  ee:	367d                	addiw	a2,a2,-1
  f0:	0505                	addi	a0,a0,1
  f2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
  f4:	f675                	bnez	a2,e0 <strncmp+0x8>
  if(n == 0)
    return 0;
  f6:	4501                	li	a0,0
  f8:	a809                	j	10a <strncmp+0x32>
  fa:	4501                	li	a0,0
  fc:	a039                	j	10a <strncmp+0x32>
  if(n == 0)
  fe:	ca09                	beqz	a2,110 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 100:	00054503          	lbu	a0,0(a0)
 104:	0005c783          	lbu	a5,0(a1)
 108:	9d1d                	subw	a0,a0,a5
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret
    return 0;
 110:	4501                	li	a0,0
 112:	bfe5                	j	10a <strncmp+0x32>

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x26>
 120:	0505                	addi	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	86be                	mv	a3,a5
 126:	0785                	addi	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x10>
 12e:	40a6853b          	subw	a0,a3,a0
 132:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 144:	ca19                	beqz	a2,15a <memset+0x1c>
 146:	87aa                	mv	a5,a0
 148:	1602                	slli	a2,a2,0x20
 14a:	9201                	srli	a2,a2,0x20
 14c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 150:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 154:	0785                	addi	a5,a5,1
 156:	fee79de3          	bne	a5,a4,150 <memset+0x12>
  }
  return dst;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  for(; *s; s++)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb99                	beqz	a5,180 <strchr+0x20>
    if(*s == c)
 16c:	00f58763          	beq	a1,a5,17a <strchr+0x1a>
  for(; *s; s++)
 170:	0505                	addi	a0,a0,1
 172:	00054783          	lbu	a5,0(a0)
 176:	fbfd                	bnez	a5,16c <strchr+0xc>
      return (char*)s;
  return 0;
 178:	4501                	li	a0,0
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  return 0;
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strchr+0x1a>

0000000000000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	711d                	addi	sp,sp,-96
 186:	ec86                	sd	ra,88(sp)
 188:	e8a2                	sd	s0,80(sp)
 18a:	e4a6                	sd	s1,72(sp)
 18c:	e0ca                	sd	s2,64(sp)
 18e:	fc4e                	sd	s3,56(sp)
 190:	f852                	sd	s4,48(sp)
 192:	f456                	sd	s5,40(sp)
 194:	f05a                	sd	s6,32(sp)
 196:	ec5e                	sd	s7,24(sp)
 198:	1080                	addi	s0,sp,96
 19a:	8baa                	mv	s7,a0
 19c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	892a                	mv	s2,a0
 1a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a2:	4aa9                	li	s5,10
 1a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a6:	89a6                	mv	s3,s1
 1a8:	2485                	addiw	s1,s1,1
 1aa:	0344d863          	bge	s1,s4,1da <gets+0x56>
    cc = read(0, &c, 1);
 1ae:	4605                	li	a2,1
 1b0:	faf40593          	addi	a1,s0,-81
 1b4:	4501                	li	a0,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	19a080e7          	jalr	410(ra) # 350 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x56>
    buf[i++] = c;
 1c2:	faf44783          	lbu	a5,-81(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01578763          	beq	a5,s5,1d8 <gets+0x54>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd679be3          	bne	a5,s6,1a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 1d4:	89a6                	mv	s3,s1
 1d6:	a011                	j	1da <gets+0x56>
 1d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1da:	99de                	add	s3,s3,s7
 1dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e0:	855e                	mv	a0,s7
 1e2:	60e6                	ld	ra,88(sp)
 1e4:	6446                	ld	s0,80(sp)
 1e6:	64a6                	ld	s1,72(sp)
 1e8:	6906                	ld	s2,64(sp)
 1ea:	79e2                	ld	s3,56(sp)
 1ec:	7a42                	ld	s4,48(sp)
 1ee:	7aa2                	ld	s5,40(sp)
 1f0:	7b02                	ld	s6,32(sp)
 1f2:	6be2                	ld	s7,24(sp)
 1f4:	6125                	addi	sp,sp,96
 1f6:	8082                	ret

00000000000001f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f8:	1101                	addi	sp,sp,-32
 1fa:	ec06                	sd	ra,24(sp)
 1fc:	e822                	sd	s0,16(sp)
 1fe:	e426                	sd	s1,8(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	4581                	li	a1,0
 208:	00000097          	auipc	ra,0x0
 20c:	170080e7          	jalr	368(ra) # 378 <open>
  if(fd < 0)
 210:	02054563          	bltz	a0,23a <stat+0x42>
 214:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 216:	85ca                	mv	a1,s2
 218:	00000097          	auipc	ra,0x0
 21c:	178080e7          	jalr	376(ra) # 390 <fstat>
 220:	892a                	mv	s2,a0
  close(fd);
 222:	8526                	mv	a0,s1
 224:	00000097          	auipc	ra,0x0
 228:	13c080e7          	jalr	316(ra) # 360 <close>
  return r;
}
 22c:	854a                	mv	a0,s2
 22e:	60e2                	ld	ra,24(sp)
 230:	6442                	ld	s0,16(sp)
 232:	64a2                	ld	s1,8(sp)
 234:	6902                	ld	s2,0(sp)
 236:	6105                	addi	sp,sp,32
 238:	8082                	ret
    return -1;
 23a:	597d                	li	s2,-1
 23c:	bfc5                	j	22c <stat+0x34>

000000000000023e <atoi>:

int
atoi(const char *s)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 244:	00054683          	lbu	a3,0(a0)
 248:	fd06879b          	addiw	a5,a3,-48
 24c:	0ff7f793          	zext.b	a5,a5
 250:	4625                	li	a2,9
 252:	02f66863          	bltu	a2,a5,282 <atoi+0x44>
 256:	872a                	mv	a4,a0
  n = 0;
 258:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 25a:	0705                	addi	a4,a4,1
 25c:	0025179b          	slliw	a5,a0,0x2
 260:	9fa9                	addw	a5,a5,a0
 262:	0017979b          	slliw	a5,a5,0x1
 266:	9fb5                	addw	a5,a5,a3
 268:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26c:	00074683          	lbu	a3,0(a4)
 270:	fd06879b          	addiw	a5,a3,-48
 274:	0ff7f793          	zext.b	a5,a5
 278:	fef671e3          	bgeu	a2,a5,25a <atoi+0x1c>
  return n;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  n = 0;
 282:	4501                	li	a0,0
 284:	bfe5                	j	27c <atoi+0x3e>

0000000000000286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28c:	02b57463          	bgeu	a0,a1,2b4 <memmove+0x2e>
    while(n-- > 0)
 290:	00c05f63          	blez	a2,2ae <memmove+0x28>
 294:	1602                	slli	a2,a2,0x20
 296:	9201                	srli	a2,a2,0x20
 298:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29c:	872a                	mv	a4,a0
      *dst++ = *src++;
 29e:	0585                	addi	a1,a1,1
 2a0:	0705                	addi	a4,a4,1
 2a2:	fff5c683          	lbu	a3,-1(a1)
 2a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
    dst += n;
 2b4:	00c50733          	add	a4,a0,a2
    src += n;
 2b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ba:	fec05ae3          	blez	a2,2ae <memmove+0x28>
 2be:	fff6079b          	addiw	a5,a2,-1
 2c2:	1782                	slli	a5,a5,0x20
 2c4:	9381                	srli	a5,a5,0x20
 2c6:	fff7c793          	not	a5,a5
 2ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2cc:	15fd                	addi	a1,a1,-1
 2ce:	177d                	addi	a4,a4,-1
 2d0:	0005c683          	lbu	a3,0(a1)
 2d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x46>
 2dc:	bfc9                	j	2ae <memmove+0x28>

00000000000002de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e4:	ca05                	beqz	a2,314 <memcmp+0x36>
 2e6:	fff6069b          	addiw	a3,a2,-1
 2ea:	1682                	slli	a3,a3,0x20
 2ec:	9281                	srli	a3,a3,0x20
 2ee:	0685                	addi	a3,a3,1
 2f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	0005c703          	lbu	a4,0(a1)
 2fa:	00e79863          	bne	a5,a4,30a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2fe:	0505                	addi	a0,a0,1
    p2++;
 300:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 302:	fed518e3          	bne	a0,a3,2f2 <memcmp+0x14>
  }
  return 0;
 306:	4501                	li	a0,0
 308:	a019                	j	30e <memcmp+0x30>
      return *p1 - *p2;
 30a:	40e7853b          	subw	a0,a5,a4
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <memcmp+0x30>

0000000000000318 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 320:	00000097          	auipc	ra,0x0
 324:	f66080e7          	jalr	-154(ra) # 286 <memmove>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 330:	4885                	li	a7,1
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exit>:
.global exit
exit:
 li a7, SYS_exit
 338:	4889                	li	a7,2
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <wait>:
.global wait
wait:
 li a7, SYS_wait
 340:	488d                	li	a7,3
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 348:	4891                	li	a7,4
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <read>:
.global read
read:
 li a7, SYS_read
 350:	4895                	li	a7,5
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <write>:
.global write
write:
 li a7, SYS_write
 358:	48c1                	li	a7,16
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <close>:
.global close
close:
 li a7, SYS_close
 360:	48d5                	li	a7,21
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kill>:
.global kill
kill:
 li a7, SYS_kill
 368:	4899                	li	a7,6
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exec>:
.global exec
exec:
 li a7, SYS_exec
 370:	489d                	li	a7,7
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <open>:
.global open
open:
 li a7, SYS_open
 378:	48bd                	li	a7,15
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 380:	48c5                	li	a7,17
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 388:	48c9                	li	a7,18
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 390:	48a1                	li	a7,8
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <link>:
.global link
link:
 li a7, SYS_link
 398:	48cd                	li	a7,19
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a0:	48d1                	li	a7,20
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a8:	48a5                	li	a7,9
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b0:	48a9                	li	a7,10
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b8:	48ad                	li	a7,11
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c0:	48b1                	li	a7,12
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c8:	48b5                	li	a7,13
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d0:	48b9                	li	a7,14
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d8:	1101                	addi	sp,sp,-32
 3da:	ec06                	sd	ra,24(sp)
 3dc:	e822                	sd	s0,16(sp)
 3de:	1000                	addi	s0,sp,32
 3e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e4:	4605                	li	a2,1
 3e6:	fef40593          	addi	a1,s0,-17
 3ea:	00000097          	auipc	ra,0x0
 3ee:	f6e080e7          	jalr	-146(ra) # 358 <write>
}
 3f2:	60e2                	ld	ra,24(sp)
 3f4:	6442                	ld	s0,16(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret

00000000000003fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fa:	7139                	addi	sp,sp,-64
 3fc:	fc06                	sd	ra,56(sp)
 3fe:	f822                	sd	s0,48(sp)
 400:	f426                	sd	s1,40(sp)
 402:	f04a                	sd	s2,32(sp)
 404:	ec4e                	sd	s3,24(sp)
 406:	0080                	addi	s0,sp,64
 408:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40a:	c299                	beqz	a3,410 <printint+0x16>
 40c:	0805c963          	bltz	a1,49e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 410:	2581                	sext.w	a1,a1
  neg = 0;
 412:	4881                	li	a7,0
 414:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 418:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41a:	2601                	sext.w	a2,a2
 41c:	00000517          	auipc	a0,0x0
 420:	4bc50513          	addi	a0,a0,1212 # 8d8 <digits>
 424:	883a                	mv	a6,a4
 426:	2705                	addiw	a4,a4,1
 428:	02c5f7bb          	remuw	a5,a1,a2
 42c:	1782                	slli	a5,a5,0x20
 42e:	9381                	srli	a5,a5,0x20
 430:	97aa                	add	a5,a5,a0
 432:	0007c783          	lbu	a5,0(a5)
 436:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43a:	0005879b          	sext.w	a5,a1
 43e:	02c5d5bb          	divuw	a1,a1,a2
 442:	0685                	addi	a3,a3,1
 444:	fec7f0e3          	bgeu	a5,a2,424 <printint+0x2a>
  if(neg)
 448:	00088c63          	beqz	a7,460 <printint+0x66>
    buf[i++] = '-';
 44c:	fd070793          	addi	a5,a4,-48
 450:	00878733          	add	a4,a5,s0
 454:	02d00793          	li	a5,45
 458:	fef70823          	sb	a5,-16(a4)
 45c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 460:	02e05863          	blez	a4,490 <printint+0x96>
 464:	fc040793          	addi	a5,s0,-64
 468:	00e78933          	add	s2,a5,a4
 46c:	fff78993          	addi	s3,a5,-1
 470:	99ba                	add	s3,s3,a4
 472:	377d                	addiw	a4,a4,-1
 474:	1702                	slli	a4,a4,0x20
 476:	9301                	srli	a4,a4,0x20
 478:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47c:	fff94583          	lbu	a1,-1(s2)
 480:	8526                	mv	a0,s1
 482:	00000097          	auipc	ra,0x0
 486:	f56080e7          	jalr	-170(ra) # 3d8 <putc>
  while(--i >= 0)
 48a:	197d                	addi	s2,s2,-1
 48c:	ff3918e3          	bne	s2,s3,47c <printint+0x82>
}
 490:	70e2                	ld	ra,56(sp)
 492:	7442                	ld	s0,48(sp)
 494:	74a2                	ld	s1,40(sp)
 496:	7902                	ld	s2,32(sp)
 498:	69e2                	ld	s3,24(sp)
 49a:	6121                	addi	sp,sp,64
 49c:	8082                	ret
    x = -xx;
 49e:	40b005bb          	negw	a1,a1
    neg = 1;
 4a2:	4885                	li	a7,1
    x = -xx;
 4a4:	bf85                	j	414 <printint+0x1a>

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	715d                	addi	sp,sp,-80
 4a8:	e486                	sd	ra,72(sp)
 4aa:	e0a2                	sd	s0,64(sp)
 4ac:	fc26                	sd	s1,56(sp)
 4ae:	f84a                	sd	s2,48(sp)
 4b0:	f44e                	sd	s3,40(sp)
 4b2:	f052                	sd	s4,32(sp)
 4b4:	ec56                	sd	s5,24(sp)
 4b6:	e85a                	sd	s6,16(sp)
 4b8:	e45e                	sd	s7,8(sp)
 4ba:	e062                	sd	s8,0(sp)
 4bc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c903          	lbu	s2,0(a1)
 4c2:	18090c63          	beqz	s2,65a <vprintf+0x1b4>
 4c6:	8aaa                	mv	s5,a0
 4c8:	8bb2                	mv	s7,a2
 4ca:	00158493          	addi	s1,a1,1
  state = 0;
 4ce:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d0:	02500a13          	li	s4,37
 4d4:	4b55                	li	s6,21
 4d6:	a839                	j	4f4 <vprintf+0x4e>
        putc(fd, c);
 4d8:	85ca                	mv	a1,s2
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	efc080e7          	jalr	-260(ra) # 3d8 <putc>
 4e4:	a019                	j	4ea <vprintf+0x44>
    } else if(state == '%'){
 4e6:	01498d63          	beq	s3,s4,500 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4ea:	0485                	addi	s1,s1,1
 4ec:	fff4c903          	lbu	s2,-1(s1)
 4f0:	16090563          	beqz	s2,65a <vprintf+0x1b4>
    if(state == 0){
 4f4:	fe0999e3          	bnez	s3,4e6 <vprintf+0x40>
      if(c == '%'){
 4f8:	ff4910e3          	bne	s2,s4,4d8 <vprintf+0x32>
        state = '%';
 4fc:	89d2                	mv	s3,s4
 4fe:	b7f5                	j	4ea <vprintf+0x44>
      if(c == 'd'){
 500:	13490263          	beq	s2,s4,624 <vprintf+0x17e>
 504:	f9d9079b          	addiw	a5,s2,-99
 508:	0ff7f793          	zext.b	a5,a5
 50c:	12fb6563          	bltu	s6,a5,636 <vprintf+0x190>
 510:	f9d9079b          	addiw	a5,s2,-99
 514:	0ff7f713          	zext.b	a4,a5
 518:	10eb6f63          	bltu	s6,a4,636 <vprintf+0x190>
 51c:	00271793          	slli	a5,a4,0x2
 520:	00000717          	auipc	a4,0x0
 524:	36070713          	addi	a4,a4,864 # 880 <malloc+0x128>
 528:	97ba                	add	a5,a5,a4
 52a:	439c                	lw	a5,0(a5)
 52c:	97ba                	add	a5,a5,a4
 52e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 530:	008b8913          	addi	s2,s7,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000ba583          	lw	a1,0(s7)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	ebc080e7          	jalr	-324(ra) # 3fa <printint>
 546:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	4981                	li	s3,0
 54a:	b745                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54c:	008b8913          	addi	s2,s7,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	ea0080e7          	jalr	-352(ra) # 3fa <printint>
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b751                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 568:	008b8913          	addi	s2,s7,8
 56c:	4681                	li	a3,0
 56e:	4641                	li	a2,16
 570:	000ba583          	lw	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e84080e7          	jalr	-380(ra) # 3fa <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b7a5                	j	4ea <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 584:	008b8c13          	addi	s8,s7,8
 588:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 58c:	03000593          	li	a1,48
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e46080e7          	jalr	-442(ra) # 3d8 <putc>
  putc(fd, 'x');
 59a:	07800593          	li	a1,120
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e38080e7          	jalr	-456(ra) # 3d8 <putc>
 5a8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5aa:	00000b97          	auipc	s7,0x0
 5ae:	32eb8b93          	addi	s7,s7,814 # 8d8 <digits>
 5b2:	03c9d793          	srli	a5,s3,0x3c
 5b6:	97de                	add	a5,a5,s7
 5b8:	0007c583          	lbu	a1,0(a5)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e1a080e7          	jalr	-486(ra) # 3d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c6:	0992                	slli	s3,s3,0x4
 5c8:	397d                	addiw	s2,s2,-1
 5ca:	fe0914e3          	bnez	s2,5b2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ce:	8be2                	mv	s7,s8
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bf21                	j	4ea <vprintf+0x44>
        s = va_arg(ap, char*);
 5d4:	008b8993          	addi	s3,s7,8
 5d8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5dc:	02090163          	beqz	s2,5fe <vprintf+0x158>
        while(*s != 0){
 5e0:	00094583          	lbu	a1,0(s2)
 5e4:	c9a5                	beqz	a1,654 <vprintf+0x1ae>
          putc(fd, *s);
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	df0080e7          	jalr	-528(ra) # 3d8 <putc>
          s++;
 5f0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5f2:	00094583          	lbu	a1,0(s2)
 5f6:	f9e5                	bnez	a1,5e6 <vprintf+0x140>
        s = va_arg(ap, char*);
 5f8:	8bce                	mv	s7,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b5fd                	j	4ea <vprintf+0x44>
          s = "(null)";
 5fe:	00000917          	auipc	s2,0x0
 602:	27a90913          	addi	s2,s2,634 # 878 <malloc+0x120>
        while(*s != 0){
 606:	02800593          	li	a1,40
 60a:	bff1                	j	5e6 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 60c:	008b8913          	addi	s2,s7,8
 610:	000bc583          	lbu	a1,0(s7)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	dc2080e7          	jalr	-574(ra) # 3d8 <putc>
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b5e1                	j	4ea <vprintf+0x44>
        putc(fd, c);
 624:	02500593          	li	a1,37
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	dae080e7          	jalr	-594(ra) # 3d8 <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bd5d                	j	4ea <vprintf+0x44>
        putc(fd, '%');
 636:	02500593          	li	a1,37
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	d9c080e7          	jalr	-612(ra) # 3d8 <putc>
        putc(fd, c);
 644:	85ca                	mv	a1,s2
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	d90080e7          	jalr	-624(ra) # 3d8 <putc>
      state = 0;
 650:	4981                	li	s3,0
 652:	bd61                	j	4ea <vprintf+0x44>
        s = va_arg(ap, char*);
 654:	8bce                	mv	s7,s3
      state = 0;
 656:	4981                	li	s3,0
 658:	bd49                	j	4ea <vprintf+0x44>
    }
  }
}
 65a:	60a6                	ld	ra,72(sp)
 65c:	6406                	ld	s0,64(sp)
 65e:	74e2                	ld	s1,56(sp)
 660:	7942                	ld	s2,48(sp)
 662:	79a2                	ld	s3,40(sp)
 664:	7a02                	ld	s4,32(sp)
 666:	6ae2                	ld	s5,24(sp)
 668:	6b42                	ld	s6,16(sp)
 66a:	6ba2                	ld	s7,8(sp)
 66c:	6c02                	ld	s8,0(sp)
 66e:	6161                	addi	sp,sp,80
 670:	8082                	ret

0000000000000672 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 672:	715d                	addi	sp,sp,-80
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	e010                	sd	a2,0(s0)
 67c:	e414                	sd	a3,8(s0)
 67e:	e818                	sd	a4,16(s0)
 680:	ec1c                	sd	a5,24(s0)
 682:	03043023          	sd	a6,32(s0)
 686:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68e:	8622                	mv	a2,s0
 690:	00000097          	auipc	ra,0x0
 694:	e16080e7          	jalr	-490(ra) # 4a6 <vprintf>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret

00000000000006a0 <printf>:

void
printf(const char *fmt, ...)
{
 6a0:	711d                	addi	sp,sp,-96
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e40c                	sd	a1,8(s0)
 6aa:	e810                	sd	a2,16(s0)
 6ac:	ec14                	sd	a3,24(s0)
 6ae:	f018                	sd	a4,32(s0)
 6b0:	f41c                	sd	a5,40(s0)
 6b2:	03043823          	sd	a6,48(s0)
 6b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ba:	00840613          	addi	a2,s0,8
 6be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c2:	85aa                	mv	a1,a0
 6c4:	4505                	li	a0,1
 6c6:	00000097          	auipc	ra,0x0
 6ca:	de0080e7          	jalr	-544(ra) # 4a6 <vprintf>
}
 6ce:	60e2                	ld	ra,24(sp)
 6d0:	6442                	ld	s0,16(sp)
 6d2:	6125                	addi	sp,sp,96
 6d4:	8082                	ret

00000000000006d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e422                	sd	s0,8(sp)
 6da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	00001797          	auipc	a5,0x1
 6e4:	9207b783          	ld	a5,-1760(a5) # 1000 <freep>
 6e8:	a02d                	j	712 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ea:	4618                	lw	a4,8(a2)
 6ec:	9f2d                	addw	a4,a4,a1
 6ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	6398                	ld	a4,0(a5)
 6f4:	6310                	ld	a2,0(a4)
 6f6:	a83d                	j	734 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9f31                	addw	a4,a4,a2
 6fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053683          	ld	a3,-16(a0)
 704:	a091                	j	748 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 706:	6398                	ld	a4,0(a5)
 708:	00e7e463          	bltu	a5,a4,710 <free+0x3a>
 70c:	00e6ea63          	bltu	a3,a4,720 <free+0x4a>
{
 710:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	fed7fae3          	bgeu	a5,a3,706 <free+0x30>
 716:	6398                	ld	a4,0(a5)
 718:	00e6e463          	bltu	a3,a4,720 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	fee7eae3          	bltu	a5,a4,710 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 720:	ff852583          	lw	a1,-8(a0)
 724:	6390                	ld	a2,0(a5)
 726:	02059813          	slli	a6,a1,0x20
 72a:	01c85713          	srli	a4,a6,0x1c
 72e:	9736                	add	a4,a4,a3
 730:	fae60de3          	beq	a2,a4,6ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 738:	4790                	lw	a2,8(a5)
 73a:	02061593          	slli	a1,a2,0x20
 73e:	01c5d713          	srli	a4,a1,0x1c
 742:	973e                	add	a4,a4,a5
 744:	fae68ae3          	beq	a3,a4,6f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 748:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74a:	00001717          	auipc	a4,0x1
 74e:	8af73b23          	sd	a5,-1866(a4) # 1000 <freep>
}
 752:	6422                	ld	s0,8(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret

0000000000000758 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 758:	7139                	addi	sp,sp,-64
 75a:	fc06                	sd	ra,56(sp)
 75c:	f822                	sd	s0,48(sp)
 75e:	f426                	sd	s1,40(sp)
 760:	f04a                	sd	s2,32(sp)
 762:	ec4e                	sd	s3,24(sp)
 764:	e852                	sd	s4,16(sp)
 766:	e456                	sd	s5,8(sp)
 768:	e05a                	sd	s6,0(sp)
 76a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76c:	02051493          	slli	s1,a0,0x20
 770:	9081                	srli	s1,s1,0x20
 772:	04bd                	addi	s1,s1,15
 774:	8091                	srli	s1,s1,0x4
 776:	0014899b          	addiw	s3,s1,1
 77a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77c:	00001517          	auipc	a0,0x1
 780:	88453503          	ld	a0,-1916(a0) # 1000 <freep>
 784:	c515                	beqz	a0,7b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 786:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 788:	4798                	lw	a4,8(a5)
 78a:	02977f63          	bgeu	a4,s1,7c8 <malloc+0x70>
  if(nu < 4096)
 78e:	8a4e                	mv	s4,s3
 790:	0009871b          	sext.w	a4,s3
 794:	6685                	lui	a3,0x1
 796:	00d77363          	bgeu	a4,a3,79c <malloc+0x44>
 79a:	6a05                	lui	s4,0x1
 79c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a4:	00001917          	auipc	s2,0x1
 7a8:	85c90913          	addi	s2,s2,-1956 # 1000 <freep>
  if(p == (char*)-1)
 7ac:	5afd                	li	s5,-1
 7ae:	a895                	j	822 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7b0:	00001797          	auipc	a5,0x1
 7b4:	86078793          	addi	a5,a5,-1952 # 1010 <base>
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
 7c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c6:	b7e1                	j	78e <malloc+0x36>
      if(p->s.size == nunits)
 7c8:	02e48c63          	beq	s1,a4,800 <malloc+0xa8>
        p->s.size -= nunits;
 7cc:	4137073b          	subw	a4,a4,s3
 7d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d2:	02071693          	slli	a3,a4,0x20
 7d6:	01c6d713          	srli	a4,a3,0x1c
 7da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82a73023          	sd	a0,-2016(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ec:	70e2                	ld	ra,56(sp)
 7ee:	7442                	ld	s0,48(sp)
 7f0:	74a2                	ld	s1,40(sp)
 7f2:	7902                	ld	s2,32(sp)
 7f4:	69e2                	ld	s3,24(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	6121                	addi	sp,sp,64
 7fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	bff1                	j	7e0 <malloc+0x88>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	eca080e7          	jalr	-310(ra) # 6d6 <free>
  return freep;
 814:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 818:	d971                	beqz	a0,7ec <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	fa9775e3          	bgeu	a4,s1,7c8 <malloc+0x70>
    if(p == freep)
 822:	00093703          	ld	a4,0(s2)
 826:	853e                	mv	a0,a5
 828:	fef719e3          	bne	a4,a5,81a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	b92080e7          	jalr	-1134(ra) # 3c0 <sbrk>
  if(p == (char*)-1)
 836:	fd5518e3          	bne	a0,s5,806 <malloc+0xae>
        return 0;
 83a:	4501                	li	a0,0
 83c:	bf45                	j	7ec <malloc+0x94>
