From: Petr Malat <oss@malat.biz>
Date: Wed, 11 Jul 2018 09:12:30 +0000
Subject: Re: [PATCH net] sctp: Free connecting association if there is a pending signal
Message-Id: <20180711091230.p4cd3kairm5zdwmp@ntb.petris.klfree.czf>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="pdmdkbtfxazf3pdj"
List-Id: <linux-sctp.vger.kernel.org>
References: <20180709101142.GA1820@bordel.klfree.net>
In-Reply-To: <20180709101142.GA1820@bordel.klfree.net>
To: linux-sctp@vger.kernel.org


--pdmdkbtfxazf3pdj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!
On Mon, Jul 09, 2018 at 03:08:37PM -0400, Neil Horman wrote:
> > This is questionable as the reason for sending the signal can be a request to
> > terminate the connection attempt.
> > 
> That may be, but the kernel has no notion of that.  If thats the intent, then
> the correct approach is to catch the signal in question in the application and
> close the socket.  That way you get the behvaior you are coding here, and the
> application knows whats going on.
Yes, that's another possible way how it could be implemented, however it
it's not possible to close only one association as the association number
is not known to the user at that time (which is not a problem for former
TCP apps).

> > > Thats why Linux deviates from the
> > > standard and return EINPROGRESS, and requires that you check the SO_ERROR value
> > > to determine if the connection is successfull (SO_ERROR == 0), or if its still
> > > pending (note in the connect man page that you can select/poll a in-progress
> > > socket for writeability to determine completion of the connection operation).
> > It's not a generic Linux problem as TCP doesn't suffer from this discrepancy, it
> > exists only in linux-sctp. Also, this behavior is not documented anywhere.
> > 
> That doesn't seem to be the case to me.  If you look at the tcp_v4_connect
> path its pretty clear that a non-blocking socket will return EINPROGRESS if the
> connect operation is interrupted.
I have extended the test to make it clear what I complain about - it's
the first case, but not the only case where the behavior differs from
TCP:

$ ./a.out | ts "%H:%M:%S" # Empty lines added for readability
10:45:46 Testing IPPROTO_SCTP on a blocking socket
10:45:49   1st connect - rtn: -1 errno: 114 (Operation already in progress)
10:45:49   2nd connect - rtn: -1 errno: 114 (Operation already in progress)
10:45:49 Testing IPPROTO_TCP on a blocking socket
10:46:52   1st connect - rtn: -1 errno: 110 (Connection timed out)
10:47:55   2nd connect - rtn: -1 errno: 110 (Connection timed out)

10:47:55 Testing IPPROTO_SCTP on a timeo blocking socket
10:47:58   1st connect - rtn: -1 errno: 4 (Interrupted system call)
10:47:58   2nd connect - rtn: -1 errno: 114 (Operation already in progress)
10:47:58 Testing IPPROTO_TCP on a timeo blocking socket
10:48:01   1st connect - rtn: -1 errno: 4 (Interrupted system call)
10:49:01   2nd connect - rtn: -1 errno: 110 (Connection timed out)

10:49:01 Testing IPPROTO_SCTP on a non-blocking socket
10:49:01   1st connect - rtn: -1 errno: 115 (Operation now in progress)
10:49:01   2nd connect - rtn: -1 errno: 114 (Operation already in progress)
10:49:01 Testing IPPROTO_TCP on a non-blocking socket
10:49:01   1st connect - rtn: -1 errno: 115 (Operation now in progress)
10:49:01   2nd connect - rtn: -1 errno: 114 (Operation already in progress)

10:49:01 Testing IPPROTO_SCTP on a timeo blocking socket
10:49:04   1st connect - rtn: -1 errno: 4 (Interrupted system call)
10:49:04   2nd connect - rtn: -1 errno: 114 (Operation already in progress)
10:49:04 Testing IPPROTO_TCP on a timeo blocking socket
10:49:07   1st connect - rtn: -1 errno: 4 (Interrupted system call)
10:50:07   2nd connect - rtn: -1 errno: 110 (Connection timed out)

