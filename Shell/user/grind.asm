
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e62080e7          	jalr	-414(ra) # ef2 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	2d650513          	addi	a0,a0,726 # 1370 <malloc+0xe6>
      a2:	00001097          	auipc	ra,0x1
      a6:	e30080e7          	jalr	-464(ra) # ed2 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	2c650513          	addi	a0,a0,710 # 1370 <malloc+0xe6>
      b2:	00001097          	auipc	ra,0x1
      b6:	e28080e7          	jalr	-472(ra) # eda <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2bc50513          	addi	a0,a0,700 # 1378 <malloc+0xee>
      c4:	00001097          	auipc	ra,0x1
      c8:	10e080e7          	jalr	270(ra) # 11d2 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d9c080e7          	jalr	-612(ra) # e6a <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	2c250513          	addi	a0,a0,706 # 1398 <malloc+0x10e>
      de:	00001097          	auipc	ra,0x1
      e2:	dfc080e7          	jalr	-516(ra) # eda <chdir>
      e6:	00001997          	auipc	s3,0x1
      ea:	2c298993          	addi	s3,s3,706 # 13a8 <malloc+0x11e>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	2b098993          	addi	s3,s3,688 # 13a0 <malloc+0x116>
  uint64 iters = 0;
      f8:	4481                	li	s1,0
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	55c90913          	addi	s2,s2,1372 # 1658 <malloc+0x3ce>
     104:	a839                	j	122 <go+0xaa>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	2a650513          	addi	a0,a0,678 # 13b0 <malloc+0x126>
     112:	00001097          	auipc	ra,0x1
     116:	d98080e7          	jalr	-616(ra) # eaa <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d78080e7          	jalr	-648(ra) # e92 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d56080e7          	jalr	-682(ra) # e8a <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	slli	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	25c50513          	addi	a0,a0,604 # 13c0 <malloc+0x136>
     16c:	00001097          	auipc	ra,0x1
     170:	d3e080e7          	jalr	-706(ra) # eaa <open>
     174:	00001097          	auipc	ra,0x1
     178:	d1e080e7          	jalr	-738(ra) # e92 <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	23250513          	addi	a0,a0,562 # 13b0 <malloc+0x126>
     186:	00001097          	auipc	ra,0x1
     18a:	d34080e7          	jalr	-716(ra) # eba <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	1e050513          	addi	a0,a0,480 # 1370 <malloc+0xe6>
     198:	00001097          	auipc	ra,0x1
     19c:	d42080e7          	jalr	-702(ra) # eda <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	23650513          	addi	a0,a0,566 # 13d8 <malloc+0x14e>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	d10080e7          	jalr	-752(ra) # eba <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	1e650513          	addi	a0,a0,486 # 1398 <malloc+0x10e>
     1ba:	00001097          	auipc	ra,0x1
     1be:	d20080e7          	jalr	-736(ra) # eda <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	1b450513          	addi	a0,a0,436 # 1378 <malloc+0xee>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	006080e7          	jalr	6(ra) # 11d2 <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	c94080e7          	jalr	-876(ra) # e6a <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	cb2080e7          	jalr	-846(ra) # e92 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	1f450513          	addi	a0,a0,500 # 13e0 <malloc+0x156>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	cb6080e7          	jalr	-842(ra) # eaa <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	c90080e7          	jalr	-880(ra) # e92 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	1e250513          	addi	a0,a0,482 # 13f0 <malloc+0x166>
     216:	00001097          	auipc	ra,0x1
     21a:	c94080e7          	jalr	-876(ra) # eaa <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00002597          	auipc	a1,0x2
     22a:	dfa58593          	addi	a1,a1,-518 # 2020 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	c5a080e7          	jalr	-934(ra) # e8a <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00002597          	auipc	a1,0x2
     242:	de258593          	addi	a1,a1,-542 # 2020 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	c3a080e7          	jalr	-966(ra) # e82 <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	15e50513          	addi	a0,a0,350 # 13b0 <malloc+0x126>
     25a:	00001097          	auipc	ra,0x1
     25e:	c78080e7          	jalr	-904(ra) # ed2 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	1a250513          	addi	a0,a0,418 # 1408 <malloc+0x17e>
     26e:	00001097          	auipc	ra,0x1
     272:	c3c080e7          	jalr	-964(ra) # eaa <open>
     276:	00001097          	auipc	ra,0x1
     27a:	c1c080e7          	jalr	-996(ra) # e92 <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	19a50513          	addi	a0,a0,410 # 1418 <malloc+0x18e>
     286:	00001097          	auipc	ra,0x1
     28a:	c34080e7          	jalr	-972(ra) # eba <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	19050513          	addi	a0,a0,400 # 1420 <malloc+0x196>
     298:	00001097          	auipc	ra,0x1
     29c:	c3a080e7          	jalr	-966(ra) # ed2 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	18450513          	addi	a0,a0,388 # 1428 <malloc+0x19e>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	bfe080e7          	jalr	-1026(ra) # eaa <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	bde080e7          	jalr	-1058(ra) # e92 <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	17c50513          	addi	a0,a0,380 # 1438 <malloc+0x1ae>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	bf6080e7          	jalr	-1034(ra) # eba <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	13250513          	addi	a0,a0,306 # 1400 <malloc+0x176>
     2d6:	00001097          	auipc	ra,0x1
     2da:	be4080e7          	jalr	-1052(ra) # eba <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	0fa58593          	addi	a1,a1,250 # 13d8 <malloc+0x14e>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	15a50513          	addi	a0,a0,346 # 1440 <malloc+0x1b6>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	bdc080e7          	jalr	-1060(ra) # eca <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	16050513          	addi	a0,a0,352 # 1458 <malloc+0x1ce>
     300:	00001097          	auipc	ra,0x1
     304:	bba080e7          	jalr	-1094(ra) # eba <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	0d858593          	addi	a1,a1,216 # 13e0 <malloc+0x156>
     310:	00001517          	auipc	a0,0x1
     314:	15850513          	addi	a0,a0,344 # 1468 <malloc+0x1de>
     318:	00001097          	auipc	ra,0x1
     31c:	bb2080e7          	jalr	-1102(ra) # eca <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	b40080e7          	jalr	-1216(ra) # e62 <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	b40080e7          	jalr	-1216(ra) # e72 <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	b2e080e7          	jalr	-1234(ra) # e6a <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	12c50513          	addi	a0,a0,300 # 1470 <malloc+0x1e6>
     34c:	00001097          	auipc	ra,0x1
     350:	e86080e7          	jalr	-378(ra) # 11d2 <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	b14080e7          	jalr	-1260(ra) # e6a <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	b04080e7          	jalr	-1276(ra) # e62 <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	b04080e7          	jalr	-1276(ra) # e72 <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	aea080e7          	jalr	-1302(ra) # e62 <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	ae2080e7          	jalr	-1310(ra) # e62 <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	ae0080e7          	jalr	-1312(ra) # e6a <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	0de50513          	addi	a0,a0,222 # 1470 <malloc+0x1e6>
     39a:	00001097          	auipc	ra,0x1
     39e:	e38080e7          	jalr	-456(ra) # 11d2 <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	ac6080e7          	jalr	-1338(ra) # e6a <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x63>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	b40080e7          	jalr	-1216(ra) # ef2 <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	b34080e7          	jalr	-1228(ra) # ef2 <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	b26080e7          	jalr	-1242(ra) # ef2 <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	b1a080e7          	jalr	-1254(ra) # ef2 <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a80080e7          	jalr	-1408(ra) # e62 <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	09650513          	addi	a0,a0,150 # 1488 <malloc+0x1fe>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	ae0080e7          	jalr	-1312(ra) # eda <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	a94080e7          	jalr	-1388(ra) # e9a <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	a62080e7          	jalr	-1438(ra) # e72 <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	03250513          	addi	a0,a0,50 # 1450 <malloc+0x1c6>
     426:	00001097          	auipc	ra,0x1
     42a:	a84080e7          	jalr	-1404(ra) # eaa <open>
     42e:	00001097          	auipc	ra,0x1
     432:	a64080e7          	jalr	-1436(ra) # e92 <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	a32080e7          	jalr	-1486(ra) # e6a <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	03050513          	addi	a0,a0,48 # 1470 <malloc+0x1e6>
     448:	00001097          	auipc	ra,0x1
     44c:	d8a080e7          	jalr	-630(ra) # 11d2 <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	a18080e7          	jalr	-1512(ra) # e6a <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	03e50513          	addi	a0,a0,62 # 1498 <malloc+0x20e>
     462:	00001097          	auipc	ra,0x1
     466:	d70080e7          	jalr	-656(ra) # 11d2 <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	9fe080e7          	jalr	-1538(ra) # e6a <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	9ee080e7          	jalr	-1554(ra) # e62 <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	9ee080e7          	jalr	-1554(ra) # e72 <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	a5c080e7          	jalr	-1444(ra) # eea <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	a04080e7          	jalr	-1532(ra) # e9a <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	9ca080e7          	jalr	-1590(ra) # e6a <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	fc850513          	addi	a0,a0,-56 # 1470 <malloc+0x1e6>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	d22080e7          	jalr	-734(ra) # 11d2 <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	9b0080e7          	jalr	-1616(ra) # e6a <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	addi	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	9b4080e7          	jalr	-1612(ra) # e7a <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	990080e7          	jalr	-1648(ra) # e62 <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	9ae080e7          	jalr	-1618(ra) # e92 <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	9a2080e7          	jalr	-1630(ra) # e92 <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	978080e7          	jalr	-1672(ra) # e72 <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	fac50513          	addi	a0,a0,-84 # 14b0 <malloc+0x226>
     50c:	00001097          	auipc	ra,0x1
     510:	cc6080e7          	jalr	-826(ra) # 11d2 <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	954080e7          	jalr	-1708(ra) # e6a <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	944080e7          	jalr	-1724(ra) # e62 <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	93c080e7          	jalr	-1732(ra) # e62 <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	f9858593          	addi	a1,a1,-104 # 14c8 <malloc+0x23e>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	94e080e7          	jalr	-1714(ra) # e8a <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	addi	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	92e080e7          	jalr	-1746(ra) # e82 <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	906080e7          	jalr	-1786(ra) # e6a <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	f6450513          	addi	a0,a0,-156 # 14d0 <malloc+0x246>
     574:	00001097          	auipc	ra,0x1
     578:	c5e080e7          	jalr	-930(ra) # 11d2 <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	f7250513          	addi	a0,a0,-142 # 14f0 <malloc+0x266>
     586:	00001097          	auipc	ra,0x1
     58a:	c4c080e7          	jalr	-948(ra) # 11d2 <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	ee050513          	addi	a0,a0,-288 # 1470 <malloc+0x1e6>
     598:	00001097          	auipc	ra,0x1
     59c:	c3a080e7          	jalr	-966(ra) # 11d2 <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	8c8080e7          	jalr	-1848(ra) # e6a <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	8b8080e7          	jalr	-1864(ra) # e62 <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	8b8080e7          	jalr	-1864(ra) # e72 <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e8c50513          	addi	a0,a0,-372 # 1450 <malloc+0x1c6>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	8ee080e7          	jalr	-1810(ra) # eba <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e7c50513          	addi	a0,a0,-388 # 1450 <malloc+0x1c6>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	8f6080e7          	jalr	-1802(ra) # ed2 <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e6c50513          	addi	a0,a0,-404 # 1450 <malloc+0x1c6>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	8ee080e7          	jalr	-1810(ra) # eda <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	dc450513          	addi	a0,a0,-572 # 13b8 <malloc+0x12e>
     5fc:	00001097          	auipc	ra,0x1
     600:	8be080e7          	jalr	-1858(ra) # eba <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	ec050513          	addi	a0,a0,-320 # 14c8 <malloc+0x23e>
     610:	00001097          	auipc	ra,0x1
     614:	89a080e7          	jalr	-1894(ra) # eaa <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	eb050513          	addi	a0,a0,-336 # 14c8 <malloc+0x23e>
     620:	00001097          	auipc	ra,0x1
     624:	89a080e7          	jalr	-1894(ra) # eba <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00001097          	auipc	ra,0x1
     62e:	840080e7          	jalr	-1984(ra) # e6a <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	e3e50513          	addi	a0,a0,-450 # 1470 <malloc+0x1e6>
     63a:	00001097          	auipc	ra,0x1
     63e:	b98080e7          	jalr	-1128(ra) # 11d2 <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00001097          	auipc	ra,0x1
     648:	826080e7          	jalr	-2010(ra) # e6a <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	ec450513          	addi	a0,a0,-316 # 1510 <malloc+0x286>
     654:	00001097          	auipc	ra,0x1
     658:	866080e7          	jalr	-1946(ra) # eba <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	eb050513          	addi	a0,a0,-336 # 1510 <malloc+0x286>
     668:	00001097          	auipc	ra,0x1
     66c:	842080e7          	jalr	-1982(ra) # eaa <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	e5058593          	addi	a1,a1,-432 # 14c8 <malloc+0x23e>
     680:	00001097          	auipc	ra,0x1
     684:	80a080e7          	jalr	-2038(ra) # e8a <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	addi	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00001097          	auipc	ra,0x1
     698:	82e080e7          	jalr	-2002(ra) # ec2 <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00000097          	auipc	ra,0x0
     6ba:	7dc080e7          	jalr	2012(ra) # e92 <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	e5250513          	addi	a0,a0,-430 # 1510 <malloc+0x286>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	7f4080e7          	jalr	2036(ra) # eba <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	e4850513          	addi	a0,a0,-440 # 1518 <malloc+0x28e>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	afa080e7          	jalr	-1286(ra) # 11d2 <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	788080e7          	jalr	1928(ra) # e6a <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	e4650513          	addi	a0,a0,-442 # 1530 <malloc+0x2a6>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	ae0080e7          	jalr	-1312(ra) # 11d2 <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00000097          	auipc	ra,0x0
     700:	76e080e7          	jalr	1902(ra) # e6a <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	e4450513          	addi	a0,a0,-444 # 1548 <malloc+0x2be>
     70c:	00001097          	auipc	ra,0x1
     710:	ac6080e7          	jalr	-1338(ra) # 11d2 <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00000097          	auipc	ra,0x0
     71a:	754080e7          	jalr	1876(ra) # e6a <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	e4050513          	addi	a0,a0,-448 # 1560 <malloc+0x2d6>
     728:	00001097          	auipc	ra,0x1
     72c:	aaa080e7          	jalr	-1366(ra) # 11d2 <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00000097          	auipc	ra,0x0
     736:	738080e7          	jalr	1848(ra) # e6a <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	e4e50513          	addi	a0,a0,-434 # 1588 <malloc+0x2fe>
     742:	00001097          	auipc	ra,0x1
     746:	a90080e7          	jalr	-1392(ra) # 11d2 <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	71e080e7          	jalr	1822(ra) # e6a <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	addi	a0,s0,-104
     758:	00000097          	auipc	ra,0x0
     75c:	722080e7          	jalr	1826(ra) # e7a <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	addi	a0,s0,-96
     768:	00000097          	auipc	ra,0x0
     76c:	712080e7          	jalr	1810(ra) # e7a <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00000097          	auipc	ra,0x0
     778:	6ee080e7          	jalr	1774(ra) # e62 <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	6de080e7          	jalr	1758(ra) # e62 <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	6fa080e7          	jalr	1786(ra) # e92 <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6ee080e7          	jalr	1774(ra) # e92 <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6e2080e7          	jalr	1762(ra) # e92 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	addi	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	6bc080e7          	jalr	1724(ra) # e82 <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	addi	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	6aa080e7          	jalr	1706(ra) # e82 <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	addi	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	698080e7          	jalr	1688(ra) # e82 <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	69c080e7          	jalr	1692(ra) # e92 <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	addi	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	670080e7          	jalr	1648(ra) # e72 <wait>
      wait(&st2);
     80a:	fa840513          	addi	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	664080e7          	jalr	1636(ra) # e72 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	e0658593          	addi	a1,a1,-506 # 1628 <malloc+0x39e>
     82a:	f9040513          	addi	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	3b0080e7          	jalr	944(ra) # bde <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	addi	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	dea50513          	addi	a0,a0,-534 # 1630 <malloc+0x3a6>
     84e:	00001097          	auipc	ra,0x1
     852:	984080e7          	jalr	-1660(ra) # 11d2 <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	612080e7          	jalr	1554(ra) # e6a <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	c5058593          	addi	a1,a1,-944 # 14b0 <malloc+0x226>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	93a080e7          	jalr	-1734(ra) # 11a4 <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	5f6080e7          	jalr	1526(ra) # e6a <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	c3458593          	addi	a1,a1,-972 # 14b0 <malloc+0x226>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	91e080e7          	jalr	-1762(ra) # 11a4 <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	5da080e7          	jalr	1498(ra) # e6a <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	5f6080e7          	jalr	1526(ra) # e92 <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5ea080e7          	jalr	1514(ra) # e92 <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5de080e7          	jalr	1502(ra) # e92 <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	5d4080e7          	jalr	1492(ra) # e92 <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	618080e7          	jalr	1560(ra) # ee2 <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	cd858593          	addi	a1,a1,-808 # 15b0 <malloc+0x326>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	8c2080e7          	jalr	-1854(ra) # 11a4 <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	57e080e7          	jalr	1406(ra) # e6a <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	59a080e7          	jalr	1434(ra) # e92 <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	cc878793          	addi	a5,a5,-824 # 15c8 <malloc+0x33e>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	cc478793          	addi	a5,a5,-828 # 15d0 <malloc+0x346>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	addi	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	cb850513          	addi	a0,a0,-840 # 15d8 <malloc+0x34e>
     928:	00000097          	auipc	ra,0x0
     92c:	57a080e7          	jalr	1402(ra) # ea2 <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	cb858593          	addi	a1,a1,-840 # 15e8 <malloc+0x35e>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	86a080e7          	jalr	-1942(ra) # 11a4 <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	526080e7          	jalr	1318(ra) # e6a <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	b2458593          	addi	a1,a1,-1244 # 1470 <malloc+0x1e6>
     954:	4509                	li	a0,2
     956:	00001097          	auipc	ra,0x1
     95a:	84e080e7          	jalr	-1970(ra) # 11a4 <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	50a080e7          	jalr	1290(ra) # e6a <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	526080e7          	jalr	1318(ra) # e92 <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	51a080e7          	jalr	1306(ra) # e92 <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	510080e7          	jalr	1296(ra) # e92 <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	554080e7          	jalr	1364(ra) # ee2 <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	c1858593          	addi	a1,a1,-1000 # 15b0 <malloc+0x326>
     9a0:	4509                	li	a0,2
     9a2:	00001097          	auipc	ra,0x1
     9a6:	802080e7          	jalr	-2046(ra) # 11a4 <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	4be080e7          	jalr	1214(ra) # e6a <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	4da080e7          	jalr	1242(ra) # e92 <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	4d0080e7          	jalr	1232(ra) # e92 <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	514080e7          	jalr	1300(ra) # ee2 <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	bd458593          	addi	a1,a1,-1068 # 15b0 <malloc+0x326>
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	7be080e7          	jalr	1982(ra) # 11a4 <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	47a080e7          	jalr	1146(ra) # e6a <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	496080e7          	jalr	1174(ra) # e92 <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	bfc78793          	addi	a5,a5,-1028 # 1600 <malloc+0x376>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	addi	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	bf050513          	addi	a0,a0,-1040 # 1608 <malloc+0x37e>
     a20:	00000097          	auipc	ra,0x0
     a24:	482080e7          	jalr	1154(ra) # ea2 <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	be858593          	addi	a1,a1,-1048 # 1610 <malloc+0x386>
     a30:	4509                	li	a0,2
     a32:	00000097          	auipc	ra,0x0
     a36:	772080e7          	jalr	1906(ra) # 11a4 <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	42e080e7          	jalr	1070(ra) # e6a <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	a2c58593          	addi	a1,a1,-1492 # 1470 <malloc+0x1e6>
     a4c:	4509                	li	a0,2
     a4e:	00000097          	auipc	ra,0x0
     a52:	756080e7          	jalr	1878(ra) # 11a4 <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	412080e7          	jalr	1042(ra) # e6a <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	addi	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	addi	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	9e450513          	addi	a0,a0,-1564 # 1450 <malloc+0x1c6>
     a74:	00000097          	auipc	ra,0x0
     a78:	446080e7          	jalr	1094(ra) # eba <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	98450513          	addi	a0,a0,-1660 # 1400 <malloc+0x176>
     a84:	00000097          	auipc	ra,0x0
     a88:	436080e7          	jalr	1078(ra) # eba <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	3d6080e7          	jalr	982(ra) # e62 <fork>
  if(pid1 < 0){
     a94:	02054163          	bltz	a0,ab6 <iter+0x56>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e91d                	bnez	a0,ad0 <iter+0x70>
    rand_next ^= 31;
     a9c:	00001717          	auipc	a4,0x1
     aa0:	56470713          	addi	a4,a4,1380 # 2000 <rand_next>
     aa4:	631c                	ld	a5,0(a4)
     aa6:	01f7c793          	xori	a5,a5,31
     aaa:	e31c                	sd	a5,0(a4)
    go(0);
     aac:	4501                	li	a0,0
     aae:	fffff097          	auipc	ra,0xfffff
     ab2:	5ca080e7          	jalr	1482(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab6:	00001517          	auipc	a0,0x1
     aba:	9ba50513          	addi	a0,a0,-1606 # 1470 <malloc+0x1e6>
     abe:	00000097          	auipc	ra,0x0
     ac2:	714080e7          	jalr	1812(ra) # 11d2 <printf>
    exit(1);
     ac6:	4505                	li	a0,1
     ac8:	00000097          	auipc	ra,0x0
     acc:	3a2080e7          	jalr	930(ra) # e6a <exit>
    exit(0);
  }

  int pid2 = fork();
     ad0:	00000097          	auipc	ra,0x0
     ad4:	392080e7          	jalr	914(ra) # e62 <fork>
     ad8:	892a                	mv	s2,a0
  if(pid2 < 0){
     ada:	02054263          	bltz	a0,afe <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ade:	ed0d                	bnez	a0,b18 <iter+0xb8>
    rand_next ^= 7177;
     ae0:	00001697          	auipc	a3,0x1
     ae4:	52068693          	addi	a3,a3,1312 # 2000 <rand_next>
     ae8:	629c                	ld	a5,0(a3)
     aea:	6709                	lui	a4,0x2
     aec:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x4f1>
     af0:	8fb9                	xor	a5,a5,a4
     af2:	e29c                	sd	a5,0(a3)
    go(1);
     af4:	4505                	li	a0,1
     af6:	fffff097          	auipc	ra,0xfffff
     afa:	582080e7          	jalr	1410(ra) # 78 <go>
    printf("grind: fork failed\n");
     afe:	00001517          	auipc	a0,0x1
     b02:	97250513          	addi	a0,a0,-1678 # 1470 <malloc+0x1e6>
     b06:	00000097          	auipc	ra,0x0
     b0a:	6cc080e7          	jalr	1740(ra) # 11d2 <printf>
    exit(1);
     b0e:	4505                	li	a0,1
     b10:	00000097          	auipc	ra,0x0
     b14:	35a080e7          	jalr	858(ra) # e6a <exit>
    exit(0);
  }

  int st1 = -1;
     b18:	57fd                	li	a5,-1
     b1a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b1e:	fdc40513          	addi	a0,s0,-36
     b22:	00000097          	auipc	ra,0x0
     b26:	350080e7          	jalr	848(ra) # e72 <wait>
  if(st1 != 0){
     b2a:	fdc42783          	lw	a5,-36(s0)
     b2e:	ef99                	bnez	a5,b4c <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b30:	57fd                	li	a5,-1
     b32:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b36:	fd840513          	addi	a0,s0,-40
     b3a:	00000097          	auipc	ra,0x0
     b3e:	338080e7          	jalr	824(ra) # e72 <wait>

  exit(0);
     b42:	4501                	li	a0,0
     b44:	00000097          	auipc	ra,0x0
     b48:	326080e7          	jalr	806(ra) # e6a <exit>
    kill(pid1);
     b4c:	8526                	mv	a0,s1
     b4e:	00000097          	auipc	ra,0x0
     b52:	34c080e7          	jalr	844(ra) # e9a <kill>
    kill(pid2);
     b56:	854a                	mv	a0,s2
     b58:	00000097          	auipc	ra,0x0
     b5c:	342080e7          	jalr	834(ra) # e9a <kill>
     b60:	bfc1                	j	b30 <iter+0xd0>

0000000000000b62 <main>:
}

int
main()
{
     b62:	1101                	addi	sp,sp,-32
     b64:	ec06                	sd	ra,24(sp)
     b66:	e822                	sd	s0,16(sp)
     b68:	e426                	sd	s1,8(sp)
     b6a:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b6c:	00001497          	auipc	s1,0x1
     b70:	49448493          	addi	s1,s1,1172 # 2000 <rand_next>
     b74:	a829                	j	b8e <main+0x2c>
      iter();
     b76:	00000097          	auipc	ra,0x0
     b7a:	eea080e7          	jalr	-278(ra) # a60 <iter>
    sleep(20);
     b7e:	4551                	li	a0,20
     b80:	00000097          	auipc	ra,0x0
     b84:	37a080e7          	jalr	890(ra) # efa <sleep>
    rand_next += 1;
     b88:	609c                	ld	a5,0(s1)
     b8a:	0785                	addi	a5,a5,1
     b8c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     b8e:	00000097          	auipc	ra,0x0
     b92:	2d4080e7          	jalr	724(ra) # e62 <fork>
    if(pid == 0){
     b96:	d165                	beqz	a0,b76 <main+0x14>
    if(pid > 0){
     b98:	fea053e3          	blez	a0,b7e <main+0x1c>
      wait(0);
     b9c:	4501                	li	a0,0
     b9e:	00000097          	auipc	ra,0x0
     ba2:	2d4080e7          	jalr	724(ra) # e72 <wait>
     ba6:	bfe1                	j	b7e <main+0x1c>

0000000000000ba8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e406                	sd	ra,8(sp)
     bac:	e022                	sd	s0,0(sp)
     bae:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bb0:	00000097          	auipc	ra,0x0
     bb4:	fb2080e7          	jalr	-78(ra) # b62 <main>
  exit(0);
     bb8:	4501                	li	a0,0
     bba:	00000097          	auipc	ra,0x0
     bbe:	2b0080e7          	jalr	688(ra) # e6a <exit>

0000000000000bc2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bc2:	1141                	addi	sp,sp,-16
     bc4:	e422                	sd	s0,8(sp)
     bc6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bc8:	87aa                	mv	a5,a0
     bca:	0585                	addi	a1,a1,1
     bcc:	0785                	addi	a5,a5,1
     bce:	fff5c703          	lbu	a4,-1(a1)
     bd2:	fee78fa3          	sb	a4,-1(a5)
     bd6:	fb75                	bnez	a4,bca <strcpy+0x8>
    ;
  return os;
}
     bd8:	6422                	ld	s0,8(sp)
     bda:	0141                	addi	sp,sp,16
     bdc:	8082                	ret

0000000000000bde <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bde:	1141                	addi	sp,sp,-16
     be0:	e422                	sd	s0,8(sp)
     be2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     be4:	00054783          	lbu	a5,0(a0)
     be8:	cb91                	beqz	a5,bfc <strcmp+0x1e>
     bea:	0005c703          	lbu	a4,0(a1)
     bee:	00f71763          	bne	a4,a5,bfc <strcmp+0x1e>
    p++, q++;
     bf2:	0505                	addi	a0,a0,1
     bf4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	fbe5                	bnez	a5,bea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bfc:	0005c503          	lbu	a0,0(a1)
}
     c00:	40a7853b          	subw	a0,a5,a0
     c04:	6422                	ld	s0,8(sp)
     c06:	0141                	addi	sp,sp,16
     c08:	8082                	ret

0000000000000c0a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     c0a:	1141                	addi	sp,sp,-16
     c0c:	e422                	sd	s0,8(sp)
     c0e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
     c10:	ce11                	beqz	a2,c2c <strncmp+0x22>
     c12:	00054783          	lbu	a5,0(a0)
     c16:	cf89                	beqz	a5,c30 <strncmp+0x26>
     c18:	0005c703          	lbu	a4,0(a1)
     c1c:	00f71a63          	bne	a4,a5,c30 <strncmp+0x26>
    n--, p++, q++;
     c20:	367d                	addiw	a2,a2,-1
     c22:	0505                	addi	a0,a0,1
     c24:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
     c26:	f675                	bnez	a2,c12 <strncmp+0x8>
  if(n == 0)
    return 0;
     c28:	4501                	li	a0,0
     c2a:	a809                	j	c3c <strncmp+0x32>
     c2c:	4501                	li	a0,0
     c2e:	a039                	j	c3c <strncmp+0x32>
  if(n == 0)
     c30:	ca09                	beqz	a2,c42 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
     c32:	00054503          	lbu	a0,0(a0)
     c36:	0005c783          	lbu	a5,0(a1)
     c3a:	9d1d                	subw	a0,a0,a5
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret
    return 0;
     c42:	4501                	li	a0,0
     c44:	bfe5                	j	c3c <strncmp+0x32>

0000000000000c46 <strlen>:

uint
strlen(const char *s)
{
     c46:	1141                	addi	sp,sp,-16
     c48:	e422                	sd	s0,8(sp)
     c4a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c4c:	00054783          	lbu	a5,0(a0)
     c50:	cf91                	beqz	a5,c6c <strlen+0x26>
     c52:	0505                	addi	a0,a0,1
     c54:	87aa                	mv	a5,a0
     c56:	86be                	mv	a3,a5
     c58:	0785                	addi	a5,a5,1
     c5a:	fff7c703          	lbu	a4,-1(a5)
     c5e:	ff65                	bnez	a4,c56 <strlen+0x10>
     c60:	40a6853b          	subw	a0,a3,a0
     c64:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c66:	6422                	ld	s0,8(sp)
     c68:	0141                	addi	sp,sp,16
     c6a:	8082                	ret
  for(n = 0; s[n]; n++)
     c6c:	4501                	li	a0,0
     c6e:	bfe5                	j	c66 <strlen+0x20>

0000000000000c70 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c70:	1141                	addi	sp,sp,-16
     c72:	e422                	sd	s0,8(sp)
     c74:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c76:	ca19                	beqz	a2,c8c <memset+0x1c>
     c78:	87aa                	mv	a5,a0
     c7a:	1602                	slli	a2,a2,0x20
     c7c:	9201                	srli	a2,a2,0x20
     c7e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c82:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c86:	0785                	addi	a5,a5,1
     c88:	fee79de3          	bne	a5,a4,c82 <memset+0x12>
  }
  return dst;
}
     c8c:	6422                	ld	s0,8(sp)
     c8e:	0141                	addi	sp,sp,16
     c90:	8082                	ret

0000000000000c92 <strchr>:

char*
strchr(const char *s, char c)
{
     c92:	1141                	addi	sp,sp,-16
     c94:	e422                	sd	s0,8(sp)
     c96:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c98:	00054783          	lbu	a5,0(a0)
     c9c:	cb99                	beqz	a5,cb2 <strchr+0x20>
    if(*s == c)
     c9e:	00f58763          	beq	a1,a5,cac <strchr+0x1a>
  for(; *s; s++)
     ca2:	0505                	addi	a0,a0,1
     ca4:	00054783          	lbu	a5,0(a0)
     ca8:	fbfd                	bnez	a5,c9e <strchr+0xc>
      return (char*)s;
  return 0;
     caa:	4501                	li	a0,0
}
     cac:	6422                	ld	s0,8(sp)
     cae:	0141                	addi	sp,sp,16
     cb0:	8082                	ret
  return 0;
     cb2:	4501                	li	a0,0
     cb4:	bfe5                	j	cac <strchr+0x1a>

0000000000000cb6 <gets>:

char*
gets(char *buf, int max)
{
     cb6:	711d                	addi	sp,sp,-96
     cb8:	ec86                	sd	ra,88(sp)
     cba:	e8a2                	sd	s0,80(sp)
     cbc:	e4a6                	sd	s1,72(sp)
     cbe:	e0ca                	sd	s2,64(sp)
     cc0:	fc4e                	sd	s3,56(sp)
     cc2:	f852                	sd	s4,48(sp)
     cc4:	f456                	sd	s5,40(sp)
     cc6:	f05a                	sd	s6,32(sp)
     cc8:	ec5e                	sd	s7,24(sp)
     cca:	1080                	addi	s0,sp,96
     ccc:	8baa                	mv	s7,a0
     cce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cd0:	892a                	mv	s2,a0
     cd2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cd4:	4aa9                	li	s5,10
     cd6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cd8:	89a6                	mv	s3,s1
     cda:	2485                	addiw	s1,s1,1
     cdc:	0344d863          	bge	s1,s4,d0c <gets+0x56>
    cc = read(0, &c, 1);
     ce0:	4605                	li	a2,1
     ce2:	faf40593          	addi	a1,s0,-81
     ce6:	4501                	li	a0,0
     ce8:	00000097          	auipc	ra,0x0
     cec:	19a080e7          	jalr	410(ra) # e82 <read>
    if(cc < 1)
     cf0:	00a05e63          	blez	a0,d0c <gets+0x56>
    buf[i++] = c;
     cf4:	faf44783          	lbu	a5,-81(s0)
     cf8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cfc:	01578763          	beq	a5,s5,d0a <gets+0x54>
     d00:	0905                	addi	s2,s2,1
     d02:	fd679be3          	bne	a5,s6,cd8 <gets+0x22>
  for(i=0; i+1 < max; ){
     d06:	89a6                	mv	s3,s1
     d08:	a011                	j	d0c <gets+0x56>
     d0a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d0c:	99de                	add	s3,s3,s7
     d0e:	00098023          	sb	zero,0(s3)
  return buf;
}
     d12:	855e                	mv	a0,s7
     d14:	60e6                	ld	ra,88(sp)
     d16:	6446                	ld	s0,80(sp)
     d18:	64a6                	ld	s1,72(sp)
     d1a:	6906                	ld	s2,64(sp)
     d1c:	79e2                	ld	s3,56(sp)
     d1e:	7a42                	ld	s4,48(sp)
     d20:	7aa2                	ld	s5,40(sp)
     d22:	7b02                	ld	s6,32(sp)
     d24:	6be2                	ld	s7,24(sp)
     d26:	6125                	addi	sp,sp,96
     d28:	8082                	ret

0000000000000d2a <stat>:

int
stat(const char *n, struct stat *st)
{
     d2a:	1101                	addi	sp,sp,-32
     d2c:	ec06                	sd	ra,24(sp)
     d2e:	e822                	sd	s0,16(sp)
     d30:	e426                	sd	s1,8(sp)
     d32:	e04a                	sd	s2,0(sp)
     d34:	1000                	addi	s0,sp,32
     d36:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d38:	4581                	li	a1,0
     d3a:	00000097          	auipc	ra,0x0
     d3e:	170080e7          	jalr	368(ra) # eaa <open>
  if(fd < 0)
     d42:	02054563          	bltz	a0,d6c <stat+0x42>
     d46:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d48:	85ca                	mv	a1,s2
     d4a:	00000097          	auipc	ra,0x0
     d4e:	178080e7          	jalr	376(ra) # ec2 <fstat>
     d52:	892a                	mv	s2,a0
  close(fd);
     d54:	8526                	mv	a0,s1
     d56:	00000097          	auipc	ra,0x0
     d5a:	13c080e7          	jalr	316(ra) # e92 <close>
  return r;
}
     d5e:	854a                	mv	a0,s2
     d60:	60e2                	ld	ra,24(sp)
     d62:	6442                	ld	s0,16(sp)
     d64:	64a2                	ld	s1,8(sp)
     d66:	6902                	ld	s2,0(sp)
     d68:	6105                	addi	sp,sp,32
     d6a:	8082                	ret
    return -1;
     d6c:	597d                	li	s2,-1
     d6e:	bfc5                	j	d5e <stat+0x34>

0000000000000d70 <atoi>:

int
atoi(const char *s)
{
     d70:	1141                	addi	sp,sp,-16
     d72:	e422                	sd	s0,8(sp)
     d74:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d76:	00054683          	lbu	a3,0(a0)
     d7a:	fd06879b          	addiw	a5,a3,-48
     d7e:	0ff7f793          	zext.b	a5,a5
     d82:	4625                	li	a2,9
     d84:	02f66863          	bltu	a2,a5,db4 <atoi+0x44>
     d88:	872a                	mv	a4,a0
  n = 0;
     d8a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d8c:	0705                	addi	a4,a4,1
     d8e:	0025179b          	slliw	a5,a0,0x2
     d92:	9fa9                	addw	a5,a5,a0
     d94:	0017979b          	slliw	a5,a5,0x1
     d98:	9fb5                	addw	a5,a5,a3
     d9a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d9e:	00074683          	lbu	a3,0(a4)
     da2:	fd06879b          	addiw	a5,a3,-48
     da6:	0ff7f793          	zext.b	a5,a5
     daa:	fef671e3          	bgeu	a2,a5,d8c <atoi+0x1c>
  return n;
}
     dae:	6422                	ld	s0,8(sp)
     db0:	0141                	addi	sp,sp,16
     db2:	8082                	ret
  n = 0;
     db4:	4501                	li	a0,0
     db6:	bfe5                	j	dae <atoi+0x3e>

0000000000000db8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     db8:	1141                	addi	sp,sp,-16
     dba:	e422                	sd	s0,8(sp)
     dbc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dbe:	02b57463          	bgeu	a0,a1,de6 <memmove+0x2e>
    while(n-- > 0)
     dc2:	00c05f63          	blez	a2,de0 <memmove+0x28>
     dc6:	1602                	slli	a2,a2,0x20
     dc8:	9201                	srli	a2,a2,0x20
     dca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dce:	872a                	mv	a4,a0
      *dst++ = *src++;
     dd0:	0585                	addi	a1,a1,1
     dd2:	0705                	addi	a4,a4,1
     dd4:	fff5c683          	lbu	a3,-1(a1)
     dd8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ddc:	fee79ae3          	bne	a5,a4,dd0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     de0:	6422                	ld	s0,8(sp)
     de2:	0141                	addi	sp,sp,16
     de4:	8082                	ret
    dst += n;
     de6:	00c50733          	add	a4,a0,a2
    src += n;
     dea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dec:	fec05ae3          	blez	a2,de0 <memmove+0x28>
     df0:	fff6079b          	addiw	a5,a2,-1
     df4:	1782                	slli	a5,a5,0x20
     df6:	9381                	srli	a5,a5,0x20
     df8:	fff7c793          	not	a5,a5
     dfc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dfe:	15fd                	addi	a1,a1,-1
     e00:	177d                	addi	a4,a4,-1
     e02:	0005c683          	lbu	a3,0(a1)
     e06:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e0a:	fee79ae3          	bne	a5,a4,dfe <memmove+0x46>
     e0e:	bfc9                	j	de0 <memmove+0x28>

0000000000000e10 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e10:	1141                	addi	sp,sp,-16
     e12:	e422                	sd	s0,8(sp)
     e14:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e16:	ca05                	beqz	a2,e46 <memcmp+0x36>
     e18:	fff6069b          	addiw	a3,a2,-1
     e1c:	1682                	slli	a3,a3,0x20
     e1e:	9281                	srli	a3,a3,0x20
     e20:	0685                	addi	a3,a3,1
     e22:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e24:	00054783          	lbu	a5,0(a0)
     e28:	0005c703          	lbu	a4,0(a1)
     e2c:	00e79863          	bne	a5,a4,e3c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e30:	0505                	addi	a0,a0,1
    p2++;
     e32:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e34:	fed518e3          	bne	a0,a3,e24 <memcmp+0x14>
  }
  return 0;
     e38:	4501                	li	a0,0
     e3a:	a019                	j	e40 <memcmp+0x30>
      return *p1 - *p2;
     e3c:	40e7853b          	subw	a0,a5,a4
}
     e40:	6422                	ld	s0,8(sp)
     e42:	0141                	addi	sp,sp,16
     e44:	8082                	ret
  return 0;
     e46:	4501                	li	a0,0
     e48:	bfe5                	j	e40 <memcmp+0x30>

