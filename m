From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Date: Mon, 01 Dec 2014 19:00:15 +0000
Subject: Re: panic in skb_push via sctp
Message-Id: <CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com>
	<547CA719.6060101@redhat.com>
	<CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
	<547CAEA3.3090906@redhat.com>
In-Reply-To: <547CAEA3.3090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com

2014-12-01 19:08 GMT+01:00 Daniel Borkmann <dborkman@redhat.com>:
>
>> Thanks for looking into it. I can try with your patch, but no
>> guarantees that the fuzzer will hit the same condition in some
>> reasonable time-frame. Will get back in some time with results.
>
>
> Ok, thanks!
>
>> PS. If you think it's possible to create a repro (userland code) which
>> can trigger this, I can give it a try.
>
>
> Did by accident trinity create tunnels? It looks that upper layer
> protocols (except SCTP) all allocate and reserve MAX_HEADER to
> accommodate enough head room in worst case for possible tunnels.

Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
it operates with a full set of capabilities, so most of the SOCK_RAW
and tunnel-like-creating calls succeed, so maybe..

-- 
Robert Święcki
