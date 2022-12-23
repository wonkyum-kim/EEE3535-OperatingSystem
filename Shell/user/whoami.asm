
user/_whoami:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/sid.h"

int main(int argc, char **argv) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("Student ID:   %d\n", sid);
   8:	783b05b7          	lui	a1,0x783b0
   c:	5b758593          	addi	a1,a1,1463 # 783b05b7 <base+0x783af5a7>
  10:	00001517          	auipc	a0,0x1
  14:	80050513          	addi	a0,a0,-2048 # 810 <malloc+0xec>
  18:	00000097          	auipc	ra,0x0
  1c:	654080e7          	jalr	1620(ra) # 66c <printf>
    printf("Student name: %s\n", sname);
  20:	00001597          	auipc	a1,0x1
  24:	80858593          	addi	a1,a1,-2040 # 828 <malloc+0x104>
  28:	00001517          	auipc	a0,0x1
  2c:	81050513          	addi	a0,a0,-2032 # 838 <malloc+0x114>
  30:	00000097          	auipc	ra,0x0
  34:	63c080e7          	jalr	1596(ra) # 66c <printf>
    exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	2ca080e7          	jalr	714(ra) # 304 <exit>

0000000000000042 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4a:	00000097          	auipc	ra,0x0
  4e:	fb6080e7          	jalr	-74(ra) # 0 <main>
  exit(0);
  52:	4501                	li	a0,0
  54:	00000097          	auipc	ra,0x0
  58:	2b0080e7          	jalr	688(ra) # 304 <exit>

000000000000005c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e422                	sd	s0,8(sp)
  60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	87aa                	mv	a5,a0
  64:	0585                	addi	a1,a1,1
  66:	0785                	addi	a5,a5,1
  68:	fff5c703          	lbu	a4,-1(a1)
  6c:	fee78fa3          	sb	a4,-1(a5)
  70:	fb75                	bnez	a4,64 <strcpy+0x8>
    ;
  return os;
}
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cb91                	beqz	a5,96 <strcmp+0x1e>
  84:	0005c703          	lbu	a4,0(a1)
  88:	00f71763          	bne	a4,a5,96 <strcmp+0x1e>
    p++, q++;
  8c:	0505                	addi	a0,a0,1
  8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	fbe5                	bnez	a5,84 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  96:	0005c503          	lbu	a0,0(a1)
}
  9a:	40a7853b          	subw	a0,a5,a0
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
  aa:	ce11                	beqz	a2,c6 <strncmp+0x22>
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cf89                	beqz	a5,ca <strncmp+0x26>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71a63          	bne	a4,a5,ca <strncmp+0x26>
    n--, p++, q++;
  ba:	367d                	addiw	a2,a2,-1
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
  c0:	f675                	bnez	a2,ac <strncmp+0x8>
  if(n == 0)
    return 0;
  c2:	4501                	li	a0,0
  c4:	a809                	j	d6 <strncmp+0x32>
  c6:	4501                	li	a0,0
  c8:	a039                	j	d6 <strncmp+0x32>
  if(n == 0)
  ca:	ca09                	beqz	a2,dc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
  cc:	00054503          	lbu	a0,0(a0)
  d0:	0005c783          	lbu	a5,0(a1)
  d4:	9d1d                	subw	a0,a0,a5
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
    return 0;
  dc:	4501                	li	a0,0
  de:	bfe5                	j	d6 <strncmp+0x32>

00000000000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf91                	beqz	a5,106 <strlen+0x26>
  ec:	0505                	addi	a0,a0,1
  ee:	87aa                	mv	a5,a0
  f0:	86be                	mv	a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	ff65                	bnez	a4,f0 <strlen+0x10>
  fa:	40a6853b          	subw	a0,a3,a0
  fe:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfe5                	j	100 <strlen+0x20>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 110:	ca19                	beqz	a2,126 <memset+0x1c>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x12>
  }
  return dst;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb99                	beqz	a5,14c <strchr+0x20>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1a>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xc>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  return 0;
 14c:	4501                	li	a0,0
 14e:	bfe5                	j	146 <strchr+0x1a>

