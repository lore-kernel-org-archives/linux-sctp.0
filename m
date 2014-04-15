From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 15 Apr 2014 08:57:45 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <534CF489.1020007@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397504717-19566-1-git-send-email-dborkman@redhat.com> <20140414.164839.2032159104530481155.davem@davemloft.net> <534CF1CB.9090502@nsn.com>
In-Reply-To: <534CF1CB.9090502@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Cc: ext David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, matija.glavinic-pecotic.ext@nsn.com, vyasevich@gmail.com, Peter Butler <pbutler@sonusnet.com>

On 04/15/2014 10:46 AM, Alexander Sverdlin wrote:
...
> Should not this be fixed actually in SCTP congestion control part?
> RWND calculation is actually not responsible for congestion control.
> And this revert actually introduces serious bug again, which leads to SCTP being stuck completely in particular
> multi-homed use-cases (refer to http://www.spinics.net/lists/linux-sctp/msg02516.html).
>
> We are not arguing against another version of the patch, but:
> - you are choosing speed instead of stability here
> - you are masking the problem reverting the code, which is not responsible for the problem observed

So on 10Gbit Ethernet it is reasonable to regress from 2Gbit down to 50Mbit???
Did you actually measure that? I'm not arguing against the original approach to
the fix, but you need to rework that for net-next just differently as Vlad
already stated, that's all.
