From: Eugene Teo <eteo@redhat.com>
Date: Thu, 28 Aug 2008 00:02:19 +0000
Subject: Re: [PATCH 2/2] sctp: fix random memory dereference with SCTP_HMAC_IDENT
Message-Id: <48B5EB0B.2030604@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com> <12198674171396-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12198674171396-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> The number of identifiers needs to be checked against the option
> length.  Also, the identifier index provided needs to be verified
> to make sure that it doesn't exceed the bounds of the array.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Acked-by: Eugene Teo <eugeneteo@kernel.sg>

Eugene