0000000000000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	711d                	addi	sp,sp,-96
 152:	ec86                	sd	ra,88(sp)
 154:	e8a2                	sd	s0,80(sp)
 156:	e4a6                	sd	s1,72(sp)
 158:	e0ca                	sd	s2,64(sp)
 15a:	fc4e                	sd	s3,56(sp)
 15c:	f852                	sd	s4,48(sp)
 15e:	f456                	sd	s5,40(sp)
 160:	f05a                	sd	s6,32(sp)
 162:	ec5e                	sd	s7,24(sp)
 164:	1080                	addi	s0,sp,96
 166:	8baa                	mv	s7,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4aa9                	li	s5,10
 170:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 172:	89a6                	mv	s3,s1
 174:	2485                	addiw	s1,s1,1
 176:	0344d863          	bge	s1,s4,1a6 <gets+0x56>
    cc = read(0, &c, 1);
 17a:	4605                	li	a2,1
 17c:	faf40593          	addi	a1,s0,-81
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	19a080e7          	jalr	410(ra) # 31c <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x56>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x54>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679be3          	bne	a5,s6,172 <gets+0x22>
  for(i=0; i+1 < max; ){
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x56>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e426                	sd	s1,8(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	170080e7          	jalr	368(ra) # 344 <open>
  if(fd < 0)
 1dc:	02054563          	bltz	a0,206 <stat+0x42>
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	178080e7          	jalr	376(ra) # 35c <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	13c080e7          	jalr	316(ra) # 32c <close>
  return r;
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	64a2                	ld	s1,8(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	597d                	li	s2,-1
 208:	bfc5                	j	1f8 <stat+0x34>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66863          	bltu	a2,a5,24e <atoi+0x44>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1c>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x3e>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57463          	bgeu	a0,a1,280 <memmove+0x2e>
    while(n-- > 0)
 25c:	00c05f63          	blez	a2,27a <memmove+0x28>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 268:	872a                	mv	a4,a0
      *dst++ = *src++;
 26a:	0585                	addi	a1,a1,1
 26c:	0705                	addi	a4,a4,1
 26e:	fff5c683          	lbu	a3,-1(a1)
 272:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 276:	fee79ae3          	bne	a5,a4,26a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec05ae3          	blez	a2,27a <memmove+0x28>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x46>
 2a8:	bfc9                	j	27a <memmove+0x28>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca05                	beqz	a2,2e0 <memcmp+0x36>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x14>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x30>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <memcmp+0x30>

00000000000002e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f66080e7          	jalr	-154(ra) # 252 <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b0:	4605                	li	a2,1
 3b2:	fef40593          	addi	a1,s0,-17
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f6e080e7          	jalr	-146(ra) # 324 <write>
}
 3be:	60e2                	ld	ra,24(sp)
 3c0:	6442                	ld	s0,16(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret

00000000000003c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c6:	7139                	addi	sp,sp,-64
 3c8:	fc06                	sd	ra,56(sp)
 3ca:	f822                	sd	s0,48(sp)
 3cc:	f426                	sd	s1,40(sp)
 3ce:	f04a                	sd	s2,32(sp)
 3d0:	ec4e                	sd	s3,24(sp)
 3d2:	0080                	addi	s0,sp,64
 3d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d6:	c299                	beqz	a3,3dc <printint+0x16>
 3d8:	0805c963          	bltz	a1,46a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3dc:	2581                	sext.w	a1,a1
  neg = 0;
 3de:	4881                	li	a7,0
 3e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e6:	2601                	sext.w	a2,a2
 3e8:	00000517          	auipc	a0,0x0
 3ec:	4c850513          	addi	a0,a0,1224 # 8b0 <digits>
 3f0:	883a                	mv	a6,a4
 3f2:	2705                	addiw	a4,a4,1
 3f4:	02c5f7bb          	remuw	a5,a1,a2
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	97aa                	add	a5,a5,a0
 3fe:	0007c783          	lbu	a5,0(a5)
 402:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 406:	0005879b          	sext.w	a5,a1
 40a:	02c5d5bb          	divuw	a1,a1,a2
 40e:	0685                	addi	a3,a3,1
 410:	fec7f0e3          	bgeu	a5,a2,3f0 <printint+0x2a>
  if(neg)
 414:	00088c63          	beqz	a7,42c <printint+0x66>
    buf[i++] = '-';
 418:	fd070793          	addi	a5,a4,-48
 41c:	00878733          	add	a4,a5,s0
 420:	02d00793          	li	a5,45
 424:	fef70823          	sb	a5,-16(a4)
 428:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 42c:	02e05863          	blez	a4,45c <printint+0x96>
 430:	fc040793          	addi	a5,s0,-64
 434:	00e78933          	add	s2,a5,a4
 438:	fff78993          	addi	s3,a5,-1
 43c:	99ba                	add	s3,s3,a4
 43e:	377d                	addiw	a4,a4,-1
 440:	1702                	slli	a4,a4,0x20
 442:	9301                	srli	a4,a4,0x20
 444:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 448:	fff94583          	lbu	a1,-1(s2)
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	f56080e7          	jalr	-170(ra) # 3a4 <putc>
  while(--i >= 0)
 456:	197d                	addi	s2,s2,-1
 458:	ff3918e3          	bne	s2,s3,448 <printint+0x82>
}
 45c:	70e2                	ld	ra,56(sp)
 45e:	7442                	ld	s0,48(sp)
 460:	74a2                	ld	s1,40(sp)
 462:	7902                	ld	s2,32(sp)
 464:	69e2                	ld	s3,24(sp)
 466:	6121                	addi	sp,sp,64
 468:	8082                	ret
    x = -xx;
 46a:	40b005bb          	negw	a1,a1
    neg = 1;
 46e:	4885                	li	a7,1
    x = -xx;
 470:	bf85                	j	3e0 <printint+0x1a>

0000000000000472 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 472:	715d                	addi	sp,sp,-80
 474:	e486                	sd	ra,72(sp)
 476:	e0a2                	sd	s0,64(sp)
 478:	fc26                	sd	s1,56(sp)
 47a:	f84a                	sd	s2,48(sp)
 47c:	f44e                	sd	s3,40(sp)
 47e:	f052                	sd	s4,32(sp)
 480:	ec56                	sd	s5,24(sp)
 482:	e85a                	sd	s6,16(sp)
 484:	e45e                	sd	s7,8(sp)
 486:	e062                	sd	s8,0(sp)
 488:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c903          	lbu	s2,0(a1)
 48e:	18090c63          	beqz	s2,626 <vprintf+0x1b4>
 492:	8aaa                	mv	s5,a0
 494:	8bb2                	mv	s7,a2
 496:	00158493          	addi	s1,a1,1
  state = 0;
 49a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49c:	02500a13          	li	s4,37
 4a0:	4b55                	li	s6,21
 4a2:	a839                	j	4c0 <vprintf+0x4e>
        putc(fd, c);
 4a4:	85ca                	mv	a1,s2
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	efc080e7          	jalr	-260(ra) # 3a4 <putc>
 4b0:	a019                	j	4b6 <vprintf+0x44>
    } else if(state == '%'){
 4b2:	01498d63          	beq	s3,s4,4cc <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4b6:	0485                	addi	s1,s1,1
 4b8:	fff4c903          	lbu	s2,-1(s1)
 4bc:	16090563          	beqz	s2,626 <vprintf+0x1b4>
    if(state == 0){
 4c0:	fe0999e3          	bnez	s3,4b2 <vprintf+0x40>
      if(c == '%'){
 4c4:	ff4910e3          	bne	s2,s4,4a4 <vprintf+0x32>
        state = '%';
 4c8:	89d2                	mv	s3,s4
 4ca:	b7f5                	j	4b6 <vprintf+0x44>
      if(c == 'd'){
 4cc:	13490263          	beq	s2,s4,5f0 <vprintf+0x17e>
 4d0:	f9d9079b          	addiw	a5,s2,-99
 4d4:	0ff7f793          	zext.b	a5,a5
 4d8:	12fb6563          	bltu	s6,a5,602 <vprintf+0x190>
 4dc:	f9d9079b          	addiw	a5,s2,-99
 4e0:	0ff7f713          	zext.b	a4,a5
 4e4:	10eb6f63          	bltu	s6,a4,602 <vprintf+0x190>
 4e8:	00271793          	slli	a5,a4,0x2
 4ec:	00000717          	auipc	a4,0x0
 4f0:	36c70713          	addi	a4,a4,876 # 858 <malloc+0x134>
 4f4:	97ba                	add	a5,a5,a4
 4f6:	439c                	lw	a5,0(a5)
 4f8:	97ba                	add	a5,a5,a4
 4fa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ebc080e7          	jalr	-324(ra) # 3c6 <printint>
 512:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 514:	4981                	li	s3,0
 516:	b745                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 518:	008b8913          	addi	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4629                	li	a2,10
 520:	000ba583          	lw	a1,0(s7)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	ea0080e7          	jalr	-352(ra) # 3c6 <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b751                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 534:	008b8913          	addi	s2,s7,8
 538:	4681                	li	a3,0
 53a:	4641                	li	a2,16
 53c:	000ba583          	lw	a1,0(s7)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e84080e7          	jalr	-380(ra) # 3c6 <printint>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b7a5                	j	4b6 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 550:	008b8c13          	addi	s8,s7,8
 554:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 558:	03000593          	li	a1,48
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e46080e7          	jalr	-442(ra) # 3a4 <putc>
  putc(fd, 'x');
 566:	07800593          	li	a1,120
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e38080e7          	jalr	-456(ra) # 3a4 <putc>
 574:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 576:	00000b97          	auipc	s7,0x0
 57a:	33ab8b93          	addi	s7,s7,826 # 8b0 <digits>
 57e:	03c9d793          	srli	a5,s3,0x3c
 582:	97de                	add	a5,a5,s7
 584:	0007c583          	lbu	a1,0(a5)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e1a080e7          	jalr	-486(ra) # 3a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 592:	0992                	slli	s3,s3,0x4
 594:	397d                	addiw	s2,s2,-1
 596:	fe0914e3          	bnez	s2,57e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 59a:	8be2                	mv	s7,s8
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf21                	j	4b6 <vprintf+0x44>
        s = va_arg(ap, char*);
 5a0:	008b8993          	addi	s3,s7,8
 5a4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5a8:	02090163          	beqz	s2,5ca <vprintf+0x158>
        while(*s != 0){
 5ac:	00094583          	lbu	a1,0(s2)
 5b0:	c9a5                	beqz	a1,620 <vprintf+0x1ae>
          putc(fd, *s);
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	df0080e7          	jalr	-528(ra) # 3a4 <putc>
          s++;
 5bc:	0905                	addi	s2,s2,1
        while(*s != 0){
 5be:	00094583          	lbu	a1,0(s2)
 5c2:	f9e5                	bnez	a1,5b2 <vprintf+0x140>
        s = va_arg(ap, char*);
 5c4:	8bce                	mv	s7,s3
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b5fd                	j	4b6 <vprintf+0x44>
          s = "(null)";
 5ca:	00000917          	auipc	s2,0x0
 5ce:	28690913          	addi	s2,s2,646 # 850 <malloc+0x12c>
        while(*s != 0){
 5d2:	02800593          	li	a1,40
 5d6:	bff1                	j	5b2 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	000bc583          	lbu	a1,0(s7)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	dc2080e7          	jalr	-574(ra) # 3a4 <putc>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b5e1                	j	4b6 <vprintf+0x44>
        putc(fd, c);
 5f0:	02500593          	li	a1,37
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	dae080e7          	jalr	-594(ra) # 3a4 <putc>
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bd5d                	j	4b6 <vprintf+0x44>
        putc(fd, '%');
 602:	02500593          	li	a1,37
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d9c080e7          	jalr	-612(ra) # 3a4 <putc>
        putc(fd, c);
 610:	85ca                	mv	a1,s2
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	d90080e7          	jalr	-624(ra) # 3a4 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bd61                	j	4b6 <vprintf+0x44>
        s = va_arg(ap, char*);
 620:	8bce                	mv	s7,s3
      state = 0;
 622:	4981                	li	s3,0
 624:	bd49                	j	4b6 <vprintf+0x44>
    }
  }
}
 626:	60a6                	ld	ra,72(sp)
 628:	6406                	ld	s0,64(sp)
 62a:	74e2                	ld	s1,56(sp)
 62c:	7942                	ld	s2,48(sp)
 62e:	79a2                	ld	s3,40(sp)
 630:	7a02                	ld	s4,32(sp)
 632:	6ae2                	ld	s5,24(sp)
 634:	6b42                	ld	s6,16(sp)
 636:	6ba2                	ld	s7,8(sp)
 638:	6c02                	ld	s8,0(sp)
 63a:	6161                	addi	sp,sp,80
 63c:	8082                	ret

000000000000063e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63e:	715d                	addi	sp,sp,-80
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	e010                	sd	a2,0(s0)
 648:	e414                	sd	a3,8(s0)
 64a:	e818                	sd	a4,16(s0)
 64c:	ec1c                	sd	a5,24(s0)
 64e:	03043023          	sd	a6,32(s0)
 652:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 656:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65a:	8622                	mv	a2,s0
 65c:	00000097          	auipc	ra,0x0
 660:	e16080e7          	jalr	-490(ra) # 472 <vprintf>
}
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	6161                	addi	sp,sp,80
 66a:	8082                	ret

000000000000066c <printf>:

void
printf(const char *fmt, ...)
{
 66c:	711d                	addi	sp,sp,-96
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	e40c                	sd	a1,8(s0)
 676:	e810                	sd	a2,16(s0)
 678:	ec14                	sd	a3,24(s0)
 67a:	f018                	sd	a4,32(s0)
 67c:	f41c                	sd	a5,40(s0)
 67e:	03043823          	sd	a6,48(s0)
 682:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 686:	00840613          	addi	a2,s0,8
 68a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68e:	85aa                	mv	a1,a0
 690:	4505                	li	a0,1
 692:	00000097          	auipc	ra,0x0
 696:	de0080e7          	jalr	-544(ra) # 472 <vprintf>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6125                	addi	sp,sp,96
 6a0:	8082                	ret

00000000000006a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a2:	1141                	addi	sp,sp,-16
 6a4:	e422                	sd	s0,8(sp)
 6a6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	00001797          	auipc	a5,0x1
 6b0:	9547b783          	ld	a5,-1708(a5) # 1000 <freep>
 6b4:	a02d                	j	6de <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b6:	4618                	lw	a4,8(a2)
 6b8:	9f2d                	addw	a4,a4,a1
 6ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	6398                	ld	a4,0(a5)
 6c0:	6310                	ld	a2,0(a4)
 6c2:	a83d                	j	700 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c4:	ff852703          	lw	a4,-8(a0)
 6c8:	9f31                	addw	a4,a4,a2
 6ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6cc:	ff053683          	ld	a3,-16(a0)
 6d0:	a091                	j	714 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d2:	6398                	ld	a4,0(a5)
 6d4:	00e7e463          	bltu	a5,a4,6dc <free+0x3a>
 6d8:	00e6ea63          	bltu	a3,a4,6ec <free+0x4a>
{
 6dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	fed7fae3          	bgeu	a5,a3,6d2 <free+0x30>
 6e2:	6398                	ld	a4,0(a5)
 6e4:	00e6e463          	bltu	a3,a4,6ec <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	fee7eae3          	bltu	a5,a4,6dc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ec:	ff852583          	lw	a1,-8(a0)
 6f0:	6390                	ld	a2,0(a5)
 6f2:	02059813          	slli	a6,a1,0x20
 6f6:	01c85713          	srli	a4,a6,0x1c
 6fa:	9736                	add	a4,a4,a3
 6fc:	fae60de3          	beq	a2,a4,6b6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 704:	4790                	lw	a2,8(a5)
 706:	02061593          	slli	a1,a2,0x20
 70a:	01c5d713          	srli	a4,a1,0x1c
 70e:	973e                	add	a4,a4,a5
 710:	fae68ae3          	beq	a3,a4,6c4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 714:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 716:	00001717          	auipc	a4,0x1
 71a:	8ef73523          	sd	a5,-1814(a4) # 1000 <freep>
}
 71e:	6422                	ld	s0,8(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 724:	7139                	addi	sp,sp,-64
 726:	fc06                	sd	ra,56(sp)
 728:	f822                	sd	s0,48(sp)
 72a:	f426                	sd	s1,40(sp)
 72c:	f04a                	sd	s2,32(sp)
 72e:	ec4e                	sd	s3,24(sp)
 730:	e852                	sd	s4,16(sp)
 732:	e456                	sd	s5,8(sp)
 734:	e05a                	sd	s6,0(sp)
 736:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 738:	02051493          	slli	s1,a0,0x20
 73c:	9081                	srli	s1,s1,0x20
 73e:	04bd                	addi	s1,s1,15
 740:	8091                	srli	s1,s1,0x4
 742:	0014899b          	addiw	s3,s1,1
 746:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 748:	00001517          	auipc	a0,0x1
 74c:	8b853503          	ld	a0,-1864(a0) # 1000 <freep>
 750:	c515                	beqz	a0,77c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 754:	4798                	lw	a4,8(a5)
 756:	02977f63          	bgeu	a4,s1,794 <malloc+0x70>
  if(nu < 4096)
 75a:	8a4e                	mv	s4,s3
 75c:	0009871b          	sext.w	a4,s3
 760:	6685                	lui	a3,0x1
 762:	00d77363          	bgeu	a4,a3,768 <malloc+0x44>
 766:	6a05                	lui	s4,0x1
 768:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 770:	00001917          	auipc	s2,0x1
 774:	89090913          	addi	s2,s2,-1904 # 1000 <freep>
  if(p == (char*)-1)
 778:	5afd                	li	s5,-1
 77a:	a895                	j	7ee <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 77c:	00001797          	auipc	a5,0x1
 780:	89478793          	addi	a5,a5,-1900 # 1010 <base>
 784:	00001717          	auipc	a4,0x1
 788:	86f73e23          	sd	a5,-1924(a4) # 1000 <freep>
 78c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 792:	b7e1                	j	75a <malloc+0x36>
      if(p->s.size == nunits)
 794:	02e48c63          	beq	s1,a4,7cc <malloc+0xa8>
        p->s.size -= nunits;
 798:	4137073b          	subw	a4,a4,s3
 79c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79e:	02071693          	slli	a3,a4,0x20
 7a2:	01c6d713          	srli	a4,a3,0x1c
 7a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84a73a23          	sd	a0,-1964(a4) # 1000 <freep>
      return (void*)(p + 1);
 7b4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b8:	70e2                	ld	ra,56(sp)
 7ba:	7442                	ld	s0,48(sp)
 7bc:	74a2                	ld	s1,40(sp)
 7be:	7902                	ld	s2,32(sp)
 7c0:	69e2                	ld	s3,24(sp)
 7c2:	6a42                	ld	s4,16(sp)
 7c4:	6aa2                	ld	s5,8(sp)
 7c6:	6b02                	ld	s6,0(sp)
 7c8:	6121                	addi	sp,sp,64
 7ca:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7cc:	6398                	ld	a4,0(a5)
 7ce:	e118                	sd	a4,0(a0)
 7d0:	bff1                	j	7ac <malloc+0x88>
  hp->s.size = nu;
 7d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d6:	0541                	addi	a0,a0,16
 7d8:	00000097          	auipc	ra,0x0
 7dc:	eca080e7          	jalr	-310(ra) # 6a2 <free>
  return freep;
 7e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e4:	d971                	beqz	a0,7b8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e8:	4798                	lw	a4,8(a5)
 7ea:	fa9775e3          	bgeu	a4,s1,794 <malloc+0x70>
    if(p == freep)
 7ee:	00093703          	ld	a4,0(s2)
 7f2:	853e                	mv	a0,a5
 7f4:	fef719e3          	bne	a4,a5,7e6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7f8:	8552                	mv	a0,s4
 7fa:	00000097          	auipc	ra,0x0
 7fe:	b92080e7          	jalr	-1134(ra) # 38c <sbrk>
  if(p == (char*)-1)
 802:	fd5518e3          	bne	a0,s5,7d2 <malloc+0xae>
        return 0;
 806:	4501                	li	a0,0
 808:	bf45                	j	7b8 <malloc+0x94>
