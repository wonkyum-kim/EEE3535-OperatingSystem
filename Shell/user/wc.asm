
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	928a0a13          	addi	s4,s4,-1752 # 960 <malloc+0xf4>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	22e080e7          	jalr	558(ra) # 274 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	00998d63          	beq	s3,s1,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3e8080e7          	jalr	1000(ra) # 464 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	addi	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	8d250513          	addi	a0,a0,-1838 # 978 <malloc+0x10c>
  ae:	00000097          	auipc	ra,0x0
  b2:	706080e7          	jalr	1798(ra) # 7b4 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	89450513          	addi	a0,a0,-1900 # 968 <malloc+0xfc>
  dc:	00000097          	auipc	ra,0x0
  e0:	6d8080e7          	jalr	1752(ra) # 7b4 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	366080e7          	jalr	870(ra) # 44c <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
  fa:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fc:	4785                	li	a5,1
  fe:	04a7d963          	bge	a5,a0,150 <main+0x62>
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	370080e7          	jalr	880(ra) # 48c <open>
 124:	84aa                	mv	s1,a0
 126:	04054363          	bltz	a0,16c <main+0x7e>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	33c080e7          	jalr	828(ra) # 474 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	304080e7          	jalr	772(ra) # 44c <exit>
    wc(0, "");
 150:	00001597          	auipc	a1,0x1
 154:	83858593          	addi	a1,a1,-1992 # 988 <malloc+0x11c>
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	ea6080e7          	jalr	-346(ra) # 0 <wc>
    exit(0);
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	2e8080e7          	jalr	744(ra) # 44c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 16c:	00093583          	ld	a1,0(s2)
 170:	00001517          	auipc	a0,0x1
 174:	82050513          	addi	a0,a0,-2016 # 990 <malloc+0x124>
 178:	00000097          	auipc	ra,0x0
 17c:	63c080e7          	jalr	1596(ra) # 7b4 <printf>
      exit(1);
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	2ca080e7          	jalr	714(ra) # 44c <exit>

000000000000018a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	f5c080e7          	jalr	-164(ra) # ee <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	2b0080e7          	jalr	688(ra) # 44c <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	87aa                	mv	a5,a0
 1ac:	0585                	addi	a1,a1,1
 1ae:	0785                	addi	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fb75                	bnez	a4,1ac <strcpy+0x8>
    ;
  return os;
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb91                	beqz	a5,1de <strcmp+0x1e>
 1cc:	0005c703          	lbu	a4,0(a1)
 1d0:	00f71763          	bne	a4,a5,1de <strcmp+0x1e>
    p++, q++;
 1d4:	0505                	addi	a0,a0,1
 1d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbe5                	bnez	a5,1cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1de:	0005c503          	lbu	a0,0(a1)
}
 1e2:	40a7853b          	subw	a0,a5,a0
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 1f2:	ce11                	beqz	a2,20e <strncmp+0x22>
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf89                	beqz	a5,212 <strncmp+0x26>
 1fa:	0005c703          	lbu	a4,0(a1)
 1fe:	00f71a63          	bne	a4,a5,212 <strncmp+0x26>
    n--, p++, q++;
 202:	367d                	addiw	a2,a2,-1
 204:	0505                	addi	a0,a0,1
 206:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 208:	f675                	bnez	a2,1f4 <strncmp+0x8>
  if(n == 0)
    return 0;
 20a:	4501                	li	a0,0
 20c:	a809                	j	21e <strncmp+0x32>
 20e:	4501                	li	a0,0
 210:	a039                	j	21e <strncmp+0x32>
  if(n == 0)
 212:	ca09                	beqz	a2,224 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 214:	00054503          	lbu	a0,0(a0)
 218:	0005c783          	lbu	a5,0(a1)
 21c:	9d1d                	subw	a0,a0,a5
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
    return 0;
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strncmp+0x32>

0000000000000228 <strlen>:

uint
strlen(const char *s)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 22e:	00054783          	lbu	a5,0(a0)
 232:	cf91                	beqz	a5,24e <strlen+0x26>
 234:	0505                	addi	a0,a0,1
 236:	87aa                	mv	a5,a0
 238:	86be                	mv	a3,a5
 23a:	0785                	addi	a5,a5,1
 23c:	fff7c703          	lbu	a4,-1(a5)
 240:	ff65                	bnez	a4,238 <strlen+0x10>
 242:	40a6853b          	subw	a0,a3,a0
 246:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  for(n = 0; s[n]; n++)
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strlen+0x20>

