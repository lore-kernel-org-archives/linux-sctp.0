From: "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Date: Fri, 28 Feb 2020 13:57:00 +0000
Subject: Re: Problems with peeled-off sockets
Message-Id: <HE1PR0702MB3610F8DFB115DA9D35D71A76ECEB0@HE1PR0702MB3610.eurprd07.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <HE1PR0702MB36104FDAA4369769A3A69704EC100@HE1PR0702MB3610.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB36104FDAA4369769A3A69704EC100@HE1PR0702MB3610.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, 27 Feb 2020, Xin Long wrote:

> On Tue, Feb 25, 2020 at 3:28 AM Leppanen, Jere (Nokia - FI/Espoo)
> <jere.leppanen@nokia.com> wrote:
>>
>> On Sat, 22 Feb 2020, Xin Long wrote:
>>
>>> On Thu, Feb 20, 2020 at 5:18 PM Leppanen, Jere (Nokia - FI/Espoo)
>>> <jere.leppanen@nokia.com> wrote: 
>>>>
>>>> Hello All,
>>>>  
>>>> According to the RFC, a peeled-off socket is a one-to-one socket. But
>>>> in lksctp a peeled-off socket it not TCP style, it's UDP_HIGH_BANDWIDTH
>>>> style. Because of this, shutdown() doesn't work, linger probably
>>>> doesn't work, and so on.
>>>>                 
>>>> For example, in sctp_shutdown():
>>>> 
>>>> static void sctp_shutdown(struct sock *sk, int how)
>>>> {
>>>>         struct net *net = sock_net(sk);
>>>>         struct sctp_endpoint *ep;
>>>>
>>>>         if (!sctp_style(sk, TCP))
>>>>                 return;
>>>>
>>>> Here we just bail out, because a peeled-off socket is not TCP style.
>>>>
>>>> Is this just a bug, or am I missing something? Asking mostly out of  
>>>> personal curiosity.
>>> I would say, it's because .shutdown is tcp_prot thing and udp_prot doesn't
>>> have. sctp doesn't have to implement it for UDP style socket. But for TCP-
>>> style socket, sctp is trying to be compatible with TCP protocol user API.
>>> But even though,  sctp's .shutdown is still not fully compatible with TCP
>>> protocol due to sctp's 3-way shakehands for finishing a connection.
>>
>> Thanks a bunch for replying, Xin Long. I'm not quite sure what you mean.
>> The actual association shutdown doesn't even come into play here, since
>> shutdown() doesn't do anything with peeled-off sockets.
> Hi,  Leppanen,
> sorry for late.
> 
> SCTP has two types of sockets: UDP and TCP styles.
> TCP style associations are not allowed to be peeled off.
> only UDP style associations can be peeled off.
> 
> Then shutdown can only work for TCP style, this explains
> why peeled-off sk can use shutdown.
> 
>
>> 
>> If you mean that the current implementation of shutdown() might have
>> some problems with peeled-off sockets; well, that's true, but I suppose 
>> that means that there's something to fix somewhere.
> I think it returns for peeled-off sockets (UDP style sockets) on purpose.
> it's like why you want to use shutdown on a UDP socket?
> 
>>
>> It looks like the reason for the peculiar socket style of peeled-off
>> sockets is that they're created by copying from a one-to-many socket and
>> modified a little to resemble a one-to-one socket. But this leads to   
>> problems in several places in the code. Is this just implementation that
>> was never finalized?  
> Right, peeled-off will allow users to use a new sk to control that asoc.
> but again, it's a feature UDP style socket.
> any other problems have you seen?

To clarify, by "peeled-off socket" I mean a socket returned by
sctp_peeloff(). sctp_peeloff() takes as an argument a
one-to-many socket, and returns a one-to-one socket.

The RFC (https://tools.ietf.org/html/rfc6458#section-9.2)
clearly states about the socket returned by sctp_peeloff() that
"[...] the new socket is a one-to-one style socket."
