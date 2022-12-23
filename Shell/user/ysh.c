#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#define buf_size    128     // Max length of user input
#define max_args    16      // Max number of arguments

int runcmd(char *cmd);      // Run a command.

// Read a shell input.
char* readcmd(char *buf) {
    // Read an input from stdin.
    fprintf(1, "$ ");
    memset(buf, 0, buf_size);
    char *cmd = gets(buf, buf_size);
  
    // Chop off the trailing '\n'.
    if(cmd) { cmd[strlen(cmd)-1] = 0; }
  
    return cmd;
}

int main(int argc, char **argv) {
    int fd = 0;
    char *cmd = 0;
    char buf[buf_size];
  
    // Ensure three file descriptors are open.
    while((fd = open("console", O_RDWR)) >= 0) {
        if(fd >= 3) { close(fd); break; }
    }
  
    fprintf(1, "EEE3535 Operating Systems: starting ysh\n");
  
    // Read and run input commands.
    while((cmd = readcmd(buf)) && runcmd(cmd)) ;
  
    fprintf(1, "EEE3535 Operating Systems: closing ysh\n");
    exit(0);
}


// Run a command.
int runcmd(char *cmd) {
    if(!*cmd) { return 1; }                     // Empty command

    // Skip leading white space(s).
    while(*cmd == ' ') { cmd++; }
    // Remove trailing white space(s).
    for(char *c = cmd+strlen(cmd)-1; *c == ' '; c--) { *c = 0; }

    if(!strcmp(cmd, "exit")) { return 0; }      // exit command
    else if(!strncmp(cmd, "cd ", 3)) {          // cd command
        if(chdir(cmd+3) < 0) { fprintf(2, "Cannot cd %s\n", cmd+3); }
    }
    else {
        // EEE3535-01 Operating Systems
        // Assignment 3: Shell

        // ---Test Cases---
        // grep xv6 README
        // ls init
        // forktest
        // grep xv6 README | grep Unix
        // ls | grep c
        // stressfs; ls
        // rm stressfs0; ls stressfs0
        // grind &
        // ls | grep c | grep e
        // stressfs | grep read | cat | wc 
        // echo EEE3535; forktest; grep Unix README; ls mkdir; stressfs; whoami
        // forktest; grep xv6 README | grep Unix | wc; whoami | grep ID

        char* s = strchr(cmd, ';');
        char* p = strchr(cmd, '|');

        // 1. In the `else` body of `runcmd()`, check if the last character of cmd is an & sign.
        //    If so, replace this character with 0 so that `cmd` is null-terminated without the & sign at the end.
        //    Fork a child process via `fork()`, and let the child recursively process `runcmd(cmd)`.
        //    The parent process does not wait for the child.
        if (cmd[strlen(cmd) - 1] == '&') {
            cmd[strlen(cmd) - 1] = 0;
            if (fork() == 0) {
                runcmd(cmd);
            }
            // do not wait
        }
        // 2. If the last character of `cmd` is not &, then check if `cmd` contains a ; sign.
        //    char* s = strchr(cmd, ';') should return a `char` pointer to the first ; sign in `cmd`.
        //    If `cmd` does not have one, `s` gets a null pointer.
        //    Replacing the first ; character with 0 can seperate the original `cmd` into two parts.
        //    Fork a a child, and let the child recursively process `runcmd(cmd)` for part 1.
        //    The parent process also recursively calls `runcmd(s + 1)` for part 2, which will again be divided into two parts since it again contains a ; sign.
        else if (s) {
            *s = 0;
            if (fork() == 0) {
                runcmd(cmd);
                exit(0);
            }
            wait(0);
            runcmd(s + 1);
        }
        // 3. If `cmd` is not &-ended nor has a ; sign, then check if it contains | sign.
        //    The first | sign in `cmd` can be similarly found as `char* p = strchr(cmd, '|')`.
        //    Replacing the first | character with 0 can seperate `cmd` into two parts.
        //    Fork a child, and make the parent process wait for the child.
        //    The child creates a pipe and forks again to create a grandchild.
        //    Let the grand child execute the write end of the pipe by calling `runcmd(cmd)` 
        //    , and the child process runs the read end of teh pipe by calling `runcmd(p + 1)`.
        //    Since the second part again contains a pipe, the same procedure will be conducted once again in the child process.
        else if (p) {
            *p = 0;
            if (fork() == 0) {  // child
                int fd[2];
                pipe(fd);
                
                if (fork() == 0) {     // grandchild
                    close(1);
                    dup(fd[1]);
                    close(fd[0]);
                    close(fd[1]);
                    runcmd(cmd);        // left
                    exit(0);
                }
                else {                  // child
                    close(0);
                    dup(fd[0]);
                    close(fd[0]);
                    close(fd[1]);
                    runcmd(p + 1);      // right
                    exit(0);
                }
            }
            wait(0);    // make the parent process wait for the child.
        }
        // 4. If `cmd` does not fall into any cases above, this must be a single command.
        //    Parse `cmd` into an `argv[]` array, fork a child, and let the child execute the command by calling exec(argv[0], argv).
        else {
            char* argv[max_args];
            int count = 0;
            char* pp = strchr(cmd, ' ');

            // add a single command except the last one.
            // (i.e. grep xv6 [README])
            while (pp) {
                *pp = 0;
                argv[count++] = cmd; 
                cmd = pp + 1;
                pp = strchr(cmd, ' ');
            }
            // add the last one.
            argv[count++] = cmd;
            // add null
            argv[count] = 0;

            if (fork() == 0) {
                exec(argv[0], argv);
            }
            wait(0);
        }
    }
    return 1;
}
