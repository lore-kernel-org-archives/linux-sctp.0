From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 01 Mar 2014 08:44:26 +0000
Subject: Re: net: sctp: rework multihoming retransmission path selection to rfc4960
Message-Id: <20140301084426.GP26776@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140228231512.GA22115@elgon.mountain>
In-Reply-To: <20140228231512.GA22115@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Mar 01, 2014 at 12:30:09AM +0100, Daniel Borkmann wrote:
> On 03/01/2014 12:15 AM, Dan Carpenter wrote:
> >Hello Daniel Borkmann,
> >
> >This is a semi-automatic email about new static checker warnings.
> >
> >The patch 4c47af4d5eb2: "net: sctp: rework multihoming retransmission
> >path selection to rfc4960" from Feb 20, 2014, leads to the following
> >Smatch complaint:
> >
> >net/sctp/associola.c:1322 sctp_assoc_update_retran_path()
> >	 warn: variable dereferenced before check 'trans_next' (see line 1319)
> >
> >net/sctp/associola.c
> >   1305          /* Iterate from retran_path's successor back to retran_path. */
> >   1306          for (trans = list_next_entry(trans, transports); 1;
> >   1307               trans = list_next_entry(trans, transports)) {
> >   1308                  /* Manually skip the head element. */
> >   1309                  if (&trans->transports = &asoc->peer.transport_addr_list)
> >   1310                          continue;
> >   1311                  if (trans->state = SCTP_UNCONFIRMED)
> >   1312                          continue;
> >   1313                  trans_next = sctp_trans_elect_best(trans, trans_next);
> >   1314                  /* Active is good enough for immediate return. */
> >   1315                  if (trans_next->state = SCTP_ACTIVE)
> >                             ^^^^^^^^^^^^^^^^^
> >Dereference.
> 
> That is a false-positive.
> 
> trans_next at that time is being assigned through sctp_trans_elect_best() a
> guaranteed non-NULL pointer.
> 

Can you remove the NULL check then?

regards,
dan carpenter

