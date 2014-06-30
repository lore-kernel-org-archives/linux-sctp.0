From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 30 Jun 2014 13:04:50 +0000
Subject: Re: [PATCH net-next 2/2] net: sctp: only warn in proc_sctp_do_alpha_beta if write
Message-Id: <20140630130450.GB2941@minipsycho.orion>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404129129-23270-1-git-send-email-dborkman@redhat.com>
 <1404129129-23270-3-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404129129-23270-3-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Mon, Jun 30, 2014 at 01:52:09PM CEST, dborkman@redhat.com wrote:
>Only warn if the value is written to alpha or beta. We don't care
>emitting a one-time warning when only reading it.
>
>Reported-by: Jiri Pirko <jpirko@redhat.com>
>Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Reviewed-by: Jiri Pirko <jiri@resnulli.us>