All these differences except the first one are not violating what one
can read in the documentation as nothing explicitly says if a signal 
delivery on a non-blocking or sndtimeo socket should terminate the ongoing
connection attempt, but the first case is clearly not aligned with the
documentation, which says EINPROGRESS arrives only on non-blocking and
non-timeo sockets.
 
> > To sum it up, the current documention and code are not aligned and one of them needs
> > to be fixed.
> Based on your description, it sounds like the behavior is actually correct for
> non-blocking sockets.  The real problem is that a blocking socket is behaving
> like a non-blocking socket, which does seem like a legitimate issue.
> sctp_wait_for_connect will return EINPROGESS if the timeo pointer points to a
> value that is zero.  I would think the best course of action is to figure out
> why a socket might have that timeout set that way if its not non-blocking
I can look further and try to  change the patch to free the association
only for blocking sockets, but that leads me to a question what is
actually the intended behavior for these cases, should SCTP be as close
to TCP as possible (to make s/IPPROTO_TCP/IPPROTO_SCTP/ working for
most applications)?
BR,
  Petr

--pdmdkbtfxazf3pdj
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="test_all_cases.c"

#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>

#define DEAD_IP "127.16.0.1"
#define fail_if(arg) if (0 != (arg)) { \
	fprintf(stderr, "Failed at %d: %s\n", __LINE__, #arg);\
	return 1; };

void handler(int sig)
{
	// printf("Got signal %d\n", sig);
}

int _test(int proto, int timeo, int blocking)
{
	struct sockaddr_in addr4 = { .sin_family = AF_INET, .sin_port = htons(5555) };
	struct sockaddr *deadaddr = (struct sockaddr *)&addr4;
	struct sigaction sa = { .sa_handler = handler, .sa_flags = SA_RESTART }; 
	struct timeval tv = { .tv_sec = 300 };
	int sk, rtn;

	fail_if(1 != inet_pton(AF_INET, DEAD_IP, &addr4.sin_addr));
	fail_if(0 > (sk = socket(PF_INET,
			SOCK_STREAM | (blocking ? 0 : SOCK_NONBLOCK), proto)));
	if (timeo) {
		fail_if(setsockopt(sk, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof tv));
	}
	fail_if(sigaction(SIGALRM, &sa, NULL));
	fail_if(alarm(3) < 0);

	rtn = connect(sk, deadaddr, sizeof *deadaddr);

	printf("  1st connect - rtn: %d errno: %d (%s)\n", rtn, errno, strerror(errno));
	rtn = connect(sk, deadaddr, sizeof *deadaddr);
	printf("  2nd connect - rtn: %d errno: %d (%s)\n", rtn, errno, strerror(errno));

	close(sk);
	return 0;
}

#define test(proto, timeo, blocking) \
	(printf("Testing " #proto " on a %s%sblocking socket\n", \
		timeo ? "timeo " : "", blocking ? "" : "non-"), \
		_test(proto, timeo, blocking))

int main(int argc, char *argv[])
{
	setlinebuf(stdout);
	fail_if(system("iptables -I OUTPUT -d " DEAD_IP "/32 -j DROP"));
	test(IPPROTO_SCTP, 0, 1);
	test(IPPROTO_TCP, 0, 1);
	test(IPPROTO_SCTP, 1, 1);
	test(IPPROTO_TCP, 1, 1);
	test(IPPROTO_SCTP, 0, 0);
	test(IPPROTO_TCP, 0, 0);
	test(IPPROTO_SCTP, 1, 1);
	test(IPPROTO_TCP, 1, 1);
	fail_if(system("iptables -D OUTPUT -d " DEAD_IP "/32 -j DROP"));
}

--pdmdkbtfxazf3pdj--
