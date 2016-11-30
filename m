From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Nov 2016 11:39:23 +0000
Subject: Re: multihoming client question
Message-Id: <CADvbK_cgpzUjeB3Nm-3D7YA=xdP4d407ds=zv9haNoDc0Tbyaw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Nov 30, 2016 at 6:48 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> Dear Sir,
>
> It is found that IP X haven't replied heartbeat Ack to IP A but our
> client will not try another path B->Y.  Would you advise how B->Y path
> can be enable?
how about data sending, can it be sacked normally ?

asking that, as transport error_count would be cleared in
sctp_check_transmitted():

                        /* 8.2. When an outstanding TSN is acknowledged,
                         * the endpoint shall clear the error counter of
                         * the destination transport address to which the
                         * DATA chunk was last sent.
                         * The association's overall error counter is
                         * also cleared.
                         */
                        transport->error_count = 0;
                        transport->asoc->overall_error_count = 0;


>
> lksctp client IP info:
> Primary IP: A
> Secondary IP: B
>
> Server primary IP: X
> Server secondary IP: Y
>
> Regards,
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
