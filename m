From: David Miller <davem@davemloft.net>
Date: Thu, 04 Apr 2019 17:38:36 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <20190404.103836.99803631681096896.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_fuTOQYZxN+d4OkwEZmjVacP6OK5YAszuijNa=3RQenBA@mail.gmail.com>
        <20190331.110248.968610750836978684.davem@davemloft.net>
        <CADvbK_cZ6q7k8X_7=SYzXKRkwXVZAHGBejxPSgK0vkUNcoktXA@mail.gmail.com>
In-Reply-To: <CADvbK_cZ6q7k8X_7=SYzXKRkwXVZAHGBejxPSgK0vkUNcoktXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, mcroce@redhat.com, vdronov@redhat.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 4 Apr 2019 17:45:07 +0800

> We're thinking about adding some sctp tests into selftests,
> but these ones are not good to be the first one, I think.
> sysctl_sockets_memctl.sh is a multi-host test, even netns can't work for it.

You can't set per-netns memory controls appropriately to make the
tests work?

> Each subcomponent seems to have its own test case in other git repo,
> can I ask what kind of tests should I put into kernel selftests in
> the future?

It would be ideal that we have a decent base set of SCTP tests and
then when bug fixes are added, we get a unit test with the fix.

I guess a good baseline would be testing basic comminucation between
SCTP sockets in different netns, and then adding tests for setting
the various socket options and making sure the socket option had the
desired effect.
