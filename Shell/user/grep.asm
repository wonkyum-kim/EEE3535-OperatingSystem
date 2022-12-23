
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	addi	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	ed4a8a93          	addi	s5,s5,-300 # 1010 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	246080e7          	jalr	582(ra) # 394 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	addi	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	40e080e7          	jalr	1038(ra) # 58c <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3ee080e7          	jalr	1006(ra) # 584 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	e5a50513          	addi	a0,a0,-422 # 1010 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2f0080e7          	jalr	752(ra) # 4ba <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	addi	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	addi	s2,a1,16
 210:	ffd5099b          	addiw	s3,a0,-3
 214:	02099793          	slli	a5,s3,0x20
 218:	01d7d993          	srli	s3,a5,0x1d
 21c:	05e1                	addi	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	386080e7          	jalr	902(ra) # 5ac <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	352080e7          	jalr	850(ra) # 594 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	31a080e7          	jalr	794(ra) # 56c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	82658593          	addi	a1,a1,-2010 # a80 <malloc+0xf4>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	642080e7          	jalr	1602(ra) # 8a6 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2fe080e7          	jalr	766(ra) # 56c <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2e8080e7          	jalr	744(ra) # 56c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	81050513          	addi	a0,a0,-2032 # aa0 <malloc+0x114>
 298:	00000097          	auipc	ra,0x0
 29c:	63c080e7          	jalr	1596(ra) # 8d4 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	2ca080e7          	jalr	714(ra) # 56c <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	2b0080e7          	jalr	688(ra) # 56c <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	addi	a1,a1,1
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	addi	a0,a0,1
 2f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 312:	ce11                	beqz	a2,32e <strncmp+0x22>
 314:	00054783          	lbu	a5,0(a0)
 318:	cf89                	beqz	a5,332 <strncmp+0x26>
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00f71a63          	bne	a4,a5,332 <strncmp+0x26>
    n--, p++, q++;
 322:	367d                	addiw	a2,a2,-1
 324:	0505                	addi	a0,a0,1
 326:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 328:	f675                	bnez	a2,314 <strncmp+0x8>
  if(n == 0)
    return 0;
 32a:	4501                	li	a0,0
 32c:	a809                	j	33e <strncmp+0x32>
 32e:	4501                	li	a0,0
 330:	a039                	j	33e <strncmp+0x32>
  if(n == 0)
 332:	ca09                	beqz	a2,344 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 334:	00054503          	lbu	a0,0(a0)
 338:	0005c783          	lbu	a5,0(a1)
 33c:	9d1d                	subw	a0,a0,a5
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
    return 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <strncmp+0x32>

0000000000000348 <strlen>:

uint
strlen(const char *s)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 34e:	00054783          	lbu	a5,0(a0)
 352:	cf91                	beqz	a5,36e <strlen+0x26>
 354:	0505                	addi	a0,a0,1
 356:	87aa                	mv	a5,a0
 358:	86be                	mv	a3,a5
 35a:	0785                	addi	a5,a5,1
 35c:	fff7c703          	lbu	a4,-1(a5)
 360:	ff65                	bnez	a4,358 <strlen+0x10>
 362:	40a6853b          	subw	a0,a3,a0
 366:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  for(n = 0; s[n]; n++)
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <strlen+0x20>

0000000000000372 <memset>:

void*
memset(void *dst, int c, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 378:	ca19                	beqz	a2,38e <memset+0x1c>
 37a:	87aa                	mv	a5,a0
 37c:	1602                	slli	a2,a2,0x20
 37e:	9201                	srli	a2,a2,0x20
 380:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 384:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 388:	0785                	addi	a5,a5,1
 38a:	fee79de3          	bne	a5,a4,384 <memset+0x12>
  }
  return dst;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <strchr>:

char*
strchr(const char *s, char c)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  for(; *s; s++)
 39a:	00054783          	lbu	a5,0(a0)
 39e:	cb99                	beqz	a5,3b4 <strchr+0x20>
    if(*s == c)
 3a0:	00f58763          	beq	a1,a5,3ae <strchr+0x1a>
  for(; *s; s++)
 3a4:	0505                	addi	a0,a0,1
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	fbfd                	bnez	a5,3a0 <strchr+0xc>
      return (char*)s;
  return 0;
 3ac:	4501                	li	a0,0
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <strchr+0x1a>

00000000000003b8 <gets>:

