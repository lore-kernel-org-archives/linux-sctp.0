From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 13 May 2009 16:12:57 +0000
Subject: Re: [PATCH] sctp: fix to choose alternate destination when retransmit
Message-Id: <4A0AF189.40207@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A097F33.5010002@cn.fujitsu.com>
In-Reply-To: <4A097F33.5010002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> RFC 5061 Section 5.1 ASCONF Chunk Procedures said:
> 
> B4)  Re-transmit the ASCONF Chunk last sent and if possible choose an
>      alternate destination address (please refer to [RFC4960],
>      Section 6.4.1).  An endpoint MUST NOT add new parameters to this
>      chunk; it MUST be the same (including its Sequence Number) as
>      the last ASCONF sent.  An endpoint MAY, however, bundle an
>      additional ASCONF with new ASCONF parameters with the next
>      Sequence Number.  For details, see Section 5.5.
> 
> This patch fix to choose an alternate destination address when
> re-transmit the ASCONF chunk, with some dup codes cleanup.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Thanks, applied.
-vlad