0000000000000252 <memset>:

void*
memset(void *dst, int c, uint n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 258:	ca19                	beqz	a2,26e <memset+0x1c>
 25a:	87aa                	mv	a5,a0
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 264:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 268:	0785                	addi	a5,a5,1
 26a:	fee79de3          	bne	a5,a4,264 <memset+0x12>
  }
  return dst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strchr>:

char*
strchr(const char *s, char c)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  for(; *s; s++)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb99                	beqz	a5,294 <strchr+0x20>
    if(*s == c)
 280:	00f58763          	beq	a1,a5,28e <strchr+0x1a>
  for(; *s; s++)
 284:	0505                	addi	a0,a0,1
 286:	00054783          	lbu	a5,0(a0)
 28a:	fbfd                	bnez	a5,280 <strchr+0xc>
      return (char*)s;
  return 0;
 28c:	4501                	li	a0,0
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  return 0;
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strchr+0x1a>

0000000000000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	711d                	addi	sp,sp,-96
 29a:	ec86                	sd	ra,88(sp)
 29c:	e8a2                	sd	s0,80(sp)
 29e:	e4a6                	sd	s1,72(sp)
 2a0:	e0ca                	sd	s2,64(sp)
 2a2:	fc4e                	sd	s3,56(sp)
 2a4:	f852                	sd	s4,48(sp)
 2a6:	f456                	sd	s5,40(sp)
 2a8:	f05a                	sd	s6,32(sp)
 2aa:	ec5e                	sd	s7,24(sp)
 2ac:	1080                	addi	s0,sp,96
 2ae:	8baa                	mv	s7,a0
 2b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b2:	892a                	mv	s2,a0
 2b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b6:	4aa9                	li	s5,10
 2b8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ba:	89a6                	mv	s3,s1
 2bc:	2485                	addiw	s1,s1,1
 2be:	0344d863          	bge	s1,s4,2ee <gets+0x56>
    cc = read(0, &c, 1);
 2c2:	4605                	li	a2,1
 2c4:	faf40593          	addi	a1,s0,-81
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	19a080e7          	jalr	410(ra) # 464 <read>
    if(cc < 1)
 2d2:	00a05e63          	blez	a0,2ee <gets+0x56>
    buf[i++] = c;
 2d6:	faf44783          	lbu	a5,-81(s0)
 2da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2de:	01578763          	beq	a5,s5,2ec <gets+0x54>
 2e2:	0905                	addi	s2,s2,1
 2e4:	fd679be3          	bne	a5,s6,2ba <gets+0x22>
  for(i=0; i+1 < max; ){
 2e8:	89a6                	mv	s3,s1
 2ea:	a011                	j	2ee <gets+0x56>
 2ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ee:	99de                	add	s3,s3,s7
 2f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2f4:	855e                	mv	a0,s7
 2f6:	60e6                	ld	ra,88(sp)
 2f8:	6446                	ld	s0,80(sp)
 2fa:	64a6                	ld	s1,72(sp)
 2fc:	6906                	ld	s2,64(sp)
 2fe:	79e2                	ld	s3,56(sp)
 300:	7a42                	ld	s4,48(sp)
 302:	7aa2                	ld	s5,40(sp)
 304:	7b02                	ld	s6,32(sp)
 306:	6be2                	ld	s7,24(sp)
 308:	6125                	addi	sp,sp,96
 30a:	8082                	ret

000000000000030c <stat>:

int
stat(const char *n, struct stat *st)
{
 30c:	1101                	addi	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	e426                	sd	s1,8(sp)
 314:	e04a                	sd	s2,0(sp)
 316:	1000                	addi	s0,sp,32
 318:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	00000097          	auipc	ra,0x0
 320:	170080e7          	jalr	368(ra) # 48c <open>
  if(fd < 0)
 324:	02054563          	bltz	a0,34e <stat+0x42>
 328:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32a:	85ca                	mv	a1,s2
 32c:	00000097          	auipc	ra,0x0
 330:	178080e7          	jalr	376(ra) # 4a4 <fstat>
 334:	892a                	mv	s2,a0
  close(fd);
 336:	8526                	mv	a0,s1
 338:	00000097          	auipc	ra,0x0
 33c:	13c080e7          	jalr	316(ra) # 474 <close>
  return r;
}
 340:	854a                	mv	a0,s2
 342:	60e2                	ld	ra,24(sp)
 344:	6442                	ld	s0,16(sp)
 346:	64a2                	ld	s1,8(sp)
 348:	6902                	ld	s2,0(sp)
 34a:	6105                	addi	sp,sp,32
 34c:	8082                	ret
    return -1;
 34e:	597d                	li	s2,-1
 350:	bfc5                	j	340 <stat+0x34>

0000000000000352 <atoi>:

int
atoi(const char *s)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 358:	00054683          	lbu	a3,0(a0)
 35c:	fd06879b          	addiw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	4625                	li	a2,9
 366:	02f66863          	bltu	a2,a5,396 <atoi+0x44>
 36a:	872a                	mv	a4,a0
  n = 0;
 36c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 36e:	0705                	addi	a4,a4,1
 370:	0025179b          	slliw	a5,a0,0x2
 374:	9fa9                	addw	a5,a5,a0
 376:	0017979b          	slliw	a5,a5,0x1
 37a:	9fb5                	addw	a5,a5,a3
 37c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 380:	00074683          	lbu	a3,0(a4)
 384:	fd06879b          	addiw	a5,a3,-48
 388:	0ff7f793          	zext.b	a5,a5
 38c:	fef671e3          	bgeu	a2,a5,36e <atoi+0x1c>
  return n;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
  n = 0;
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <atoi+0x3e>

000000000000039a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a0:	02b57463          	bgeu	a0,a1,3c8 <memmove+0x2e>
    while(n-- > 0)
 3a4:	00c05f63          	blez	a2,3c2 <memmove+0x28>
 3a8:	1602                	slli	a2,a2,0x20
 3aa:	9201                	srli	a2,a2,0x20
 3ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b2:	0585                	addi	a1,a1,1
 3b4:	0705                	addi	a4,a4,1
 3b6:	fff5c683          	lbu	a3,-1(a1)
 3ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3be:	fee79ae3          	bne	a5,a4,3b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
    dst += n;
 3c8:	00c50733          	add	a4,a0,a2
    src += n;
 3cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ce:	fec05ae3          	blez	a2,3c2 <memmove+0x28>
 3d2:	fff6079b          	addiw	a5,a2,-1
 3d6:	1782                	slli	a5,a5,0x20
 3d8:	9381                	srli	a5,a5,0x20
 3da:	fff7c793          	not	a5,a5
 3de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e0:	15fd                	addi	a1,a1,-1
 3e2:	177d                	addi	a4,a4,-1
 3e4:	0005c683          	lbu	a3,0(a1)
 3e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ec:	fee79ae3          	bne	a5,a4,3e0 <memmove+0x46>
 3f0:	bfc9                	j	3c2 <memmove+0x28>

00000000000003f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f8:	ca05                	beqz	a2,428 <memcmp+0x36>
 3fa:	fff6069b          	addiw	a3,a2,-1
 3fe:	1682                	slli	a3,a3,0x20
 400:	9281                	srli	a3,a3,0x20
 402:	0685                	addi	a3,a3,1
 404:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 406:	00054783          	lbu	a5,0(a0)
 40a:	0005c703          	lbu	a4,0(a1)
 40e:	00e79863          	bne	a5,a4,41e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 412:	0505                	addi	a0,a0,1
    p2++;
 414:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 416:	fed518e3          	bne	a0,a3,406 <memcmp+0x14>
  }
  return 0;
 41a:	4501                	li	a0,0
 41c:	a019                	j	422 <memcmp+0x30>
      return *p1 - *p2;
 41e:	40e7853b          	subw	a0,a5,a4
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
  return 0;
 428:	4501                	li	a0,0
 42a:	bfe5                	j	422 <memcmp+0x30>

