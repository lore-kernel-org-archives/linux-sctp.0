From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 30 Oct 2013 13:39:14 +0000
Subject: Re: [lksctp-developers] [PATCH] sctp_status: server side should also receive msg_cnt times
Message-Id: <52710C02.9030903@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382842583-890-1-git-send-email-liuhangbin@gmail.com>
In-Reply-To: <1382842583-890-1-git-send-email-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/27/2013 03:56 AM, Hangbin Liu wrote:
> As client side send msg_cnt times for each repeat. Server will exit too early
> if we only receive one time for each repeat and leave client keep sent, which
> makes client could not exit normally
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Ok, applied, thanks.
