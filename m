From: David Miller <davem@davemloft.net>
Date: Wed, 13 Mar 2013 14:04:31 +0000
Subject: Re: [PATCH] sctp: Use correct sideffect command in duplicate cookie handling
Message-Id: <20130313.100431.523451251434580538.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1363139603-14042-1-git-send-email-vyasevich@gmail.com>
In-Reply-To: <1363139603-14042-1-git-send-email-vyasevich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 12 Mar 2013 21:53:23 -0400

> When SCTP is done processing a duplicate cookie chunk, it tries
> to delete a newly created association.  For that, it has to set
> the right association for the side-effect processing to work.
> However, when it uses the SCTP_CMD_NEW_ASOC command, that performs
> more work then really needed (like hashing the associationa and
> assigning it an id) and there is no point to do that only to
> delete the association as a next step.  In fact, it also creates
> an impossible condition where an association may be found by
> the getsockopt() call, and that association is empty.  This
> causes a crash in some sctp getsockopts.
> 
> The solution is rather simple.  We simply use SCTP_CMD_SET_ASOC
> command that doesn't have all the overhead and does exactly
> what we need.
> 
> Reported-by: Karl Heiss <kheiss@gmail.com>
> Tested-by: Karl Heiss <kheiss@gmail.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>

Applied.
