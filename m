From: Joe Perches <joe@perches.com>
Date: Thu, 27 Jun 2013 01:05:04 +0000
Subject: Re: [PATCH net-next 1/2] lib: vsprintf: add IPv4/v6 generic %pig/%pIg format specifier
Message-Id: <1372295104.2172.26.camel@joe-AO722>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372266073-11998-1-git-send-email-dborkman@redhat.com>
	 <1372266073-11998-2-git-send-email-dborkman@redhat.com>
In-Reply-To: <1372266073-11998-2-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Wed, 2013-06-26 at 19:01 +0200, Daniel Borkmann wrote:
> In order to avoid making code that deals with printing both, IPv4 and
> IPv6 addresses, unnecessary complicated as for example ...
> 
>   if (sa.sa_family = AF_INET6)
>     printk("... %pI6 ...", sin6_addr);
>   else
>     printk("... %pI4 ...", sin_addr.s_addr);
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1093,6 +1093,18 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
[]
> +		case 'g':
> +			{

This is overly indented.

Just use:
		case 'g': {
			etc...

(%pig looks poorly named though)

I'd prefer "%piS" for "struct sockaddr"

Some other options might be to add port, flowinfo or scope,

See: http://patchwork.ozlabs.org/patch/31480/


