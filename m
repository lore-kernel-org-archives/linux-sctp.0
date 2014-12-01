From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Date: Mon, 01 Dec 2014 19:17:36 +0000
Subject: Re: panic in skb_push via sctp
Message-Id: <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com>
	<547CA719.6060101@redhat.com>
	<CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
	<547CAEA3.3090906@redhat.com>
	<CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com>
	<547CBE0D.8010501@redhat.com>
In-Reply-To: <547CBE0D.8010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Vladislav Yasevich <vyasevich@gmail.com>

>> Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
>> it operates with a full set of capabilities, so most of the SOCK_RAW
>> and tunnel-like-creating calls succeed, so maybe..
>
>
> Ok thanks, can you post your .config?

Hi,

http://alt.swiecki.net/.ksan/.config-sctp

-- 
Robert Święcki
