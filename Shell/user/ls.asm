
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	360080e7          	jalr	864(ra) # 370 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	334080e7          	jalr	820(ra) # 370 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	312080e7          	jalr	786(ra) # 370 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	46c080e7          	jalr	1132(ra) # 4e2 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2f0080e7          	jalr	752(ra) # 370 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2e2080e7          	jalr	738(ra) # 370 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2f2080e7          	jalr	754(ra) # 39a <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4fa080e7          	jalr	1274(ra) # 5d4 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	500080e7          	jalr	1280(ra) # 5ec <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	4705                	li	a4,1
  fe:	08e78c63          	beq	a5,a4,196 <ls+0xe2>
 102:	37f9                	addiw	a5,a5,-2
 104:	17c2                	slli	a5,a5,0x30
 106:	93c1                	srli	a5,a5,0x30
 108:	02f76663          	bltu	a4,a5,134 <ls+0x80>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	9ac50513          	addi	a0,a0,-1620 # ad0 <malloc+0x11c>
 12c:	00000097          	auipc	ra,0x0
 130:	7d0080e7          	jalr	2000(ra) # 8fc <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	486080e7          	jalr	1158(ra) # 5bc <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	93e58593          	addi	a1,a1,-1730 # aa0 <malloc+0xec>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	762080e7          	jalr	1890(ra) # 8ce <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	94058593          	addi	a1,a1,-1728 # ab8 <malloc+0x104>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	74c080e7          	jalr	1868(ra) # 8ce <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	430080e7          	jalr	1072(ra) # 5bc <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	1d8080e7          	jalr	472(ra) # 370 <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	93650513          	addi	a0,a0,-1738 # ae0 <malloc+0x12c>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	74a080e7          	jalr	1866(ra) # 8fc <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	12a080e7          	jalr	298(ra) # 2ec <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	1a2080e7          	jalr	418(ra) # 370 <strlen>
 1d6:	1502                	slli	a0,a0,0x20
 1d8:	9101                	srli	a0,a0,0x20
 1da:	dc040793          	addi	a5,s0,-576
 1de:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1e2:	00190993          	addi	s3,s2,1
 1e6:	02f00793          	li	a5,47
 1ea:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1ee:	00001a17          	auipc	s4,0x1
 1f2:	90aa0a13          	addi	s4,s4,-1782 # af8 <malloc+0x144>
        printf("ls: cannot stat %s\n", buf);
 1f6:	00001a97          	auipc	s5,0x1
 1fa:	8c2a8a93          	addi	s5,s5,-1854 # ab8 <malloc+0x104>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fe:	a801                	j	20e <ls+0x15a>
        printf("ls: cannot stat %s\n", buf);
 200:	dc040593          	addi	a1,s0,-576
 204:	8556                	mv	a0,s5
 206:	00000097          	auipc	ra,0x0
 20a:	6f6080e7          	jalr	1782(ra) # 8fc <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20e:	4641                	li	a2,16
 210:	db040593          	addi	a1,s0,-592
 214:	8526                	mv	a0,s1
 216:	00000097          	auipc	ra,0x0
 21a:	396080e7          	jalr	918(ra) # 5ac <read>
 21e:	47c1                	li	a5,16
 220:	f0f51ae3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 224:	db045783          	lhu	a5,-592(s0)
 228:	d3fd                	beqz	a5,20e <ls+0x15a>
      memmove(p, de.name, DIRSIZ);
 22a:	4639                	li	a2,14
 22c:	db240593          	addi	a1,s0,-590
 230:	854e                	mv	a0,s3
 232:	00000097          	auipc	ra,0x0
 236:	2b0080e7          	jalr	688(ra) # 4e2 <memmove>
      p[DIRSIZ] = 0;
 23a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 23e:	d9840593          	addi	a1,s0,-616
 242:	dc040513          	addi	a0,s0,-576
 246:	00000097          	auipc	ra,0x0
 24a:	20e080e7          	jalr	526(ra) # 454 <stat>
 24e:	fa0549e3          	bltz	a0,200 <ls+0x14c>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 252:	dc040513          	addi	a0,s0,-576
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <fmtname>
 25e:	85aa                	mv	a1,a0
 260:	da843703          	ld	a4,-600(s0)
 264:	d9c42683          	lw	a3,-612(s0)
 268:	da041603          	lh	a2,-608(s0)
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	68e080e7          	jalr	1678(ra) # 8fc <printf>
 276:	bf61                	j	20e <ls+0x15a>

0000000000000278 <main>:

int
main(int argc, char *argv[])
{
 278:	1101                	addi	sp,sp,-32
 27a:	ec06                	sd	ra,24(sp)
 27c:	e822                	sd	s0,16(sp)
 27e:	e426                	sd	s1,8(sp)
 280:	e04a                	sd	s2,0(sp)
 282:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 284:	4785                	li	a5,1
 286:	02a7d963          	bge	a5,a0,2b8 <main+0x40>
 28a:	00858493          	addi	s1,a1,8
 28e:	ffe5091b          	addiw	s2,a0,-2
 292:	02091793          	slli	a5,s2,0x20
 296:	01d7d913          	srli	s2,a5,0x1d
 29a:	05c1                	addi	a1,a1,16
 29c:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 29e:	6088                	ld	a0,0(s1)
 2a0:	00000097          	auipc	ra,0x0
 2a4:	e14080e7          	jalr	-492(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2a8:	04a1                	addi	s1,s1,8
 2aa:	ff249ae3          	bne	s1,s2,29e <main+0x26>
  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	2e4080e7          	jalr	740(ra) # 594 <exit>
    ls(".");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	85050513          	addi	a0,a0,-1968 # b08 <malloc+0x154>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	df4080e7          	jalr	-524(ra) # b4 <ls>
    exit(0);
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	2ca080e7          	jalr	714(ra) # 594 <exit>

00000000000002d2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2da:	00000097          	auipc	ra,0x0
 2de:	f9e080e7          	jalr	-98(ra) # 278 <main>
  exit(0);
 2e2:	4501                	li	a0,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	2b0080e7          	jalr	688(ra) # 594 <exit>

00000000000002ec <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f2:	87aa                	mv	a5,a0
 2f4:	0585                	addi	a1,a1,1
 2f6:	0785                	addi	a5,a5,1
 2f8:	fff5c703          	lbu	a4,-1(a1)
 2fc:	fee78fa3          	sb	a4,-1(a5)
 300:	fb75                	bnez	a4,2f4 <strcpy+0x8>
    ;
  return os;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb91                	beqz	a5,326 <strcmp+0x1e>
 314:	0005c703          	lbu	a4,0(a1)
 318:	00f71763          	bne	a4,a5,326 <strcmp+0x1e>
    p++, q++;
 31c:	0505                	addi	a0,a0,1
 31e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	fbe5                	bnez	a5,314 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 326:	0005c503          	lbu	a0,0(a1)
}
 32a:	40a7853b          	subw	a0,a5,a0
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 33a:	ce11                	beqz	a2,356 <strncmp+0x22>
 33c:	00054783          	lbu	a5,0(a0)
 340:	cf89                	beqz	a5,35a <strncmp+0x26>
 342:	0005c703          	lbu	a4,0(a1)
 346:	00f71a63          	bne	a4,a5,35a <strncmp+0x26>
    n--, p++, q++;
 34a:	367d                	addiw	a2,a2,-1
 34c:	0505                	addi	a0,a0,1
 34e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 350:	f675                	bnez	a2,33c <strncmp+0x8>
  if(n == 0)
    return 0;
 352:	4501                	li	a0,0
 354:	a809                	j	366 <strncmp+0x32>
 356:	4501                	li	a0,0
 358:	a039                	j	366 <strncmp+0x32>
  if(n == 0)
 35a:	ca09                	beqz	a2,36c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 35c:	00054503          	lbu	a0,0(a0)
 360:	0005c783          	lbu	a5,0(a1)
 364:	9d1d                	subw	a0,a0,a5
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
    return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strncmp+0x32>

0000000000000370 <strlen>:

uint
strlen(const char *s)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 376:	00054783          	lbu	a5,0(a0)
 37a:	cf91                	beqz	a5,396 <strlen+0x26>
 37c:	0505                	addi	a0,a0,1
 37e:	87aa                	mv	a5,a0
 380:	86be                	mv	a3,a5
 382:	0785                	addi	a5,a5,1
 384:	fff7c703          	lbu	a4,-1(a5)
 388:	ff65                	bnez	a4,380 <strlen+0x10>
 38a:	40a6853b          	subw	a0,a3,a0
 38e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
  for(n = 0; s[n]; n++)
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <strlen+0x20>

000000000000039a <memset>:

void*
memset(void *dst, int c, uint n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3a0:	ca19                	beqz	a2,3b6 <memset+0x1c>
 3a2:	87aa                	mv	a5,a0
 3a4:	1602                	slli	a2,a2,0x20
 3a6:	9201                	srli	a2,a2,0x20
 3a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b0:	0785                	addi	a5,a5,1
 3b2:	fee79de3          	bne	a5,a4,3ac <memset+0x12>
  }
  return dst;
}
 3b6:	6422                	ld	s0,8(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <strchr>:

char*
strchr(const char *s, char c)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	cb99                	beqz	a5,3dc <strchr+0x20>
    if(*s == c)
 3c8:	00f58763          	beq	a1,a5,3d6 <strchr+0x1a>
  for(; *s; s++)
 3cc:	0505                	addi	a0,a0,1
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	fbfd                	bnez	a5,3c8 <strchr+0xc>
      return (char*)s;
  return 0;
 3d4:	4501                	li	a0,0
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
  return 0;
 3dc:	4501                	li	a0,0
 3de:	bfe5                	j	3d6 <strchr+0x1a>

00000000000003e0 <gets>:

char*
gets(char *buf, int max)
{
 3e0:	711d                	addi	sp,sp,-96
 3e2:	ec86                	sd	ra,88(sp)
 3e4:	e8a2                	sd	s0,80(sp)
 3e6:	e4a6                	sd	s1,72(sp)
 3e8:	e0ca                	sd	s2,64(sp)
 3ea:	fc4e                	sd	s3,56(sp)
 3ec:	f852                	sd	s4,48(sp)
 3ee:	f456                	sd	s5,40(sp)
 3f0:	f05a                	sd	s6,32(sp)
 3f2:	ec5e                	sd	s7,24(sp)
 3f4:	1080                	addi	s0,sp,96
 3f6:	8baa                	mv	s7,a0
 3f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fa:	892a                	mv	s2,a0
 3fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3fe:	4aa9                	li	s5,10
 400:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 402:	89a6                	mv	s3,s1
 404:	2485                	addiw	s1,s1,1
 406:	0344d863          	bge	s1,s4,436 <gets+0x56>
    cc = read(0, &c, 1);
 40a:	4605                	li	a2,1
 40c:	faf40593          	addi	a1,s0,-81
 410:	4501                	li	a0,0
 412:	00000097          	auipc	ra,0x0
 416:	19a080e7          	jalr	410(ra) # 5ac <read>
    if(cc < 1)
 41a:	00a05e63          	blez	a0,436 <gets+0x56>
    buf[i++] = c;
 41e:	faf44783          	lbu	a5,-81(s0)
 422:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 426:	01578763          	beq	a5,s5,434 <gets+0x54>
 42a:	0905                	addi	s2,s2,1
 42c:	fd679be3          	bne	a5,s6,402 <gets+0x22>
  for(i=0; i+1 < max; ){
 430:	89a6                	mv	s3,s1
 432:	a011                	j	436 <gets+0x56>
 434:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 436:	99de                	add	s3,s3,s7
 438:	00098023          	sb	zero,0(s3)
  return buf;
}
 43c:	855e                	mv	a0,s7
 43e:	60e6                	ld	ra,88(sp)
 440:	6446                	ld	s0,80(sp)
 442:	64a6                	ld	s1,72(sp)
 444:	6906                	ld	s2,64(sp)
 446:	79e2                	ld	s3,56(sp)
 448:	7a42                	ld	s4,48(sp)
 44a:	7aa2                	ld	s5,40(sp)
 44c:	7b02                	ld	s6,32(sp)
 44e:	6be2                	ld	s7,24(sp)
 450:	6125                	addi	sp,sp,96
 452:	8082                	ret

0000000000000454 <stat>:

int
stat(const char *n, struct stat *st)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	e426                	sd	s1,8(sp)
 45c:	e04a                	sd	s2,0(sp)
 45e:	1000                	addi	s0,sp,32
 460:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 462:	4581                	li	a1,0
 464:	00000097          	auipc	ra,0x0
 468:	170080e7          	jalr	368(ra) # 5d4 <open>
  if(fd < 0)
 46c:	02054563          	bltz	a0,496 <stat+0x42>
 470:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 472:	85ca                	mv	a1,s2
 474:	00000097          	auipc	ra,0x0
 478:	178080e7          	jalr	376(ra) # 5ec <fstat>
 47c:	892a                	mv	s2,a0
  close(fd);
 47e:	8526                	mv	a0,s1
 480:	00000097          	auipc	ra,0x0
 484:	13c080e7          	jalr	316(ra) # 5bc <close>
  return r;
}
 488:	854a                	mv	a0,s2
 48a:	60e2                	ld	ra,24(sp)
 48c:	6442                	ld	s0,16(sp)
 48e:	64a2                	ld	s1,8(sp)
 490:	6902                	ld	s2,0(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret
    return -1;
 496:	597d                	li	s2,-1
 498:	bfc5                	j	488 <stat+0x34>

000000000000049a <atoi>:

int
atoi(const char *s)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e422                	sd	s0,8(sp)
 49e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a0:	00054683          	lbu	a3,0(a0)
 4a4:	fd06879b          	addiw	a5,a3,-48
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	4625                	li	a2,9
 4ae:	02f66863          	bltu	a2,a5,4de <atoi+0x44>
 4b2:	872a                	mv	a4,a0
  n = 0;
 4b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4b6:	0705                	addi	a4,a4,1
 4b8:	0025179b          	slliw	a5,a0,0x2
 4bc:	9fa9                	addw	a5,a5,a0
 4be:	0017979b          	slliw	a5,a5,0x1
 4c2:	9fb5                	addw	a5,a5,a3
 4c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c8:	00074683          	lbu	a3,0(a4)
 4cc:	fd06879b          	addiw	a5,a3,-48
 4d0:	0ff7f793          	zext.b	a5,a5
 4d4:	fef671e3          	bgeu	a2,a5,4b6 <atoi+0x1c>
  return n;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  n = 0;
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <atoi+0x3e>

00000000000004e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e8:	02b57463          	bgeu	a0,a1,510 <memmove+0x2e>
    while(n-- > 0)
 4ec:	00c05f63          	blez	a2,50a <memmove+0x28>
 4f0:	1602                	slli	a2,a2,0x20
 4f2:	9201                	srli	a2,a2,0x20
 4f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 4fa:	0585                	addi	a1,a1,1
 4fc:	0705                	addi	a4,a4,1
 4fe:	fff5c683          	lbu	a3,-1(a1)
 502:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 506:	fee79ae3          	bne	a5,a4,4fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret
    dst += n;
 510:	00c50733          	add	a4,a0,a2
    src += n;
 514:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 516:	fec05ae3          	blez	a2,50a <memmove+0x28>
 51a:	fff6079b          	addiw	a5,a2,-1
 51e:	1782                	slli	a5,a5,0x20
 520:	9381                	srli	a5,a5,0x20
 522:	fff7c793          	not	a5,a5
 526:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 528:	15fd                	addi	a1,a1,-1
 52a:	177d                	addi	a4,a4,-1
 52c:	0005c683          	lbu	a3,0(a1)
 530:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 534:	fee79ae3          	bne	a5,a4,528 <memmove+0x46>
 538:	bfc9                	j	50a <memmove+0x28>

000000000000053a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 53a:	1141                	addi	sp,sp,-16
 53c:	e422                	sd	s0,8(sp)
 53e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 540:	ca05                	beqz	a2,570 <memcmp+0x36>
 542:	fff6069b          	addiw	a3,a2,-1
 546:	1682                	slli	a3,a3,0x20
 548:	9281                	srli	a3,a3,0x20
 54a:	0685                	addi	a3,a3,1
 54c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 54e:	00054783          	lbu	a5,0(a0)
 552:	0005c703          	lbu	a4,0(a1)
 556:	00e79863          	bne	a5,a4,566 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 55a:	0505                	addi	a0,a0,1
    p2++;
 55c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 55e:	fed518e3          	bne	a0,a3,54e <memcmp+0x14>
  }
  return 0;
 562:	4501                	li	a0,0
 564:	a019                	j	56a <memcmp+0x30>
      return *p1 - *p2;
 566:	40e7853b          	subw	a0,a5,a4
}
 56a:	6422                	ld	s0,8(sp)
 56c:	0141                	addi	sp,sp,16
 56e:	8082                	ret
  return 0;
 570:	4501                	li	a0,0
 572:	bfe5                	j	56a <memcmp+0x30>