0000000000000e4a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e4a:	1141                	addi	sp,sp,-16
     e4c:	e406                	sd	ra,8(sp)
     e4e:	e022                	sd	s0,0(sp)
     e50:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e52:	00000097          	auipc	ra,0x0
     e56:	f66080e7          	jalr	-154(ra) # db8 <memmove>
}
     e5a:	60a2                	ld	ra,8(sp)
     e5c:	6402                	ld	s0,0(sp)
     e5e:	0141                	addi	sp,sp,16
     e60:	8082                	ret

0000000000000e62 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e62:	4885                	li	a7,1
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <exit>:
.global exit
exit:
 li a7, SYS_exit
     e6a:	4889                	li	a7,2
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e72:	488d                	li	a7,3
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e7a:	4891                	li	a7,4
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <read>:
.global read
read:
 li a7, SYS_read
     e82:	4895                	li	a7,5
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <write>:
.global write
write:
 li a7, SYS_write
     e8a:	48c1                	li	a7,16
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <close>:
.global close
close:
 li a7, SYS_close
     e92:	48d5                	li	a7,21
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <kill>:
.global kill
kill:
 li a7, SYS_kill
     e9a:	4899                	li	a7,6
 ecall
     e9c:	00000073          	ecall
 ret
     ea0:	8082                	ret

