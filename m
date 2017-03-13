From: David Miller <davem@davemloft.net>
Date: Mon, 13 Mar 2017 06:22:45 +0000
Subject: Re: [PATCHv2 net-next 0/7] sctp: add receiver-side procedures for stream reconf asoc reset and add s
Message-Id: <20170312.232245.410360677237076869.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1489118815.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1489118815.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 10 Mar 2017 12:11:05 +0800

> Patch 2/7, 4/7, 5/7, 6/7 are to implement the process of asoc reset request,
> add streams requests and all kinds of responses.
> 
> Patch 1/7 and 3/7 are ahead of 2/7 and 4/7 to add two event notification
> for asoc reset and add streams.
> 
> Patch 7/7 is the last patch for implementing rfc6525 sctp stream reconf
> to add sysctl and sockopt interface for users to enable sctp stream reconf.
> 
> After this patchset, sctp stream reconf will be able to work as rfc6525.
> 
> v1->v2:
>   - put these into a smaller group.
>   - rename the titles of the commits and improve some changelogs.
>   - improve sctp_chunk_lookup_strreset_param and reuse it in patch 4/7.
>   - process addstrm outreq as the ack of in addstrm inreq if strreset_chunk
>     is not NULL in patch 4/7.
>   - remove the stream alloc when sending addstrm inreq, and the process in
>     peer will response it by sending a addstrm out request back in patch 5/7.
>   - adjust the process of addstrm in resp to fit in the codes that only alloc
>     streams through addstrm outreq in patch 6/7.

Series applied, thanks.