0000000000000574 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 574:	1141                	addi	sp,sp,-16
 576:	e406                	sd	ra,8(sp)
 578:	e022                	sd	s0,0(sp)
 57a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 57c:	00000097          	auipc	ra,0x0
 580:	f66080e7          	jalr	-154(ra) # 4e2 <memmove>
}
 584:	60a2                	ld	ra,8(sp)
 586:	6402                	ld	s0,0(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret

000000000000058c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 58c:	4885                	li	a7,1
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <exit>:
.global exit
exit:
 li a7, SYS_exit
 594:	4889                	li	a7,2
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <wait>:
.global wait
wait:
 li a7, SYS_wait
 59c:	488d                	li	a7,3
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a4:	4891                	li	a7,4
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <read>:
.global read
read:
 li a7, SYS_read
 5ac:	4895                	li	a7,5
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <write>:
.global write
write:
 li a7, SYS_write
 5b4:	48c1                	li	a7,16
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <close>:
.global close
close:
 li a7, SYS_close
 5bc:	48d5                	li	a7,21
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c4:	4899                	li	a7,6
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 5cc:	489d                	li	a7,7
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <open>:
.global open
open:
 li a7, SYS_open
 5d4:	48bd                	li	a7,15
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5dc:	48c5                	li	a7,17
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e4:	48c9                	li	a7,18
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ec:	48a1                	li	a7,8
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <link>:
.global link
link:
 li a7, SYS_link
 5f4:	48cd                	li	a7,19
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5fc:	48d1                	li	a7,20
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 604:	48a5                	li	a7,9
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <dup>:
.global dup
dup:
 li a7, SYS_dup
 60c:	48a9                	li	a7,10
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 614:	48ad                	li	a7,11
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 61c:	48b1                	li	a7,12
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 624:	48b5                	li	a7,13
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 62c:	48b9                	li	a7,14
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 634:	1101                	addi	sp,sp,-32
 636:	ec06                	sd	ra,24(sp)
 638:	e822                	sd	s0,16(sp)
 63a:	1000                	addi	s0,sp,32
 63c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 640:	4605                	li	a2,1
 642:	fef40593          	addi	a1,s0,-17
 646:	00000097          	auipc	ra,0x0
 64a:	f6e080e7          	jalr	-146(ra) # 5b4 <write>
}
 64e:	60e2                	ld	ra,24(sp)
 650:	6442                	ld	s0,16(sp)
 652:	6105                	addi	sp,sp,32
 654:	8082                	ret

