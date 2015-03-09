From: Danny Smit <danny.smit.0@gmail.com>
Date: Mon, 09 Mar 2015 13:15:46 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <CACoz=-wLEggYo3RcibBQdC-hUYM-iQy1wXVoRvatU9s54ZMeJQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Mar 9, 2015 at 10:40 AM, Adam Endrodi <adam.endrodi@nokia.com> wrote:
> On Sat, Mar 07, 2015 at 08:44:24PM +0100, ext Danny Smit wrote:
>> Whats interesting is that the poll() call returns immediately (within
>> milliseconds) regardless of the timeout value. It does set "revents"
>> on the struct in [sfd], of which the very first occurrence of this
>> call sets revents to 73 (0x49), but all subsequent calls to poll
>> within the loop shown above sets revents to 65 (0x48).
>
> So POLLERR (0x08) is reported in all cases.  Perhaps this is the indication
> of ABORT you're looking for?

I noticed I made a small mistake in the hexadecimal numbers:

The first occurrence gives: 73 (0x49)
All subsequent occurences give: 65 (0x41)

Therefore only the first occurrence includes POLLERR (0x08).

My apologies for the confusion.


I'm still a bit confused about how this is supposed to work though. Is
the POLLERR really the way to go? It doesn't seem to be described
anywhere, rfc6458 doesn't seem to be conclusive about this particular
case (where an ABORT is returned on the SCTP handshake in NON_BLOCKING
mode).

Furthermore I did find a man page which states: "The sctp_recvmsg()
call is used by one-to-one (SOCK_STREAM) type sockets after a
successful connect() call"
Although this originates from FreeBSD
(http://www.freebsd.org/cgi/man.cgi?query=sctp_recvmsg&manpath=FreeBSD+8.0-RELEASE),
this makes me believe that I'm not supposed to use sctp_recvmsg()
before the connection is successfully established. However in
non-blocking mode, how is an ABORT supposed to be detected without
sctp_recvmsg()?


>> But every call to sctp_recvmsg() still returns with an error and sets
>> errno to 107 (ENOTCONN). Therefore sctp_recvmsg somehow still seems
>> unable to read the events.
>
> I'm out of ideas :( Time to involve real experts I guess.

Thanks anyway for trying to help out, it is very much appreciated! I
hope someone can shed some light on this.