0000000000000ea2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ea2:	489d                	li	a7,7
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <open>:
.global open
open:
 li a7, SYS_open
     eaa:	48bd                	li	a7,15
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     eb2:	48c5                	li	a7,17
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     eba:	48c9                	li	a7,18
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ec2:	48a1                	li	a7,8
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <link>:
.global link
link:
 li a7, SYS_link
     eca:	48cd                	li	a7,19
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ed2:	48d1                	li	a7,20
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     eda:	48a5                	li	a7,9
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ee2:	48a9                	li	a7,10
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     eea:	48ad                	li	a7,11
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ef2:	48b1                	li	a7,12
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     efa:	48b5                	li	a7,13
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f02:	48b9                	li	a7,14
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f0a:	1101                	addi	sp,sp,-32
     f0c:	ec06                	sd	ra,24(sp)
     f0e:	e822                	sd	s0,16(sp)
     f10:	1000                	addi	s0,sp,32
     f12:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f16:	4605                	li	a2,1
     f18:	fef40593          	addi	a1,s0,-17
     f1c:	00000097          	auipc	ra,0x0
     f20:	f6e080e7          	jalr	-146(ra) # e8a <write>
}
     f24:	60e2                	ld	ra,24(sp)
     f26:	6442                	ld	s0,16(sp)
     f28:	6105                	addi	sp,sp,32
     f2a:	8082                	ret

