From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 27 Aug 2013 13:59:42 +0000
Subject: Re: [PATCH net-next] net: sctp: sctp_verify_init: clean up mandatory checks and add comment
Message-Id: <521CB0CE.3000806@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377609830-10193-1-git-send-email-dborkman@redhat.com> <20130827134302.GB7619@hmsreliant.think-freely.org>
In-Reply-To: <20130827134302.GB7619@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 08/27/2013 03:43 PM, Neil Horman wrote:

> nit: If we're making this easier to review, I think the above would be easier to
> read if it said:
> Note: Initial TSN is also mandatory, but is not checked here since the valid
> range is 0..2**(32-1)

Ok, will send a v2 in a moment.