0000000000000656 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 656:	7139                	addi	sp,sp,-64
 658:	fc06                	sd	ra,56(sp)
 65a:	f822                	sd	s0,48(sp)
 65c:	f426                	sd	s1,40(sp)
 65e:	f04a                	sd	s2,32(sp)
 660:	ec4e                	sd	s3,24(sp)
 662:	0080                	addi	s0,sp,64
 664:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 666:	c299                	beqz	a3,66c <printint+0x16>
 668:	0805c963          	bltz	a1,6fa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 66c:	2581                	sext.w	a1,a1
  neg = 0;
 66e:	4881                	li	a7,0
 670:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 674:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 676:	2601                	sext.w	a2,a2
 678:	00000517          	auipc	a0,0x0
 67c:	4f850513          	addi	a0,a0,1272 # b70 <digits>
 680:	883a                	mv	a6,a4
 682:	2705                	addiw	a4,a4,1
 684:	02c5f7bb          	remuw	a5,a1,a2
 688:	1782                	slli	a5,a5,0x20
 68a:	9381                	srli	a5,a5,0x20
 68c:	97aa                	add	a5,a5,a0
 68e:	0007c783          	lbu	a5,0(a5)
 692:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 696:	0005879b          	sext.w	a5,a1
 69a:	02c5d5bb          	divuw	a1,a1,a2
 69e:	0685                	addi	a3,a3,1
 6a0:	fec7f0e3          	bgeu	a5,a2,680 <printint+0x2a>
  if(neg)
 6a4:	00088c63          	beqz	a7,6bc <printint+0x66>
    buf[i++] = '-';
 6a8:	fd070793          	addi	a5,a4,-48
 6ac:	00878733          	add	a4,a5,s0
 6b0:	02d00793          	li	a5,45
 6b4:	fef70823          	sb	a5,-16(a4)
 6b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6bc:	02e05863          	blez	a4,6ec <printint+0x96>
 6c0:	fc040793          	addi	a5,s0,-64
 6c4:	00e78933          	add	s2,a5,a4
 6c8:	fff78993          	addi	s3,a5,-1
 6cc:	99ba                	add	s3,s3,a4
 6ce:	377d                	addiw	a4,a4,-1
 6d0:	1702                	slli	a4,a4,0x20
 6d2:	9301                	srli	a4,a4,0x20
 6d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d8:	fff94583          	lbu	a1,-1(s2)
 6dc:	8526                	mv	a0,s1
 6de:	00000097          	auipc	ra,0x0
 6e2:	f56080e7          	jalr	-170(ra) # 634 <putc>
  while(--i >= 0)
 6e6:	197d                	addi	s2,s2,-1
 6e8:	ff3918e3          	bne	s2,s3,6d8 <printint+0x82>
}
 6ec:	70e2                	ld	ra,56(sp)
 6ee:	7442                	ld	s0,48(sp)
 6f0:	74a2                	ld	s1,40(sp)
 6f2:	7902                	ld	s2,32(sp)
 6f4:	69e2                	ld	s3,24(sp)
 6f6:	6121                	addi	sp,sp,64
 6f8:	8082                	ret
    x = -xx;
 6fa:	40b005bb          	negw	a1,a1
    neg = 1;
 6fe:	4885                	li	a7,1
    x = -xx;
 700:	bf85                	j	670 <printint+0x1a>