0000000000000f2c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f2c:	7139                	addi	sp,sp,-64
     f2e:	fc06                	sd	ra,56(sp)
     f30:	f822                	sd	s0,48(sp)
     f32:	f426                	sd	s1,40(sp)
     f34:	f04a                	sd	s2,32(sp)
     f36:	ec4e                	sd	s3,24(sp)
     f38:	0080                	addi	s0,sp,64
     f3a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f3c:	c299                	beqz	a3,f42 <printint+0x16>
     f3e:	0805c963          	bltz	a1,fd0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f42:	2581                	sext.w	a1,a1
  neg = 0;
     f44:	4881                	li	a7,0
     f46:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f4a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f4c:	2601                	sext.w	a2,a2
     f4e:	00000517          	auipc	a0,0x0
     f52:	7ca50513          	addi	a0,a0,1994 # 1718 <digits>
     f56:	883a                	mv	a6,a4
     f58:	2705                	addiw	a4,a4,1
     f5a:	02c5f7bb          	remuw	a5,a1,a2
     f5e:	1782                	slli	a5,a5,0x20
     f60:	9381                	srli	a5,a5,0x20
     f62:	97aa                	add	a5,a5,a0
     f64:	0007c783          	lbu	a5,0(a5)
     f68:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f6c:	0005879b          	sext.w	a5,a1
     f70:	02c5d5bb          	divuw	a1,a1,a2
     f74:	0685                	addi	a3,a3,1
     f76:	fec7f0e3          	bgeu	a5,a2,f56 <printint+0x2a>
  if(neg)
     f7a:	00088c63          	beqz	a7,f92 <printint+0x66>
    buf[i++] = '-';
     f7e:	fd070793          	addi	a5,a4,-48
     f82:	00878733          	add	a4,a5,s0
     f86:	02d00793          	li	a5,45
     f8a:	fef70823          	sb	a5,-16(a4)
     f8e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f92:	02e05863          	blez	a4,fc2 <printint+0x96>
     f96:	fc040793          	addi	a5,s0,-64
     f9a:	00e78933          	add	s2,a5,a4
     f9e:	fff78993          	addi	s3,a5,-1
     fa2:	99ba                	add	s3,s3,a4
     fa4:	377d                	addiw	a4,a4,-1
     fa6:	1702                	slli	a4,a4,0x20
     fa8:	9301                	srli	a4,a4,0x20
     faa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fae:	fff94583          	lbu	a1,-1(s2)
     fb2:	8526                	mv	a0,s1
     fb4:	00000097          	auipc	ra,0x0
     fb8:	f56080e7          	jalr	-170(ra) # f0a <putc>
  while(--i >= 0)
     fbc:	197d                	addi	s2,s2,-1
     fbe:	ff3918e3          	bne	s2,s3,fae <printint+0x82>
}
     fc2:	70e2                	ld	ra,56(sp)
     fc4:	7442                	ld	s0,48(sp)
     fc6:	74a2                	ld	s1,40(sp)
     fc8:	7902                	ld	s2,32(sp)
     fca:	69e2                	ld	s3,24(sp)
     fcc:	6121                	addi	sp,sp,64
     fce:	8082                	ret
    x = -xx;
     fd0:	40b005bb          	negw	a1,a1
    neg = 1;
     fd4:	4885                	li	a7,1
    x = -xx;
     fd6:	bf85                	j	f46 <printint+0x1a>

