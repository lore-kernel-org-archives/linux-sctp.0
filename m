From: David Miller <davem@davemloft.net>
Date: Thu, 09 Feb 2017 22:02:08 +0000
Subject: Re: [PATCHv4 net-next 0/7] net: dst_confirm replacement
Message-Id: <20170209.170208.999235350231796696.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1486415657-14714-1-git-send-email-ja@ssi.bg>
        <20170207.131134.567606043153504044.davem@davemloft.net>
        <alpine.LFD.2.11.1702082245270.2608@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1702082245270.2608-c1lBKlETG9EWAawoAK+ZAw@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ja-FgGsKACvmQM@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Julian Anastasov <ja@ssi.bg>
Date: Wed, 8 Feb 2017 23:05:36 +0200 (EET)

> On Tue, 7 Feb 2017, David Miller wrote:
> 
>> > - Now may be old function neigh_output() should be restored
>> > instead of dst_neigh_output?
>> 
>> Please elaborate.
> 
> 	As dst_neigh_output does not use the dst arg anymore,
> my idea was to rename dst_neigh_output to neigh_output, i.e.
> just like it was before commit 5110effee8fd ("net: Do delayed neigh 
> confirmation."

This sounds like a great idea.
