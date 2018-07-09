From: =?UTF-8?Q?Martin_Schr=C3=B6der?= <martin@oneiros.de>
Date: Mon, 09 Jul 2018 11:38:23 +0000
Subject: Re: Possible bug: Association always uses the primary source address in replies
Message-Id: <CAP7DCDefnsPAgdR4VEqevbnT4f=qzwyoZd+WosuXAg6SAKLpYQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
In-Reply-To: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

2018-07-06 18:34 GMT+02:00 Xin Long <lucien.xin@gmail.com>:
> Make sense?

Yes, but it doesn't make us happy. :-)

So we can get our setup working (but will be able to test that only in
some weeks).

The biggest problem for us is that we only control one side and can not
really prevent such a cross connection.

Btw: Why is there a primary address (local) AND a primary peer address
(remote) if only one path is possible as primary and the local and the
remote address is fixed?

Many many thanks for your help

Best
   Martin