0000000000000702 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 702:	715d                	addi	sp,sp,-80
 704:	e486                	sd	ra,72(sp)
 706:	e0a2                	sd	s0,64(sp)
 708:	fc26                	sd	s1,56(sp)
 70a:	f84a                	sd	s2,48(sp)
 70c:	f44e                	sd	s3,40(sp)
 70e:	f052                	sd	s4,32(sp)
 710:	ec56                	sd	s5,24(sp)
 712:	e85a                	sd	s6,16(sp)
 714:	e45e                	sd	s7,8(sp)
 716:	e062                	sd	s8,0(sp)
 718:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 71a:	0005c903          	lbu	s2,0(a1)
 71e:	18090c63          	beqz	s2,8b6 <vprintf+0x1b4>
 722:	8aaa                	mv	s5,a0
 724:	8bb2                	mv	s7,a2
 726:	00158493          	addi	s1,a1,1
  state = 0;
 72a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72c:	02500a13          	li	s4,37
 730:	4b55                	li	s6,21
 732:	a839                	j	750 <vprintf+0x4e>
        putc(fd, c);
 734:	85ca                	mv	a1,s2
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	efc080e7          	jalr	-260(ra) # 634 <putc>
 740:	a019                	j	746 <vprintf+0x44>
    } else if(state == '%'){
 742:	01498d63          	beq	s3,s4,75c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 746:	0485                	addi	s1,s1,1
 748:	fff4c903          	lbu	s2,-1(s1)
 74c:	16090563          	beqz	s2,8b6 <vprintf+0x1b4>
    if(state == 0){
 750:	fe0999e3          	bnez	s3,742 <vprintf+0x40>
      if(c == '%'){
 754:	ff4910e3          	bne	s2,s4,734 <vprintf+0x32>
        state = '%';
 758:	89d2                	mv	s3,s4
 75a:	b7f5                	j	746 <vprintf+0x44>
      if(c == 'd'){
 75c:	13490263          	beq	s2,s4,880 <vprintf+0x17e>
 760:	f9d9079b          	addiw	a5,s2,-99
 764:	0ff7f793          	zext.b	a5,a5
 768:	12fb6563          	bltu	s6,a5,892 <vprintf+0x190>
 76c:	f9d9079b          	addiw	a5,s2,-99
 770:	0ff7f713          	zext.b	a4,a5
 774:	10eb6f63          	bltu	s6,a4,892 <vprintf+0x190>
 778:	00271793          	slli	a5,a4,0x2
 77c:	00000717          	auipc	a4,0x0
 780:	39c70713          	addi	a4,a4,924 # b18 <malloc+0x164>
 784:	97ba                	add	a5,a5,a4
 786:	439c                	lw	a5,0(a5)
 788:	97ba                	add	a5,a5,a4
 78a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 78c:	008b8913          	addi	s2,s7,8
 790:	4685                	li	a3,1
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	ebc080e7          	jalr	-324(ra) # 656 <printint>
 7a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b745                	j	746 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a8:	008b8913          	addi	s2,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4629                	li	a2,10
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	ea0080e7          	jalr	-352(ra) # 656 <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b751                	j	746 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4641                	li	a2,16
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e84080e7          	jalr	-380(ra) # 656 <printint>
 7da:	8bca                	mv	s7,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b7a5                	j	746 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7e0:	008b8c13          	addi	s8,s7,8
 7e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e8:	03000593          	li	a1,48
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e46080e7          	jalr	-442(ra) # 634 <putc>
  putc(fd, 'x');
 7f6:	07800593          	li	a1,120
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	e38080e7          	jalr	-456(ra) # 634 <putc>
 804:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 806:	00000b97          	auipc	s7,0x0
 80a:	36ab8b93          	addi	s7,s7,874 # b70 <digits>
 80e:	03c9d793          	srli	a5,s3,0x3c
 812:	97de                	add	a5,a5,s7
 814:	0007c583          	lbu	a1,0(a5)
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e1a080e7          	jalr	-486(ra) # 634 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	0992                	slli	s3,s3,0x4
 824:	397d                	addiw	s2,s2,-1
 826:	fe0914e3          	bnez	s2,80e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 82a:	8be2                	mv	s7,s8
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bf21                	j	746 <vprintf+0x44>
        s = va_arg(ap, char*);
 830:	008b8993          	addi	s3,s7,8
 834:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 838:	02090163          	beqz	s2,85a <vprintf+0x158>
        while(*s != 0){
 83c:	00094583          	lbu	a1,0(s2)
 840:	c9a5                	beqz	a1,8b0 <vprintf+0x1ae>
          putc(fd, *s);
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	df0080e7          	jalr	-528(ra) # 634 <putc>
          s++;
 84c:	0905                	addi	s2,s2,1
        while(*s != 0){
 84e:	00094583          	lbu	a1,0(s2)
 852:	f9e5                	bnez	a1,842 <vprintf+0x140>
        s = va_arg(ap, char*);
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	b5fd                	j	746 <vprintf+0x44>
          s = "(null)";
 85a:	00000917          	auipc	s2,0x0
 85e:	2b690913          	addi	s2,s2,694 # b10 <malloc+0x15c>
        while(*s != 0){
 862:	02800593          	li	a1,40
 866:	bff1                	j	842 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 868:	008b8913          	addi	s2,s7,8
 86c:	000bc583          	lbu	a1,0(s7)
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	dc2080e7          	jalr	-574(ra) # 634 <putc>
 87a:	8bca                	mv	s7,s2
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b5e1                	j	746 <vprintf+0x44>
        putc(fd, c);
 880:	02500593          	li	a1,37
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	dae080e7          	jalr	-594(ra) # 634 <putc>
      state = 0;
 88e:	4981                	li	s3,0
 890:	bd5d                	j	746 <vprintf+0x44>
        putc(fd, '%');
 892:	02500593          	li	a1,37
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	d9c080e7          	jalr	-612(ra) # 634 <putc>
        putc(fd, c);
 8a0:	85ca                	mv	a1,s2
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	d90080e7          	jalr	-624(ra) # 634 <putc>
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bd61                	j	746 <vprintf+0x44>
        s = va_arg(ap, char*);
 8b0:	8bce                	mv	s7,s3
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	bd49                	j	746 <vprintf+0x44>
    }
  }
}
 8b6:	60a6                	ld	ra,72(sp)
 8b8:	6406                	ld	s0,64(sp)
 8ba:	74e2                	ld	s1,56(sp)
 8bc:	7942                	ld	s2,48(sp)
 8be:	79a2                	ld	s3,40(sp)
 8c0:	7a02                	ld	s4,32(sp)
 8c2:	6ae2                	ld	s5,24(sp)
 8c4:	6b42                	ld	s6,16(sp)
 8c6:	6ba2                	ld	s7,8(sp)
 8c8:	6c02                	ld	s8,0(sp)
 8ca:	6161                	addi	sp,sp,80
 8cc:	8082                	ret

00000000000008ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ce:	715d                	addi	sp,sp,-80
 8d0:	ec06                	sd	ra,24(sp)
 8d2:	e822                	sd	s0,16(sp)
 8d4:	1000                	addi	s0,sp,32
 8d6:	e010                	sd	a2,0(s0)
 8d8:	e414                	sd	a3,8(s0)
 8da:	e818                	sd	a4,16(s0)
 8dc:	ec1c                	sd	a5,24(s0)
 8de:	03043023          	sd	a6,32(s0)
 8e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ea:	8622                	mv	a2,s0
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e16080e7          	jalr	-490(ra) # 702 <vprintf>
}
 8f4:	60e2                	ld	ra,24(sp)
 8f6:	6442                	ld	s0,16(sp)
 8f8:	6161                	addi	sp,sp,80
 8fa:	8082                	ret

00000000000008fc <printf>:

void
printf(const char *fmt, ...)
{
 8fc:	711d                	addi	sp,sp,-96
 8fe:	ec06                	sd	ra,24(sp)
 900:	e822                	sd	s0,16(sp)
 902:	1000                	addi	s0,sp,32
 904:	e40c                	sd	a1,8(s0)
 906:	e810                	sd	a2,16(s0)
 908:	ec14                	sd	a3,24(s0)
 90a:	f018                	sd	a4,32(s0)
 90c:	f41c                	sd	a5,40(s0)
 90e:	03043823          	sd	a6,48(s0)
 912:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 916:	00840613          	addi	a2,s0,8
 91a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 91e:	85aa                	mv	a1,a0
 920:	4505                	li	a0,1
 922:	00000097          	auipc	ra,0x0
 926:	de0080e7          	jalr	-544(ra) # 702 <vprintf>
}
 92a:	60e2                	ld	ra,24(sp)
 92c:	6442                	ld	s0,16(sp)
 92e:	6125                	addi	sp,sp,96
 930:	8082                	ret

0000000000000932 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 932:	1141                	addi	sp,sp,-16
 934:	e422                	sd	s0,8(sp)
 936:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 938:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93c:	00000797          	auipc	a5,0x0
 940:	6c47b783          	ld	a5,1732(a5) # 1000 <freep>
 944:	a02d                	j	96e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 946:	4618                	lw	a4,8(a2)
 948:	9f2d                	addw	a4,a4,a1
 94a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 94e:	6398                	ld	a4,0(a5)
 950:	6310                	ld	a2,0(a4)
 952:	a83d                	j	990 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 954:	ff852703          	lw	a4,-8(a0)
 958:	9f31                	addw	a4,a4,a2
 95a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 95c:	ff053683          	ld	a3,-16(a0)
 960:	a091                	j	9a4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 962:	6398                	ld	a4,0(a5)
 964:	00e7e463          	bltu	a5,a4,96c <free+0x3a>
 968:	00e6ea63          	bltu	a3,a4,97c <free+0x4a>
{
 96c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96e:	fed7fae3          	bgeu	a5,a3,962 <free+0x30>
 972:	6398                	ld	a4,0(a5)
 974:	00e6e463          	bltu	a3,a4,97c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 978:	fee7eae3          	bltu	a5,a4,96c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 97c:	ff852583          	lw	a1,-8(a0)
 980:	6390                	ld	a2,0(a5)
 982:	02059813          	slli	a6,a1,0x20
 986:	01c85713          	srli	a4,a6,0x1c
 98a:	9736                	add	a4,a4,a3
 98c:	fae60de3          	beq	a2,a4,946 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 990:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 994:	4790                	lw	a2,8(a5)
 996:	02061593          	slli	a1,a2,0x20
 99a:	01c5d713          	srli	a4,a1,0x1c
 99e:	973e                	add	a4,a4,a5
 9a0:	fae68ae3          	beq	a3,a4,954 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9a6:	00000717          	auipc	a4,0x0
 9aa:	64f73d23          	sd	a5,1626(a4) # 1000 <freep>
}
 9ae:	6422                	ld	s0,8(sp)
 9b0:	0141                	addi	sp,sp,16
 9b2:	8082                	ret

00000000000009b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b4:	7139                	addi	sp,sp,-64
 9b6:	fc06                	sd	ra,56(sp)
 9b8:	f822                	sd	s0,48(sp)
 9ba:	f426                	sd	s1,40(sp)
 9bc:	f04a                	sd	s2,32(sp)
 9be:	ec4e                	sd	s3,24(sp)
 9c0:	e852                	sd	s4,16(sp)
 9c2:	e456                	sd	s5,8(sp)
 9c4:	e05a                	sd	s6,0(sp)
 9c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c8:	02051493          	slli	s1,a0,0x20
 9cc:	9081                	srli	s1,s1,0x20
 9ce:	04bd                	addi	s1,s1,15
 9d0:	8091                	srli	s1,s1,0x4
 9d2:	0014899b          	addiw	s3,s1,1
 9d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9d8:	00000517          	auipc	a0,0x0
 9dc:	62853503          	ld	a0,1576(a0) # 1000 <freep>
 9e0:	c515                	beqz	a0,a0c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e4:	4798                	lw	a4,8(a5)
 9e6:	02977f63          	bgeu	a4,s1,a24 <malloc+0x70>
  if(nu < 4096)
 9ea:	8a4e                	mv	s4,s3
 9ec:	0009871b          	sext.w	a4,s3
 9f0:	6685                	lui	a3,0x1
 9f2:	00d77363          	bgeu	a4,a3,9f8 <malloc+0x44>
 9f6:	6a05                	lui	s4,0x1
 9f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a00:	00000917          	auipc	s2,0x0
 a04:	60090913          	addi	s2,s2,1536 # 1000 <freep>
  if(p == (char*)-1)
 a08:	5afd                	li	s5,-1
 a0a:	a895                	j	a7e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a0c:	00000797          	auipc	a5,0x0
 a10:	61478793          	addi	a5,a5,1556 # 1020 <base>
 a14:	00000717          	auipc	a4,0x0
 a18:	5ef73623          	sd	a5,1516(a4) # 1000 <freep>
 a1c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a22:	b7e1                	j	9ea <malloc+0x36>
      if(p->s.size == nunits)
 a24:	02e48c63          	beq	s1,a4,a5c <malloc+0xa8>
        p->s.size -= nunits;
 a28:	4137073b          	subw	a4,a4,s3
 a2c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2e:	02071693          	slli	a3,a4,0x20
 a32:	01c6d713          	srli	a4,a3,0x1c
 a36:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a38:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3c:	00000717          	auipc	a4,0x0
 a40:	5ca73223          	sd	a0,1476(a4) # 1000 <freep>
      return (void*)(p + 1);
 a44:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a48:	70e2                	ld	ra,56(sp)
 a4a:	7442                	ld	s0,48(sp)
 a4c:	74a2                	ld	s1,40(sp)
 a4e:	7902                	ld	s2,32(sp)
 a50:	69e2                	ld	s3,24(sp)
 a52:	6a42                	ld	s4,16(sp)
 a54:	6aa2                	ld	s5,8(sp)
 a56:	6b02                	ld	s6,0(sp)
 a58:	6121                	addi	sp,sp,64
 a5a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a5c:	6398                	ld	a4,0(a5)
 a5e:	e118                	sd	a4,0(a0)
 a60:	bff1                	j	a3c <malloc+0x88>
  hp->s.size = nu;
 a62:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a66:	0541                	addi	a0,a0,16
 a68:	00000097          	auipc	ra,0x0
 a6c:	eca080e7          	jalr	-310(ra) # 932 <free>
  return freep;
 a70:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a74:	d971                	beqz	a0,a48 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a78:	4798                	lw	a4,8(a5)
 a7a:	fa9775e3          	bgeu	a4,s1,a24 <malloc+0x70>
    if(p == freep)
 a7e:	00093703          	ld	a4,0(s2)
 a82:	853e                	mv	a0,a5
 a84:	fef719e3          	bne	a4,a5,a76 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a88:	8552                	mv	a0,s4
 a8a:	00000097          	auipc	ra,0x0
 a8e:	b92080e7          	jalr	-1134(ra) # 61c <sbrk>
  if(p == (char*)-1)
 a92:	fd5518e3          	bne	a0,s5,a62 <malloc+0xae>
        return 0;
 a96:	4501                	li	a0,0
 a98:	bf45                	j	a48 <malloc+0x94>
