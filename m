From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 17 Jun 2019 13:49:13 +0000
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-Id: <20190617134913.GL3436@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190616153804.3604-1-hdanton@sina.com>
In-Reply-To: <20190616153804.3604-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hi,

On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> 
> Hello Syzbot
> 
> On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
...
> Check prio_head and bail out if it is not valid.
> 
> Thanks
> Hillf
> ----->8---
> ---
> net/sctp/stream_sched_prio.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> index 2245083..db25a43 100644
> --- a/net/sctp/stream_sched_prio.c
> +++ b/net/sctp/stream_sched_prio.c
> @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> 	struct sctp_stream_priorities *prio, *prio_head;
> 
> 	prio_head = soute->prio_head;
> +	if (!prio_head)
> +		return;
> 
> 	/* Nothing to do if already scheduled */
> 	if (!list_empty(&soute->prio_list))
> --

Thanks but this is not a good fix for this. It will cause the stream
to never be scheduled.

The problem happens because of the fault injection that happened a bit
before the crash, in here:

int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
{
        struct sctp_stream_out_ext *soute;

        soute = kzalloc(sizeof(*soute), GFP_KERNEL);
        if (!soute)
                return -ENOMEM;
        SCTP_SO(stream, sid)->ext = soute;  <---- [A]

        return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
                      ^^^^^^^^^^^^---- [B] failed
}

This causes the 1st sendmsg to bail out with the error. When the 2nd
one gets in, it will:

sctp_sendmsg_to_asoc()
{
...
        if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
                                                                 ^^^^^--- [C]
                err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
                if (err)
                        goto err;
        }

[A] leaves ext initialized, despite the failed in [B]. Then in [C], it
will not try to initialize again.

We need to either uninitialize ->ext as error handling for [B], or
improve the check on [C].

syzbot++ once again.

  Marcelo
