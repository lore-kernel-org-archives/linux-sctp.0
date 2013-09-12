From: David Miller <davem@davemloft.net>
Date: Thu, 12 Sep 2013 21:26:40 +0000
Subject: Re: [PATCH net v2] net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
Message-Id: <20130912.172640.1787268200692982351.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1378911516-15942-1-git-send-email-dborkman@redhat.com>
	<52308C88.10604@gmail.com>
In-Reply-To: <52308C88.10604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, adobriyan@gmail.com, steffen.klassert@secunet.com, hannes@stressinduktion.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 11 Sep 2013 11:30:16 -0400

> On 09/11/2013 10:58 AM, Daniel Borkmann wrote:
>> Alan Chester reported an issue with IPv6 on SCTP that IPsec traffic is
>> not
>> being encrypted, whereas on IPv4 it is. Setting up an AH + ESP
>> transport
>> does not seem to have the desired effect:
...
>> Reported-by: Alan Chester <alan.chester@tekelec.com>
>> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> Cc: Steffen Klassert <steffen.klassert@secunet.com>
>> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied and queued up for -stable, thanks.

Yeah it is tricky to share a common transmit path with the
way SCTP works.
