From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 28 Jun 2018 06:40:36 +0000
Subject: Re: [PATCH net-next 3/5] sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams
Message-Id: <CADvbK_cHRA1aN+-tdzURqkZUf29w-0VwGHC_oKDbfLPjYQ1+qg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <b63859ce9c0d5b3d69028d9aa32fd2abe9fdbbe9.1529892764.git.lucien.xin@gmail.com>
 <cover.1529892764.git.lucien.xin@gmail.com> <adc389159b825d29f2768c61f1428d6be9105819.1529892764.git.lucien.xin@gmail.com>
 <20180625.163126.1464757436422028440.davem@davemloft.net> <20180625112847.GB16772@hmswarspite.think-freely.org>
 <20180625130319.GA820@localhost.localdomain> <CAPA1RqB48gBWKOQck6Ke5yH3cm1B5QtJKh1CL4SYfqes8Tc+Nw@mail.gmail.com>
 <20180625163157.GA542@localhost.localdomain> <CADvbK_dpvT1aMtEdARkXQ1b6O5b-QsXTMwBdJsS4bFYnMd=X4Q@mail.gmail.com>
 <CAPA1RqDprqydZ5YpODEa-aLX2seL1tGB+cCc02HX+O89f7zczw@mail.gmail.com>
In-Reply-To: <CAPA1RqDprqydZ5YpODEa-aLX2seL1tGB+cCc02HX+O89f7zczw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?5ZCJ6Jek6Iux5piO?= <hideaki.yoshifuji@miraclelinux.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, yoshfuji <yoshfuji@linux-ipv6.org>

On Tue, Jun 26, 2018 at 8:02 PM, 吉藤英明
<hideaki.yoshifuji@miraclelinux.com> wrote:
> 2018-06-26 13:33 GMT+09:00 Xin Long <lucien.xin@gmail.com>:
>> On Tue, Jun 26, 2018 at 12:31 AM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>>> Hi,
>>>
>>> On Tue, Jun 26, 2018 at 01:12:00AM +0900, 吉藤英明 wrote:
>>>> Hi,
>>>>
>>>> 2018-06-25 22:03 GMT+09:00 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
>>>> > On Mon, Jun 25, 2018 at 07:28:47AM -0400, Neil Horman wrote:
>>>> >> On Mon, Jun 25, 2018 at 04:31:26PM +0900, David Miller wrote:
>>>> >> > From: Xin Long <lucien.xin@gmail.com>
>>>> >> > Date: Mon, 25 Jun 2018 10:14:35 +0800
>>>> >> >
>>>> >> > >  struct sctp_paddrparams {
>>>> >> > > @@ -773,6 +775,8 @@ struct sctp_paddrparams {
>>>> >> > >   __u32                   spp_pathmtu;
>>>> >> > >   __u32                   spp_sackdelay;
>>>> >> > >   __u32                   spp_flags;
>>>> >> > > + __u32                   spp_ipv6_flowlabel;
>>>> >> > > + __u8                    spp_dscp;
>>>> >> > >  } __attribute__((packed, aligned(4)));
>>>> >> >
>>>> >> > I don't think you can change the size of this structure like this.
>>>> >> >
>>>> >> > This check in sctp_setsockopt_peer_addr_params():
>>>> >> >
>>>> >> >     if (optlen != sizeof(struct sctp_paddrparams))
>>>> >> >             return -EINVAL;
>>>> >> >
>>>> >> > is going to trigger in old kernels when executing programs
>>>> >> > built against the new struct definition.
>>>> >
>>>> > That will happen, yes, but do we really care about being future-proof
>>>> > here? I mean: if we also update such check(s) to support dealing with
>>>> > smaller-than-supported structs, newer kernels will be able to run
>>>> > programs built against the old struct, and the new one; while building
>>>> > using newer headers and running on older kernel may fool the
>>>> > application in other ways too (like enabling support for something
>>>> > that is available on newer kernel and that is not present in the older
>>>> > one).
>>>>
>>>> We should not break existing apps.
>>>> We still accept apps of pre-2.4 era without sin6_scope_id
>>>> (e.g., net/ipv6/af_inet6.c:inet6_bind()).
>>>
>>> Yes. That's what I tried to say. That is supporting an old app built
>>> with old kernel headers and running on a newer kernel, and not the
>>> other way around (an app built with fresh headers and running on an
>>> old kernel).
>> To make it, I will update the check like:
>>
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index 1df5d07..c949d8c 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -2715,13 +2715,18 @@ static int
>> sctp_setsockopt_peer_addr_params(struct sock *sk,
>>         struct sctp_sock        *sp = sctp_sk(sk);
>>         int error;
>>         int hb_change, pmtud_change, sackdelay_change;
>> +       int plen = sizeof(params);
>> +       int old_plen = plen - sizeof(u32) * 2;
>
> if (optlen < offsetof(struct sctp_paddrparams, spp_ipv6_flowlabel))
> maybe?
Hi, yoshfuji,
offsetof() is better. thank you.

>
>>
>> -       if (optlen != sizeof(struct sctp_paddrparams))
>> +       if (optlen != plen && optlen != old_plen)
>>                 return -EINVAL;
>>
>>         if (copy_from_user(&params, optval, optlen))
>>                 return -EFAULT;
>>
>> +       if (optlen == old_plen)
>> +               params.spp_flags &= ~(SPP_DSCP | SPP_IPV6_FLOWLABEL);
>
> I think we should return -EINVAL if size is not new one.
Sorry, if we returned  -EINVAL when size is the old one,
how can we guarantee an old app built with old kernel
headers and running on a newer kernel works well?
or you meant?
if ((params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL)) &&
    optlen != plen)
        return EINVAL;

>
> --yoshfuji
>
>> +
>>         /* Validate flags and value parameters. */
>>         hb_change        = params.spp_flags & SPP_HB;
>>         pmtud_change     = params.spp_flags & SPP_PMTUD;
>> @@ -5591,10 +5596,13 @@ static int
>> sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
>>         struct sctp_transport   *trans = NULL;
>>         struct sctp_association *asoc = NULL;
>>         struct sctp_sock        *sp = sctp_sk(sk);
>> +       int plen = sizeof(params);
>> +       int old_plen = plen - sizeof(u32) * 2;
>>
>> -       if (len < sizeof(struct sctp_paddrparams))
>> +       if (len < old_plen)
>>                 return -EINVAL;
>> -       len = sizeof(struct sctp_paddrparams);
>> +
>> +       len = len >= plen ? plen : old_plen;
>>         if (copy_from_user(&params, optval, len))
>>                 return -EFAULT;
>>
>> does it look ok to you?
