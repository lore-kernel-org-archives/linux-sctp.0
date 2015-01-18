From: David Miller <davem@davemloft.net>
Date: Sun, 18 Jan 2015 04:53:54 +0000
Subject: Re: [PATCH net] net: sctp: fix race for one-to-many sockets in sendmsg's auto associate
Message-Id: <20150117.235354.784017919774639035.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1421336075-25061-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1421336075-25061-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 15 Jan 2015 16:34:35 +0100

 ...
> The fix defers waiting after sctp_primitive_ASSOCIATE() and
> sctp_primitive_SEND() succeeded, so that DATA chunks cooked up
> from sctp_sendmsg() have already been placed into the output
> queue through the side-effect interpreter, and therefore can then
> be bundeled together with COOKIE_ECHO control chunks.
 ...
> Looks like this bug is from the pre-git history museum. ;)
> 
> Fixes: 08707d5482df ("lksctp-2_5_31-0_5_1.patch")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks.
