From: David Miller <davem@davemloft.net>
Date: Fri, 15 Dec 2017 18:53:06 +0000
Subject: Re: [PATCHv2 net-next 0/8] sctp: Implement Stream Interleave: Interaction with Other SCTP Extensions
Message-Id: <20171215.135306.1237219753205231632.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 15 Dec 2017 00:41:24 +0800

> Stream Interleave would be implemented in two Parts:
> 
>    1. The I-DATA Chunk Supporting User Message Interleaving
>    2. Interaction with Other SCTP Extensions
> 
> Overview in section 2.3 of RFC8260 for Part 2:
> 
>    The usage of the I-DATA chunk might interfere with other SCTP
>    extensions.  Future SCTP extensions MUST describe if and how they
>    interfere with the usage of I-DATA chunks.  For the SCTP extensions
>    already defined when this document was published, the details are
>    given in the following subsections.
> 
> As the 2nd part of Stream Interleave Implementation, this patchset mostly
> adds the support for SCTP Partial Reliability Extension with I-FORWARD-TSN
> chunk. Then adjusts stream scheduler and stream reconfig to make them work
> properly with I-DATA chunks.
> 
> In the last patch, all stream interleave codes will be enabled by adding
> sysctl to allow users to use this feature.
> 
> v1 -> v2:
>   - removed the intl_enable check from sctp_chunk_event_lookup, as Marcelo's
>     suggestion.
>   - fixed a typo in changelog.

Series applied, thanks.
