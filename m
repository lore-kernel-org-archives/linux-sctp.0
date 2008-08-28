From: Eugene Teo <eteo@redhat.com>
Date: Thu, 28 Aug 2008 00:01:45 +0000
Subject: Re: [PATCH 1/2] sctp: correct bounds check in sctp_setsockopt_auth_key
Message-Id: <48B5EAE9.9090704@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com> <12198674162757-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12198674162757-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> The bonds check to prevent buffer overlflow was not exactly
> right.  It still allowed overflow of up to 8 bytes which is
> sizeof(struct sctp_authkey).
> 
> Since optlen is already checked against the size of that struct,
> we are guaranteed not to cause interger overflow either.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Acked-by: Eugene Teo <eugeneteo@kernel.sg>

Eugene