000000000000042c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 434:	00000097          	auipc	ra,0x0
 438:	f66080e7          	jalr	-154(ra) # 39a <memmove>
}
 43c:	60a2                	ld	ra,8(sp)
 43e:	6402                	ld	s0,0(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret

0000000000000444 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 444:	4885                	li	a7,1
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exit>:
.global exit
exit:
 li a7, SYS_exit
 44c:	4889                	li	a7,2
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <wait>:
.global wait
wait:
 li a7, SYS_wait
 454:	488d                	li	a7,3
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45c:	4891                	li	a7,4
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <read>:
.global read
read:
 li a7, SYS_read
 464:	4895                	li	a7,5
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <write>:
.global write
write:
 li a7, SYS_write
 46c:	48c1                	li	a7,16
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <close>:
.global close
close:
 li a7, SYS_close
 474:	48d5                	li	a7,21
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <kill>:
.global kill
kill:
 li a7, SYS_kill
 47c:	4899                	li	a7,6
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exec>:
.global exec
exec:
 li a7, SYS_exec
 484:	489d                	li	a7,7
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <open>:
.global open
open:
 li a7, SYS_open
 48c:	48bd                	li	a7,15
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 494:	48c5                	li	a7,17
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49c:	48c9                	li	a7,18
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a4:	48a1                	li	a7,8
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <link>:
.global link
link:
 li a7, SYS_link
 4ac:	48cd                	li	a7,19
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b4:	48d1                	li	a7,20
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4bc:	48a5                	li	a7,9
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c4:	48a9                	li	a7,10
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4cc:	48ad                	li	a7,11
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d4:	48b1                	li	a7,12
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4dc:	48b5                	li	a7,13
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e4:	48b9                	li	a7,14
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ec:	1101                	addi	sp,sp,-32
 4ee:	ec06                	sd	ra,24(sp)
 4f0:	e822                	sd	s0,16(sp)
 4f2:	1000                	addi	s0,sp,32
 4f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f8:	4605                	li	a2,1
 4fa:	fef40593          	addi	a1,s0,-17
 4fe:	00000097          	auipc	ra,0x0
 502:	f6e080e7          	jalr	-146(ra) # 46c <write>
}
 506:	60e2                	ld	ra,24(sp)
 508:	6442                	ld	s0,16(sp)
 50a:	6105                	addi	sp,sp,32
 50c:	8082                	ret

