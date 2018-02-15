From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 15 Feb 2018 08:11:26 +0000
Subject: [bug report] sctp: remove the useless check in sctp_renege_events
Message-Id: <20180215081126.GA16057@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello Xin Long,

This is a semi-automatic email about new static checker warnings.

The patch fb23403536ea: "sctp: remove the useless check in
sctp_renege_events" from Feb 12, 2018, leads to the following Smatch
complaint:

    net/sctp/stream_interleave.c:970 sctp_renege_events()
    warn: variable dereferenced before check 'chunk' (see line 957)

net/sctp/stream_interleave.c
   956	
   957		needed = ntohs(chunk->chunk_hdr->length) -
                               ^^^^^^^^^^^^^^^^
We removed the check for "chunk"

   958			 sizeof(struct sctp_idata_chunk);
   959	
   960		if (skb_queue_empty(&asoc->base.sk->sk_receive_queue)) {
   961			freed = sctp_ulpq_renege_list(ulpq, &ulpq->lobby, needed);
   962			if (freed < needed)
   963				freed += sctp_ulpq_renege_list(ulpq, &ulpq->reasm,
   964							       needed);
   965			if (freed < needed)
   966				freed += sctp_ulpq_renege_list(ulpq, &ulpq->reasm_uo,
   967							       needed);
   968		}
   969	
   970		if (chunk && freed >= needed)
                    ^^^^^
so we should probably remove it here.

   971			if (sctp_ulpevent_idata(ulpq, chunk, gfp) <= 0)
   972				sctp_intl_start_pd(ulpq, gfp);

regards,
dan carpenter
