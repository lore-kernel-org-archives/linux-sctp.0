From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 01 Dec 2014 21:58:39 +0000
Subject: Re: panic in skb_push via sctp
Message-Id: <547CE48F.3020700@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com> <547CA719.6060101@redhat.com> <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com> <547CAEA3.3090906@redhat.com> <CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com> <547CBE0D.8010501@redhat.com> <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
In-Reply-To: <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Vladislav Yasevich <vyasevich@gmail.com>

On 12/01/2014 08:17 PM, Robert Święcki wrote:
>>> Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
>>> it operates with a full set of capabilities, so most of the SOCK_RAW
>>> and tunnel-like-creating calls succeed, so maybe..
>>
>>
>> Ok thanks, can you post your .config?
>
> http://alt.swiecki.net/.ksan/.config-sctp

Thanks, so relevant tunneling is enabled that means MAX_HEADER != LL_MAX_HEADER.
