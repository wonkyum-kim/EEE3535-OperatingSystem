
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	830a8a93          	addi	s5,s5,-2000 # 860 <malloc+0xf0>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	330080e7          	jalr	816(ra) # 370 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	0d8080e7          	jalr	216(ra) # 12c <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	30c080e7          	jalr	780(ra) # 370 <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00000597          	auipc	a1,0x0
  76:	7f658593          	addi	a1,a1,2038 # 868 <malloc+0xf8>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2f4080e7          	jalr	756(ra) # 370 <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	2ca080e7          	jalr	714(ra) # 350 <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	2b0080e7          	jalr	688(ra) # 350 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	addi	a1,a1,1
  b2:	0785                	addi	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	addi	a0,a0,1
  da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
  f6:	ce11                	beqz	a2,112 <strncmp+0x22>
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf89                	beqz	a5,116 <strncmp+0x26>
  fe:	0005c703          	lbu	a4,0(a1)
 102:	00f71a63          	bne	a4,a5,116 <strncmp+0x26>
    n--, p++, q++;
 106:	367d                	addiw	a2,a2,-1
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 10c:	f675                	bnez	a2,f8 <strncmp+0x8>
  if(n == 0)
    return 0;
 10e:	4501                	li	a0,0
 110:	a809                	j	122 <strncmp+0x32>
 112:	4501                	li	a0,0
 114:	a039                	j	122 <strncmp+0x32>
  if(n == 0)
 116:	ca09                	beqz	a2,128 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 118:	00054503          	lbu	a0,0(a0)
 11c:	0005c783          	lbu	a5,0(a1)
 120:	9d1d                	subw	a0,a0,a5
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
    return 0;
 128:	4501                	li	a0,0
 12a:	bfe5                	j	122 <strncmp+0x32>

000000000000012c <strlen>:

uint
strlen(const char *s)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cf91                	beqz	a5,152 <strlen+0x26>
 138:	0505                	addi	a0,a0,1
 13a:	87aa                	mv	a5,a0
 13c:	86be                	mv	a3,a5
 13e:	0785                	addi	a5,a5,1
 140:	fff7c703          	lbu	a4,-1(a5)
 144:	ff65                	bnez	a4,13c <strlen+0x10>
 146:	40a6853b          	subw	a0,a3,a0
 14a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  for(n = 0; s[n]; n++)
 152:	4501                	li	a0,0
 154:	bfe5                	j	14c <strlen+0x20>

0000000000000156 <memset>:

void*
memset(void *dst, int c, uint n)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15c:	ca19                	beqz	a2,172 <memset+0x1c>
 15e:	87aa                	mv	a5,a0
 160:	1602                	slli	a2,a2,0x20
 162:	9201                	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x12>
  }
  return dst;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strchr>:

char*
strchr(const char *s, char c)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb99                	beqz	a5,198 <strchr+0x20>
    if(*s == c)
 184:	00f58763          	beq	a1,a5,192 <strchr+0x1a>
  for(; *s; s++)
 188:	0505                	addi	a0,a0,1
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbfd                	bnez	a5,184 <strchr+0xc>
      return (char*)s;
  return 0;
 190:	4501                	li	a0,0
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret
  return 0;
 198:	4501                	li	a0,0
 19a:	bfe5                	j	192 <strchr+0x1a>

000000000000019c <gets>:

