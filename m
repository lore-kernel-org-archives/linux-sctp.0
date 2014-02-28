From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 28 Feb 2014 23:30:09 +0000
Subject: Re: net: sctp: rework multihoming retransmission path selection to rfc4960
Message-Id: <53111C01.40203@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140228231512.GA22115@elgon.mountain>
In-Reply-To: <20140228231512.GA22115@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/01/2014 12:15 AM, Dan Carpenter wrote:
> Hello Daniel Borkmann,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 4c47af4d5eb2: "net: sctp: rework multihoming retransmission
> path selection to rfc4960" from Feb 20, 2014, leads to the following
> Smatch complaint:
>
> net/sctp/associola.c:1322 sctp_assoc_update_retran_path()
> 	 warn: variable dereferenced before check 'trans_next' (see line 1319)
>
> net/sctp/associola.c
>    1305          /* Iterate from retran_path's successor back to retran_path. */
>    1306          for (trans = list_next_entry(trans, transports); 1;
>    1307               trans = list_next_entry(trans, transports)) {
>    1308                  /* Manually skip the head element. */
>    1309                  if (&trans->transports = &asoc->peer.transport_addr_list)
>    1310                          continue;
>    1311                  if (trans->state = SCTP_UNCONFIRMED)
>    1312                          continue;
>    1313                  trans_next = sctp_trans_elect_best(trans, trans_next);
>    1314                  /* Active is good enough for immediate return. */
>    1315                  if (trans_next->state = SCTP_ACTIVE)
>                              ^^^^^^^^^^^^^^^^^
> Dereference.

That is a false-positive.

trans_next at that time is being assigned through sctp_trans_elect_best() a
guaranteed non-NULL pointer.

>    1316                          break;
>                                  ^^^^^^
>    1317                  /* We've reached the end, time to update path. */
>    1318			if (trans = asoc->peer.retran_path)
>    1319				break;
>                                  ^^^^^
> These two breaks are the the only way to exit from the loop.
>
>    1320		}
>    1321	
>    1322		if (trans_next != NULL)
>                      ^^^^^^^^^^^^^^^^^^
> Check to late.
>
>    1323			asoc->peer.retran_path = trans_next;
>    1324	
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