000000000000050e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50e:	7139                	addi	sp,sp,-64
 510:	fc06                	sd	ra,56(sp)
 512:	f822                	sd	s0,48(sp)
 514:	f426                	sd	s1,40(sp)
 516:	f04a                	sd	s2,32(sp)
 518:	ec4e                	sd	s3,24(sp)
 51a:	0080                	addi	s0,sp,64
 51c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51e:	c299                	beqz	a3,524 <printint+0x16>
 520:	0805c963          	bltz	a1,5b2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 524:	2581                	sext.w	a1,a1
  neg = 0;
 526:	4881                	li	a7,0
 528:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 52c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52e:	2601                	sext.w	a2,a2
 530:	00000517          	auipc	a0,0x0
 534:	4d850513          	addi	a0,a0,1240 # a08 <digits>
 538:	883a                	mv	a6,a4
 53a:	2705                	addiw	a4,a4,1
 53c:	02c5f7bb          	remuw	a5,a1,a2
 540:	1782                	slli	a5,a5,0x20
 542:	9381                	srli	a5,a5,0x20
 544:	97aa                	add	a5,a5,a0
 546:	0007c783          	lbu	a5,0(a5)
 54a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54e:	0005879b          	sext.w	a5,a1
 552:	02c5d5bb          	divuw	a1,a1,a2
 556:	0685                	addi	a3,a3,1
 558:	fec7f0e3          	bgeu	a5,a2,538 <printint+0x2a>
  if(neg)
 55c:	00088c63          	beqz	a7,574 <printint+0x66>
    buf[i++] = '-';
 560:	fd070793          	addi	a5,a4,-48
 564:	00878733          	add	a4,a5,s0
 568:	02d00793          	li	a5,45
 56c:	fef70823          	sb	a5,-16(a4)
 570:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 574:	02e05863          	blez	a4,5a4 <printint+0x96>
 578:	fc040793          	addi	a5,s0,-64
 57c:	00e78933          	add	s2,a5,a4
 580:	fff78993          	addi	s3,a5,-1
 584:	99ba                	add	s3,s3,a4
 586:	377d                	addiw	a4,a4,-1
 588:	1702                	slli	a4,a4,0x20
 58a:	9301                	srli	a4,a4,0x20
 58c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 590:	fff94583          	lbu	a1,-1(s2)
 594:	8526                	mv	a0,s1
 596:	00000097          	auipc	ra,0x0
 59a:	f56080e7          	jalr	-170(ra) # 4ec <putc>
  while(--i >= 0)
 59e:	197d                	addi	s2,s2,-1
 5a0:	ff3918e3          	bne	s2,s3,590 <printint+0x82>
}
 5a4:	70e2                	ld	ra,56(sp)
 5a6:	7442                	ld	s0,48(sp)
 5a8:	74a2                	ld	s1,40(sp)
 5aa:	7902                	ld	s2,32(sp)
 5ac:	69e2                	ld	s3,24(sp)
 5ae:	6121                	addi	sp,sp,64
 5b0:	8082                	ret
    x = -xx;
 5b2:	40b005bb          	negw	a1,a1
    neg = 1;
 5b6:	4885                	li	a7,1
    x = -xx;
 5b8:	bf85                	j	528 <printint+0x1a>

