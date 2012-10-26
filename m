From: "David Laight" <David.Laight@ACULAB.COM>
Date: Fri, 26 Oct 2012 09:00:13 +0000
Subject: RE: [PATCH] sctp: Clean up type-punning in sctp_cmd_t union
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B706F@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1351198075-20385-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1351198075-20385-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org

> Subject: [PATCH] sctp: Clean up type-punning in sctp_cmd_t union
...
> +#define SCTP_NULL_BYTE 0xAA
>  static inline sctp_arg_t SCTP_NULL(void)
>  {
> -	sctp_arg_t retval; retval.ptr = NULL; return retval;
> +	sctp_arg_t retval;
> +	memset(&retval, SCTP_NULL_BYTE, sizeof(sctp_arg_t));
> +	return retval;
>  }

You really don't want to be taking the address of a local
variable that would normally be held in a register.
It stops the compiler doing a lot of optimisations.
In this case the structure is also being returned by value,
not nice except that all(?) modern ABI do pass small structures
in registers.

An assignment of some member of the union to NULL would
seem most appropriate.
OTOH the code that uses this must be someones 'bright idea (tm)'
that probably wasn't such a good idea after all.

	David



