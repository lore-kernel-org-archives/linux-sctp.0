From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 08 Apr 2014 17:13:46 +0000
Subject: Re: [PATCH net] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <53442E4A.2090004@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1396964037-13245-1-git-send-email-dborkman@redhat.com> <20140408.125032.810691136561418545.davem@davemloft.net>
In-Reply-To: <20140408.125032.810691136561418545.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com

On 04/08/2014 12:50 PM, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Tue,  8 Apr 2014 15:33:57 +0200
> 
>>  [ When net-next opens up again, we need to think how
>>    we can ideally make a new list interface and simplify
>>    both open-coded list traversals. ]
> 
> I don't think you need a new list interface.
> 
> Instead, just have a back pointer to the sctp_sk() from the asoc, then
> you can do normal list traversals over the asocs.

We already have that, but doing so will give preference to first
association and possibly starving the last one.

This starvation avoidance is the whole point of having a per-association
accounting.

-vlad