char*
gets(char *buf, int max)
{
 3b8:	711d                	addi	sp,sp,-96
 3ba:	ec86                	sd	ra,88(sp)
 3bc:	e8a2                	sd	s0,80(sp)
 3be:	e4a6                	sd	s1,72(sp)
 3c0:	e0ca                	sd	s2,64(sp)
 3c2:	fc4e                	sd	s3,56(sp)
 3c4:	f852                	sd	s4,48(sp)
 3c6:	f456                	sd	s5,40(sp)
 3c8:	f05a                	sd	s6,32(sp)
 3ca:	ec5e                	sd	s7,24(sp)
 3cc:	1080                	addi	s0,sp,96
 3ce:	8baa                	mv	s7,a0
 3d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d2:	892a                	mv	s2,a0
 3d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3d6:	4aa9                	li	s5,10
 3d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3da:	89a6                	mv	s3,s1
 3dc:	2485                	addiw	s1,s1,1
 3de:	0344d863          	bge	s1,s4,40e <gets+0x56>
    cc = read(0, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	faf40593          	addi	a1,s0,-81
 3e8:	4501                	li	a0,0
 3ea:	00000097          	auipc	ra,0x0
 3ee:	19a080e7          	jalr	410(ra) # 584 <read>
    if(cc < 1)
 3f2:	00a05e63          	blez	a0,40e <gets+0x56>
    buf[i++] = c;
 3f6:	faf44783          	lbu	a5,-81(s0)
 3fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3fe:	01578763          	beq	a5,s5,40c <gets+0x54>
 402:	0905                	addi	s2,s2,1
 404:	fd679be3          	bne	a5,s6,3da <gets+0x22>
  for(i=0; i+1 < max; ){
 408:	89a6                	mv	s3,s1
 40a:	a011                	j	40e <gets+0x56>
 40c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 40e:	99de                	add	s3,s3,s7
 410:	00098023          	sb	zero,0(s3)
  return buf;
}
 414:	855e                	mv	a0,s7
 416:	60e6                	ld	ra,88(sp)
 418:	6446                	ld	s0,80(sp)
 41a:	64a6                	ld	s1,72(sp)
 41c:	6906                	ld	s2,64(sp)
 41e:	79e2                	ld	s3,56(sp)
 420:	7a42                	ld	s4,48(sp)
 422:	7aa2                	ld	s5,40(sp)
 424:	7b02                	ld	s6,32(sp)
 426:	6be2                	ld	s7,24(sp)
 428:	6125                	addi	sp,sp,96
 42a:	8082                	ret

000000000000042c <stat>:

int
stat(const char *n, struct stat *st)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	e426                	sd	s1,8(sp)
 434:	e04a                	sd	s2,0(sp)
 436:	1000                	addi	s0,sp,32
 438:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 43a:	4581                	li	a1,0
 43c:	00000097          	auipc	ra,0x0
 440:	170080e7          	jalr	368(ra) # 5ac <open>
  if(fd < 0)
 444:	02054563          	bltz	a0,46e <stat+0x42>
 448:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 44a:	85ca                	mv	a1,s2
 44c:	00000097          	auipc	ra,0x0
 450:	178080e7          	jalr	376(ra) # 5c4 <fstat>
 454:	892a                	mv	s2,a0
  close(fd);
 456:	8526                	mv	a0,s1
 458:	00000097          	auipc	ra,0x0
 45c:	13c080e7          	jalr	316(ra) # 594 <close>
  return r;
}
 460:	854a                	mv	a0,s2
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	64a2                	ld	s1,8(sp)
 468:	6902                	ld	s2,0(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret
    return -1;
 46e:	597d                	li	s2,-1
 470:	bfc5                	j	460 <stat+0x34>

0000000000000472 <atoi>:

int
atoi(const char *s)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 478:	00054683          	lbu	a3,0(a0)
 47c:	fd06879b          	addiw	a5,a3,-48
 480:	0ff7f793          	zext.b	a5,a5
 484:	4625                	li	a2,9
 486:	02f66863          	bltu	a2,a5,4b6 <atoi+0x44>
 48a:	872a                	mv	a4,a0
  n = 0;
 48c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 48e:	0705                	addi	a4,a4,1
 490:	0025179b          	slliw	a5,a0,0x2
 494:	9fa9                	addw	a5,a5,a0
 496:	0017979b          	slliw	a5,a5,0x1
 49a:	9fb5                	addw	a5,a5,a3
 49c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4a0:	00074683          	lbu	a3,0(a4)
 4a4:	fd06879b          	addiw	a5,a3,-48
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	fef671e3          	bgeu	a2,a5,48e <atoi+0x1c>
  return n;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret
  n = 0;
 4b6:	4501                	li	a0,0
 4b8:	bfe5                	j	4b0 <atoi+0x3e>

00000000000004ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4c0:	02b57463          	bgeu	a0,a1,4e8 <memmove+0x2e>
    while(n-- > 0)
 4c4:	00c05f63          	blez	a2,4e2 <memmove+0x28>
 4c8:	1602                	slli	a2,a2,0x20
 4ca:	9201                	srli	a2,a2,0x20
 4cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4d2:	0585                	addi	a1,a1,1
 4d4:	0705                	addi	a4,a4,1
 4d6:	fff5c683          	lbu	a3,-1(a1)
 4da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4de:	fee79ae3          	bne	a5,a4,4d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e2:	6422                	ld	s0,8(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret
    dst += n;
 4e8:	00c50733          	add	a4,a0,a2
    src += n;
 4ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ee:	fec05ae3          	blez	a2,4e2 <memmove+0x28>
 4f2:	fff6079b          	addiw	a5,a2,-1
 4f6:	1782                	slli	a5,a5,0x20
 4f8:	9381                	srli	a5,a5,0x20
 4fa:	fff7c793          	not	a5,a5
 4fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 500:	15fd                	addi	a1,a1,-1
 502:	177d                	addi	a4,a4,-1
 504:	0005c683          	lbu	a3,0(a1)
 508:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 50c:	fee79ae3          	bne	a5,a4,500 <memmove+0x46>
 510:	bfc9                	j	4e2 <memmove+0x28>

0000000000000512 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 512:	1141                	addi	sp,sp,-16
 514:	e422                	sd	s0,8(sp)
 516:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 518:	ca05                	beqz	a2,548 <memcmp+0x36>
 51a:	fff6069b          	addiw	a3,a2,-1
 51e:	1682                	slli	a3,a3,0x20
 520:	9281                	srli	a3,a3,0x20
 522:	0685                	addi	a3,a3,1
 524:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 526:	00054783          	lbu	a5,0(a0)
 52a:	0005c703          	lbu	a4,0(a1)
 52e:	00e79863          	bne	a5,a4,53e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 532:	0505                	addi	a0,a0,1
    p2++;
 534:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 536:	fed518e3          	bne	a0,a3,526 <memcmp+0x14>
  }
  return 0;
 53a:	4501                	li	a0,0
 53c:	a019                	j	542 <memcmp+0x30>
      return *p1 - *p2;
 53e:	40e7853b          	subw	a0,a5,a4
}
 542:	6422                	ld	s0,8(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
  return 0;
 548:	4501                	li	a0,0
 54a:	bfe5                	j	542 <memcmp+0x30>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f66080e7          	jalr	-154(ra) # 4ba <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 618:	4605                	li	a2,1
 61a:	fef40593          	addi	a1,s0,-17
 61e:	00000097          	auipc	ra,0x0
 622:	f6e080e7          	jalr	-146(ra) # 58c <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	f426                	sd	s1,40(sp)
 636:	f04a                	sd	s2,32(sp)
 638:	ec4e                	sd	s3,24(sp)
 63a:	0080                	addi	s0,sp,64
 63c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63e:	c299                	beqz	a3,644 <printint+0x16>
 640:	0805c963          	bltz	a1,6d2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 644:	2581                	sext.w	a1,a1
  neg = 0;
 646:	4881                	li	a7,0
 648:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 64c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 64e:	2601                	sext.w	a2,a2
 650:	00000517          	auipc	a0,0x0
 654:	4c850513          	addi	a0,a0,1224 # b18 <digits>
 658:	883a                	mv	a6,a4
 65a:	2705                	addiw	a4,a4,1
 65c:	02c5f7bb          	remuw	a5,a1,a2
 660:	1782                	slli	a5,a5,0x20
 662:	9381                	srli	a5,a5,0x20
 664:	97aa                	add	a5,a5,a0
 666:	0007c783          	lbu	a5,0(a5)
 66a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66e:	0005879b          	sext.w	a5,a1
 672:	02c5d5bb          	divuw	a1,a1,a2
 676:	0685                	addi	a3,a3,1
 678:	fec7f0e3          	bgeu	a5,a2,658 <printint+0x2a>
  if(neg)
 67c:	00088c63          	beqz	a7,694 <printint+0x66>
    buf[i++] = '-';
 680:	fd070793          	addi	a5,a4,-48
 684:	00878733          	add	a4,a5,s0
 688:	02d00793          	li	a5,45
 68c:	fef70823          	sb	a5,-16(a4)
 690:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 694:	02e05863          	blez	a4,6c4 <printint+0x96>
 698:	fc040793          	addi	a5,s0,-64
 69c:	00e78933          	add	s2,a5,a4
 6a0:	fff78993          	addi	s3,a5,-1
 6a4:	99ba                	add	s3,s3,a4
 6a6:	377d                	addiw	a4,a4,-1
 6a8:	1702                	slli	a4,a4,0x20
 6aa:	9301                	srli	a4,a4,0x20
 6ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6b0:	fff94583          	lbu	a1,-1(s2)
 6b4:	8526                	mv	a0,s1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	f56080e7          	jalr	-170(ra) # 60c <putc>
  while(--i >= 0)
 6be:	197d                	addi	s2,s2,-1
 6c0:	ff3918e3          	bne	s2,s3,6b0 <printint+0x82>
}
 6c4:	70e2                	ld	ra,56(sp)
 6c6:	7442                	ld	s0,48(sp)
 6c8:	74a2                	ld	s1,40(sp)
 6ca:	7902                	ld	s2,32(sp)
 6cc:	69e2                	ld	s3,24(sp)
 6ce:	6121                	addi	sp,sp,64
 6d0:	8082                	ret
    x = -xx;
 6d2:	40b005bb          	negw	a1,a1
    neg = 1;
 6d6:	4885                	li	a7,1
    x = -xx;
 6d8:	bf85                	j	648 <printint+0x1a>

00000000000006da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6da:	715d                	addi	sp,sp,-80
 6dc:	e486                	sd	ra,72(sp)
 6de:	e0a2                	sd	s0,64(sp)
 6e0:	fc26                	sd	s1,56(sp)
 6e2:	f84a                	sd	s2,48(sp)
 6e4:	f44e                	sd	s3,40(sp)
 6e6:	f052                	sd	s4,32(sp)
 6e8:	ec56                	sd	s5,24(sp)
 6ea:	e85a                	sd	s6,16(sp)
 6ec:	e45e                	sd	s7,8(sp)
 6ee:	e062                	sd	s8,0(sp)
 6f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f2:	0005c903          	lbu	s2,0(a1)
 6f6:	18090c63          	beqz	s2,88e <vprintf+0x1b4>
 6fa:	8aaa                	mv	s5,a0
 6fc:	8bb2                	mv	s7,a2
 6fe:	00158493          	addi	s1,a1,1
  state = 0;
 702:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 704:	02500a13          	li	s4,37
 708:	4b55                	li	s6,21
 70a:	a839                	j	728 <vprintf+0x4e>
        putc(fd, c);
 70c:	85ca                	mv	a1,s2
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	efc080e7          	jalr	-260(ra) # 60c <putc>
 718:	a019                	j	71e <vprintf+0x44>
    } else if(state == '%'){
 71a:	01498d63          	beq	s3,s4,734 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 71e:	0485                	addi	s1,s1,1
 720:	fff4c903          	lbu	s2,-1(s1)
 724:	16090563          	beqz	s2,88e <vprintf+0x1b4>
    if(state == 0){
 728:	fe0999e3          	bnez	s3,71a <vprintf+0x40>
      if(c == '%'){
 72c:	ff4910e3          	bne	s2,s4,70c <vprintf+0x32>
        state = '%';
 730:	89d2                	mv	s3,s4
 732:	b7f5                	j	71e <vprintf+0x44>
      if(c == 'd'){
 734:	13490263          	beq	s2,s4,858 <vprintf+0x17e>
 738:	f9d9079b          	addiw	a5,s2,-99
 73c:	0ff7f793          	zext.b	a5,a5
 740:	12fb6563          	bltu	s6,a5,86a <vprintf+0x190>
 744:	f9d9079b          	addiw	a5,s2,-99
 748:	0ff7f713          	zext.b	a4,a5
 74c:	10eb6f63          	bltu	s6,a4,86a <vprintf+0x190>
 750:	00271793          	slli	a5,a4,0x2
 754:	00000717          	auipc	a4,0x0
 758:	36c70713          	addi	a4,a4,876 # ac0 <malloc+0x134>
 75c:	97ba                	add	a5,a5,a4
 75e:	439c                	lw	a5,0(a5)
 760:	97ba                	add	a5,a5,a4
 762:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 764:	008b8913          	addi	s2,s7,8
 768:	4685                	li	a3,1
 76a:	4629                	li	a2,10
 76c:	000ba583          	lw	a1,0(s7)
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	ebc080e7          	jalr	-324(ra) # 62e <printint>
 77a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b745                	j	71e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 780:	008b8913          	addi	s2,s7,8
 784:	4681                	li	a3,0
 786:	4629                	li	a2,10
 788:	000ba583          	lw	a1,0(s7)
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	ea0080e7          	jalr	-352(ra) # 62e <printint>
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
 79a:	b751                	j	71e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 79c:	008b8913          	addi	s2,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4641                	li	a2,16
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e84080e7          	jalr	-380(ra) # 62e <printint>
 7b2:	8bca                	mv	s7,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b7a5                	j	71e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7b8:	008b8c13          	addi	s8,s7,8
 7bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c0:	03000593          	li	a1,48
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e46080e7          	jalr	-442(ra) # 60c <putc>
  putc(fd, 'x');
 7ce:	07800593          	li	a1,120
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e38080e7          	jalr	-456(ra) # 60c <putc>
 7dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7de:	00000b97          	auipc	s7,0x0
 7e2:	33ab8b93          	addi	s7,s7,826 # b18 <digits>
 7e6:	03c9d793          	srli	a5,s3,0x3c
 7ea:	97de                	add	a5,a5,s7
 7ec:	0007c583          	lbu	a1,0(a5)
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e1a080e7          	jalr	-486(ra) # 60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fa:	0992                	slli	s3,s3,0x4
 7fc:	397d                	addiw	s2,s2,-1
 7fe:	fe0914e3          	bnez	s2,7e6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 802:	8be2                	mv	s7,s8
      state = 0;
 804:	4981                	li	s3,0
 806:	bf21                	j	71e <vprintf+0x44>
        s = va_arg(ap, char*);
 808:	008b8993          	addi	s3,s7,8
 80c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 810:	02090163          	beqz	s2,832 <vprintf+0x158>
        while(*s != 0){
 814:	00094583          	lbu	a1,0(s2)
 818:	c9a5                	beqz	a1,888 <vprintf+0x1ae>
          putc(fd, *s);
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	df0080e7          	jalr	-528(ra) # 60c <putc>
          s++;
 824:	0905                	addi	s2,s2,1
        while(*s != 0){
 826:	00094583          	lbu	a1,0(s2)
 82a:	f9e5                	bnez	a1,81a <vprintf+0x140>
        s = va_arg(ap, char*);
 82c:	8bce                	mv	s7,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	b5fd                	j	71e <vprintf+0x44>
          s = "(null)";
 832:	00000917          	auipc	s2,0x0
 836:	28690913          	addi	s2,s2,646 # ab8 <malloc+0x12c>
        while(*s != 0){
 83a:	02800593          	li	a1,40
 83e:	bff1                	j	81a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 840:	008b8913          	addi	s2,s7,8
 844:	000bc583          	lbu	a1,0(s7)
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	dc2080e7          	jalr	-574(ra) # 60c <putc>
 852:	8bca                	mv	s7,s2
      state = 0;
 854:	4981                	li	s3,0
 856:	b5e1                	j	71e <vprintf+0x44>
        putc(fd, c);
 858:	02500593          	li	a1,37
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	dae080e7          	jalr	-594(ra) # 60c <putc>
      state = 0;
 866:	4981                	li	s3,0
 868:	bd5d                	j	71e <vprintf+0x44>
        putc(fd, '%');
 86a:	02500593          	li	a1,37
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	d9c080e7          	jalr	-612(ra) # 60c <putc>
        putc(fd, c);
 878:	85ca                	mv	a1,s2
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	d90080e7          	jalr	-624(ra) # 60c <putc>
      state = 0;
 884:	4981                	li	s3,0
 886:	bd61                	j	71e <vprintf+0x44>
        s = va_arg(ap, char*);
 888:	8bce                	mv	s7,s3
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bd49                	j	71e <vprintf+0x44>
    }
  }
}
 88e:	60a6                	ld	ra,72(sp)
 890:	6406                	ld	s0,64(sp)
 892:	74e2                	ld	s1,56(sp)
 894:	7942                	ld	s2,48(sp)
 896:	79a2                	ld	s3,40(sp)
 898:	7a02                	ld	s4,32(sp)
 89a:	6ae2                	ld	s5,24(sp)
 89c:	6b42                	ld	s6,16(sp)
 89e:	6ba2                	ld	s7,8(sp)
 8a0:	6c02                	ld	s8,0(sp)
 8a2:	6161                	addi	sp,sp,80
 8a4:	8082                	ret

00000000000008a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	ec06                	sd	ra,24(sp)
 8aa:	e822                	sd	s0,16(sp)
 8ac:	1000                	addi	s0,sp,32
 8ae:	e010                	sd	a2,0(s0)
 8b0:	e414                	sd	a3,8(s0)
 8b2:	e818                	sd	a4,16(s0)
 8b4:	ec1c                	sd	a5,24(s0)
 8b6:	03043023          	sd	a6,32(s0)
 8ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c2:	8622                	mv	a2,s0
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e16080e7          	jalr	-490(ra) # 6da <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6161                	addi	sp,sp,80
 8d2:	8082                	ret

00000000000008d4 <printf>:

void
printf(const char *fmt, ...)
{
 8d4:	711d                	addi	sp,sp,-96
 8d6:	ec06                	sd	ra,24(sp)
 8d8:	e822                	sd	s0,16(sp)
 8da:	1000                	addi	s0,sp,32
 8dc:	e40c                	sd	a1,8(s0)
 8de:	e810                	sd	a2,16(s0)
 8e0:	ec14                	sd	a3,24(s0)
 8e2:	f018                	sd	a4,32(s0)
 8e4:	f41c                	sd	a5,40(s0)
 8e6:	03043823          	sd	a6,48(s0)
 8ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ee:	00840613          	addi	a2,s0,8
 8f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f6:	85aa                	mv	a1,a0
 8f8:	4505                	li	a0,1
 8fa:	00000097          	auipc	ra,0x0
 8fe:	de0080e7          	jalr	-544(ra) # 6da <vprintf>
}
 902:	60e2                	ld	ra,24(sp)
 904:	6442                	ld	s0,16(sp)
 906:	6125                	addi	sp,sp,96
 908:	8082                	ret

000000000000090a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90a:	1141                	addi	sp,sp,-16
 90c:	e422                	sd	s0,8(sp)
 90e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 910:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 914:	00000797          	auipc	a5,0x0
 918:	6ec7b783          	ld	a5,1772(a5) # 1000 <freep>
 91c:	a02d                	j	946 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91e:	4618                	lw	a4,8(a2)
 920:	9f2d                	addw	a4,a4,a1
 922:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	6310                	ld	a2,0(a4)
 92a:	a83d                	j	968 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 92c:	ff852703          	lw	a4,-8(a0)
 930:	9f31                	addw	a4,a4,a2
 932:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 934:	ff053683          	ld	a3,-16(a0)
 938:	a091                	j	97c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93a:	6398                	ld	a4,0(a5)
 93c:	00e7e463          	bltu	a5,a4,944 <free+0x3a>
 940:	00e6ea63          	bltu	a3,a4,954 <free+0x4a>
{
 944:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	fed7fae3          	bgeu	a5,a3,93a <free+0x30>
 94a:	6398                	ld	a4,0(a5)
 94c:	00e6e463          	bltu	a3,a4,954 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 950:	fee7eae3          	bltu	a5,a4,944 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 954:	ff852583          	lw	a1,-8(a0)
 958:	6390                	ld	a2,0(a5)
 95a:	02059813          	slli	a6,a1,0x20
 95e:	01c85713          	srli	a4,a6,0x1c
 962:	9736                	add	a4,a4,a3
 964:	fae60de3          	beq	a2,a4,91e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 96c:	4790                	lw	a2,8(a5)
 96e:	02061593          	slli	a1,a2,0x20
 972:	01c5d713          	srli	a4,a1,0x1c
 976:	973e                	add	a4,a4,a5
 978:	fae68ae3          	beq	a3,a4,92c <free+0x22>
    p->s.ptr = bp->s.ptr;
 97c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 97e:	00000717          	auipc	a4,0x0
 982:	68f73123          	sd	a5,1666(a4) # 1000 <freep>
}
 986:	6422                	ld	s0,8(sp)
 988:	0141                	addi	sp,sp,16
 98a:	8082                	ret

000000000000098c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 98c:	7139                	addi	sp,sp,-64
 98e:	fc06                	sd	ra,56(sp)
 990:	f822                	sd	s0,48(sp)
 992:	f426                	sd	s1,40(sp)
 994:	f04a                	sd	s2,32(sp)
 996:	ec4e                	sd	s3,24(sp)
 998:	e852                	sd	s4,16(sp)
 99a:	e456                	sd	s5,8(sp)
 99c:	e05a                	sd	s6,0(sp)
 99e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a0:	02051493          	slli	s1,a0,0x20
 9a4:	9081                	srli	s1,s1,0x20
 9a6:	04bd                	addi	s1,s1,15
 9a8:	8091                	srli	s1,s1,0x4
 9aa:	0014899b          	addiw	s3,s1,1
 9ae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b0:	00000517          	auipc	a0,0x0
 9b4:	65053503          	ld	a0,1616(a0) # 1000 <freep>
 9b8:	c515                	beqz	a0,9e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9bc:	4798                	lw	a4,8(a5)
 9be:	02977f63          	bgeu	a4,s1,9fc <malloc+0x70>
  if(nu < 4096)
 9c2:	8a4e                	mv	s4,s3
 9c4:	0009871b          	sext.w	a4,s3
 9c8:	6685                	lui	a3,0x1
 9ca:	00d77363          	bgeu	a4,a3,9d0 <malloc+0x44>
 9ce:	6a05                	lui	s4,0x1
 9d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d8:	00000917          	auipc	s2,0x0
 9dc:	62890913          	addi	s2,s2,1576 # 1000 <freep>
  if(p == (char*)-1)
 9e0:	5afd                	li	s5,-1
 9e2:	a895                	j	a56 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9e4:	00001797          	auipc	a5,0x1
 9e8:	a2c78793          	addi	a5,a5,-1492 # 1410 <base>
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60f73a23          	sd	a5,1556(a4) # 1000 <freep>
 9f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fa:	b7e1                	j	9c2 <malloc+0x36>
      if(p->s.size == nunits)
 9fc:	02e48c63          	beq	s1,a4,a34 <malloc+0xa8>
        p->s.size -= nunits;
 a00:	4137073b          	subw	a4,a4,s3
 a04:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a06:	02071693          	slli	a3,a4,0x20
 a0a:	01c6d713          	srli	a4,a3,0x1c
 a0e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a10:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a14:	00000717          	auipc	a4,0x0
 a18:	5ea73623          	sd	a0,1516(a4) # 1000 <freep>
      return (void*)(p + 1);
 a1c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a20:	70e2                	ld	ra,56(sp)
 a22:	7442                	ld	s0,48(sp)
 a24:	74a2                	ld	s1,40(sp)
 a26:	7902                	ld	s2,32(sp)
 a28:	69e2                	ld	s3,24(sp)
 a2a:	6a42                	ld	s4,16(sp)
 a2c:	6aa2                	ld	s5,8(sp)
 a2e:	6b02                	ld	s6,0(sp)
 a30:	6121                	addi	sp,sp,64
 a32:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a34:	6398                	ld	a4,0(a5)
 a36:	e118                	sd	a4,0(a0)
 a38:	bff1                	j	a14 <malloc+0x88>
  hp->s.size = nu;
 a3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3e:	0541                	addi	a0,a0,16
 a40:	00000097          	auipc	ra,0x0
 a44:	eca080e7          	jalr	-310(ra) # 90a <free>
  return freep;
 a48:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4c:	d971                	beqz	a0,a20 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a50:	4798                	lw	a4,8(a5)
 a52:	fa9775e3          	bgeu	a4,s1,9fc <malloc+0x70>
    if(p == freep)
 a56:	00093703          	ld	a4,0(s2)
 a5a:	853e                	mv	a0,a5
 a5c:	fef719e3          	bne	a4,a5,a4e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a60:	8552                	mv	a0,s4
 a62:	00000097          	auipc	ra,0x0
 a66:	b92080e7          	jalr	-1134(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 a6a:	fd5518e3          	bne	a0,s5,a3a <malloc+0xae>
        return 0;
 a6e:	4501                	li	a0,0
 a70:	bf45                	j	a20 <malloc+0x94>
