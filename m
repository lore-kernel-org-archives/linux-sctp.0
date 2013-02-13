From: David Miller <davem@davemloft.net>
Date: Wed, 13 Feb 2013 19:06:07 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: minor: make jsctp_sf_eat_sack static
Message-Id: <20130213.140607.144614341798606281.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360752304.git.dborkman@redhat.com>
	<7eef4b701794c1bb78819bc6e6c45bf99b49801d.1360752304.git.dborkman@redhat.com>
	<20130213.140436.521031425285650154.davem@davemloft.net>
In-Reply-To: <20130213.140436.521031425285650154.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 13 Feb 2013 14:04:36 -0500 (EST)

> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Wed, 13 Feb 2013 12:03:49 +0100
> 
>> The function jsctp_sf_eat_sack can be made static, no need to extend
>> its visibility.
>> 
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> 
> It's exported for the jprobe lookup by ->symbol_name
> 
> Did you test this?

Never mind, I mis-read this, the symbol name is for the routine being
shadowed by the jprobe, which is exported.

These two patches look fine and I'll apply them, thanks Daniel.
