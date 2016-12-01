From: tsoi andrew <tsoiandrew@gmail.com>
Date: Thu, 01 Dec 2016 07:04:07 +0000
Subject: Re: multihoming client question
Message-Id: <CAJ0j_Bb42iLOekbXDTcuVsLYU6_vZzqfhFy2ixpx_tyQE=VuJg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Sir,

The connection is broken so that no data is sending at this moment.
While testing failover(force no heartbeat ack replied from the IP X),
I find that IP A try to send the heartbeat to IP Y but no heartbeat
ack finally.  Can lksctp client try to send heartbeat from IP B to IP
Y?     As only connection between IP B and IP Y is valid at that time.

Regards,
Andrew

On Wed, Nov 30, 2016 at 7:39 PM, Xin Long <lucien.xin@gmail.com> wrote:
> On Wed, Nov 30, 2016 at 6:48 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
>> Dear Sir,
>>
>> It is found that IP X haven't replied heartbeat Ack to IP A but our
>> client will not try another path B->Y.  Would you advise how B->Y path
>> can be enable?
> how about data sending, can it be sacked normally ?
>
> asking that, as transport error_count would be cleared in
> sctp_check_transmitted():
>
>                         /* 8.2. When an outstanding TSN is acknowledged,
>                          * the endpoint shall clear the error counter of
>                          * the destination transport address to which the
>                          * DATA chunk was last sent.
>                          * The association's overall error counter is
>                          * also cleared.
>                          */
>                         transport->error_count = 0;
>                         transport->asoc->overall_error_count = 0;
>
>
>>
>> lksctp client IP info:
>> Primary IP: A
>> Secondary IP: B
>>
>> Server primary IP: X
>> Server secondary IP: Y
>>
>> Regards,
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
