From: David Miller <davem@davemloft.net>
Date: Tue, 06 Sep 2016 22:57:57 +0000
Subject: Re: [RFC PATCH v2 1/6] proc: Reduce cache miss in {snmp,netstat}_seq_show
Message-Id: <20160906.155757.924163804989771884.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1473129009-20478-1-git-send-email-hejianet@gmail.com>
        <1473129009-20478-2-git-send-email-hejianet@gmail.com>
In-Reply-To: <1473129009-20478-2-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hejianet@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, vyasevich@gmail.com, nhorman@tuxdriver.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au

From: Jia He <hejianet@gmail.com>
Date: Tue,  6 Sep 2016 10:30:04 +0800

> +#define MAX(a, b) ((u32)(a) >= (u32)(b) ? (a) : (b))

Please do not define private min/max macros, use the existing max_t()
or similar as needed.
