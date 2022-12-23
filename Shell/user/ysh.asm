
user/_ysh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readcmd>:
#define max_args    16      // Max number of arguments

int runcmd(char *cmd);      // Run a command.

// Read a shell input.
char* readcmd(char *buf) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    // Read an input from stdin.
    fprintf(1, "$ ");
   c:	00001597          	auipc	a1,0x1
  10:	b5458593          	addi	a1,a1,-1196 # b60 <malloc+0xf2>
  14:	4505                	li	a0,1
  16:	00001097          	auipc	ra,0x1
  1a:	972080e7          	jalr	-1678(ra) # 988 <fprintf>
    memset(buf, 0, buf_size);
  1e:	08000613          	li	a2,128
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	00000097          	auipc	ra,0x0
  2a:	42e080e7          	jalr	1070(ra) # 454 <memset>
    char *cmd = gets(buf, buf_size);
  2e:	08000593          	li	a1,128
  32:	8526                	mv	a0,s1
  34:	00000097          	auipc	ra,0x0
  38:	466080e7          	jalr	1126(ra) # 49a <gets>
  3c:	84aa                	mv	s1,a0
  
    // Chop off the trailing '\n'.
    if(cmd) { cmd[strlen(cmd)-1] = 0; }
  3e:	c919                	beqz	a0,54 <readcmd+0x54>
  40:	00000097          	auipc	ra,0x0
  44:	3ea080e7          	jalr	1002(ra) # 42a <strlen>
  48:	357d                	addiw	a0,a0,-1
  4a:	1502                	slli	a0,a0,0x20
  4c:	9101                	srli	a0,a0,0x20
  4e:	9526                	add	a0,a0,s1
  50:	00050023          	sb	zero,0(a0)
  
    return cmd;
}
  54:	8526                	mv	a0,s1
  56:	60e2                	ld	ra,24(sp)
  58:	6442                	ld	s0,16(sp)
  5a:	64a2                	ld	s1,8(sp)
  5c:	6105                	addi	sp,sp,32
  5e:	8082                	ret

0000000000000060 <runcmd>:
}


