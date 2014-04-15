From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Date: Tue, 15 Apr 2014 06:43:47 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <534CD523.50301@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397504717-19566-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1397504717-19566-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ext Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>, Vlad Yasevich <vyasevich@gmail.com>

Hello Daniel,

On 14/04/14 21:45, ext Daniel Borkmann wrote:
> This reverts commit ef2820a735f7 ("net: sctp: Fix a_rwnd/rwnd management
> to reflect real state of the receiver's buffer") as it introduced a
> serious performance regression on SCTP over IPv4 and IPv6, though a not
> as dramatic on the latter. Measurements are on 10Gbit/s with ixgbe NICs.

Could you please share other HW details? I wonder how much CPU power one needs for such a throughput?

-- 
Best regards,
Alexander Sverdlin.
