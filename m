From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 09 May 2012 12:04:10 +0000
Subject: Re: [Lksctp-developers] Bug: sctp packets are dropped after IPSEC rekeying (route cache issue)
Message-Id: <4FAA5D3A.7080706@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C46AA7B.3090601@6wind.com> <4C46FD58.9030107@hp.com> <4FA3AA6A.4070503@6wind.com> <20120504.104812.502049217620285020.davem@davemloft.net> <4FA3F4C6.7070605@6wind.com> <CAGCdqXFjyWst22DJgxNfakz3-JwRq0Z+WZVj-XT=qRQFY5w3rw@mail.gmail.com>
In-Reply-To: <CAGCdqXFjyWst22DJgxNfakz3-JwRq0Z+WZVj-XT=qRQFY5w3rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: David Miller <davem@davemloft.net>, babu.srinivasan@gmail.com, lksctp-developers@lists.sourceforge.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, michael.kreuzer@nsn.com

Le 04/05/2012 20:15, Vladislav Yasevich a =E9crit :
> On Fri, May 4, 2012 at 11:24 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com>wrote:
>
>> Le 04/05/2012 16:48, David Miller a =E9crit :
>>
>>   From: Nicolas Dichtel<nicolas.dichtel@6wind.**com<nicolas.dichtel@6win=
d.com>
>>>>
>>> Date: Fri, 04 May 2012 12:07:38 +0200
>>>
>>>   Finally, this patch was never integrated into the mainline. Should I
>>>> rebase it on the head?
It applies cleanly on linus tree, so I will not rebase it.


Regards,
Nicolas

>>>>
>>>> I've attach the last approved patch.
>>>>
>>>> Here is the original thread:
>>>> http://sourceforge.net/**mailarchive/message.php?msg_**id%786006<http:=
//sourceforge.net/mailarchive/message.php?msg_id%786006>
>>>>
>>>
>>> Vlad no longer works for HP so your email likely will bounce, and
>>> he will not see it.
>>>
>> Right.
>>
>>
>>
>>> His new email address is vyasevich@gmail.com, as per the MAINTAINERS
>>> file.
>>>
>>
>> I put the right email address now. I attach the patch again, for Vlad.
>>
>>
>> Thank you,
>> Nicolas
>>
>
>
> Right.  This looks fine.
>
> Acked-by: Vlad Yaseivch<vyasevich@gmail.com>
