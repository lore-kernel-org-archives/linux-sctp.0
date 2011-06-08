From: Michio Honda <micchie@sfc.wide.ad.jp>
Date: Wed, 08 Jun 2011 06:57:50 +0000
Subject: Re: sctp: Add ASCONF operation on the single-homed host
Message-Id: <87E26258-BFE2-474F-928B-410D22B2AD4F@sfc.wide.ad.jp>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110608065302.GF3846@shale.localdomain>
In-Reply-To: <20110608065302.GF3846@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Exactly, thanks.  
I will post a patch to fix it in a few days.  

Best regards
- Michio

On Jun 8, 2011, at 15:53 , Dan Carpenter wrote:

> This code was added in 8a07eb0a50a "sctp: Add ASCONF operation on
> the single-homed host".
> 
>   784                  if ((laddr = NULL) && (addrcnt = 1)) {
>   785                          if (asoc->asconf_addr_del_pending)
>   786                                  continue;
>   787                          asoc->asconf_addr_del_pending >   788                              kzalloc(sizeof(union sctp_addr), GFP_ATOMIC);
>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 	We need some error handling here if the allocation fails.
> 
>   789                          asoc->asconf_addr_del_pending->sa.sa_family >   790                                      addrs->sa_family;
>   791                          asoc->asconf_addr_del_pending->v4.sin_port >   792                                      htons(bp->port);
> 
> regards,
> dan carpenter

