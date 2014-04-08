From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 08 Apr 2014 17:20:16 +0000
Subject: Re: [PATCH net v2] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <53442FD0.5020609@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1396970773-17500-1-git-send-email-dborkman@redhat.com> <53442A62.3050905@redhat.com> <20140408.131819.1373401078750444800.davem@davemloft.net>
In-Reply-To: <20140408.131819.1373401078750444800.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com, vyasevic@redhat.com

On 04/08/2014 07:18 PM, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Tue, 08 Apr 2014 18:57:06 +0200
>
>> Hm, I still found an issue, please hold on with this one, thanks.
>
> Ugh too late I pushed it out, you'll need to send a relative fix.

No problem, will do, thanks. I suggest to take it out from
the stable queue for now. Sorry for any inconvenience.