// Run a command.
int runcmd(char *cmd) {
    if(!*cmd) { return 1; }                     // Empty command
  60:	00054783          	lbu	a5,0(a0)
  64:	2a078763          	beqz	a5,312 <runcmd+0x2b2>
int runcmd(char *cmd) {
  68:	7171                	addi	sp,sp,-176
  6a:	f506                	sd	ra,168(sp)
  6c:	f122                	sd	s0,160(sp)
  6e:	ed26                	sd	s1,152(sp)
  70:	e94a                	sd	s2,144(sp)
  72:	e54e                	sd	s3,136(sp)
  74:	1900                	addi	s0,sp,176
  76:	84aa                	mv	s1,a0

    // Skip leading white space(s).
    while(*cmd == ' ') { cmd++; }
  78:	02000713          	li	a4,32
  7c:	00e79763          	bne	a5,a4,8a <runcmd+0x2a>
  80:	0485                	addi	s1,s1,1
  82:	0004c783          	lbu	a5,0(s1)
  86:	fee78de3          	beq	a5,a4,80 <runcmd+0x20>
    // Remove trailing white space(s).
    for(char *c = cmd+strlen(cmd)-1; *c == ' '; c--) { *c = 0; }
  8a:	8526                	mv	a0,s1
  8c:	00000097          	auipc	ra,0x0
  90:	39e080e7          	jalr	926(ra) # 42a <strlen>
  94:	02051793          	slli	a5,a0,0x20
  98:	9381                	srli	a5,a5,0x20
  9a:	17fd                	addi	a5,a5,-1
  9c:	97a6                	add	a5,a5,s1
  9e:	0007c683          	lbu	a3,0(a5)
  a2:	02000713          	li	a4,32
  a6:	00e69b63          	bne	a3,a4,bc <runcmd+0x5c>
  aa:	02000693          	li	a3,32
  ae:	00078023          	sb	zero,0(a5)
  b2:	17fd                	addi	a5,a5,-1
  b4:	0007c703          	lbu	a4,0(a5)
  b8:	fed70be3          	beq	a4,a3,ae <runcmd+0x4e>

    if(!strcmp(cmd, "exit")) { return 0; }      // exit command
  bc:	00001597          	auipc	a1,0x1
  c0:	aac58593          	addi	a1,a1,-1364 # b68 <malloc+0xfa>
  c4:	8526                	mv	a0,s1
  c6:	00000097          	auipc	ra,0x0
  ca:	2fc080e7          	jalr	764(ra) # 3c2 <strcmp>
  ce:	e901                	bnez	a0,de <runcmd+0x7e>
            }
            wait(0);
        }
    }
    return 1;
}
  d0:	70aa                	ld	ra,168(sp)
  d2:	740a                	ld	s0,160(sp)
  d4:	64ea                	ld	s1,152(sp)
  d6:	694a                	ld	s2,144(sp)
  d8:	69aa                	ld	s3,136(sp)
  da:	614d                	addi	sp,sp,176
  dc:	8082                	ret
    else if(!strncmp(cmd, "cd ", 3)) {          // cd command
  de:	460d                	li	a2,3
  e0:	00001597          	auipc	a1,0x1
  e4:	a9058593          	addi	a1,a1,-1392 # b70 <malloc+0x102>
  e8:	8526                	mv	a0,s1
  ea:	00000097          	auipc	ra,0x0
  ee:	304080e7          	jalr	772(ra) # 3ee <strncmp>
  f2:	e51d                	bnez	a0,120 <runcmd+0xc0>
        if(chdir(cmd+3) < 0) { fprintf(2, "Cannot cd %s\n", cmd+3); }
  f4:	048d                	addi	s1,s1,3
  f6:	8526                	mv	a0,s1
  f8:	00000097          	auipc	ra,0x0
  fc:	5c6080e7          	jalr	1478(ra) # 6be <chdir>
 100:	87aa                	mv	a5,a0
    return 1;
 102:	4505                	li	a0,1
        if(chdir(cmd+3) < 0) { fprintf(2, "Cannot cd %s\n", cmd+3); }
 104:	fc07d6e3          	bgez	a5,d0 <runcmd+0x70>
 108:	8626                	mv	a2,s1
 10a:	00001597          	auipc	a1,0x1
 10e:	a6e58593          	addi	a1,a1,-1426 # b78 <malloc+0x10a>
 112:	4509                	li	a0,2
 114:	00001097          	auipc	ra,0x1
 118:	874080e7          	jalr	-1932(ra) # 988 <fprintf>
    return 1;
 11c:	4505                	li	a0,1
 11e:	bf4d                	j	d0 <runcmd+0x70>
        char* s = strchr(cmd, ';');
 120:	03b00593          	li	a1,59
 124:	8526                	mv	a0,s1
 126:	00000097          	auipc	ra,0x0
 12a:	350080e7          	jalr	848(ra) # 476 <strchr>
 12e:	892a                	mv	s2,a0
        char* p = strchr(cmd, '|');
 130:	07c00593          	li	a1,124
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	340080e7          	jalr	832(ra) # 476 <strchr>
 13e:	89aa                	mv	s3,a0
        if (cmd[strlen(cmd) - 1] == '&') {
 140:	8526                	mv	a0,s1
 142:	00000097          	auipc	ra,0x0
 146:	2e8080e7          	jalr	744(ra) # 42a <strlen>
 14a:	fff5079b          	addiw	a5,a0,-1
 14e:	1782                	slli	a5,a5,0x20
 150:	9381                	srli	a5,a5,0x20
 152:	97a6                	add	a5,a5,s1
 154:	0007c703          	lbu	a4,0(a5)
 158:	02600793          	li	a5,38
 15c:	02f70863          	beq	a4,a5,18c <runcmd+0x12c>
        else if (s) {
 160:	06090a63          	beqz	s2,1d4 <runcmd+0x174>
            *s = 0;
 164:	00090023          	sb	zero,0(s2)
            if (fork() == 0) {
 168:	00000097          	auipc	ra,0x0
 16c:	4de080e7          	jalr	1246(ra) # 646 <fork>
 170:	c921                	beqz	a0,1c0 <runcmd+0x160>
            wait(0);
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	4e2080e7          	jalr	1250(ra) # 656 <wait>
            runcmd(s + 1);
 17c:	00190513          	addi	a0,s2,1
 180:	00000097          	auipc	ra,0x0
 184:	ee0080e7          	jalr	-288(ra) # 60 <runcmd>
    return 1;
 188:	4505                	li	a0,1
 18a:	b799                	j	d0 <runcmd+0x70>
            cmd[strlen(cmd) - 1] = 0;
 18c:	8526                	mv	a0,s1
 18e:	00000097          	auipc	ra,0x0
 192:	29c080e7          	jalr	668(ra) # 42a <strlen>
 196:	fff5079b          	addiw	a5,a0,-1
 19a:	1782                	slli	a5,a5,0x20
 19c:	9381                	srli	a5,a5,0x20
 19e:	97a6                	add	a5,a5,s1
 1a0:	00078023          	sb	zero,0(a5)
            if (fork() == 0) {
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4a2080e7          	jalr	1186(ra) # 646 <fork>
 1ac:	87aa                	mv	a5,a0
    return 1;
 1ae:	4505                	li	a0,1
            if (fork() == 0) {
 1b0:	f385                	bnez	a5,d0 <runcmd+0x70>
                runcmd(cmd);
 1b2:	8526                	mv	a0,s1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	eac080e7          	jalr	-340(ra) # 60 <runcmd>
    return 1;
 1bc:	4505                	li	a0,1
 1be:	bf09                	j	d0 <runcmd+0x70>
                runcmd(cmd);
 1c0:	8526                	mv	a0,s1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	e9e080e7          	jalr	-354(ra) # 60 <runcmd>
                exit(0);
 1ca:	4501                	li	a0,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	482080e7          	jalr	1154(ra) # 64e <exit>
        else if (p) {
 1d4:	0a098e63          	beqz	s3,290 <runcmd+0x230>
            *p = 0;
 1d8:	00098023          	sb	zero,0(s3)
            if (fork() == 0) {  // child
 1dc:	00000097          	auipc	ra,0x0
 1e0:	46a080e7          	jalr	1130(ra) # 646 <fork>
 1e4:	ed59                	bnez	a0,282 <runcmd+0x222>
                pipe(fd);
 1e6:	f5040513          	addi	a0,s0,-176
 1ea:	00000097          	auipc	ra,0x0
 1ee:	474080e7          	jalr	1140(ra) # 65e <pipe>
                if (fork() == 0) {     // grandchild
 1f2:	00000097          	auipc	ra,0x0
 1f6:	454080e7          	jalr	1108(ra) # 646 <fork>
 1fa:	e131                	bnez	a0,23e <runcmd+0x1de>
                    close(1);
 1fc:	4505                	li	a0,1
 1fe:	00000097          	auipc	ra,0x0
 202:	478080e7          	jalr	1144(ra) # 676 <close>
                    dup(fd[1]);
 206:	f5442503          	lw	a0,-172(s0)
 20a:	00000097          	auipc	ra,0x0
 20e:	4bc080e7          	jalr	1212(ra) # 6c6 <dup>
                    close(fd[0]);
 212:	f5042503          	lw	a0,-176(s0)
 216:	00000097          	auipc	ra,0x0
 21a:	460080e7          	jalr	1120(ra) # 676 <close>
                    close(fd[1]);
 21e:	f5442503          	lw	a0,-172(s0)
 222:	00000097          	auipc	ra,0x0
 226:	454080e7          	jalr	1108(ra) # 676 <close>
                    runcmd(cmd);        // left
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	e34080e7          	jalr	-460(ra) # 60 <runcmd>
                    exit(0);
 234:	4501                	li	a0,0
 236:	00000097          	auipc	ra,0x0
 23a:	418080e7          	jalr	1048(ra) # 64e <exit>
                    close(0);
 23e:	4501                	li	a0,0
 240:	00000097          	auipc	ra,0x0
 244:	436080e7          	jalr	1078(ra) # 676 <close>
                    dup(fd[0]);
 248:	f5042503          	lw	a0,-176(s0)
 24c:	00000097          	auipc	ra,0x0
 250:	47a080e7          	jalr	1146(ra) # 6c6 <dup>
                    close(fd[0]);
 254:	f5042503          	lw	a0,-176(s0)
 258:	00000097          	auipc	ra,0x0
 25c:	41e080e7          	jalr	1054(ra) # 676 <close>
                    close(fd[1]);
 260:	f5442503          	lw	a0,-172(s0)
 264:	00000097          	auipc	ra,0x0
 268:	412080e7          	jalr	1042(ra) # 676 <close>
                    runcmd(p + 1);      // right
 26c:	00198513          	addi	a0,s3,1
 270:	00000097          	auipc	ra,0x0
 274:	df0080e7          	jalr	-528(ra) # 60 <runcmd>
                    exit(0);
 278:	4501                	li	a0,0
 27a:	00000097          	auipc	ra,0x0
 27e:	3d4080e7          	jalr	980(ra) # 64e <exit>
            wait(0);    // make the parent process wait for the child.
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	3d2080e7          	jalr	978(ra) # 656 <wait>
    return 1;
 28c:	4505                	li	a0,1
 28e:	b589                	j	d0 <runcmd+0x70>
            char* pp = strchr(cmd, ' ');
 290:	02000593          	li	a1,32
 294:	8526                	mv	a0,s1
 296:	00000097          	auipc	ra,0x0
 29a:	1e0080e7          	jalr	480(ra) # 476 <strchr>
            while (pp) {
 29e:	cd39                	beqz	a0,2fc <runcmd+0x29c>
 2a0:	f5040993          	addi	s3,s0,-176
            int count = 0;
 2a4:	4901                	li	s2,0
                *pp = 0;
 2a6:	00050023          	sb	zero,0(a0)
                argv[count++] = cmd; 
 2aa:	2905                	addiw	s2,s2,1
 2ac:	0099b023          	sd	s1,0(s3)
                cmd = pp + 1;
 2b0:	00150493          	addi	s1,a0,1
                pp = strchr(cmd, ' ');
 2b4:	02000593          	li	a1,32
 2b8:	8526                	mv	a0,s1
 2ba:	00000097          	auipc	ra,0x0
 2be:	1bc080e7          	jalr	444(ra) # 476 <strchr>
            while (pp) {
 2c2:	09a1                	addi	s3,s3,8
 2c4:	f16d                	bnez	a0,2a6 <runcmd+0x246>
            argv[count++] = cmd;
 2c6:	00391793          	slli	a5,s2,0x3
 2ca:	fd078793          	addi	a5,a5,-48
 2ce:	97a2                	add	a5,a5,s0
 2d0:	f897b023          	sd	s1,-128(a5)
            argv[count] = 0;
 2d4:	0019079b          	addiw	a5,s2,1
 2d8:	078e                	slli	a5,a5,0x3
 2da:	fd078793          	addi	a5,a5,-48
 2de:	97a2                	add	a5,a5,s0
 2e0:	f807b023          	sd	zero,-128(a5)
            if (fork() == 0) {
 2e4:	00000097          	auipc	ra,0x0
 2e8:	362080e7          	jalr	866(ra) # 646 <fork>
 2ec:	c911                	beqz	a0,300 <runcmd+0x2a0>
            wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	366080e7          	jalr	870(ra) # 656 <wait>
    return 1;
 2f8:	4505                	li	a0,1
 2fa:	bbd9                	j	d0 <runcmd+0x70>
            int count = 0;
 2fc:	4901                	li	s2,0
 2fe:	b7e1                	j	2c6 <runcmd+0x266>
                exec(argv[0], argv);
 300:	f5040593          	addi	a1,s0,-176
 304:	f5043503          	ld	a0,-176(s0)
 308:	00000097          	auipc	ra,0x0
 30c:	37e080e7          	jalr	894(ra) # 686 <exec>
 310:	bff9                	j	2ee <runcmd+0x28e>
    if(!*cmd) { return 1; }                     // Empty command
 312:	4505                	li	a0,1
}
 314:	8082                	ret

0000000000000316 <main>:
int main(int argc, char **argv) {
 316:	7135                	addi	sp,sp,-160
 318:	ed06                	sd	ra,152(sp)
 31a:	e922                	sd	s0,144(sp)
 31c:	e526                	sd	s1,136(sp)
 31e:	1100                	addi	s0,sp,160
    while((fd = open("console", O_RDWR)) >= 0) {
 320:	00001497          	auipc	s1,0x1
 324:	86848493          	addi	s1,s1,-1944 # b88 <malloc+0x11a>
 328:	4589                	li	a1,2
 32a:	8526                	mv	a0,s1
 32c:	00000097          	auipc	ra,0x0
 330:	362080e7          	jalr	866(ra) # 68e <open>
 334:	00054963          	bltz	a0,346 <main+0x30>
        if(fd >= 3) { close(fd); break; }
 338:	4789                	li	a5,2
 33a:	fea7d7e3          	bge	a5,a0,328 <main+0x12>
 33e:	00000097          	auipc	ra,0x0
 342:	338080e7          	jalr	824(ra) # 676 <close>
    fprintf(1, "EEE3535 Operating Systems: starting ysh\n");
 346:	00001597          	auipc	a1,0x1
 34a:	84a58593          	addi	a1,a1,-1974 # b90 <malloc+0x122>
 34e:	4505                	li	a0,1
 350:	00000097          	auipc	ra,0x0
 354:	638080e7          	jalr	1592(ra) # 988 <fprintf>
    while((cmd = readcmd(buf)) && runcmd(cmd)) ;
 358:	f6040513          	addi	a0,s0,-160
 35c:	00000097          	auipc	ra,0x0
 360:	ca4080e7          	jalr	-860(ra) # 0 <readcmd>
 364:	c511                	beqz	a0,370 <main+0x5a>
 366:	00000097          	auipc	ra,0x0
 36a:	cfa080e7          	jalr	-774(ra) # 60 <runcmd>
 36e:	f56d                	bnez	a0,358 <main+0x42>
    fprintf(1, "EEE3535 Operating Systems: closing ysh\n");
 370:	00001597          	auipc	a1,0x1
 374:	85058593          	addi	a1,a1,-1968 # bc0 <malloc+0x152>
 378:	4505                	li	a0,1
 37a:	00000097          	auipc	ra,0x0
 37e:	60e080e7          	jalr	1550(ra) # 988 <fprintf>
    exit(0);
 382:	4501                	li	a0,0
 384:	00000097          	auipc	ra,0x0
 388:	2ca080e7          	jalr	714(ra) # 64e <exit>

000000000000038c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  extern int main();
  main();
 394:	00000097          	auipc	ra,0x0
 398:	f82080e7          	jalr	-126(ra) # 316 <main>
  exit(0);
 39c:	4501                	li	a0,0
 39e:	00000097          	auipc	ra,0x0
 3a2:	2b0080e7          	jalr	688(ra) # 64e <exit>

00000000000003a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ac:	87aa                	mv	a5,a0
 3ae:	0585                	addi	a1,a1,1
 3b0:	0785                	addi	a5,a5,1
 3b2:	fff5c703          	lbu	a4,-1(a1)
 3b6:	fee78fa3          	sb	a4,-1(a5)
 3ba:	fb75                	bnez	a4,3ae <strcpy+0x8>
    ;
  return os;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3c8:	00054783          	lbu	a5,0(a0)
 3cc:	cb91                	beqz	a5,3e0 <strcmp+0x1e>
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00f71763          	bne	a4,a5,3e0 <strcmp+0x1e>
    p++, q++;
 3d6:	0505                	addi	a0,a0,1
 3d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	fbe5                	bnez	a5,3ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3e0:	0005c503          	lbu	a0,0(a1)
}
 3e4:	40a7853b          	subw	a0,a5,a0
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 3f4:	ce11                	beqz	a2,410 <strncmp+0x22>
 3f6:	00054783          	lbu	a5,0(a0)
 3fa:	cf89                	beqz	a5,414 <strncmp+0x26>
 3fc:	0005c703          	lbu	a4,0(a1)
 400:	00f71a63          	bne	a4,a5,414 <strncmp+0x26>
    n--, p++, q++;
 404:	367d                	addiw	a2,a2,-1
 406:	0505                	addi	a0,a0,1
 408:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 40a:	f675                	bnez	a2,3f6 <strncmp+0x8>
  if(n == 0)
    return 0;
 40c:	4501                	li	a0,0
 40e:	a809                	j	420 <strncmp+0x32>
 410:	4501                	li	a0,0
 412:	a039                	j	420 <strncmp+0x32>
  if(n == 0)
 414:	ca09                	beqz	a2,426 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
 416:	00054503          	lbu	a0,0(a0)
 41a:	0005c783          	lbu	a5,0(a1)
 41e:	9d1d                	subw	a0,a0,a5
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
    return 0;
 426:	4501                	li	a0,0
 428:	bfe5                	j	420 <strncmp+0x32>

000000000000042a <strlen>:

uint
strlen(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 430:	00054783          	lbu	a5,0(a0)
 434:	cf91                	beqz	a5,450 <strlen+0x26>
 436:	0505                	addi	a0,a0,1
 438:	87aa                	mv	a5,a0
 43a:	86be                	mv	a3,a5
 43c:	0785                	addi	a5,a5,1
 43e:	fff7c703          	lbu	a4,-1(a5)
 442:	ff65                	bnez	a4,43a <strlen+0x10>
 444:	40a6853b          	subw	a0,a3,a0
 448:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret
  for(n = 0; s[n]; n++)
 450:	4501                	li	a0,0
 452:	bfe5                	j	44a <strlen+0x20>

0000000000000454 <memset>:

void*
memset(void *dst, int c, uint n)
{
 454:	1141                	addi	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45a:	ca19                	beqz	a2,470 <memset+0x1c>
 45c:	87aa                	mv	a5,a0
 45e:	1602                	slli	a2,a2,0x20
 460:	9201                	srli	a2,a2,0x20
 462:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 466:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 46a:	0785                	addi	a5,a5,1
 46c:	fee79de3          	bne	a5,a4,466 <memset+0x12>
  }
  return dst;
}
 470:	6422                	ld	s0,8(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <strchr>:

char*
strchr(const char *s, char c)
{
 476:	1141                	addi	sp,sp,-16
 478:	e422                	sd	s0,8(sp)
 47a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 47c:	00054783          	lbu	a5,0(a0)
 480:	cb99                	beqz	a5,496 <strchr+0x20>
    if(*s == c)
 482:	00f58763          	beq	a1,a5,490 <strchr+0x1a>
  for(; *s; s++)
 486:	0505                	addi	a0,a0,1
 488:	00054783          	lbu	a5,0(a0)
 48c:	fbfd                	bnez	a5,482 <strchr+0xc>
      return (char*)s;
  return 0;
 48e:	4501                	li	a0,0
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret
  return 0;
 496:	4501                	li	a0,0
 498:	bfe5                	j	490 <strchr+0x1a>

000000000000049a <gets>:

char*
gets(char *buf, int max)
{
 49a:	711d                	addi	sp,sp,-96
 49c:	ec86                	sd	ra,88(sp)
 49e:	e8a2                	sd	s0,80(sp)
 4a0:	e4a6                	sd	s1,72(sp)
 4a2:	e0ca                	sd	s2,64(sp)
 4a4:	fc4e                	sd	s3,56(sp)
 4a6:	f852                	sd	s4,48(sp)
 4a8:	f456                	sd	s5,40(sp)
 4aa:	f05a                	sd	s6,32(sp)
 4ac:	ec5e                	sd	s7,24(sp)
 4ae:	1080                	addi	s0,sp,96
 4b0:	8baa                	mv	s7,a0
 4b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b4:	892a                	mv	s2,a0
 4b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4b8:	4aa9                	li	s5,10
 4ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4bc:	89a6                	mv	s3,s1
 4be:	2485                	addiw	s1,s1,1
 4c0:	0344d863          	bge	s1,s4,4f0 <gets+0x56>
    cc = read(0, &c, 1);
 4c4:	4605                	li	a2,1
 4c6:	faf40593          	addi	a1,s0,-81
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	19a080e7          	jalr	410(ra) # 666 <read>
    if(cc < 1)
 4d4:	00a05e63          	blez	a0,4f0 <gets+0x56>
    buf[i++] = c;
 4d8:	faf44783          	lbu	a5,-81(s0)
 4dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e0:	01578763          	beq	a5,s5,4ee <gets+0x54>
 4e4:	0905                	addi	s2,s2,1
 4e6:	fd679be3          	bne	a5,s6,4bc <gets+0x22>
  for(i=0; i+1 < max; ){
 4ea:	89a6                	mv	s3,s1
 4ec:	a011                	j	4f0 <gets+0x56>
 4ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4f0:	99de                	add	s3,s3,s7
 4f2:	00098023          	sb	zero,0(s3)
  return buf;
}
 4f6:	855e                	mv	a0,s7
 4f8:	60e6                	ld	ra,88(sp)
 4fa:	6446                	ld	s0,80(sp)
 4fc:	64a6                	ld	s1,72(sp)
 4fe:	6906                	ld	s2,64(sp)
 500:	79e2                	ld	s3,56(sp)
 502:	7a42                	ld	s4,48(sp)
 504:	7aa2                	ld	s5,40(sp)
 506:	7b02                	ld	s6,32(sp)
 508:	6be2                	ld	s7,24(sp)
 50a:	6125                	addi	sp,sp,96
 50c:	8082                	ret

000000000000050e <stat>:

int
stat(const char *n, struct stat *st)
{
 50e:	1101                	addi	sp,sp,-32
 510:	ec06                	sd	ra,24(sp)
 512:	e822                	sd	s0,16(sp)
 514:	e426                	sd	s1,8(sp)
 516:	e04a                	sd	s2,0(sp)
 518:	1000                	addi	s0,sp,32
 51a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 51c:	4581                	li	a1,0
 51e:	00000097          	auipc	ra,0x0
 522:	170080e7          	jalr	368(ra) # 68e <open>
  if(fd < 0)
 526:	02054563          	bltz	a0,550 <stat+0x42>
 52a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 52c:	85ca                	mv	a1,s2
 52e:	00000097          	auipc	ra,0x0
 532:	178080e7          	jalr	376(ra) # 6a6 <fstat>
 536:	892a                	mv	s2,a0
  close(fd);
 538:	8526                	mv	a0,s1
 53a:	00000097          	auipc	ra,0x0
 53e:	13c080e7          	jalr	316(ra) # 676 <close>
  return r;
}
 542:	854a                	mv	a0,s2
 544:	60e2                	ld	ra,24(sp)
 546:	6442                	ld	s0,16(sp)
 548:	64a2                	ld	s1,8(sp)
 54a:	6902                	ld	s2,0(sp)
 54c:	6105                	addi	sp,sp,32
 54e:	8082                	ret
    return -1;
 550:	597d                	li	s2,-1
 552:	bfc5                	j	542 <stat+0x34>

0000000000000554 <atoi>:

int
atoi(const char *s)
{
 554:	1141                	addi	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 55a:	00054683          	lbu	a3,0(a0)
 55e:	fd06879b          	addiw	a5,a3,-48
 562:	0ff7f793          	zext.b	a5,a5
 566:	4625                	li	a2,9
 568:	02f66863          	bltu	a2,a5,598 <atoi+0x44>
 56c:	872a                	mv	a4,a0
  n = 0;
 56e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 570:	0705                	addi	a4,a4,1
 572:	0025179b          	slliw	a5,a0,0x2
 576:	9fa9                	addw	a5,a5,a0
 578:	0017979b          	slliw	a5,a5,0x1
 57c:	9fb5                	addw	a5,a5,a3
 57e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 582:	00074683          	lbu	a3,0(a4)
 586:	fd06879b          	addiw	a5,a3,-48
 58a:	0ff7f793          	zext.b	a5,a5
 58e:	fef671e3          	bgeu	a2,a5,570 <atoi+0x1c>
  return n;
}
 592:	6422                	ld	s0,8(sp)
 594:	0141                	addi	sp,sp,16
 596:	8082                	ret
  n = 0;
 598:	4501                	li	a0,0
 59a:	bfe5                	j	592 <atoi+0x3e>

000000000000059c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 59c:	1141                	addi	sp,sp,-16
 59e:	e422                	sd	s0,8(sp)
 5a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5a2:	02b57463          	bgeu	a0,a1,5ca <memmove+0x2e>
    while(n-- > 0)
 5a6:	00c05f63          	blez	a2,5c4 <memmove+0x28>
 5aa:	1602                	slli	a2,a2,0x20
 5ac:	9201                	srli	a2,a2,0x20
 5ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5b4:	0585                	addi	a1,a1,1
 5b6:	0705                	addi	a4,a4,1
 5b8:	fff5c683          	lbu	a3,-1(a1)
 5bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c0:	fee79ae3          	bne	a5,a4,5b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5c4:	6422                	ld	s0,8(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret
    dst += n;
 5ca:	00c50733          	add	a4,a0,a2
    src += n;
 5ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d0:	fec05ae3          	blez	a2,5c4 <memmove+0x28>
 5d4:	fff6079b          	addiw	a5,a2,-1
 5d8:	1782                	slli	a5,a5,0x20
 5da:	9381                	srli	a5,a5,0x20
 5dc:	fff7c793          	not	a5,a5
 5e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e2:	15fd                	addi	a1,a1,-1
 5e4:	177d                	addi	a4,a4,-1
 5e6:	0005c683          	lbu	a3,0(a1)
 5ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ee:	fee79ae3          	bne	a5,a4,5e2 <memmove+0x46>
 5f2:	bfc9                	j	5c4 <memmove+0x28>

00000000000005f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f4:	1141                	addi	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5fa:	ca05                	beqz	a2,62a <memcmp+0x36>
 5fc:	fff6069b          	addiw	a3,a2,-1
 600:	1682                	slli	a3,a3,0x20
 602:	9281                	srli	a3,a3,0x20
 604:	0685                	addi	a3,a3,1
 606:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 608:	00054783          	lbu	a5,0(a0)
 60c:	0005c703          	lbu	a4,0(a1)
 610:	00e79863          	bne	a5,a4,620 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 614:	0505                	addi	a0,a0,1
    p2++;
 616:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 618:	fed518e3          	bne	a0,a3,608 <memcmp+0x14>
  }
  return 0;
 61c:	4501                	li	a0,0
 61e:	a019                	j	624 <memcmp+0x30>
      return *p1 - *p2;
 620:	40e7853b          	subw	a0,a5,a4
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret
  return 0;
 62a:	4501                	li	a0,0
 62c:	bfe5                	j	624 <memcmp+0x30>

000000000000062e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e406                	sd	ra,8(sp)
 632:	e022                	sd	s0,0(sp)
 634:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 636:	00000097          	auipc	ra,0x0
 63a:	f66080e7          	jalr	-154(ra) # 59c <memmove>
}
 63e:	60a2                	ld	ra,8(sp)
 640:	6402                	ld	s0,0(sp)
 642:	0141                	addi	sp,sp,16
 644:	8082                	ret

0000000000000646 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 646:	4885                	li	a7,1
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <exit>:
.global exit
exit:
 li a7, SYS_exit
 64e:	4889                	li	a7,2
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <wait>:
.global wait
wait:
 li a7, SYS_wait
 656:	488d                	li	a7,3
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 65e:	4891                	li	a7,4
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <read>:
.global read
read:
 li a7, SYS_read
 666:	4895                	li	a7,5
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <write>:
.global write
write:
 li a7, SYS_write
 66e:	48c1                	li	a7,16
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <close>:
.global close
close:
 li a7, SYS_close
 676:	48d5                	li	a7,21
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <kill>:
.global kill
kill:
 li a7, SYS_kill
 67e:	4899                	li	a7,6
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <exec>:
.global exec
exec:
 li a7, SYS_exec
 686:	489d                	li	a7,7
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <open>:
.global open
open:
 li a7, SYS_open
 68e:	48bd                	li	a7,15
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 696:	48c5                	li	a7,17
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 69e:	48c9                	li	a7,18
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a6:	48a1                	li	a7,8
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <link>:
.global link
link:
 li a7, SYS_link
 6ae:	48cd                	li	a7,19
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b6:	48d1                	li	a7,20
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6be:	48a5                	li	a7,9
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c6:	48a9                	li	a7,10
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ce:	48ad                	li	a7,11
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d6:	48b1                	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6de:	48b5                	li	a7,13
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e6:	48b9                	li	a7,14
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ee:	1101                	addi	sp,sp,-32
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6fa:	4605                	li	a2,1
 6fc:	fef40593          	addi	a1,s0,-17
 700:	00000097          	auipc	ra,0x0
 704:	f6e080e7          	jalr	-146(ra) # 66e <write>
}
 708:	60e2                	ld	ra,24(sp)
 70a:	6442                	ld	s0,16(sp)
 70c:	6105                	addi	sp,sp,32
 70e:	8082                	ret

0000000000000710 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 710:	7139                	addi	sp,sp,-64
 712:	fc06                	sd	ra,56(sp)
 714:	f822                	sd	s0,48(sp)
 716:	f426                	sd	s1,40(sp)
 718:	f04a                	sd	s2,32(sp)
 71a:	ec4e                	sd	s3,24(sp)
 71c:	0080                	addi	s0,sp,64
 71e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 720:	c299                	beqz	a3,726 <printint+0x16>
 722:	0805c963          	bltz	a1,7b4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 726:	2581                	sext.w	a1,a1
  neg = 0;
 728:	4881                	li	a7,0
 72a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 72e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 730:	2601                	sext.w	a2,a2
 732:	00000517          	auipc	a0,0x0
 736:	51650513          	addi	a0,a0,1302 # c48 <digits>
 73a:	883a                	mv	a6,a4
 73c:	2705                	addiw	a4,a4,1
 73e:	02c5f7bb          	remuw	a5,a1,a2
 742:	1782                	slli	a5,a5,0x20
 744:	9381                	srli	a5,a5,0x20
 746:	97aa                	add	a5,a5,a0
 748:	0007c783          	lbu	a5,0(a5)
 74c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 750:	0005879b          	sext.w	a5,a1
 754:	02c5d5bb          	divuw	a1,a1,a2
 758:	0685                	addi	a3,a3,1
 75a:	fec7f0e3          	bgeu	a5,a2,73a <printint+0x2a>
  if(neg)
 75e:	00088c63          	beqz	a7,776 <printint+0x66>
    buf[i++] = '-';
 762:	fd070793          	addi	a5,a4,-48
 766:	00878733          	add	a4,a5,s0
 76a:	02d00793          	li	a5,45
 76e:	fef70823          	sb	a5,-16(a4)
 772:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 776:	02e05863          	blez	a4,7a6 <printint+0x96>
 77a:	fc040793          	addi	a5,s0,-64
 77e:	00e78933          	add	s2,a5,a4
 782:	fff78993          	addi	s3,a5,-1
 786:	99ba                	add	s3,s3,a4
 788:	377d                	addiw	a4,a4,-1
 78a:	1702                	slli	a4,a4,0x20
 78c:	9301                	srli	a4,a4,0x20
 78e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 792:	fff94583          	lbu	a1,-1(s2)
 796:	8526                	mv	a0,s1
 798:	00000097          	auipc	ra,0x0
 79c:	f56080e7          	jalr	-170(ra) # 6ee <putc>
  while(--i >= 0)
 7a0:	197d                	addi	s2,s2,-1
 7a2:	ff3918e3          	bne	s2,s3,792 <printint+0x82>
}
 7a6:	70e2                	ld	ra,56(sp)
 7a8:	7442                	ld	s0,48(sp)
 7aa:	74a2                	ld	s1,40(sp)
 7ac:	7902                	ld	s2,32(sp)
 7ae:	69e2                	ld	s3,24(sp)
 7b0:	6121                	addi	sp,sp,64
 7b2:	8082                	ret
    x = -xx;
 7b4:	40b005bb          	negw	a1,a1
    neg = 1;
 7b8:	4885                	li	a7,1
    x = -xx;
 7ba:	bf85                	j	72a <printint+0x1a>

00000000000007bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7bc:	715d                	addi	sp,sp,-80
 7be:	e486                	sd	ra,72(sp)
 7c0:	e0a2                	sd	s0,64(sp)
 7c2:	fc26                	sd	s1,56(sp)
 7c4:	f84a                	sd	s2,48(sp)
 7c6:	f44e                	sd	s3,40(sp)
 7c8:	f052                	sd	s4,32(sp)
 7ca:	ec56                	sd	s5,24(sp)
 7cc:	e85a                	sd	s6,16(sp)
 7ce:	e45e                	sd	s7,8(sp)
 7d0:	e062                	sd	s8,0(sp)
 7d2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d4:	0005c903          	lbu	s2,0(a1)
 7d8:	18090c63          	beqz	s2,970 <vprintf+0x1b4>
 7dc:	8aaa                	mv	s5,a0
 7de:	8bb2                	mv	s7,a2
 7e0:	00158493          	addi	s1,a1,1
  state = 0;
 7e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e6:	02500a13          	li	s4,37
 7ea:	4b55                	li	s6,21
 7ec:	a839                	j	80a <vprintf+0x4e>
        putc(fd, c);
 7ee:	85ca                	mv	a1,s2
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	efc080e7          	jalr	-260(ra) # 6ee <putc>
 7fa:	a019                	j	800 <vprintf+0x44>
    } else if(state == '%'){
 7fc:	01498d63          	beq	s3,s4,816 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 800:	0485                	addi	s1,s1,1
 802:	fff4c903          	lbu	s2,-1(s1)
 806:	16090563          	beqz	s2,970 <vprintf+0x1b4>
    if(state == 0){
 80a:	fe0999e3          	bnez	s3,7fc <vprintf+0x40>
      if(c == '%'){
 80e:	ff4910e3          	bne	s2,s4,7ee <vprintf+0x32>
        state = '%';
 812:	89d2                	mv	s3,s4
 814:	b7f5                	j	800 <vprintf+0x44>
      if(c == 'd'){
 816:	13490263          	beq	s2,s4,93a <vprintf+0x17e>
 81a:	f9d9079b          	addiw	a5,s2,-99
 81e:	0ff7f793          	zext.b	a5,a5
 822:	12fb6563          	bltu	s6,a5,94c <vprintf+0x190>
 826:	f9d9079b          	addiw	a5,s2,-99
 82a:	0ff7f713          	zext.b	a4,a5
 82e:	10eb6f63          	bltu	s6,a4,94c <vprintf+0x190>
 832:	00271793          	slli	a5,a4,0x2
 836:	00000717          	auipc	a4,0x0
 83a:	3ba70713          	addi	a4,a4,954 # bf0 <malloc+0x182>
 83e:	97ba                	add	a5,a5,a4
 840:	439c                	lw	a5,0(a5)
 842:	97ba                	add	a5,a5,a4
 844:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 846:	008b8913          	addi	s2,s7,8
 84a:	4685                	li	a3,1
 84c:	4629                	li	a2,10
 84e:	000ba583          	lw	a1,0(s7)
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	ebc080e7          	jalr	-324(ra) # 710 <printint>
 85c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 85e:	4981                	li	s3,0
 860:	b745                	j	800 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 862:	008b8913          	addi	s2,s7,8
 866:	4681                	li	a3,0
 868:	4629                	li	a2,10
 86a:	000ba583          	lw	a1,0(s7)
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	ea0080e7          	jalr	-352(ra) # 710 <printint>
 878:	8bca                	mv	s7,s2
      state = 0;
 87a:	4981                	li	s3,0
 87c:	b751                	j	800 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 87e:	008b8913          	addi	s2,s7,8
 882:	4681                	li	a3,0
 884:	4641                	li	a2,16
 886:	000ba583          	lw	a1,0(s7)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e84080e7          	jalr	-380(ra) # 710 <printint>
 894:	8bca                	mv	s7,s2
      state = 0;
 896:	4981                	li	s3,0
 898:	b7a5                	j	800 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 89a:	008b8c13          	addi	s8,s7,8
 89e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a2:	03000593          	li	a1,48
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	e46080e7          	jalr	-442(ra) # 6ee <putc>
  putc(fd, 'x');
 8b0:	07800593          	li	a1,120
 8b4:	8556                	mv	a0,s5
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e38080e7          	jalr	-456(ra) # 6ee <putc>
 8be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c0:	00000b97          	auipc	s7,0x0
 8c4:	388b8b93          	addi	s7,s7,904 # c48 <digits>
 8c8:	03c9d793          	srli	a5,s3,0x3c
 8cc:	97de                	add	a5,a5,s7
 8ce:	0007c583          	lbu	a1,0(a5)
 8d2:	8556                	mv	a0,s5
 8d4:	00000097          	auipc	ra,0x0
 8d8:	e1a080e7          	jalr	-486(ra) # 6ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8dc:	0992                	slli	s3,s3,0x4
 8de:	397d                	addiw	s2,s2,-1
 8e0:	fe0914e3          	bnez	s2,8c8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8e4:	8be2                	mv	s7,s8
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bf21                	j	800 <vprintf+0x44>
        s = va_arg(ap, char*);
 8ea:	008b8993          	addi	s3,s7,8
 8ee:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8f2:	02090163          	beqz	s2,914 <vprintf+0x158>
        while(*s != 0){
 8f6:	00094583          	lbu	a1,0(s2)
 8fa:	c9a5                	beqz	a1,96a <vprintf+0x1ae>
          putc(fd, *s);
 8fc:	8556                	mv	a0,s5
 8fe:	00000097          	auipc	ra,0x0
 902:	df0080e7          	jalr	-528(ra) # 6ee <putc>
          s++;
 906:	0905                	addi	s2,s2,1
        while(*s != 0){
 908:	00094583          	lbu	a1,0(s2)
 90c:	f9e5                	bnez	a1,8fc <vprintf+0x140>
        s = va_arg(ap, char*);
 90e:	8bce                	mv	s7,s3
      state = 0;
 910:	4981                	li	s3,0
 912:	b5fd                	j	800 <vprintf+0x44>
          s = "(null)";
 914:	00000917          	auipc	s2,0x0
 918:	2d490913          	addi	s2,s2,724 # be8 <malloc+0x17a>
        while(*s != 0){
 91c:	02800593          	li	a1,40
 920:	bff1                	j	8fc <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 922:	008b8913          	addi	s2,s7,8
 926:	000bc583          	lbu	a1,0(s7)
 92a:	8556                	mv	a0,s5
 92c:	00000097          	auipc	ra,0x0
 930:	dc2080e7          	jalr	-574(ra) # 6ee <putc>
 934:	8bca                	mv	s7,s2
      state = 0;
 936:	4981                	li	s3,0
 938:	b5e1                	j	800 <vprintf+0x44>
        putc(fd, c);
 93a:	02500593          	li	a1,37
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	dae080e7          	jalr	-594(ra) # 6ee <putc>
      state = 0;
 948:	4981                	li	s3,0
 94a:	bd5d                	j	800 <vprintf+0x44>
        putc(fd, '%');
 94c:	02500593          	li	a1,37
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	d9c080e7          	jalr	-612(ra) # 6ee <putc>
        putc(fd, c);
 95a:	85ca                	mv	a1,s2
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	d90080e7          	jalr	-624(ra) # 6ee <putc>
      state = 0;
 966:	4981                	li	s3,0
 968:	bd61                	j	800 <vprintf+0x44>
        s = va_arg(ap, char*);
 96a:	8bce                	mv	s7,s3
      state = 0;
 96c:	4981                	li	s3,0
 96e:	bd49                	j	800 <vprintf+0x44>
    }
  }
}
 970:	60a6                	ld	ra,72(sp)
 972:	6406                	ld	s0,64(sp)
 974:	74e2                	ld	s1,56(sp)
 976:	7942                	ld	s2,48(sp)
 978:	79a2                	ld	s3,40(sp)
 97a:	7a02                	ld	s4,32(sp)
 97c:	6ae2                	ld	s5,24(sp)
 97e:	6b42                	ld	s6,16(sp)
 980:	6ba2                	ld	s7,8(sp)
 982:	6c02                	ld	s8,0(sp)
 984:	6161                	addi	sp,sp,80
 986:	8082                	ret

0000000000000988 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 988:	715d                	addi	sp,sp,-80
 98a:	ec06                	sd	ra,24(sp)
 98c:	e822                	sd	s0,16(sp)
 98e:	1000                	addi	s0,sp,32
 990:	e010                	sd	a2,0(s0)
 992:	e414                	sd	a3,8(s0)
 994:	e818                	sd	a4,16(s0)
 996:	ec1c                	sd	a5,24(s0)
 998:	03043023          	sd	a6,32(s0)
 99c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9a4:	8622                	mv	a2,s0
 9a6:	00000097          	auipc	ra,0x0
 9aa:	e16080e7          	jalr	-490(ra) # 7bc <vprintf>
}
 9ae:	60e2                	ld	ra,24(sp)
 9b0:	6442                	ld	s0,16(sp)
 9b2:	6161                	addi	sp,sp,80
 9b4:	8082                	ret

00000000000009b6 <printf>:

void
printf(const char *fmt, ...)
{
 9b6:	711d                	addi	sp,sp,-96
 9b8:	ec06                	sd	ra,24(sp)
 9ba:	e822                	sd	s0,16(sp)
 9bc:	1000                	addi	s0,sp,32
 9be:	e40c                	sd	a1,8(s0)
 9c0:	e810                	sd	a2,16(s0)
 9c2:	ec14                	sd	a3,24(s0)
 9c4:	f018                	sd	a4,32(s0)
 9c6:	f41c                	sd	a5,40(s0)
 9c8:	03043823          	sd	a6,48(s0)
 9cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d0:	00840613          	addi	a2,s0,8
 9d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9d8:	85aa                	mv	a1,a0
 9da:	4505                	li	a0,1
 9dc:	00000097          	auipc	ra,0x0
 9e0:	de0080e7          	jalr	-544(ra) # 7bc <vprintf>
}
 9e4:	60e2                	ld	ra,24(sp)
 9e6:	6442                	ld	s0,16(sp)
 9e8:	6125                	addi	sp,sp,96
 9ea:	8082                	ret

00000000000009ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ec:	1141                	addi	sp,sp,-16
 9ee:	e422                	sd	s0,8(sp)
 9f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f6:	00000797          	auipc	a5,0x0
 9fa:	60a7b783          	ld	a5,1546(a5) # 1000 <freep>
 9fe:	a02d                	j	a28 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a00:	4618                	lw	a4,8(a2)
 a02:	9f2d                	addw	a4,a4,a1
 a04:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a08:	6398                	ld	a4,0(a5)
 a0a:	6310                	ld	a2,0(a4)
 a0c:	a83d                	j	a4a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a0e:	ff852703          	lw	a4,-8(a0)
 a12:	9f31                	addw	a4,a4,a2
 a14:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a16:	ff053683          	ld	a3,-16(a0)
 a1a:	a091                	j	a5e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1c:	6398                	ld	a4,0(a5)
 a1e:	00e7e463          	bltu	a5,a4,a26 <free+0x3a>
 a22:	00e6ea63          	bltu	a3,a4,a36 <free+0x4a>
{
 a26:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a28:	fed7fae3          	bgeu	a5,a3,a1c <free+0x30>
 a2c:	6398                	ld	a4,0(a5)
 a2e:	00e6e463          	bltu	a3,a4,a36 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a32:	fee7eae3          	bltu	a5,a4,a26 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a36:	ff852583          	lw	a1,-8(a0)
 a3a:	6390                	ld	a2,0(a5)
 a3c:	02059813          	slli	a6,a1,0x20
 a40:	01c85713          	srli	a4,a6,0x1c
 a44:	9736                	add	a4,a4,a3
 a46:	fae60de3          	beq	a2,a4,a00 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a4a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a4e:	4790                	lw	a2,8(a5)
 a50:	02061593          	slli	a1,a2,0x20
 a54:	01c5d713          	srli	a4,a1,0x1c
 a58:	973e                	add	a4,a4,a5
 a5a:	fae68ae3          	beq	a3,a4,a0e <free+0x22>
    p->s.ptr = bp->s.ptr;
 a5e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a60:	00000717          	auipc	a4,0x0
 a64:	5af73023          	sd	a5,1440(a4) # 1000 <freep>
}
 a68:	6422                	ld	s0,8(sp)
 a6a:	0141                	addi	sp,sp,16
 a6c:	8082                	ret

0000000000000a6e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a6e:	7139                	addi	sp,sp,-64
 a70:	fc06                	sd	ra,56(sp)
 a72:	f822                	sd	s0,48(sp)
 a74:	f426                	sd	s1,40(sp)
 a76:	f04a                	sd	s2,32(sp)
 a78:	ec4e                	sd	s3,24(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
 a80:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	02051493          	slli	s1,a0,0x20
 a86:	9081                	srli	s1,s1,0x20
 a88:	04bd                	addi	s1,s1,15
 a8a:	8091                	srli	s1,s1,0x4
 a8c:	0014899b          	addiw	s3,s1,1
 a90:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a92:	00000517          	auipc	a0,0x0
 a96:	56e53503          	ld	a0,1390(a0) # 1000 <freep>
 a9a:	c515                	beqz	a0,ac6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9e:	4798                	lw	a4,8(a5)
 aa0:	02977f63          	bgeu	a4,s1,ade <malloc+0x70>
  if(nu < 4096)
 aa4:	8a4e                	mv	s4,s3
 aa6:	0009871b          	sext.w	a4,s3
 aaa:	6685                	lui	a3,0x1
 aac:	00d77363          	bgeu	a4,a3,ab2 <malloc+0x44>
 ab0:	6a05                	lui	s4,0x1
 ab2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ab6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aba:	00000917          	auipc	s2,0x0
 abe:	54690913          	addi	s2,s2,1350 # 1000 <freep>
  if(p == (char*)-1)
 ac2:	5afd                	li	s5,-1
 ac4:	a895                	j	b38 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 ac6:	00000797          	auipc	a5,0x0
 aca:	54a78793          	addi	a5,a5,1354 # 1010 <base>
 ace:	00000717          	auipc	a4,0x0
 ad2:	52f73923          	sd	a5,1330(a4) # 1000 <freep>
 ad6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 adc:	b7e1                	j	aa4 <malloc+0x36>
      if(p->s.size == nunits)
 ade:	02e48c63          	beq	s1,a4,b16 <malloc+0xa8>
        p->s.size -= nunits;
 ae2:	4137073b          	subw	a4,a4,s3
 ae6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae8:	02071693          	slli	a3,a4,0x20
 aec:	01c6d713          	srli	a4,a3,0x1c
 af0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af6:	00000717          	auipc	a4,0x0
 afa:	50a73523          	sd	a0,1290(a4) # 1000 <freep>
      return (void*)(p + 1);
 afe:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b02:	70e2                	ld	ra,56(sp)
 b04:	7442                	ld	s0,48(sp)
 b06:	74a2                	ld	s1,40(sp)
 b08:	7902                	ld	s2,32(sp)
 b0a:	69e2                	ld	s3,24(sp)
 b0c:	6a42                	ld	s4,16(sp)
 b0e:	6aa2                	ld	s5,8(sp)
 b10:	6b02                	ld	s6,0(sp)
 b12:	6121                	addi	sp,sp,64
 b14:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b16:	6398                	ld	a4,0(a5)
 b18:	e118                	sd	a4,0(a0)
 b1a:	bff1                	j	af6 <malloc+0x88>
  hp->s.size = nu;
 b1c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b20:	0541                	addi	a0,a0,16
 b22:	00000097          	auipc	ra,0x0
 b26:	eca080e7          	jalr	-310(ra) # 9ec <free>
  return freep;
 b2a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b2e:	d971                	beqz	a0,b02 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b30:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b32:	4798                	lw	a4,8(a5)
 b34:	fa9775e3          	bgeu	a4,s1,ade <malloc+0x70>
    if(p == freep)
 b38:	00093703          	ld	a4,0(s2)
 b3c:	853e                	mv	a0,a5
 b3e:	fef719e3          	bne	a4,a5,b30 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b42:	8552                	mv	a0,s4
 b44:	00000097          	auipc	ra,0x0
 b48:	b92080e7          	jalr	-1134(ra) # 6d6 <sbrk>
  if(p == (char*)-1)
 b4c:	fd5518e3          	bne	a0,s5,b1c <malloc+0xae>
        return 0;
 b50:	4501                	li	a0,0
 b52:	bf45                	j	b02 <malloc+0x94>
