From: David Miller <davem@davemloft.net>
Date: Mon, 11 Dec 2017 16:23:33 +0000
Subject: Re: [PATCHv2 net-next 00/12] sctp: Implement Stream Interleave: The I-DATA Chunk Supporting User Mes
Message-Id: <20171211.112333.782901553664685729.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri,  8 Dec 2017 21:03:57 +0800

> Stream Interleave would be Implemented in two Parts:
> 
>    1. The I-DATA Chunk Supporting User Message Interleaving
>    2. Interaction with Other SCTP Extensions
 ...
> As the 1st part of Stream Interleave Implementation, this patchset adds
> an ops framework named sctp_stream_interleave with a bunch of stuff that
> does lots of things needed somewhere.
> 
> Then it defines sctp_stream_interleave_0 to work for normal DATA chunks
> and sctp_stream_interleave_1 for I-DATA chunks.
> 
> With these functions, hundreds of if-else checks for the different process
> on I-DATA chunks would be avoided. Besides, very few codes could be shared
> in these two function sets.
> 
> In this patchset, it adds some basic variables, structures and socket
> options firstly, then implement these functions one by one to add the
> procedures for ordered idata gradually, at last adjusts some codes to
> make them work for unordered idata.
> 
> To make it safe to be implemented and also not break the normal data
> chunk process, this feature can't be enabled to use until all stream
> interleave codes are completely accomplished.
> 
> v1 -> v2:
>   - fixed a checkpatch warning that a blank line was missed.
>   - avoided a kbuild warning reported from gcc-4.9.

Series applied, thanks Xin.
