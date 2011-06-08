From: Dan Carpenter <error27@gmail.com>
Date: Wed, 08 Jun 2011 06:53:02 +0000
Subject: re: sctp: Add ASCONF operation on the single-homed host
Message-Id: <20110608065302.GF3846@shale.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This code was added in 8a07eb0a50a "sctp: Add ASCONF operation on
the single-homed host".

   784                  if ((laddr = NULL) && (addrcnt = 1)) {
   785                          if (asoc->asconf_addr_del_pending)
   786                                  continue;
   787                          asoc->asconf_addr_del_pending    788                              kzalloc(sizeof(union sctp_addr), GFP_ATOMIC);
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	We need some error handling here if the allocation fails.

   789                          asoc->asconf_addr_del_pending->sa.sa_family    790                                      addrs->sa_family;
   791                          asoc->asconf_addr_del_pending->v4.sin_port    792                                      htons(bp->port);

regards,
dan carpenter
