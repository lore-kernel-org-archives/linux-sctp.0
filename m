From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 09 Jul 2018 12:15:12 +0000
Subject: Re: [PATCH net] sctp: Free connecting association if there is a pending signal
Message-Id: <20180709121512.GA11116@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180709101142.GA1820@bordel.klfree.net>
In-Reply-To: <20180709101142.GA1820@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 09, 2018 at 12:11:44PM +0200, Petr Malat wrote:
> Hi!
> I believe signal handling in the connect path is not implemented properly
> as connect() terminates with EINPROGRESS instead of being restarted after
> the signal handler returns (see attached sctp_connect_intr_bug.c).
> I went through the POSIX manual pages and it seems EINPROGRESS can be
> returned only if the socket is nonblocking. Linux documentation also
> mention connect() could fail with EINPROGRESS if SO_SNDTIMEO expires (this
> option is not discussed by POSIX manual pages). This is also how TCP
> behaves.
> I was able to solve the issue by freeing the association in the signal
> handling path, see the attached sctp_connect_intr.patch, which also contains
> the rationale for the change.
> Please, review the change as I based it on code comments which may be obsolete
> and I do not have knowledge of SCTP stack internals.
> BR,
>   Petr

I'm not sure what exactly you are trying to solve here.  You can't restart a
connect() system call because there may be packets on the wire that are
implementing the state transitions needed to establish the connection you
requested.  Theres no way for the local system to determine if that state
transition has completed properly yet or not.  Terminating the connection as you
are doing here leads to significant traffic overhead for what might otherwise be
in most cases a successfull connection.  Thats why Linux deviates from the
standard and return EINPROGRESS, and requires that you check the SO_ERROR value
to determine if the connection is successfull (SO_ERROR = 0), or if its still
pending (note in the connect man page that you can select/poll a in-progress
socket for writeability to determine completion of the connection operation).

Sorry, but this doesn't seem like its actually fixing anything. 

Also, in the future, if you want to submit a patch, you'll want to do so using
the patch posting guidelines in the documentation, or it won't get integrated.

Regards
Neil

> #include <sys/socket.h>
> #include <sys/types.h>
> #include <arpa/inet.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <signal.h>
> #include <string.h>
> #include <errno.h>
> #include <stdio.h>
> 
> #define DEAD_IP "127.16.0.1"
> #define fail_if(arg) if (0 != (arg)) { \
> 	fprintf(stderr, "Failed at %d: %s\n", __LINE__, #arg);\
> 	return 1; }
> 
> void handler(int sig)
> {
> 	printf("Got signal %d\n", sig);
> }
> 
> int main(int argc, char *argv[])
> {
> 	struct sockaddr_in addr4 = { .sin_family = AF_INET, .sin_port = htons(5555) };
> 	struct sockaddr *deadaddr = (struct sockaddr *)&addr4;
> 	struct sigaction sa = { .sa_handler = handler, .sa_flags = SA_RESTART }; 
> 	int sk, rtn;
> 
> 	fail_if(1 != inet_pton(AF_INET, DEAD_IP, &addr4.sin_addr));
> 
> 	fail_if(system("iptables -I OUTPUT -d " DEAD_IP "/32 -j DROP"));
> 
> 	fail_if(0 > (sk = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP)));
> 	fail_if(sigaction(SIGALRM, &sa, NULL));
> 	fail_if(alarm(3) < 0);
> 
> 	rtn = connect(sk, deadaddr, sizeof *deadaddr);
> 
> 	// The call should either resume the operation of fail with EINTR
> 	printf("rtn: %d errno: %d (%s)\n", rtn, errno, strerror(errno));
> 
> 	fail_if(system("iptables -D OUTPUT -d " DEAD_IP "/32 -j DROP"));
> 
> 	return 0;
> }

> sctp: Free connecting association if there is a pending signal
> 
> When a connection attempt is interrupted by a signal, there are two
> possibilities how the process can continue:
>  - There has been a timeout specified through SO_SNDTIMEO, in that case
>    the call must terminate the association and return -EINTR, because
>    it's not possible to restart the call safely as the timeout is
>    not an argument of the connect or SCTP_SOCKOPT_CONNECTX call.
>  - If the connect timeout has not been limited, it's possible to restart
>    the call, however the association must be freed as well to make that
>    possible. Theoretically, one could pick up the ongoing association in
>    the restart path, but the problem is we can't esily detect if
>    the syscall restarting wasn't disabled by the user.
> As a result, it's sensible to free the association independently if the
> connect attempt is being restarted or not.
> 
> Signed-off-by: Petr Malat <oss@malat.biz>
> --- linux-4.18-rc3.orig/net/sctp/socket.c	2018-07-09 11:46:51.991717457 +0200
> +++ linux-4.18-rc3/net/sctp/socket.c	2018-07-05 15:17:29.292657471 +0200
> @@ -8456,6 +8456,7 @@ do_error:
>  	goto out;
>  
>  do_interrupted:
> +	sctp_association_free(asoc);
>  	err = sock_intr_errno(*timeo_p);
>  	goto out;
>  

