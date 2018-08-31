From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 31 Aug 2018 15:08:09 +0000
Subject: Re: [PATCH net-next 1/3] net: rework SIOCGSTAMP ioctl handling
Message-Id: <CAF=yD-+tiVeP0FA1CUrT4Jyn28tnT+bett+Dq2frvU5eS1ANPw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180829130308.3504560-1-arnd@arndb.de> <CAF=yD-J7-GumUmonrZt7s44e3bsjY2DCD6ZpmhtCx6FOBV5BNA@mail.gmail.com>
 <CAK8P3a2XTUZJUqGu6v=SZqcoJTqM3fgtDAWBnBopX3=4NJYcRA@mail.gmail.com>
 <CAF=yD-+9yc838Y_DO1S4HsBpLrBk8iNt0oAj1ceO1S6sE+tCdg@mail.gmail.com> <CAK8P3a00DLR9JyfKwbYXnKCpRf+YWuUyMbC+UfXZTfdnAJxRtg@mail.gmail.com>
In-Reply-To: <CAK8P3a00DLR9JyfKwbYXnKCpRf+YWuUyMbC+UfXZTfdnAJxRtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org, y2038 Mailman List <y2038@lists.linaro.org>, Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org, linux-x25@vger.kernel.org

> > > Looking at it again, it seems that sock_gettstamp() should
> > > actually deal with this gracefully: it will return a -EINVAL
> > > error condition if the timestamp remains at the
> > > SK_DEFAULT_STAMP initial value, which is probably
> > > just as appropriate (or better) as the current -ENOTTY
> > > default, and if we are actually recording timestamps, we
> > > might just as well report them.
> >
> > Yes, that's a nice solution. There is always some risk in changing
> > error codes. But ioctl callers should be able to support newly
> > implemented functionality. Even if partially implemented and
> > returning ENOENT instead of ENOIOCTLCMD.
>
> Ok, so do you think we should stay with the current version
> for now, and change the two points later, or should I rework
> it to integrate the locking and removing the callback?
>
> I suppose the series actually gets nicer without the
> callback, since I can simply add the generic timestamping
> implementation first, and then remove the dead ioctl
> handlers.

Agreed. I would add the locks in a separate patch, if only on the
off-chance that lockdep discovers something and it will be easier
to bisect and revise independently. I can also follow up with that
patch outside this set, of course.
