From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 05 Apr 2019 04:49:37 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <CADvbK_fcGR_U-URF-5N1i=nK=u7Xxa+tkfWeb5hTzMPFukHysg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_fuTOQYZxN+d4OkwEZmjVacP6OK5YAszuijNa=3RQenBA@mail.gmail.com>
 <20190331.110248.968610750836978684.davem@davemloft.net> <CADvbK_cZ6q7k8X_7=SYzXKRkwXVZAHGBejxPSgK0vkUNcoktXA@mail.gmail.com>
 <20190404.103836.99803631681096896.davem@davemloft.net>
In-Reply-To: <20190404.103836.99803631681096896.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

On Fri, Apr 5, 2019 at 1:38 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Thu, 4 Apr 2019 17:45:07 +0800
>
> > We're thinking about adding some sctp tests into selftests,
> > but these ones are not good to be the first one, I think.
> > sysctl_sockets_memctl.sh is a multi-host test, even netns can't work for it.
>
> You can't set per-netns memory controls appropriately to make the
> tests work?
static atomic_long_t sctp_memory_allocated;

struct proto sctp_prot = {
.memory_allocated = &sctp_memory_allocated,

sysctl limitation is per-netns, but the counter 'sctp_memory_allocated' is not.
It means other netns buffer allocation will affect the current netns.

>
> > Each subcomponent seems to have its own test case in other git repo,
> > can I ask what kind of tests should I put into kernel selftests in
> > the future?
>
> It would be ideal that we have a decent base set of SCTP tests and
> then when bug fixes are added, we get a unit test with the fix.
>
> I guess a good baseline would be testing basic comminucation between
> SCTP sockets in different netns, and then adding tests for setting
> the various socket options and making sure the socket option had the
> desired effect.
got your point. thanks
