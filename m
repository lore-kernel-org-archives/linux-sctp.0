From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 01 Dec 2015 11:29:40 +0000
Subject: Re: [PATCH] sctp: use GFP_USER for user-controlled kmalloc
Message-Id: <565D84A4.3080408@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+a_V5WQZNEnYkuA3Xc5qCWmLV3oScNeNiATZm-wW5eg3Q@mail.gmail.comc> <db23659cdf84bc80aff45e906cbfb67581e7a125.1448901154.git.marcelo.leitner@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1CBDF85D@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CBDF85D@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>, "dvyukov@google.com" <dvyukov@google.com>, "kcc@google.com" <kcc@google.com>, "glider@google.com" <glider@google.com>, "sasha.levin@oracle.com" <sasha.levin@oracle.com>, "edumazet@google.com" <edumazet@google.com>

On 12/01/2015 11:46 AM, David Laight wrote:
> From: Marcelo Ricardo Leitner
>> Sent: 30 November 2015 16:33
>> Dmitry Vyukov reported that the user could trigger a kernel warning by
>> using a large len value for getsockopt SCTP_GET_LOCAL_ADDRS, as that
>> value directly affects the value used as a kmalloc() parameter.
>>
>> This patch thus switches the allocation flags from all user-controllable
>> kmalloc size to GFP_USER to put some more restrictions on it and also
>> disables the warn, as they are not necessary.
>
> ISTM that the code should put some 'sanity limit' on that
> size before allocating the kernel buffer.

One could do that in addition, but this buffer has just a short lifetime
and by using GFP_USER hardwall restrictions apply already.
