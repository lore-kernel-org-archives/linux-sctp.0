From: Joshua Kinard <kumba@gentoo.org>
Date: Fri, 10 Oct 2014 10:04:23 +0000
Subject: Re: [PATCH net 1/3] net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
Message-Id: <5437AF27.2030506@gentoo.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com> <1412888133-833-2-git-send-email-dborkman@redhat.com>
In-Reply-To: <1412888133-833-2-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On 10/09/2014 16:55, Daniel Borkmann wrote:
> Commit 6f4c618ddb0 ("SCTP : Add paramters validity check for
> ASCONF chunk") added basic verification of ASCONF chunks, however,
> it is still possible to remotely crash a server by sending a
> special crafted ASCONF chunk, even up to pre 2.6.12 kernels:
> 
> skb_over_panic: text:ffffffffa01ea1c3 len:31056 put:30768
>  head:ffff88011bd81800 data:ffff88011bd81800 tail:0x7950
>  end:0x440 dev:<NULL>
>  ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:129!
> [...]
> Call Trace:
>  <IRQ>
>  [<ffffffff8144fb1c>] skb_put+0x5c/0x70
>  [<ffffffffa01ea1c3>] sctp_addto_chunk+0x63/0xd0 [sctp]
[snip]
> 
> This can be triggered e.g., through a simple scripted nmap
> connection scan injecting the chunk after the handshake, for
> example, ...
> 
>   -------------- INIT[ASCONF; ASCONF_ACK] ------------->
>   <----------- INIT-ACK[ASCONF; ASCONF_ACK] ------------
>   -------------------- COOKIE-ECHO -------------------->
>   <-------------------- COOKIE-ACK ---------------------
>   ------------------ ASCONF; UNKNOWN ------------------>
> 
> ... where ASCONF chunk of length 280 contains 2 parameters ...
> 
>   1) Add IP address parameter (param length: 16)
>   2) Add/del IP address parameter (param length: 255)
> 
> ... followed by an UNKNOWN chunk of e.g. 4 bytes. Here, the
> Address Parameter in the ASCONF chunk is even missing, too.
> This is just an example and similarly-crafted ASCONF chunks
> could be used just as well.

If I am reading correctly, this crash can only be triggered by actually getting
through the SCTP handshake, then sending this specially-crafted ASCONF chunk?
Meaning a blind nmap scan using this tactic against a random netblock wouldn't
just randomly knock servers offline?  This would seem to reduce the attack
surface a quite bit by requiring the remote endpoint to actually respond.

Is there a CVE # for this?

Thanks!,

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
