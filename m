From: Alexander Potapenko <glider@google.com>
Date: Mon, 01 Apr 2019 08:43:55 +0000
Subject: Re: [PATCH net] sctp: initialize _pad of sockaddr_in before copying to user memory
Message-Id: <CAG_fn=UPX0d9DGjih0H03WfK=TZBz5rfF09E59ux3HteTUfDNw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <b4aeae8a46f4dcddcfddb0ba3943abda3413f142.1554022695.git.lucien.xin@gmail.com>
In-Reply-To: <b4aeae8a46f4dcddcfddb0ba3943abda3413f142.1554022695.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller <syzkaller@googlegroups.com>

On Sun, Mar 31, 2019 at 10:58 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> Syzbot report a kernel-infoleak:
>
>   BUG: KMSAN: kernel-infoleak in _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
>   Call Trace:
>     _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
>     copy_to_user include/linux/uaccess.h:174 [inline]
>     sctp_getsockopt_peer_addrs net/sctp/socket.c:5911 [inline]
>     sctp_getsockopt+0x1668e/0x17f70 net/sctp/socket.c:7562
>     ...
>   Uninit was stored to memory at:
>     sctp_transport_init net/sctp/transport.c:61 [inline]
>     sctp_transport_new+0x16d/0x9a0 net/sctp/transport.c:115
>     sctp_assoc_add_peer+0x532/0x1f70 net/sctp/associola.c:637
>     sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
>     sctp_process_init+0x1a1b/0x3ed0 net/sctp/sm_make_chunk.c:2361
>     ...
>   Bytes 8-15 of 16 are uninitialized
>
> It was caused by that th _pad field (the 8-15 bytes) of a v4 addr (saved in
> struct sockaddr_in) wasn't initialized, but directly copied to user memory
> in sctp_getsockopt_peer_addrs().
>
> So fix it by calling memset(addr->v4.sin_zero, 0, 8) to initialize _pad of
> sockaddr_in before copying it to user memory in sctp_v4_addr_to_user(), as
> sctp_v6_addr_to_user() does.
>
> Reported-by: syzbot+86b5c7c236a22616a72f@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Alexander Potapenko <glider@google.com>
> ---
>  net/sctp/protocol.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 6abc8b2..951afde 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -600,6 +600,7 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
>  static int sctp_v4_addr_to_user(struct sctp_sock *sp, union sctp_addr *addr)
>  {
>         /* No address mapping for V4 sockets */
> +       memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
>         return sizeof(struct sockaddr_in);
>  }
>
> --
> 2.1.0
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.



-- 
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Straße, 33
80636 München

Geschäftsführer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
