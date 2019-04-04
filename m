From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 04 Apr 2019 09:45:07 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <CADvbK_cZ6q7k8X_7=SYzXKRkwXVZAHGBejxPSgK0vkUNcoktXA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1554022192.git.lucien.xin@gmail.com> <CADvbK_fuTOQYZxN+d4OkwEZmjVacP6OK5YAszuijNa=3RQenBA@mail.gmail.com>
 <20190331.110248.968610750836978684.davem@davemloft.net>
In-Reply-To: <20190331.110248.968610750836978684.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

On Mon, Apr 1, 2019 at 2:02 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Sun, 31 Mar 2019 16:56:40 +0800
>
> > Simple tests are as attached.
>
> Are these integratable into selftests somehow?
We're thinking about adding some sctp tests into selftests,
but these ones are not good to be the first one, I think.
sysctl_sockets_memctl.sh is a multi-host test, even netns can't work for it.

Each subcomponent seems to have its own test case in other git repo,
can I ask what kind of tests should I put into kernel selftests in the future?