char*
gets(char *buf, int max)
{
 19c:	711d                	addi	sp,sp,-96
 19e:	ec86                	sd	ra,88(sp)
 1a0:	e8a2                	sd	s0,80(sp)
 1a2:	e4a6                	sd	s1,72(sp)
 1a4:	e0ca                	sd	s2,64(sp)
 1a6:	fc4e                	sd	s3,56(sp)
 1a8:	f852                	sd	s4,48(sp)
 1aa:	f456                	sd	s5,40(sp)
 1ac:	f05a                	sd	s6,32(sp)
 1ae:	ec5e                	sd	s7,24(sp)
 1b0:	1080                	addi	s0,sp,96
 1b2:	8baa                	mv	s7,a0
 1b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b6:	892a                	mv	s2,a0
 1b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ba:	4aa9                	li	s5,10
 1bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1be:	89a6                	mv	s3,s1
 1c0:	2485                	addiw	s1,s1,1
 1c2:	0344d863          	bge	s1,s4,1f2 <gets+0x56>
    cc = read(0, &c, 1);
 1c6:	4605                	li	a2,1
 1c8:	faf40593          	addi	a1,s0,-81
 1cc:	4501                	li	a0,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	19a080e7          	jalr	410(ra) # 368 <read>
    if(cc < 1)
 1d6:	00a05e63          	blez	a0,1f2 <gets+0x56>
    buf[i++] = c;
 1da:	faf44783          	lbu	a5,-81(s0)
 1de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e2:	01578763          	beq	a5,s5,1f0 <gets+0x54>
 1e6:	0905                	addi	s2,s2,1
 1e8:	fd679be3          	bne	a5,s6,1be <gets+0x22>
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	a011                	j	1f2 <gets+0x56>
 1f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f2:	99de                	add	s3,s3,s7
 1f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f8:	855e                	mv	a0,s7
 1fa:	60e6                	ld	ra,88(sp)
 1fc:	6446                	ld	s0,80(sp)
 1fe:	64a6                	ld	s1,72(sp)
 200:	6906                	ld	s2,64(sp)
 202:	79e2                	ld	s3,56(sp)
 204:	7a42                	ld	s4,48(sp)
 206:	7aa2                	ld	s5,40(sp)
 208:	7b02                	ld	s6,32(sp)
 20a:	6be2                	ld	s7,24(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e426                	sd	s1,8(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	00000097          	auipc	ra,0x0
 224:	170080e7          	jalr	368(ra) # 390 <open>
  if(fd < 0)
 228:	02054563          	bltz	a0,252 <stat+0x42>
 22c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22e:	85ca                	mv	a1,s2
 230:	00000097          	auipc	ra,0x0
 234:	178080e7          	jalr	376(ra) # 3a8 <fstat>
 238:	892a                	mv	s2,a0
  close(fd);
 23a:	8526                	mv	a0,s1
 23c:	00000097          	auipc	ra,0x0
 240:	13c080e7          	jalr	316(ra) # 378 <close>
  return r;
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	64a2                	ld	s1,8(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfc5                	j	244 <stat+0x34>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054683          	lbu	a3,0(a0)
 260:	fd06879b          	addiw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	4625                	li	a2,9
 26a:	02f66863          	bltu	a2,a5,29a <atoi+0x44>
 26e:	872a                	mv	a4,a0
  n = 0;
 270:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 272:	0705                	addi	a4,a4,1
 274:	0025179b          	slliw	a5,a0,0x2
 278:	9fa9                	addw	a5,a5,a0
 27a:	0017979b          	slliw	a5,a5,0x1
 27e:	9fb5                	addw	a5,a5,a3
 280:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 284:	00074683          	lbu	a3,0(a4)
 288:	fd06879b          	addiw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	fef671e3          	bgeu	a2,a5,272 <atoi+0x1c>
  return n;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  n = 0;
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <atoi+0x3e>

000000000000029e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a4:	02b57463          	bgeu	a0,a1,2cc <memmove+0x2e>
    while(n-- > 0)
 2a8:	00c05f63          	blez	a2,2c6 <memmove+0x28>
 2ac:	1602                	slli	a2,a2,0x20
 2ae:	9201                	srli	a2,a2,0x20
 2b0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b6:	0585                	addi	a1,a1,1
 2b8:	0705                	addi	a4,a4,1
 2ba:	fff5c683          	lbu	a3,-1(a1)
 2be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c2:	fee79ae3          	bne	a5,a4,2b6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d2:	fec05ae3          	blez	a2,2c6 <memmove+0x28>
 2d6:	fff6079b          	addiw	a5,a2,-1
 2da:	1782                	slli	a5,a5,0x20
 2dc:	9381                	srli	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	addi	a1,a1,-1
 2e6:	177d                	addi	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x46>
 2f4:	bfc9                	j	2c6 <memmove+0x28>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ca05                	beqz	a2,32c <memcmp+0x36>
 2fe:	fff6069b          	addiw	a3,a2,-1
 302:	1682                	slli	a3,a3,0x20
 304:	9281                	srli	a3,a3,0x20
 306:	0685                	addi	a3,a3,1
 308:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30a:	00054783          	lbu	a5,0(a0)
 30e:	0005c703          	lbu	a4,0(a1)
 312:	00e79863          	bne	a5,a4,322 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 316:	0505                	addi	a0,a0,1
    p2++;
 318:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31a:	fed518e3          	bne	a0,a3,30a <memcmp+0x14>
  }
  return 0;
 31e:	4501                	li	a0,0
 320:	a019                	j	326 <memcmp+0x30>
      return *p1 - *p2;
 322:	40e7853b          	subw	a0,a5,a4
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfe5                	j	326 <memcmp+0x30>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 338:	00000097          	auipc	ra,0x0
 33c:	f66080e7          	jalr	-154(ra) # 29e <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f0:	1101                	addi	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	1000                	addi	s0,sp,32
 3f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fc:	4605                	li	a2,1
 3fe:	fef40593          	addi	a1,s0,-17
 402:	00000097          	auipc	ra,0x0
 406:	f6e080e7          	jalr	-146(ra) # 370 <write>
}
 40a:	60e2                	ld	ra,24(sp)
 40c:	6442                	ld	s0,16(sp)
 40e:	6105                	addi	sp,sp,32
 410:	8082                	ret

0000000000000412 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 412:	7139                	addi	sp,sp,-64
 414:	fc06                	sd	ra,56(sp)
 416:	f822                	sd	s0,48(sp)
 418:	f426                	sd	s1,40(sp)
 41a:	f04a                	sd	s2,32(sp)
 41c:	ec4e                	sd	s3,24(sp)
 41e:	0080                	addi	s0,sp,64
 420:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 422:	c299                	beqz	a3,428 <printint+0x16>
 424:	0805c963          	bltz	a1,4b6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 428:	2581                	sext.w	a1,a1
  neg = 0;
 42a:	4881                	li	a7,0
 42c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 430:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 432:	2601                	sext.w	a2,a2
 434:	00000517          	auipc	a0,0x0
 438:	49c50513          	addi	a0,a0,1180 # 8d0 <digits>
 43c:	883a                	mv	a6,a4
 43e:	2705                	addiw	a4,a4,1
 440:	02c5f7bb          	remuw	a5,a1,a2
 444:	1782                	slli	a5,a5,0x20
 446:	9381                	srli	a5,a5,0x20
 448:	97aa                	add	a5,a5,a0
 44a:	0007c783          	lbu	a5,0(a5)
 44e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 452:	0005879b          	sext.w	a5,a1
 456:	02c5d5bb          	divuw	a1,a1,a2
 45a:	0685                	addi	a3,a3,1
 45c:	fec7f0e3          	bgeu	a5,a2,43c <printint+0x2a>
  if(neg)
 460:	00088c63          	beqz	a7,478 <printint+0x66>
    buf[i++] = '-';
 464:	fd070793          	addi	a5,a4,-48
 468:	00878733          	add	a4,a5,s0
 46c:	02d00793          	li	a5,45
 470:	fef70823          	sb	a5,-16(a4)
 474:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 478:	02e05863          	blez	a4,4a8 <printint+0x96>
 47c:	fc040793          	addi	a5,s0,-64
 480:	00e78933          	add	s2,a5,a4
 484:	fff78993          	addi	s3,a5,-1
 488:	99ba                	add	s3,s3,a4
 48a:	377d                	addiw	a4,a4,-1
 48c:	1702                	slli	a4,a4,0x20
 48e:	9301                	srli	a4,a4,0x20
 490:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 494:	fff94583          	lbu	a1,-1(s2)
 498:	8526                	mv	a0,s1
 49a:	00000097          	auipc	ra,0x0
 49e:	f56080e7          	jalr	-170(ra) # 3f0 <putc>
  while(--i >= 0)
 4a2:	197d                	addi	s2,s2,-1
 4a4:	ff3918e3          	bne	s2,s3,494 <printint+0x82>
}
 4a8:	70e2                	ld	ra,56(sp)
 4aa:	7442                	ld	s0,48(sp)
 4ac:	74a2                	ld	s1,40(sp)
 4ae:	7902                	ld	s2,32(sp)
 4b0:	69e2                	ld	s3,24(sp)
 4b2:	6121                	addi	sp,sp,64
 4b4:	8082                	ret
    x = -xx;
 4b6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ba:	4885                	li	a7,1
    x = -xx;
 4bc:	bf85                	j	42c <printint+0x1a>

00000000000004be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4be:	715d                	addi	sp,sp,-80
 4c0:	e486                	sd	ra,72(sp)
 4c2:	e0a2                	sd	s0,64(sp)
 4c4:	fc26                	sd	s1,56(sp)
 4c6:	f84a                	sd	s2,48(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	f052                	sd	s4,32(sp)
 4cc:	ec56                	sd	s5,24(sp)
 4ce:	e85a                	sd	s6,16(sp)
 4d0:	e45e                	sd	s7,8(sp)
 4d2:	e062                	sd	s8,0(sp)
 4d4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d6:	0005c903          	lbu	s2,0(a1)
 4da:	18090c63          	beqz	s2,672 <vprintf+0x1b4>
 4de:	8aaa                	mv	s5,a0
 4e0:	8bb2                	mv	s7,a2
 4e2:	00158493          	addi	s1,a1,1
  state = 0;
 4e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e8:	02500a13          	li	s4,37
 4ec:	4b55                	li	s6,21
 4ee:	a839                	j	50c <vprintf+0x4e>
        putc(fd, c);
 4f0:	85ca                	mv	a1,s2
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	efc080e7          	jalr	-260(ra) # 3f0 <putc>
 4fc:	a019                	j	502 <vprintf+0x44>
    } else if(state == '%'){
 4fe:	01498d63          	beq	s3,s4,518 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 502:	0485                	addi	s1,s1,1
 504:	fff4c903          	lbu	s2,-1(s1)
 508:	16090563          	beqz	s2,672 <vprintf+0x1b4>
    if(state == 0){
 50c:	fe0999e3          	bnez	s3,4fe <vprintf+0x40>
      if(c == '%'){
 510:	ff4910e3          	bne	s2,s4,4f0 <vprintf+0x32>
        state = '%';
 514:	89d2                	mv	s3,s4
 516:	b7f5                	j	502 <vprintf+0x44>
      if(c == 'd'){
 518:	13490263          	beq	s2,s4,63c <vprintf+0x17e>
 51c:	f9d9079b          	addiw	a5,s2,-99
 520:	0ff7f793          	zext.b	a5,a5
 524:	12fb6563          	bltu	s6,a5,64e <vprintf+0x190>
 528:	f9d9079b          	addiw	a5,s2,-99
 52c:	0ff7f713          	zext.b	a4,a5
 530:	10eb6f63          	bltu	s6,a4,64e <vprintf+0x190>
 534:	00271793          	slli	a5,a4,0x2
 538:	00000717          	auipc	a4,0x0
 53c:	34070713          	addi	a4,a4,832 # 878 <malloc+0x108>
 540:	97ba                	add	a5,a5,a4
 542:	439c                	lw	a5,0(a5)
 544:	97ba                	add	a5,a5,a4
 546:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 548:	008b8913          	addi	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	ebc080e7          	jalr	-324(ra) # 412 <printint>
 55e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 560:	4981                	li	s3,0
 562:	b745                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 564:	008b8913          	addi	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	ea0080e7          	jalr	-352(ra) # 412 <printint>
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b751                	j	502 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 580:	008b8913          	addi	s2,s7,8
 584:	4681                	li	a3,0
 586:	4641                	li	a2,16
 588:	000ba583          	lw	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e84080e7          	jalr	-380(ra) # 412 <printint>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b7a5                	j	502 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 59c:	008b8c13          	addi	s8,s7,8
 5a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5a4:	03000593          	li	a1,48
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e46080e7          	jalr	-442(ra) # 3f0 <putc>
  putc(fd, 'x');
 5b2:	07800593          	li	a1,120
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e38080e7          	jalr	-456(ra) # 3f0 <putc>
 5c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c2:	00000b97          	auipc	s7,0x0
 5c6:	30eb8b93          	addi	s7,s7,782 # 8d0 <digits>
 5ca:	03c9d793          	srli	a5,s3,0x3c
 5ce:	97de                	add	a5,a5,s7
 5d0:	0007c583          	lbu	a1,0(a5)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e1a080e7          	jalr	-486(ra) # 3f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5de:	0992                	slli	s3,s3,0x4
 5e0:	397d                	addiw	s2,s2,-1
 5e2:	fe0914e3          	bnez	s2,5ca <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5e6:	8be2                	mv	s7,s8
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bf21                	j	502 <vprintf+0x44>
        s = va_arg(ap, char*);
 5ec:	008b8993          	addi	s3,s7,8
 5f0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5f4:	02090163          	beqz	s2,616 <vprintf+0x158>
        while(*s != 0){
 5f8:	00094583          	lbu	a1,0(s2)
 5fc:	c9a5                	beqz	a1,66c <vprintf+0x1ae>
          putc(fd, *s);
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	df0080e7          	jalr	-528(ra) # 3f0 <putc>
          s++;
 608:	0905                	addi	s2,s2,1
        while(*s != 0){
 60a:	00094583          	lbu	a1,0(s2)
 60e:	f9e5                	bnez	a1,5fe <vprintf+0x140>
        s = va_arg(ap, char*);
 610:	8bce                	mv	s7,s3
      state = 0;
 612:	4981                	li	s3,0
 614:	b5fd                	j	502 <vprintf+0x44>
          s = "(null)";
 616:	00000917          	auipc	s2,0x0
 61a:	25a90913          	addi	s2,s2,602 # 870 <malloc+0x100>
        while(*s != 0){
 61e:	02800593          	li	a1,40
 622:	bff1                	j	5fe <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 624:	008b8913          	addi	s2,s7,8
 628:	000bc583          	lbu	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	dc2080e7          	jalr	-574(ra) # 3f0 <putc>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b5e1                	j	502 <vprintf+0x44>
        putc(fd, c);
 63c:	02500593          	li	a1,37
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	dae080e7          	jalr	-594(ra) # 3f0 <putc>
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bd5d                	j	502 <vprintf+0x44>
        putc(fd, '%');
 64e:	02500593          	li	a1,37
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	d9c080e7          	jalr	-612(ra) # 3f0 <putc>
        putc(fd, c);
 65c:	85ca                	mv	a1,s2
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	d90080e7          	jalr	-624(ra) # 3f0 <putc>
      state = 0;
 668:	4981                	li	s3,0
 66a:	bd61                	j	502 <vprintf+0x44>
        s = va_arg(ap, char*);
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	bd49                	j	502 <vprintf+0x44>
    }
  }
}
 672:	60a6                	ld	ra,72(sp)
 674:	6406                	ld	s0,64(sp)
 676:	74e2                	ld	s1,56(sp)
 678:	7942                	ld	s2,48(sp)
 67a:	79a2                	ld	s3,40(sp)
 67c:	7a02                	ld	s4,32(sp)
 67e:	6ae2                	ld	s5,24(sp)
 680:	6b42                	ld	s6,16(sp)
 682:	6ba2                	ld	s7,8(sp)
 684:	6c02                	ld	s8,0(sp)
 686:	6161                	addi	sp,sp,80
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e16080e7          	jalr	-490(ra) # 4be <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	00000097          	auipc	ra,0x0
 6e2:	de0080e7          	jalr	-544(ra) # 4be <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	00001797          	auipc	a5,0x1
 6fc:	9087b783          	ld	a5,-1784(a5) # 1000 <freep>
 700:	a02d                	j	72a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 702:	4618                	lw	a4,8(a2)
 704:	9f2d                	addw	a4,a4,a1
 706:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	6398                	ld	a4,0(a5)
 70c:	6310                	ld	a2,0(a4)
 70e:	a83d                	j	74c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 710:	ff852703          	lw	a4,-8(a0)
 714:	9f31                	addw	a4,a4,a2
 716:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 718:	ff053683          	ld	a3,-16(a0)
 71c:	a091                	j	760 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	6398                	ld	a4,0(a5)
 720:	00e7e463          	bltu	a5,a4,728 <free+0x3a>
 724:	00e6ea63          	bltu	a3,a4,738 <free+0x4a>
{
 728:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	fed7fae3          	bgeu	a5,a3,71e <free+0x30>
 72e:	6398                	ld	a4,0(a5)
 730:	00e6e463          	bltu	a3,a4,738 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 734:	fee7eae3          	bltu	a5,a4,728 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 738:	ff852583          	lw	a1,-8(a0)
 73c:	6390                	ld	a2,0(a5)
 73e:	02059813          	slli	a6,a1,0x20
 742:	01c85713          	srli	a4,a6,0x1c
 746:	9736                	add	a4,a4,a3
 748:	fae60de3          	beq	a2,a4,702 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 750:	4790                	lw	a2,8(a5)
 752:	02061593          	slli	a1,a2,0x20
 756:	01c5d713          	srli	a4,a1,0x1c
 75a:	973e                	add	a4,a4,a5
 75c:	fae68ae3          	beq	a3,a4,710 <free+0x22>
    p->s.ptr = bp->s.ptr;
 760:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 762:	00001717          	auipc	a4,0x1
 766:	88f73f23          	sd	a5,-1890(a4) # 1000 <freep>
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret

0000000000000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	7139                	addi	sp,sp,-64
 772:	fc06                	sd	ra,56(sp)
 774:	f822                	sd	s0,48(sp)
 776:	f426                	sd	s1,40(sp)
 778:	f04a                	sd	s2,32(sp)
 77a:	ec4e                	sd	s3,24(sp)
 77c:	e852                	sd	s4,16(sp)
 77e:	e456                	sd	s5,8(sp)
 780:	e05a                	sd	s6,0(sp)
 782:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 784:	02051493          	slli	s1,a0,0x20
 788:	9081                	srli	s1,s1,0x20
 78a:	04bd                	addi	s1,s1,15
 78c:	8091                	srli	s1,s1,0x4
 78e:	0014899b          	addiw	s3,s1,1
 792:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 794:	00001517          	auipc	a0,0x1
 798:	86c53503          	ld	a0,-1940(a0) # 1000 <freep>
 79c:	c515                	beqz	a0,7c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a0:	4798                	lw	a4,8(a5)
 7a2:	02977f63          	bgeu	a4,s1,7e0 <malloc+0x70>
  if(nu < 4096)
 7a6:	8a4e                	mv	s4,s3
 7a8:	0009871b          	sext.w	a4,s3
 7ac:	6685                	lui	a3,0x1
 7ae:	00d77363          	bgeu	a4,a3,7b4 <malloc+0x44>
 7b2:	6a05                	lui	s4,0x1
 7b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7bc:	00001917          	auipc	s2,0x1
 7c0:	84490913          	addi	s2,s2,-1980 # 1000 <freep>
  if(p == (char*)-1)
 7c4:	5afd                	li	s5,-1
 7c6:	a895                	j	83a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7c8:	00001797          	auipc	a5,0x1
 7cc:	84878793          	addi	a5,a5,-1976 # 1010 <base>
 7d0:	00001717          	auipc	a4,0x1
 7d4:	82f73823          	sd	a5,-2000(a4) # 1000 <freep>
 7d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7de:	b7e1                	j	7a6 <malloc+0x36>
      if(p->s.size == nunits)
 7e0:	02e48c63          	beq	s1,a4,818 <malloc+0xa8>
        p->s.size -= nunits;
 7e4:	4137073b          	subw	a4,a4,s3
 7e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ea:	02071693          	slli	a3,a4,0x20
 7ee:	01c6d713          	srli	a4,a3,0x1c
 7f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80a73423          	sd	a0,-2040(a4) # 1000 <freep>
      return (void*)(p + 1);
 800:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 804:	70e2                	ld	ra,56(sp)
 806:	7442                	ld	s0,48(sp)
 808:	74a2                	ld	s1,40(sp)
 80a:	7902                	ld	s2,32(sp)
 80c:	69e2                	ld	s3,24(sp)
 80e:	6a42                	ld	s4,16(sp)
 810:	6aa2                	ld	s5,8(sp)
 812:	6b02                	ld	s6,0(sp)
 814:	6121                	addi	sp,sp,64
 816:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	e118                	sd	a4,0(a0)
 81c:	bff1                	j	7f8 <malloc+0x88>
  hp->s.size = nu;
 81e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 822:	0541                	addi	a0,a0,16
 824:	00000097          	auipc	ra,0x0
 828:	eca080e7          	jalr	-310(ra) # 6ee <free>
  return freep;
 82c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 830:	d971                	beqz	a0,804 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	fa9775e3          	bgeu	a4,s1,7e0 <malloc+0x70>
    if(p == freep)
 83a:	00093703          	ld	a4,0(s2)
 83e:	853e                	mv	a0,a5
 840:	fef719e3          	bne	a4,a5,832 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 844:	8552                	mv	a0,s4
 846:	00000097          	auipc	ra,0x0
 84a:	b92080e7          	jalr	-1134(ra) # 3d8 <sbrk>
  if(p == (char*)-1)
 84e:	fd5518e3          	bne	a0,s5,81e <malloc+0xae>
        return 0;
 852:	4501                	li	a0,0
 854:	bf45                	j	804 <malloc+0x94>
