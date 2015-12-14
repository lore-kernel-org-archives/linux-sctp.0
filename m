From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 14 Dec 2015 09:53:58 +0000
Subject: RE: [PATCH 1/1] net: sctp: dynamically enable or disable pf state
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1CBEC9E2@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1449824732-22362-1-git-send-email-zyjzyj2000@gmail.com>
In-Reply-To: <1449824732-22362-1-git-send-email-zyjzyj2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "'zyjzyj2000@gmail.com'" <zyjzyj2000@gmail.com>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "alexandre.dietsch@windriver.com" <alexandre.dietsch@windriver.com>, "stefan.costandache@windriver.com" <stefan.costandache@windriver.com>

From: zyjzyj2000@gmail.com
> Sent: 11 December 2015 09:06
...
> +pf_enable - INTEGER
> +	Enable or disable pf state. A value of pf_retrans > path_max_retrans
> +	also disables pf state. That is, one of both pf_enable and
> +	pf_retrans > path_max_retrans can disable pf state. Since pf_retrans
> +	and path_max_retrans can be changed by userspace application, sometimes
> +	user expects to disable pf state by the value of
> +	pf_retrans > path_max_retrans, but ocassionally the value of pf_retrans
> +	or path_max_retrans is changed by the user application, this pf state is
> +	enabled. As such, it is necessary to add this to dynamically enable
> +	and disable pf state.
> +
> +	1: Enable pf.
> +
> +	0: Disable pf.
> +
> +	Default: 1

You ought to say what 'pf' is short for.

	David

