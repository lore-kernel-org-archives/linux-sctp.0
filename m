From: "Horacio Sanson" <hsanson@gmail.com>
Date: Tue, 22 Apr 2008 14:36:29 +0000
Subject: Re: Latest lksctp-dev tree broke sctp_sendmsg()?
Message-Id: <6156dd8b0804220736o742aac75k7400c186ee8c94ae@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
In-Reply-To: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Apr 22, 2008 at 10:00 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Apr 22, 2008 at 09:36:59AM +0900, Horacio Sanson wrote:
>  > Thanks for the replies,
>  >
>  > On Tue, Apr 22, 2008 at 12:10 AM, Vlad Yasevich
>  > <vladislav.yasevich@hp.com> wrote:
>  > > Hi Horacio
>  > >
>  > >
>  > >  Horacio Sanson wrote:
>  > >
>  > > > I have a small echo server/client program for testing. It works in
>  > > > linux kernel 2.6.22-14 (Ubuntu) but using the latest lksctp-dev tree
>  > > > (from git) I get "invalid parameter" errors when calling
>  > > > sctp_sendmsg().
>  > > >
>  > > > Any directions are appreciated:
>  > > >
>  > >
>  > >  I just tried running this on the .git kernel with 1.0.6, 1.0.7, 1.0.8
>  > >  libraries.  It worked in all cases.
>  > >
>  >
>  > Indeed running the code using sctp-tools 1.0.8 in kernel 2.6.22 works
>  > flawlessly. But with the latest kernel from git (2.6.25-rc8) it does
>  > not work. It gives me "invalid parameter" errors when calling
>  > sctp_sendmsg().
>  >
>  Are you using the sctp-tools packaged by ubuntu, or building them yourself?  I
>  wouldn't  think this to be the case, but its possible that the maintainer at
>  ubuntu included a patch unique to their distro's sctp-tools thats breaking your
>  setup.  I'd check their packaging metadata for something like that.
>
>  Neil
>
>

I am using the lksctp-dev kernel and the lksctp-tools both up to date
from git repository. I also checked that the only libsctp library I
have is the one from git and made sure to load the sctp kernel
modules.

I must mention that this program worked fine before with kernel
2.6.25-rc3 but after a recent update of lksctp-dev to 2.6.25-rc8  a
few days ago it started failing.....

For now I will keep working with the 2.6.22 kernel.

