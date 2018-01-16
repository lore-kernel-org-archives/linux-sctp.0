From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Jan 2018 06:12:50 +0000
Subject: Re: [PATCH net] sctp: return error if the asoc has been peeled off in sctp_wait_for_sndbuf
Message-Id: <CADvbK_c+rrrvARMVvHnhGP1z0btC1wbE7j1LEbJy1ZrjirnmMQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <3c7ffecf19e5b08ed1df58e5359617e9513f77ef.1516006896.git.lucien.xin@gmail.com>
 <20180115130625.GB24317@hmswarspite.think-freely.org> <CADvbK_cPpd7Q2=9C_nnNeA5butjHX47ATyA0cgnueKcDCaCo3w@mail.gmail.com>
 <20180115185820.GD24317@hmswarspite.think-freely.org>
In-Reply-To: <20180115185820.GD24317@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Jan 16, 2018 at 2:58 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Jan 16, 2018 at 01:20:28AM +0800, Xin Long wrote:
>> On Mon, Jan 15, 2018 at 9:06 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > On Mon, Jan 15, 2018 at 05:01:36PM +0800, Xin Long wrote:
>> >> After commit cea0cc80a677 ("sctp: use the right sk after waking up from
>> >> wait_buf sleep"), it may change to lock another sk if the asoc has been
>> >> peeled off in sctp_wait_for_sndbuf.
>> >>
>> >> However, the asoc's new sk could be already closed elsewhere, as it's in
>> >> the sendmsg context of the old sk that can't avoid the new sk's closing.
>> >> If the sk's last one refcnt is held by this asoc, later on after putting
>> >> this asoc, the new sk will be freed, while under it's own lock.
>> >>
>> >> This patch is to revert that commit, but fix the old issue by returning
>> >> error under the old sk's lock.
>> >>
>> >> Fixes: cea0cc80a677 ("sctp: use the right sk after waking up from wait_buf sleep")
>> >> Reported-by: syzbot+ac6ea7baa4432811eb50@syzkaller.appspotmail.com
>> >> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> >> ---
>> >>  net/sctp/socket.c | 16 ++++++----------
>> >>  1 file changed, 6 insertions(+), 10 deletions(-)
>> >>
>> >> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> >> index 15ae018..feb2ca6 100644
>> >> --- a/net/sctp/socket.c
>> >> +++ b/net/sctp/socket.c
>> >> @@ -85,7 +85,7 @@
>> >>  static int sctp_writeable(struct sock *sk);
>> >>  static void sctp_wfree(struct sk_buff *skb);
>> >>  static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
>> >> -                             size_t msg_len, struct sock **orig_sk);
>> >> +                             size_t msg_len);
>> >>  static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p);
>> >>  static int sctp_wait_for_connect(struct sctp_association *, long *timeo_p);
>> >>  static int sctp_wait_for_accept(struct sock *sk, long timeo);
>> >> @@ -1977,7 +1977,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
>> >>       timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>> >>       if (!sctp_wspace(asoc)) {
>> >>               /* sk can be changed by peel off when waiting for buf. */
>> >> -             err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len, &sk);
>> >> +             err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
>> >>               if (err) {
>> >>                       if (err = -ESRCH) {
>> >>                               /* asoc is already dead. */
>> >> @@ -8022,12 +8022,12 @@ void sctp_sock_rfree(struct sk_buff *skb)
>> >>
>> >>  /* Helper function to wait for space in the sndbuf.  */
>> >>  static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
>> >> -                             size_t msg_len, struct sock **orig_sk)
>> >> +                             size_t msg_len)
>> >>  {
>> >>       struct sock *sk = asoc->base.sk;
>> >> -     int err = 0;
>> >>       long current_timeo = *timeo_p;
>> >>       DEFINE_WAIT(wait);
>> >> +     int err = 0;
>> >>
>> >>       pr_debug("%s: asoc:%p, timeo:%ld, msg_len:%zu\n", __func__, asoc,
>> >>                *timeo_p, msg_len);
>> >> @@ -8056,17 +8056,13 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
>> >>               release_sock(sk);
>> >>               current_timeo = schedule_timeout(current_timeo);
>> >>               lock_sock(sk);
>> >> -             if (sk != asoc->base.sk) {
>> >> -                     release_sock(sk);
>> >> -                     sk = asoc->base.sk;
>> >> -                     lock_sock(sk);
>> >> -             }
>> >> +             if (sk != asoc->base.sk)
>> >> +                     goto do_error;
>> > Is this a safe comparison to make (thinking in terms both of non-cache coherent
>> > arches, or, more likely, of cases where the sock slab reuses an object leading
>> > to the same pointer).  Would it be better to have a single point of freeing the
>> > sock and use the SOCK_DEAD flag here?
>> Hi, Neil, You meant leading to 'asoc->base.sk is the same as sk' ?
>> Here sk is being used in it's sendmsg context, this sk can't even be closed.
> if thats the case, then I'm confused.  Your changelog message asserted that the
> existing mechanism was broken because the socket might get closed during the
> execution of this code.  Can you provide a example of how the current
> implementation might break?
Here are two SKs, asoc's NEW sk and OLD sk.

"However, the asoc's new sk could be already closed elsewhere, as it's in
the sendmsg context of the old sk that can't avoid the new sk's closing."

It's in asoc's OLD sk's sendmsg, the asoc's NEW sk can be closed elsewhere.

Example:
If it's in wait_buf.
After peeling off the assoc and returning the NEW sk, just close() this NEW sk.

Please let me know if it's still confusing. :-)

>
>> it's impossible that the sock slab may reuses this sk(still alive) to
>> asoc->base.sk in somewhere?
> If its still alive, absolutely, but your changelog suggested that that might not
> be  the case
> Neil
>
>>
>> >
>> > Neil
>> >
>> >>
>> >>               *timeo_p = current_timeo;
>> >>       }
>> >>
>> >>  out:
>> >> -     *orig_sk = sk;
>> >>       finish_wait(&asoc->wait, &wait);
>> >>
>> >>       /* Release the association's refcnt.  */
>> >> --
>> >> 2.1.0
>> >>
>> >>
>>
