From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 15 Apr 2014 07:08:37 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <534CDAF5.1040900@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397504717-19566-1-git-send-email-dborkman@redhat.com> <534CD523.50301@nsn.com>
In-Reply-To: <534CD523.50301@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>, Vlad Yasevich <vyasevich@gmail.com>, pbutler@sonusnet.com

Hi Matija,

[cc'ing Peter]

On 04/15/2014 08:43 AM, Alexander Sverdlin wrote:
> On 14/04/14 21:45, ext Daniel Borkmann wrote:
>> This reverts commit ef2820a735f7 ("net: sctp: Fix a_rwnd/rwnd management
>> to reflect real state of the receiver's buffer") as it introduced a
>> serious performance regression on SCTP over IPv4 and IPv6, though a not
>> as dramatic on the latter. Measurements are on 10Gbit/s with ixgbe NICs.
>
> Could you please share other HW details? I wonder how much CPU power one needs for such a throughput?

If you would like to get to know the exact specifics from the bug report,
resp. numbers from the commit message, I refer you to Peter's setup, i.e.
he used ixgbe NICs as these are one of the few with SCTP checksum
offloading available.

Thanks,

Daniel

  [1] http://www.spinics.net/lists/linux-sctp/msg03290.html
