From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 10 Mar 2015 19:28:58 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <54FF45FA.9010804@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/09/2015 09:15 AM, Danny Smit wrote:
> On Mon, Mar 9, 2015 at 10:40 AM, Adam Endrodi <adam.endrodi@nokia.com> wrote:
>> On Sat, Mar 07, 2015 at 08:44:24PM +0100, ext Danny Smit wrote:
>>> Whats interesting is that the poll() call returns immediately (within
>>> milliseconds) regardless of the timeout value. It does set "revents"
>>> on the struct in [sfd], of which the very first occurrence of this
>>> call sets revents to 73 (0x49), but all subsequent calls to poll
>>> within the loop shown above sets revents to 65 (0x48).
>>
>> So POLLERR (0x08) is reported in all cases.  Perhaps this is the indication
>> of ABORT you're looking for?
>
> I noticed I made a small mistake in the hexadecimal numbers:
>
> The first occurrence gives: 73 (0x49)
> All subsequent occurences give: 65 (0x41)
>
> Therefore only the first occurrence includes POLLERR (0x08).
>
> My apologies for the confusion.
>
>
> I'm still a bit confused about how this is supposed to work though. Is
> the POLLERR really the way to go? It doesn't seem to be described
> anywhere, rfc6458 doesn't seem to be conclusive about this particular
> case (where an ABORT is returned on the SCTP handshake in NON_BLOCKING
> mode).
>
> Furthermore I did find a man page which states: "The sctp_recvmsg()
> call is used by one-to-one (SOCK_STREAM) type sockets after a
> successful connect() call"
> Although this originates from FreeBSD
> (http://www.freebsd.org/cgi/man.cgi?query=sctp_recvmsg&manpath=FreeBSD+8.0-RELEASE),
> this makes me believe that I'm not supposed to use sctp_recvmsg()
> before the connection is successfully established. However in
> non-blocking mode, how is an ABORT supposed to be detected without
> sctp_recvmsg()?
>
>

Ouch.  Looking at the sctp_recvmsg() code, one of the first things
we do is return error if the socket is not connected.  I agree that this makes
it absolutely impossible to receive any kind of notification data about
connection termination in the case of a 1-to-1 socket.

I think that check really needs to take into consideration the state
of the socket receive queue.

Can you try this patch.

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2625ecc..14fc29d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2077,7 +2077,8 @@ static int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,

 	lock_sock(sk);

-	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED)) {
+	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
+	    skb_queue_empty(&sk->sk_receive_queue)) {
 		err = -ENOTCONN;
 		goto out;
 	}

Thanks
-vlad
