From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 26 Jun 2020 16:27:35 +0000
Subject: Re: Strange problem with SCTP+IPv6
Message-Id: <66D9D559-23D6-42B0-9401-62B00C4F748E@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200621155604.GA23135@minyard.net>
 <CADvbK_d9mV9rBg7oLC+9u4fg3d_5a_g8ukPe83vOAE8ZM3FhHA@mail.gmail.com>
 <20200622165759.GA3235@minyard.net>
 <4B68D06C-00F4-42C3-804A-B5531AABCE21@lurchi.franken.de>
 <20200622183253.GQ2491@localhost.localdomain>
 <E5F42909-3AB4-47FE-98B7-DEFB63968696@lurchi.franken.de>
 <CADvbK_fddQiOJUVJNkJuxkzQ9V-tpk_ATBP4NpZ2rZketHEFcg@mail.gmail.com>
 <50b0a6ff186e408bbfe6211221cb3998@AcuMS.aculab.com>
In-Reply-To: <50b0a6ff186e408bbfe6211221cb3998@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "minyard@acm.org" <minyard@acm.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

> On 26. Jun 2020, at 18:13, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Xin Long
>> Sent: 23 June 2020 11:14
>>>> It looks like a bug to me. Testing with this test app here, I can see
>>>> the INIT_ACK being sent with a bunch of ipv4 addresses in it and
>>>> that's unexpected for a v6only socket. As is, it's the server saying
>>>> "I'm available at these other addresses too, but not."
>>> I agree.
>> Then we need a fix in sctp_bind_addrs_to_raw():
>> 
>> @@ -238,6 +240,9 @@ union sctp_params sctp_bind_addrs_to_raw(const
>> struct sctp_bind_addr *bp,
>>        addrparms = retval;
>> 
>>        list_for_each_entry(addr, &bp->address_list, list) {
>> +               if ((PF_INET6 = sk->sk_family) && inet_v6_ipv6only(sk) &&
>> +                   (AF_INET = addr->a.sa.sa_family))
>> +                       continue;
>>                af = sctp_get_af_specific(addr->a.v4.sin_family);
>>                len = af->to_addr_param(&addr->a, &rawaddr);
>>                memcpy(addrparms.v, &rawaddr, len);
> 
> Thought.
> 
> Does it make any sense to offer addresses in the INIT_ACK that don't
> have routes to those proposed in the received INIT?
> 
> 'routes' probably isn't exactly the right word.
> You probably only want the local address that will be used
> as the source address for the probes.
> Or, at least, sources addresses that could be used for the probes.
> 
> So if the INIT only contains IPv6 addresses should the INIT_ACK
> ever contain IPv4 ones.
The client (if it not using an IPv6 socket having IPv6 only enabled) could
add an IPv4 address during the lifetime of the association by using the
address reconfiguration extension.

What could be done is to not send IPv4 addresses if the INIT contains
a Supported Address Types parameter indicating IPv6, but not IPv4 support.
As a client you might want to send this parameter, when the IPv6 socket has
enabled the IPV6_ONLY socket option.
Also if the client uses an IPv4 socket, it can indicate in the Supported
Address Parameter that it only support IPv4, and the server does not need
to list IPv6 addresses.

Best regards
Michael
> 
> 	David.
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
