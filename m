From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 01 Jul 2019 08:29:20 +0000
Subject: Re: Unable to call SCTP_ADD_STREAMS twice?
Message-Id: <CADvbK_cdjw+a-HoBuuop7njwCwrrkV2_oSWiv5zF-UngxnUbtw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHVEBDeOjt7LbMk=aP1QOzowtxvR+iLKgxM37bXTr=2GEhTu6w@mail.gmail.com>
In-Reply-To: <CAHVEBDeOjt7LbMk=aP1QOzowtxvR+iLKgxM37bXTr=2GEhTu6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Jun 29, 2019 at 4:34 AM TJ Corley <tjcorley30@gmail.com> wrote:
>
> I am creating a library and it appears I am unable to call setsockopt
> with the option SCTP_ADD_STREAMS on the same same socket twice. On the
> second attempt it will return EINPROGRESS no matter what. It appears
> this is happening due to the fact that
> asoc->strreset_outstanding is still set. However if I am reading the
> code correctly when I call the socket option sctp_send_reconf will be
> called with a param of type SCTP_PARAM_RESET_ADD_OUT_STREAMS which
> should eventually trigger the chain of  sctp_sf_do_reconf
> ->sctp_process_strreset_outreq which will decrement
> asoc->strreset_outstanding.
>
> I have SCTP_RECONFIG_SUPPORTED enabled and SCTP_ENABLE_RESET set to
> SCTP_ENABLE_CHANGE_ASSOC_REQ | SCTP_ENABLE_RESET_STREAM_REQ |
> SCTP_ENABLE_RESET_ASSOC_REQ on all the relevant sockets. Is there
> anything else I should be doing?
Yes, you need to do:

# sysctl -w net.sctp.reconf_enable=1

which is like a main switch for all sctp socket.

>
> I have included my sample code below that triggers this behavior.
>
> Thanks for all the help,
>
> TJ
>
> #include <arpa/inet.h>
> #include <errno.h>
> #include <linux/sctp.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/socket.h>
> #include <sys/uio.h>
> #include <unistd.h>
>
> int allow_reconfigure_support(int fd) {
>   struct sctp_assoc_value params;
>
>   params.assoc_value = 1;
>   params.assoc_id = 0;
>   return setsockopt(fd, IPPROTO_SCTP, SCTP_RECONFIG_SUPPORTED, &params,
>                     sizeof(params));
> }
>
> int allow_reset(int fd) {
>
>   struct sctp_assoc_value params;
>
>   params.assoc_id = 0;
>   params.assoc_value = SCTP_ENABLE_CHANGE_ASSOC_REQ |
>                        SCTP_ENABLE_RESET_STREAM_REQ |
>                        SCTP_ENABLE_RESET_ASSOC_REQ;
>
>   return setsockopt(fd, IPPROTO_SCTP, SCTP_ENABLE_STREAM_RESET, &params,
>                     sizeof(params));
> }
>
> int add_streams(int fd, int num_streams) {
>
>   struct sctp_add_streams addstr;
>   addstr.sas_outstrms = num_streams;
>   addstr.sas_instrms = 0x00;
>   addstr.sas_assoc_id = 0;
>
>   return setsockopt(fd, IPPROTO_SCTP, SCTP_ADD_STREAMS, &addstr,
>                     sizeof(addstr));
> }
>
> int main() {
>   struct sockaddr_in in, out;
>   socklen_t out_len;
>   int server;
>   int client;
>   int accept_fd;
>   int err;
>   memset(&in, '\x00', sizeof(in));
>
>   in.sin_family = AF_INET;
>   in.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
>   in.sin_port = htons(12346);
>
>   server = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
>   client = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
>
>   if (server = -1 || client = -1) {
>     printf("socket(): %s\n", strerror(errno));
>     return -1;
>   }
>
>   if (allow_reconfigure_support(server)) {
>     printf("server allow_reconfigure_support: %s\n", strerror(errno));
>   }
>
>   if (allow_reset(client)) {
>     printf("client allow_reset: %s\n", strerror(errno));
>   }
>
>   if (allow_reconfigure_support(client)) {
>     printf("client allow_reconfigure_support: %s\n", strerror(errno));
>   }
>
>   if (allow_reset(client)) {
>     printf("client allow_reset: %s\n", strerror(errno));
>   }
>
>   printf("server fd: %d\n", server);
>   printf("client fd: %d\n", client);
>
>   err = bind(server, (void *)&in, sizeof(in));
>   if (err = -1) {
>     printf("bind: %s\n", strerror(errno));
>     return -1;
>   }
>
>   err = listen(server, 1);
>   if (err = -1) {
>     printf("listen: %s\n", strerror(errno));
>     return -1;
>   }
>
>   err = connect(client, (void *)&in, sizeof(in));
>   if (err = -1) {
>     printf("connect: %s\n", strerror(errno));
>     return -1;
>   }
>
>   accept_fd = accept(server, (void *)&out, &out_len);
>   if (accept_fd = -1) {
>     printf("accept: %s\n", strerror(errno));
>     return -1;
>   }
>   printf("accept_fd: %d\n", accept_fd);
>
>   if (allow_reconfigure_support(accept_fd)) {
>     printf("accept_fd allow_reconfigure_support: %s\n", strerror(errno));
>   }
>
>   if (allow_reset(accept_fd)) {
>     printf("accept_fd allow_reset: %s\n", strerror(errno));
>   }
>
>   err = add_streams(accept_fd, 0x10);
>   if (err = -1) {
>     printf("add_streams: %s\n", strerror(errno));
>     return -1;
>   }
>
>   sleep(1);
>
>   err = add_streams(accept_fd, 0x10);
>   if (err = -1) {
>     printf("add_streams2: %s\n", strerror(errno));
>     return -1;
>   }
>
>   printf("finished no errors\n");
> }