thanks
Horacio
>
>
>  > I am no good at kernel development, but any tips on how to debug this
>  > are appreciated.
>  >
>  > regards,
>  > Horacio
>  >
>  > >  The test was run over loopback with
>  > >  # client 127.0.0.1 9 "Stream 9"
>  > >
>  > >  If you are trying to use more then 10 streams (0 - 9), then you
>  > >  need to tell lksctp that using SCTP_INITMSG socket option or ancillary
>  > >  data.  This is what's most likely generating an error for you (at least
>  > >  that did it for me).
>  > >
>  > >  -vlad
>  > >
>  > >
>  > > >
>  > > >
>  > > >
>  > > >
>  > > > Horacio
>  > > >
>  > > >
>  > > >
>  > > > ###############
>  > > > # server code
>  > > > ###############
>  > > > #include <stdlib.h>
>  > > > #include <stdio.h>
>  > > > #include <strings.h>
>  > > > #include <string.h>
>  > > > #include <errno.h>
>  > > > #include <sys/socket.h>
>  > > > #include <netinet/in.h>
>  > > > #include <netinet/sctp.h>
>  > > >
>  > > > #define MAXLINE     255
>  > > > #define LISTENQ     1024
>  > > > #define SERV_PORT   9879
>  > > > #define BUFFSIZE    8192
>  > > >
>  > > > int main(int arvc, char **argv)
>  > > > {
>  > > >    int sock_fd, msg_flags, ret;
>  > > >    char readbuf[BUFFSIZE];
>  > > >
>  > > >    struct sockaddr_in servaddr, cliaddr;
>  > > >    struct sctp_sndrcvinfo sri;
>  > > >    struct sctp_event_subscribe evnts;
>  > > >
>  > > >    socklen_t len;
>  > > >    size_t rd_sz;
>  > > >
>  > > >    sock_fd = socket(AF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
>  > > >
>  > > >    if(sock_fd < 0) {
>  > > >        printf("socket creation error\n");
>  > > >        perror("socket");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    bzero(&servaddr,sizeof(servaddr));
>  > > >    servaddr.sin_family = AF_INET;
>  > > >    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
>  > > >    servaddr.sin_port = htons(SERV_PORT);
>  > > >
>  > > >    bind(sock_fd, (struct sockaddr *) &servaddr, sizeof(servaddr));
>  > > >
>  > > >    bzero(&evnts,sizeof(evnts));
>  > > >
>  > > >    evnts.sctp_data_io_event = 1;
>  > > >    ret = setsockopt(sock_fd, IPPROTO_SCTP, SCTP_EVENTS, &evnts,
>  > > sizeof(evnts));
>  > > >
>  > > >    if(ret < 0) {
>  > > >        printf("error setting socket options\n");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    ret = listen(sock_fd, LISTENQ);
>  > > >
>  > > >    if(ret < 0) {
>  > > >        printf("error linstening socket\n");
>  > > >        perror("listen");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >
>  > > >    for(;;) {
>  > > >        len = sizeof(struct sockaddr_in);
>  > > >        rd_sz = sctp_recvmsg(sock_fd, readbuf, sizeof(readbuf),
>  > > >                             (struct sockaddr *) &cliaddr, &len,
>  > > >                              &sri, &msg_flags);
>  > > >
>  > > >        if(rd_sz <= 0) {
>  > > >            continue;
>  > > >        }
>  > > >
>  > > >        printf("From str:%d seq:%d (assoc:0x%x):",
>  > > >               sri.sinfo_stream,sri.sinfo_ssn,
>  > > >               (u_int)sri.sinfo_assoc_id);
>  > > >        printf("%.*s\n",rd_sz,readbuf);
>  > > >
>  > > >        sctp_sendmsg(sock_fd, readbuf, rd_sz, (struct sockaddr *)&cliaddr,
>  > > >                     len, sri.sinfo_ppid, sri.sinfo_flags,sri.sinfo_stream,
>  > > >                     0,0);
>  > > >    }
>  > > > }
>  > > >
>  > > >
>  > > >
>  > > >
>  > > > ###############
>  > > > # client code
>  > > > ###############
>  > > > #include <stdlib.h>
>  > > > #include <stdio.h>
>  > > > #include <strings.h>
>  > > > #include <string.h>
>  > > > #include <errno.h>
>  > > > #include <sys/socket.h>
>  > > > #include <netinet/in.h>
>  > > > #include <netinet/sctp.h>
>  > > >
>  > > > #define MAXLINE     255
>  > > > #define LISTENQ     1024
>  > > > #define SERV_PORT   9879
>  > > > #define BUFFSIZE    8192
>  > > >
>  > > >
>  > > > int main(int argc, char **argv)
>  > > > {
>  > > >    int sock_fd, ret;
>  > > >    struct sockaddr_in servaddr;
>  > > >    struct sctp_sndrcvinfo sri;
>  > > >    struct sctp_event_subscribe evnts;
>  > > >    char sendline[MAXLINE], recvline[MAXLINE];
>  > > >    socklen_t len;
>  > > >    int wr_sz, rd_sz;
>  > > >    int msg_flags;
>  > > >
>  > > >    if(argc < 4) {
>  > > >        printf("Usage: %s [server_ip] [strno] [message]\n",argv[0]);
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    sock_fd = socket(AF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
>  > > >
>  > > >    if(sock_fd < 0) {
>  > > >        printf("socket creation error\n");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    bzero(&servaddr, sizeof(servaddr));
>  > > >    servaddr.sin_family = AF_INET;
>  > > >    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
>  > > >    servaddr.sin_port = htons(SERV_PORT);
>  > > >
>  > > >    ret = inet_pton(AF_INET, argv[1], &servaddr.sin_addr);
>  > > >    if(ret < 0) {
>  > > >        perror("inet_pton");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    bzero(&evnts, sizeof(evnts));
>  > > >    evnts.sctp_data_io_event = 1;
>  > > >    ret = setsockopt(sock_fd, IPPROTO_SCTP, SCTP_EVENTS, &evnts,
>  > > sizeof(evnts));
>  > > >
>  > > >    if(ret < 0) {
>  > > >        printf("error setting socket options\n");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    len = sizeof(struct sockaddr_in);
>  > > >    bzero(&sri, sizeof(sri));
>  > > >    sri.sinfo_stream = strtol(argv[2],NULL,0);
>  > > >    snprintf(sendline,MAXLINE,"%s",argv[3]);
>  > > >    wr_sz = strlen(sendline);
>  > > >
>  > > >    printf("Say str:%d  msg: %s\n",sri.sinfo_stream, sendline);
>  > > >
>  > > >    ret = sctp_sendmsg(sock_fd, sendline, wr_sz, (struct sockaddr *)
>  > > &servaddr,
>  > > >                       len,0,0,sri.sinfo_stream,0,0);
>  > > >
>  > > >    if(ret < 0) {
>  > > >        perror("sctp_sendmsg");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    len = sizeof(servaddr);
>  > > >
>  > > >    rd_sz = sctp_recvmsg(sock_fd, recvline, sizeof(recvline),
>  > > >                         (struct sockaddr *)&servaddr, &len,
>  > > >                          &sri,&msg_flags);
>  > > >
>  > > >    if(rd_sz < 0) {
>  > > >        perror("sctp_recvmsg");
>  > > >        exit(1);
>  > > >    }
>  > > >
>  > > >    printf("echo str:%d seq:%d (assoc:0x%x):",
>  > > >           sri.sinfo_stream,sri.sinfo_ssn,
>  > > >           (u_int)sri.sinfo_assoc_id);
>  > > >    printf("%.*s\n",rd_sz,recvline);
>  > > >
>  > > > }
>  > > >
>  > > > --
>  > > > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>  > > > the body of a message to majordomo@vger.kernel.org
>  > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > > >
>  > > >
>  > >
>  > >
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  --
>  /****************************************************
>
>  * Neil Horman <nhorman@tuxdriver.com>
>   * Software Engineer, Red Hat
>   ****************************************************/
>