0000000000000fd8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fd8:	715d                	addi	sp,sp,-80
     fda:	e486                	sd	ra,72(sp)
     fdc:	e0a2                	sd	s0,64(sp)
     fde:	fc26                	sd	s1,56(sp)
     fe0:	f84a                	sd	s2,48(sp)
     fe2:	f44e                	sd	s3,40(sp)
     fe4:	f052                	sd	s4,32(sp)
     fe6:	ec56                	sd	s5,24(sp)
     fe8:	e85a                	sd	s6,16(sp)
     fea:	e45e                	sd	s7,8(sp)
     fec:	e062                	sd	s8,0(sp)
     fee:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ff0:	0005c903          	lbu	s2,0(a1)
     ff4:	18090c63          	beqz	s2,118c <vprintf+0x1b4>
     ff8:	8aaa                	mv	s5,a0
     ffa:	8bb2                	mv	s7,a2
     ffc:	00158493          	addi	s1,a1,1
  state = 0;
    1000:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1002:	02500a13          	li	s4,37
    1006:	4b55                	li	s6,21
    1008:	a839                	j	1026 <vprintf+0x4e>
        putc(fd, c);
    100a:	85ca                	mv	a1,s2
    100c:	8556                	mv	a0,s5
    100e:	00000097          	auipc	ra,0x0
    1012:	efc080e7          	jalr	-260(ra) # f0a <putc>
    1016:	a019                	j	101c <vprintf+0x44>
    } else if(state == '%'){
    1018:	01498d63          	beq	s3,s4,1032 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    101c:	0485                	addi	s1,s1,1
    101e:	fff4c903          	lbu	s2,-1(s1)
    1022:	16090563          	beqz	s2,118c <vprintf+0x1b4>
    if(state == 0){
    1026:	fe0999e3          	bnez	s3,1018 <vprintf+0x40>
      if(c == '%'){
    102a:	ff4910e3          	bne	s2,s4,100a <vprintf+0x32>
        state = '%';
    102e:	89d2                	mv	s3,s4
    1030:	b7f5                	j	101c <vprintf+0x44>
      if(c == 'd'){
    1032:	13490263          	beq	s2,s4,1156 <vprintf+0x17e>
    1036:	f9d9079b          	addiw	a5,s2,-99
    103a:	0ff7f793          	zext.b	a5,a5
    103e:	12fb6563          	bltu	s6,a5,1168 <vprintf+0x190>
    1042:	f9d9079b          	addiw	a5,s2,-99
    1046:	0ff7f713          	zext.b	a4,a5
    104a:	10eb6f63          	bltu	s6,a4,1168 <vprintf+0x190>
    104e:	00271793          	slli	a5,a4,0x2
    1052:	00000717          	auipc	a4,0x0
    1056:	66e70713          	addi	a4,a4,1646 # 16c0 <malloc+0x436>
    105a:	97ba                	add	a5,a5,a4
    105c:	439c                	lw	a5,0(a5)
    105e:	97ba                	add	a5,a5,a4
    1060:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1062:	008b8913          	addi	s2,s7,8
    1066:	4685                	li	a3,1
    1068:	4629                	li	a2,10
    106a:	000ba583          	lw	a1,0(s7)
    106e:	8556                	mv	a0,s5
    1070:	00000097          	auipc	ra,0x0
    1074:	ebc080e7          	jalr	-324(ra) # f2c <printint>
    1078:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    107a:	4981                	li	s3,0
    107c:	b745                	j	101c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    107e:	008b8913          	addi	s2,s7,8
    1082:	4681                	li	a3,0
    1084:	4629                	li	a2,10
    1086:	000ba583          	lw	a1,0(s7)
    108a:	8556                	mv	a0,s5
    108c:	00000097          	auipc	ra,0x0
    1090:	ea0080e7          	jalr	-352(ra) # f2c <printint>
    1094:	8bca                	mv	s7,s2
      state = 0;
    1096:	4981                	li	s3,0
    1098:	b751                	j	101c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    109a:	008b8913          	addi	s2,s7,8
    109e:	4681                	li	a3,0
    10a0:	4641                	li	a2,16
    10a2:	000ba583          	lw	a1,0(s7)
    10a6:	8556                	mv	a0,s5
    10a8:	00000097          	auipc	ra,0x0
    10ac:	e84080e7          	jalr	-380(ra) # f2c <printint>
    10b0:	8bca                	mv	s7,s2
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	b7a5                	j	101c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    10b6:	008b8c13          	addi	s8,s7,8
    10ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10be:	03000593          	li	a1,48
    10c2:	8556                	mv	a0,s5
    10c4:	00000097          	auipc	ra,0x0
    10c8:	e46080e7          	jalr	-442(ra) # f0a <putc>
  putc(fd, 'x');
    10cc:	07800593          	li	a1,120
    10d0:	8556                	mv	a0,s5
    10d2:	00000097          	auipc	ra,0x0
    10d6:	e38080e7          	jalr	-456(ra) # f0a <putc>
    10da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10dc:	00000b97          	auipc	s7,0x0
    10e0:	63cb8b93          	addi	s7,s7,1596 # 1718 <digits>
    10e4:	03c9d793          	srli	a5,s3,0x3c
    10e8:	97de                	add	a5,a5,s7
    10ea:	0007c583          	lbu	a1,0(a5)
    10ee:	8556                	mv	a0,s5
    10f0:	00000097          	auipc	ra,0x0
    10f4:	e1a080e7          	jalr	-486(ra) # f0a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10f8:	0992                	slli	s3,s3,0x4
    10fa:	397d                	addiw	s2,s2,-1
    10fc:	fe0914e3          	bnez	s2,10e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1100:	8be2                	mv	s7,s8
      state = 0;
    1102:	4981                	li	s3,0
    1104:	bf21                	j	101c <vprintf+0x44>
        s = va_arg(ap, char*);
    1106:	008b8993          	addi	s3,s7,8
    110a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    110e:	02090163          	beqz	s2,1130 <vprintf+0x158>
        while(*s != 0){
    1112:	00094583          	lbu	a1,0(s2)
    1116:	c9a5                	beqz	a1,1186 <vprintf+0x1ae>
          putc(fd, *s);
    1118:	8556                	mv	a0,s5
    111a:	00000097          	auipc	ra,0x0
    111e:	df0080e7          	jalr	-528(ra) # f0a <putc>
          s++;
    1122:	0905                	addi	s2,s2,1
        while(*s != 0){
    1124:	00094583          	lbu	a1,0(s2)
    1128:	f9e5                	bnez	a1,1118 <vprintf+0x140>
        s = va_arg(ap, char*);
    112a:	8bce                	mv	s7,s3
      state = 0;
    112c:	4981                	li	s3,0
    112e:	b5fd                	j	101c <vprintf+0x44>
          s = "(null)";
    1130:	00000917          	auipc	s2,0x0
    1134:	58890913          	addi	s2,s2,1416 # 16b8 <malloc+0x42e>
        while(*s != 0){
    1138:	02800593          	li	a1,40
    113c:	bff1                	j	1118 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    113e:	008b8913          	addi	s2,s7,8
    1142:	000bc583          	lbu	a1,0(s7)
    1146:	8556                	mv	a0,s5
    1148:	00000097          	auipc	ra,0x0
    114c:	dc2080e7          	jalr	-574(ra) # f0a <putc>
    1150:	8bca                	mv	s7,s2
      state = 0;
    1152:	4981                	li	s3,0
    1154:	b5e1                	j	101c <vprintf+0x44>
        putc(fd, c);
    1156:	02500593          	li	a1,37
    115a:	8556                	mv	a0,s5
    115c:	00000097          	auipc	ra,0x0
    1160:	dae080e7          	jalr	-594(ra) # f0a <putc>
      state = 0;
    1164:	4981                	li	s3,0
    1166:	bd5d                	j	101c <vprintf+0x44>
        putc(fd, '%');
    1168:	02500593          	li	a1,37
    116c:	8556                	mv	a0,s5
    116e:	00000097          	auipc	ra,0x0
    1172:	d9c080e7          	jalr	-612(ra) # f0a <putc>
        putc(fd, c);
    1176:	85ca                	mv	a1,s2
    1178:	8556                	mv	a0,s5
    117a:	00000097          	auipc	ra,0x0
    117e:	d90080e7          	jalr	-624(ra) # f0a <putc>
      state = 0;
    1182:	4981                	li	s3,0
    1184:	bd61                	j	101c <vprintf+0x44>
        s = va_arg(ap, char*);
    1186:	8bce                	mv	s7,s3
      state = 0;
    1188:	4981                	li	s3,0
    118a:	bd49                	j	101c <vprintf+0x44>
    }
  }
}
    118c:	60a6                	ld	ra,72(sp)
    118e:	6406                	ld	s0,64(sp)
    1190:	74e2                	ld	s1,56(sp)
    1192:	7942                	ld	s2,48(sp)
    1194:	79a2                	ld	s3,40(sp)
    1196:	7a02                	ld	s4,32(sp)
    1198:	6ae2                	ld	s5,24(sp)
    119a:	6b42                	ld	s6,16(sp)
    119c:	6ba2                	ld	s7,8(sp)
    119e:	6c02                	ld	s8,0(sp)
    11a0:	6161                	addi	sp,sp,80
    11a2:	8082                	ret

00000000000011a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a4:	715d                	addi	sp,sp,-80
    11a6:	ec06                	sd	ra,24(sp)
    11a8:	e822                	sd	s0,16(sp)
    11aa:	1000                	addi	s0,sp,32
    11ac:	e010                	sd	a2,0(s0)
    11ae:	e414                	sd	a3,8(s0)
    11b0:	e818                	sd	a4,16(s0)
    11b2:	ec1c                	sd	a5,24(s0)
    11b4:	03043023          	sd	a6,32(s0)
    11b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11c0:	8622                	mv	a2,s0
    11c2:	00000097          	auipc	ra,0x0
    11c6:	e16080e7          	jalr	-490(ra) # fd8 <vprintf>
}
    11ca:	60e2                	ld	ra,24(sp)
    11cc:	6442                	ld	s0,16(sp)
    11ce:	6161                	addi	sp,sp,80
    11d0:	8082                	ret

00000000000011d2 <printf>:

void
printf(const char *fmt, ...)
{
    11d2:	711d                	addi	sp,sp,-96
    11d4:	ec06                	sd	ra,24(sp)
    11d6:	e822                	sd	s0,16(sp)
    11d8:	1000                	addi	s0,sp,32
    11da:	e40c                	sd	a1,8(s0)
    11dc:	e810                	sd	a2,16(s0)
    11de:	ec14                	sd	a3,24(s0)
    11e0:	f018                	sd	a4,32(s0)
    11e2:	f41c                	sd	a5,40(s0)
    11e4:	03043823          	sd	a6,48(s0)
    11e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11ec:	00840613          	addi	a2,s0,8
    11f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f4:	85aa                	mv	a1,a0
    11f6:	4505                	li	a0,1
    11f8:	00000097          	auipc	ra,0x0
    11fc:	de0080e7          	jalr	-544(ra) # fd8 <vprintf>
}
    1200:	60e2                	ld	ra,24(sp)
    1202:	6442                	ld	s0,16(sp)
    1204:	6125                	addi	sp,sp,96
    1206:	8082                	ret

0000000000001208 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1208:	1141                	addi	sp,sp,-16
    120a:	e422                	sd	s0,8(sp)
    120c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    120e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1212:	00001797          	auipc	a5,0x1
    1216:	dfe7b783          	ld	a5,-514(a5) # 2010 <freep>
    121a:	a02d                	j	1244 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    121c:	4618                	lw	a4,8(a2)
    121e:	9f2d                	addw	a4,a4,a1
    1220:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1224:	6398                	ld	a4,0(a5)
    1226:	6310                	ld	a2,0(a4)
    1228:	a83d                	j	1266 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    122a:	ff852703          	lw	a4,-8(a0)
    122e:	9f31                	addw	a4,a4,a2
    1230:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1232:	ff053683          	ld	a3,-16(a0)
    1236:	a091                	j	127a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1238:	6398                	ld	a4,0(a5)
    123a:	00e7e463          	bltu	a5,a4,1242 <free+0x3a>
    123e:	00e6ea63          	bltu	a3,a4,1252 <free+0x4a>
{
    1242:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1244:	fed7fae3          	bgeu	a5,a3,1238 <free+0x30>
    1248:	6398                	ld	a4,0(a5)
    124a:	00e6e463          	bltu	a3,a4,1252 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    124e:	fee7eae3          	bltu	a5,a4,1242 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1252:	ff852583          	lw	a1,-8(a0)
    1256:	6390                	ld	a2,0(a5)
    1258:	02059813          	slli	a6,a1,0x20
    125c:	01c85713          	srli	a4,a6,0x1c
    1260:	9736                	add	a4,a4,a3
    1262:	fae60de3          	beq	a2,a4,121c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1266:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    126a:	4790                	lw	a2,8(a5)
    126c:	02061593          	slli	a1,a2,0x20
    1270:	01c5d713          	srli	a4,a1,0x1c
    1274:	973e                	add	a4,a4,a5
    1276:	fae68ae3          	beq	a3,a4,122a <free+0x22>
    p->s.ptr = bp->s.ptr;
    127a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    127c:	00001717          	auipc	a4,0x1
    1280:	d8f73a23          	sd	a5,-620(a4) # 2010 <freep>
}
    1284:	6422                	ld	s0,8(sp)
    1286:	0141                	addi	sp,sp,16
    1288:	8082                	ret

000000000000128a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    128a:	7139                	addi	sp,sp,-64
    128c:	fc06                	sd	ra,56(sp)
    128e:	f822                	sd	s0,48(sp)
    1290:	f426                	sd	s1,40(sp)
    1292:	f04a                	sd	s2,32(sp)
    1294:	ec4e                	sd	s3,24(sp)
    1296:	e852                	sd	s4,16(sp)
    1298:	e456                	sd	s5,8(sp)
    129a:	e05a                	sd	s6,0(sp)
    129c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    129e:	02051493          	slli	s1,a0,0x20
    12a2:	9081                	srli	s1,s1,0x20
    12a4:	04bd                	addi	s1,s1,15
    12a6:	8091                	srli	s1,s1,0x4
    12a8:	0014899b          	addiw	s3,s1,1
    12ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12ae:	00001517          	auipc	a0,0x1
    12b2:	d6253503          	ld	a0,-670(a0) # 2010 <freep>
    12b6:	c515                	beqz	a0,12e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ba:	4798                	lw	a4,8(a5)
    12bc:	02977f63          	bgeu	a4,s1,12fa <malloc+0x70>
  if(nu < 4096)
    12c0:	8a4e                	mv	s4,s3
    12c2:	0009871b          	sext.w	a4,s3
    12c6:	6685                	lui	a3,0x1
    12c8:	00d77363          	bgeu	a4,a3,12ce <malloc+0x44>
    12cc:	6a05                	lui	s4,0x1
    12ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12d6:	00001917          	auipc	s2,0x1
    12da:	d3a90913          	addi	s2,s2,-710 # 2010 <freep>
  if(p == (char*)-1)
    12de:	5afd                	li	s5,-1
    12e0:	a895                	j	1354 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    12e2:	00001797          	auipc	a5,0x1
    12e6:	12678793          	addi	a5,a5,294 # 2408 <base>
    12ea:	00001717          	auipc	a4,0x1
    12ee:	d2f73323          	sd	a5,-730(a4) # 2010 <freep>
    12f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12f8:	b7e1                	j	12c0 <malloc+0x36>
      if(p->s.size == nunits)
    12fa:	02e48c63          	beq	s1,a4,1332 <malloc+0xa8>
        p->s.size -= nunits;
    12fe:	4137073b          	subw	a4,a4,s3
    1302:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1304:	02071693          	slli	a3,a4,0x20
    1308:	01c6d713          	srli	a4,a3,0x1c
    130c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    130e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1312:	00001717          	auipc	a4,0x1
    1316:	cea73f23          	sd	a0,-770(a4) # 2010 <freep>
      return (void*)(p + 1);
    131a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    131e:	70e2                	ld	ra,56(sp)
    1320:	7442                	ld	s0,48(sp)
    1322:	74a2                	ld	s1,40(sp)
    1324:	7902                	ld	s2,32(sp)
    1326:	69e2                	ld	s3,24(sp)
    1328:	6a42                	ld	s4,16(sp)
    132a:	6aa2                	ld	s5,8(sp)
    132c:	6b02                	ld	s6,0(sp)
    132e:	6121                	addi	sp,sp,64
    1330:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1332:	6398                	ld	a4,0(a5)
    1334:	e118                	sd	a4,0(a0)
    1336:	bff1                	j	1312 <malloc+0x88>
  hp->s.size = nu;
    1338:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    133c:	0541                	addi	a0,a0,16
    133e:	00000097          	auipc	ra,0x0
    1342:	eca080e7          	jalr	-310(ra) # 1208 <free>
  return freep;
    1346:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    134a:	d971                	beqz	a0,131e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    134c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    134e:	4798                	lw	a4,8(a5)
    1350:	fa9775e3          	bgeu	a4,s1,12fa <malloc+0x70>
    if(p == freep)
    1354:	00093703          	ld	a4,0(s2)
    1358:	853e                	mv	a0,a5
    135a:	fef719e3          	bne	a4,a5,134c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    135e:	8552                	mv	a0,s4
    1360:	00000097          	auipc	ra,0x0
    1364:	b92080e7          	jalr	-1134(ra) # ef2 <sbrk>
  if(p == (char*)-1)
    1368:	fd5518e3          	bne	a0,s5,1338 <malloc+0xae>
        return 0;
    136c:	4501                	li	a0,0
    136e:	bf45                	j	131e <malloc+0x94>
