From: Joe Perches <joe@perches.com>
Date: Wed, 30 Oct 2013 13:56:58 +0000
Subject: Re: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
Message-Id: <1383141418.12439.76.camel@joe-AO722>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
	 <1383130252-1515-2-git-send-email-dborkman@redhat.com>
In-Reply-To: <1383130252-1515-2-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 11:50 +0100, Daniel Borkmann wrote:
> This is nothing more but a whitepace cleanup, as 80 chars is not a
> hard but soft limit, and otherwise makes the test cases arrary really
> look ugly. So fix it up.

That does look nicer.

Another option might be to take the repetitive
6 leading 0's out of column 2 and the repetitive
5 leading 0's out of column 3.

> diff --git a/lib/crc32.c b/lib/crc32.c
[]
> @@ -795,206 +795,106 @@ static struct crc_test {
>  	u32 crc32c_le;	/* expected crc32c_le result */
>  } test[] >  {
> -	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1,
> -	 0xf6e93d6c},
> -	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad,
> -	 0x0fe92aca},
[etc...]
> +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> +	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad, 0x0fe92aca},

these could be

+	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
+	{0x35c672c6, 0x3a, 0x1aa, 0xc6d3dfba, 0x28aaf3ad, 0x0fe92aca},

etc...

