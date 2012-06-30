From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 30 Jun 2012 12:17:48 +0000
Subject: possible integer underflow in __sctp_auth_cid()
Message-Id: <20120630121748.GD22767@elgon.mountain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

In 555d3d5d "SCTP: Fix chunk acceptance when no authenticated chunks
were listed.", we added a check for if (param->param_hdr.length = 0).
Shouldn't that check be a check for if
(param->param_hdr.length < sizeos(sizeof(sctp_paramhdr_t)))?  Otherwise,
when we do the substraction on the next line we would unintentionally
end up with a high positive number.

I had a similar question about sctp_auth_ep_add_chunkid():

net/sctp/auth.c
   770          /* Check if we can add this chunk to the array */
   771          param_len = ntohs(p->param_hdr.length);
   772          nchunks = param_len - sizeof(sctp_paramhdr_t);
   773          if (nchunks = SCTP_NUM_CHUNK_TYPES)
   774                  return -EINVAL;
   775
   776          p->chunks[nchunks] = chunk_id;

If param_len is less than sizeof(sctp_paramhdr_t) we could write past
the end of the array.  There are a couple other places with this same
subtraction as well.

regards,
dan carpenter
