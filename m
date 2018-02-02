From: Tommi Rantala <tt.rantala@gmail.com>
Date: Fri, 02 Feb 2018 08:27:41 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <CA+ydwtrgw+kuOkZC=o33fNZqr6WtVoTKAiE46z=RFjNkc0kV5g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130155909.GA25399@hmswarspite.think-freely.org> <085a2abc-36e3-74fd-8c3a-9352bdd05cf8@nokia.com>
 <20180130210353.GB25399@hmswarspite.think-freely.org> <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
 <20180131123105.GB23692@hmswarspite.think-freely.org> <aba6d3c5-4b26-5e61-e4c4-e5925749cd1e@nokia.com>
 <CA+ydwtpiPeFuOB9PyCiOiKhzx69Ecu9mMt2ut=t0F-dwrt40Sg@mail.gmail.com> <893a7e36-5124-ab2b-9408-0de5fac392b5@oracle.com>
In-Reply-To: <893a7e36-5124-ab2b-9408-0de5fac392b5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Kodanev <alexey.kodanev@oracle.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

2018-02-02 1:57 GMT+02:00 Alexey Kodanev <alexey.kodanev@oracle.com>:
> For ipv6 part, shouldn't we release 'bdst' there if the previous address
> match is better and we continue to the next iteration?

Good catch!

Didn't see that one.

Tommi

> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 5d4c15b..a044096 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -336,8 +336,11 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>                 }
>
>                 bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
> -               if (matchlen > bmatchlen)
> +               if (matchlen > bmatchlen) {
> +                       if (!IS_ERR(bdst))
> +                               dst_release(bdst);
>                         continue;
> +               }
>
>                 if (!IS_ERR_OR_NULL(dst))
>                         dst_release(dst);
>
> Thanks,
> Alexey