00000000000005ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ba:	715d                	addi	sp,sp,-80
 5bc:	e486                	sd	ra,72(sp)
 5be:	e0a2                	sd	s0,64(sp)
 5c0:	fc26                	sd	s1,56(sp)
 5c2:	f84a                	sd	s2,48(sp)
 5c4:	f44e                	sd	s3,40(sp)
 5c6:	f052                	sd	s4,32(sp)
 5c8:	ec56                	sd	s5,24(sp)
 5ca:	e85a                	sd	s6,16(sp)
 5cc:	e45e                	sd	s7,8(sp)
 5ce:	e062                	sd	s8,0(sp)
 5d0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d2:	0005c903          	lbu	s2,0(a1)
 5d6:	18090c63          	beqz	s2,76e <vprintf+0x1b4>
 5da:	8aaa                	mv	s5,a0
 5dc:	8bb2                	mv	s7,a2
 5de:	00158493          	addi	s1,a1,1
  state = 0;
 5e2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e4:	02500a13          	li	s4,37
 5e8:	4b55                	li	s6,21
 5ea:	a839                	j	608 <vprintf+0x4e>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	efc080e7          	jalr	-260(ra) # 4ec <putc>
 5f8:	a019                	j	5fe <vprintf+0x44>
    } else if(state == '%'){
 5fa:	01498d63          	beq	s3,s4,614 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5fe:	0485                	addi	s1,s1,1
 600:	fff4c903          	lbu	s2,-1(s1)
 604:	16090563          	beqz	s2,76e <vprintf+0x1b4>
    if(state == 0){
 608:	fe0999e3          	bnez	s3,5fa <vprintf+0x40>
      if(c == '%'){
 60c:	ff4910e3          	bne	s2,s4,5ec <vprintf+0x32>
        state = '%';
 610:	89d2                	mv	s3,s4
 612:	b7f5                	j	5fe <vprintf+0x44>
      if(c == 'd'){
 614:	13490263          	beq	s2,s4,738 <vprintf+0x17e>
 618:	f9d9079b          	addiw	a5,s2,-99
 61c:	0ff7f793          	zext.b	a5,a5
 620:	12fb6563          	bltu	s6,a5,74a <vprintf+0x190>
 624:	f9d9079b          	addiw	a5,s2,-99
 628:	0ff7f713          	zext.b	a4,a5
 62c:	10eb6f63          	bltu	s6,a4,74a <vprintf+0x190>
 630:	00271793          	slli	a5,a4,0x2
 634:	00000717          	auipc	a4,0x0
 638:	37c70713          	addi	a4,a4,892 # 9b0 <malloc+0x144>
 63c:	97ba                	add	a5,a5,a4
 63e:	439c                	lw	a5,0(a5)
 640:	97ba                	add	a5,a5,a4
 642:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 644:	008b8913          	addi	s2,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	ebc080e7          	jalr	-324(ra) # 50e <printint>
 65a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b745                	j	5fe <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 660:	008b8913          	addi	s2,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	ea0080e7          	jalr	-352(ra) # 50e <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b751                	j	5fe <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000ba583          	lw	a1,0(s7)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e84080e7          	jalr	-380(ra) # 50e <printint>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b7a5                	j	5fe <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 698:	008b8c13          	addi	s8,s7,8
 69c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a0:	03000593          	li	a1,48
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	e46080e7          	jalr	-442(ra) # 4ec <putc>
  putc(fd, 'x');
 6ae:	07800593          	li	a1,120
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e38080e7          	jalr	-456(ra) # 4ec <putc>
 6bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	34ab8b93          	addi	s7,s7,842 # a08 <digits>
 6c6:	03c9d793          	srli	a5,s3,0x3c
 6ca:	97de                	add	a5,a5,s7
 6cc:	0007c583          	lbu	a1,0(a5)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e1a080e7          	jalr	-486(ra) # 4ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6da:	0992                	slli	s3,s3,0x4
 6dc:	397d                	addiw	s2,s2,-1
 6de:	fe0914e3          	bnez	s2,6c6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8be2                	mv	s7,s8
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bf21                	j	5fe <vprintf+0x44>
        s = va_arg(ap, char*);
 6e8:	008b8993          	addi	s3,s7,8
 6ec:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6f0:	02090163          	beqz	s2,712 <vprintf+0x158>
        while(*s != 0){
 6f4:	00094583          	lbu	a1,0(s2)
 6f8:	c9a5                	beqz	a1,768 <vprintf+0x1ae>
          putc(fd, *s);
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	df0080e7          	jalr	-528(ra) # 4ec <putc>
          s++;
 704:	0905                	addi	s2,s2,1
        while(*s != 0){
 706:	00094583          	lbu	a1,0(s2)
 70a:	f9e5                	bnez	a1,6fa <vprintf+0x140>
        s = va_arg(ap, char*);
 70c:	8bce                	mv	s7,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	b5fd                	j	5fe <vprintf+0x44>
          s = "(null)";
 712:	00000917          	auipc	s2,0x0
 716:	29690913          	addi	s2,s2,662 # 9a8 <malloc+0x13c>
        while(*s != 0){
 71a:	02800593          	li	a1,40
 71e:	bff1                	j	6fa <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 720:	008b8913          	addi	s2,s7,8
 724:	000bc583          	lbu	a1,0(s7)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	dc2080e7          	jalr	-574(ra) # 4ec <putc>
 732:	8bca                	mv	s7,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	b5e1                	j	5fe <vprintf+0x44>
        putc(fd, c);
 738:	02500593          	li	a1,37
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	dae080e7          	jalr	-594(ra) # 4ec <putc>
      state = 0;
 746:	4981                	li	s3,0
 748:	bd5d                	j	5fe <vprintf+0x44>
        putc(fd, '%');
 74a:	02500593          	li	a1,37
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	d9c080e7          	jalr	-612(ra) # 4ec <putc>
        putc(fd, c);
 758:	85ca                	mv	a1,s2
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	d90080e7          	jalr	-624(ra) # 4ec <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	bd61                	j	5fe <vprintf+0x44>
        s = va_arg(ap, char*);
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bd49                	j	5fe <vprintf+0x44>
    }
  }
}
 76e:	60a6                	ld	ra,72(sp)
 770:	6406                	ld	s0,64(sp)
 772:	74e2                	ld	s1,56(sp)
 774:	7942                	ld	s2,48(sp)
 776:	79a2                	ld	s3,40(sp)
 778:	7a02                	ld	s4,32(sp)
 77a:	6ae2                	ld	s5,24(sp)
 77c:	6b42                	ld	s6,16(sp)
 77e:	6ba2                	ld	s7,8(sp)
 780:	6c02                	ld	s8,0(sp)
 782:	6161                	addi	sp,sp,80
 784:	8082                	ret

0000000000000786 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 786:	715d                	addi	sp,sp,-80
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e010                	sd	a2,0(s0)
 790:	e414                	sd	a3,8(s0)
 792:	e818                	sd	a4,16(s0)
 794:	ec1c                	sd	a5,24(s0)
 796:	03043023          	sd	a6,32(s0)
 79a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a2:	8622                	mv	a2,s0
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e16080e7          	jalr	-490(ra) # 5ba <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6161                	addi	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <printf>:

void
printf(const char *fmt, ...)
{
 7b4:	711d                	addi	sp,sp,-96
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e40c                	sd	a1,8(s0)
 7be:	e810                	sd	a2,16(s0)
 7c0:	ec14                	sd	a3,24(s0)
 7c2:	f018                	sd	a4,32(s0)
 7c4:	f41c                	sd	a5,40(s0)
 7c6:	03043823          	sd	a6,48(s0)
 7ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	00840613          	addi	a2,s0,8
 7d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d6:	85aa                	mv	a1,a0
 7d8:	4505                	li	a0,1
 7da:	00000097          	auipc	ra,0x0
 7de:	de0080e7          	jalr	-544(ra) # 5ba <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret

00000000000007ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e422                	sd	s0,8(sp)
 7ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	00001797          	auipc	a5,0x1
 7f8:	80c7b783          	ld	a5,-2036(a5) # 1000 <freep>
 7fc:	a02d                	j	826 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fe:	4618                	lw	a4,8(a2)
 800:	9f2d                	addw	a4,a4,a1
 802:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	6310                	ld	a2,0(a4)
 80a:	a83d                	j	848 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80c:	ff852703          	lw	a4,-8(a0)
 810:	9f31                	addw	a4,a4,a2
 812:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 814:	ff053683          	ld	a3,-16(a0)
 818:	a091                	j	85c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x3a>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x4a>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x30>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059813          	slli	a6,a1,0x20
 83e:	01c85713          	srli	a4,a6,0x1c
 842:	9736                	add	a4,a4,a3
 844:	fae60de3          	beq	a2,a4,7fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061593          	slli	a1,a2,0x20
 852:	01c5d713          	srli	a4,a1,0x1c
 856:	973e                	add	a4,a4,a5
 858:	fae68ae3          	beq	a3,a4,80c <free+0x22>
    p->s.ptr = bp->s.ptr;
 85c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	6422                	ld	s0,8(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret

000000000000086c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	f04a                	sd	s2,32(sp)
 876:	ec4e                	sd	s3,24(sp)
 878:	e852                	sd	s4,16(sp)
 87a:	e456                	sd	s5,8(sp)
 87c:	e05a                	sd	s6,0(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 880:	02051493          	slli	s1,a0,0x20
 884:	9081                	srli	s1,s1,0x20
 886:	04bd                	addi	s1,s1,15
 888:	8091                	srli	s1,s1,0x4
 88a:	0014899b          	addiw	s3,s1,1
 88e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 890:	00000517          	auipc	a0,0x0
 894:	77053503          	ld	a0,1904(a0) # 1000 <freep>
 898:	c515                	beqz	a0,8c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	02977f63          	bgeu	a4,s1,8dc <malloc+0x70>
  if(nu < 4096)
 8a2:	8a4e                	mv	s4,s3
 8a4:	0009871b          	sext.w	a4,s3
 8a8:	6685                	lui	a3,0x1
 8aa:	00d77363          	bgeu	a4,a3,8b0 <malloc+0x44>
 8ae:	6a05                	lui	s4,0x1
 8b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b8:	00000917          	auipc	s2,0x0
 8bc:	74890913          	addi	s2,s2,1864 # 1000 <freep>
  if(p == (char*)-1)
 8c0:	5afd                	li	s5,-1
 8c2:	a895                	j	936 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8c4:	00001797          	auipc	a5,0x1
 8c8:	94c78793          	addi	a5,a5,-1716 # 1210 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7e1                	j	8a2 <malloc+0x36>
      if(p->s.size == nunits)
 8dc:	02e48c63          	beq	s1,a4,914 <malloc+0xa8>
        p->s.size -= nunits;
 8e0:	4137073b          	subw	a4,a4,s3
 8e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e6:	02071693          	slli	a3,a4,0x20
 8ea:	01c6d713          	srli	a4,a3,0x1c
 8ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70a73623          	sd	a0,1804(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 900:	70e2                	ld	ra,56(sp)
 902:	7442                	ld	s0,48(sp)
 904:	74a2                	ld	s1,40(sp)
 906:	7902                	ld	s2,32(sp)
 908:	69e2                	ld	s3,24(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	6121                	addi	sp,sp,64
 912:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 914:	6398                	ld	a4,0(a5)
 916:	e118                	sd	a4,0(a0)
 918:	bff1                	j	8f4 <malloc+0x88>
  hp->s.size = nu;
 91a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91e:	0541                	addi	a0,a0,16
 920:	00000097          	auipc	ra,0x0
 924:	eca080e7          	jalr	-310(ra) # 7ea <free>
  return freep;
 928:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92c:	d971                	beqz	a0,900 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	fa9775e3          	bgeu	a4,s1,8dc <malloc+0x70>
    if(p == freep)
 936:	00093703          	ld	a4,0(s2)
 93a:	853e                	mv	a0,a5
 93c:	fef719e3          	bne	a4,a5,92e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 940:	8552                	mv	a0,s4
 942:	00000097          	auipc	ra,0x0
 946:	b92080e7          	jalr	-1134(ra) # 4d4 <sbrk>
  if(p == (char*)-1)
 94a:	fd5518e3          	bne	a0,s5,91a <malloc+0xae>
        return 0;
 94e:	4501                	li	a0,0
 950:	bf45                	j	900 <malloc+0x94>
