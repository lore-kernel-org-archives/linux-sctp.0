From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 08 Aug 2014 14:05:58 +0000
Subject: Re: MSG_EOR flag in conjunction with SOCK_STREAM
Message-Id: <53E4D946.5030500@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E38504E@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E38504E@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 08/07/2014 05:08 PM, Butler, Peter wrote:
> A question about using a SOCK_STREAM socket (one-to-one TCP-style) and checking for the MSG_EOR flag.
> 
> If, on a given association (i.e. a single file descriptor, as per the one-to-one TCP-style SOCK_STREAM socket semantics), a message is received via sctp_recvmsg() with the MSG_EOR flag *not* set (such that more of the message is yet to be retrieved), does LKSCTP guarantee that the subsequent call to sctp_recvmsg() will still pertain to the same message (i.e. record)?
> 
> That is, could the following message sequence (as returned by sctp_recvmsg(); not necessarily in this order on the wire) ever occur in subsequent calls to sctp_recvmsg() on the aforementioned file descriptor?
> 
> MSG A, part 1
> MSG A, part 2
> MSG A, part 3
> MSG B
> MSG A, part 4
> MSG A, part 5 (EOR)
> .
> .
> .
> 
> Or will the kernel always guarantee the following:
> 
> MSG A, part 1
> MSG A, part 2
> MSG A, part 3
> MSG A, part 4
> MSG A, part 5 (EOR)
> MSG B
> .
> .
> .
> 

On Linux,  I believe that the above is guaranteed on a SOCK_STREAM socket.  Linux
doesn't currently implement interleaving level 2.  The default is level 0 (no
interleaving). Level 1 is supported (association interleaving), but it only really
functions on 1-many sockets.  Level 2 (inter-stream interleaving) is not supported
yet.

> If the former is indeed possible, can the 'interleaving' only occur within separate streams of the association?  Or can it also occur within a single given stream?
> 
> Can unordered data ever cause this to occur?
> 

Not currently on linux.

-vlad


> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

