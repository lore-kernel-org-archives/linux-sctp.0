From: Danny Smit <danny.smit.0@gmail.com>
Date: Sat, 07 Mar 2015 19:44:24 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <CACoz=-zqwzaRZbysV_pv_wgrjNDbMuDN7ys=csZLCg7aWTyxCg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I changed my code to reflect this, but it doesn't really make a
difference. For what its worth, I already tried something similar with
an higher level API to wait for socket notification, which led to the
same results.

Whats interesting is that the poll() call returns immediately (within
milliseconds) regardless of the timeout value. It does set "revents"
on the struct in [sfd], of which the very first occurrence of this
call sets revents to 73 (0x49), but all subsequent calls to poll
within the loop shown above sets revents to 65 (0x48).

If I'm correct this would mean:

0x49 = POLLIN | POLLERR | POLLRDNORM
0x41 = POLLIN | POLLRDNORM

I'm not sure where the first POLLERR comes from and what to conclude
based on this. However the other flag do seem to indicate that there
is data available to be read.

But every call to sctp_recvmsg() still returns with an error and sets
errno to 107 (ENOTCONN). Therefore sctp_recvmsg somehow still seems
unable to read the events.

On Fri, Mar 6, 2015 at 5:29 PM, Adam Endrodi <adam.endrodi@nokia.com> wrote:
> On Fri, Mar 06, 2015 at 04:42:57PM +0100, ext Danny Smit wrote:
>> On Fri, Mar 6, 2015 at 12:13 PM, Adam Endrodi wrote:
>> > On Fri, Mar 06, 2015 at 11:52:05AM +0100, ext Danny Smit wrote:
>> >>
>> >> The scenario is simple:
>> >> - call socket() to create a socket.
>> >> - call sctp_connectx() to establish a connection.
>> >>
>> >> The last call is repeated periodically to retry to establish a connection.
>> >>
>> >> When looking on the wire using wireshark it shows that an SCTP INIT
>> >> packet is sent to the second host, which replies with an SCTP ABORT.
>> >>
>> >> This is exactly according to the SCTP specification. However it
>> >> appears ABORT isn't propagated into to application layer that calls
>> >> sctp_connectx().
>> > [...]
>> >> Note that the API is used in non-blocking mode.
>> >
>> > This case sctp_connectx() doesn't wait until the connection is established.
>> > You need to use sctp_recvmsg() to get the notification.
>>
>> I tried to apply this as suggested, the scenario now is as follows:
>>
>> First call sctp_connectx() on a socket in non blocking mode, which
>> results in the error code EINPROGRESS.
>>
>> Next call sctp_recvmsg(), which results in the error code ENOTCONN
>> instead of getting any notifications.
>>
>> This actually feels right because there is no connection established
>> yet. It also doesn't seem to make a difference for the memory
>> consumption. Am I missing something?
>
> How about something like:
>
> for (;;)
> {
>         sctp_connectx(sfd);
>         poll([sfd], -1);
>         sctp_recvmsg(sfd);
> }
>
> --
> adam
