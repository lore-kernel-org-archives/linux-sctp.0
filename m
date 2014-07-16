From: David Miller <davem@davemloft.net>
Date: Wed, 16 Jul 2014 21:44:10 +0000
Subject: Re: [PATCH net-next v2 0/6] SCTP updates
Message-Id: <20140716.144410.2191854657630314423.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1405189840-31171-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1405189840-31171-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: geirola@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat, 12 Jul 2014 20:30:34 +0200

> This set improves the SCTP socket API to be more in line with
> RFC6458, Geir and myself have finalized it eventually. While
> at it, the first patch also fixes two possible information
> leaks that should go to net tree as well. For more details, I
> refer you to the patches themselves.
> 
> v1 -> v2:
>  - Added 6th patch to deprecate SCTP_SNDRCV, rest unchanged

Now that patch #1 has propagated into net-next, I applied the
rest of this series, thanks.
