From: Joe Perches <joe@perches.com>
Date: Wed, 11 Sep 2013 23:43:03 +0000
Subject: Re: [RFC PATCH] vsnprintf: Remove use of %n and convert existing uses
Message-Id: <1378942983.4714.40.camel@joe-AO722>
List-Id: <linux-sctp.vger.kernel.org>
References: <20130911044116.GA17294@www.outflux.net>
	 <1378875632.606.5.camel@joe-AO722>
	 <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
	 <20130911093118.GD25896@mwanda>
	 <CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
	 <1378926562.4714.11.camel@joe-AO722>
	 <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
	 <1378928700.4714.17.camel@joe-AO722>
	 <CAGXu5jLTjrPr=GwOmMcu55Qp9K-_XS75xq9NJ0vBUEwy-i_YMw@mail.gmail.com>
	 <1378941761.4714.37.camel@joe-AO722>
	 <CAGXu5jLyCGuSRqEGCSw=VrrOvOr=aAok6ZZTAj_qmDA3CbmLww@mail.gmail.com>
In-Reply-To: <CAGXu5jLyCGuSRqEGCSw=VrrOvOr=aAok6ZZTAj_qmDA3CbmLww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tushar Behera <tushar.behera@linaro.org>, Lidza Louina <lidza.louina@gmail.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Remi Denis-Courmont <courmisch@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Wed, 2013-09-11 at 16:29 -0700, Kees Cook wrote:
> On Wed, Sep 11, 2013 at 4:22 PM, Joe Perches <joe@perches.com> wrote:
> > Using vsnprintf or its derivatives with %n can have security
> > vulnerability implications.
> >
> > Prior to commit fef20d9c1380
> > ("vsprintf: unify the format decoding layer for its 3 users"),
> > any use of %n was ignored.
> >
> > Reintroduce this feature and convert the existing uses of %n
> > to use the return length from vsnprintf or its derivatives.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (proc bits)
> > cc: Kees Cook <keescook@chromium.org>
> > cc: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Yes, please. It might also be worth updating
> Documentation/printk-formats.txt to mention that %n has intentionally
> removed and will be ignored.

Fine with me if you want to update that file.

It doesn't currently try to be a complete man page
for vsnprintf though.

vsprintf.c does have kernel-doc documentation and
that already does show that %n is ignored.


