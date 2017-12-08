From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 03:44:53 +0000
Subject: Re: [PATCH net-next 09/12] sctp: implement renege_events for sctp_stream_interleave
Message-Id: <CADvbK_ddKD+tFck05cq0HYJO8toNzcwgYpO7K2MEM1Zg9Otj9w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <167166ed3ee953dbcee3aef43496d8c7b44c6b95.1512486606.git.lucien.xin@gmail.com>
 <201712081042.25vrMdbv%fengguang.wu@intel.com>
In-Reply-To: <201712081042.25vrMdbv%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>

On Fri, Dec 8, 2017 at 11:45 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi Xin,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-Stream-Interleave-The-I-DATA-Chunk-Supporting-User-Message-Interleaving/20171208-031625
> config: x86_64-randconfig-g0-12080821 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
>
> All warnings (new ones prefixed by >>):
>
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spinlock_check
>    Cyclomatic Complexity 1 include/linux/skbuff.h:skb_queue_empty
>    Cyclomatic Complexity 2 include/linux/skbuff.h:skb_peek_tail
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_queue_head_init
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_insert
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_queue_splice
>    Cyclomatic Complexity 2 include/linux/skbuff.h:skb_queue_splice_tail_init
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_queue_before
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_queue_tail
>    Cyclomatic Complexity 1 include/linux/skbuff.h:__skb_unlink
>    Cyclomatic Complexity 1 include/net/net_namespace.h:read_pnet
>    Cyclomatic Complexity 1 include/net/sock.h:sk_has_account
>    Cyclomatic Complexity 1 include/net/sock.h:sock_net
>    Cyclomatic Complexity 1 include/net/busy_poll.h:sk_mark_napi_id
>    Cyclomatic Complexity 1 include/net/sctp/ulpevent.h:sctp_skb2event
>    Cyclomatic Complexity 2 include/net/sctp/ulpevent.h:sctp_ulpevent_type_enabled
>    Cyclomatic Complexity 1 include/net/sctp/structs.h:sctp_sk
>    Cyclomatic Complexity 1 include/net/sctp/structs.h:sctp_chunk_stream_no
>    Cyclomatic Complexity 6 net//sctp/stream_interleave.c:sctp_validate_data
>    Cyclomatic Complexity 15 net//sctp/stream_interleave.c:sctp_intl_retrieve_first
>    Cyclomatic Complexity 16 net//sctp/stream_interleave.c:sctp_intl_retrieve_partial
>    Cyclomatic Complexity 25 net//sctp/stream_interleave.c:sctp_intl_retrieve_reassembled
>    Cyclomatic Complexity 3 include/net/sock.h:sk_mem_reclaim
>    Cyclomatic Complexity 2 include/net/sctp/ulpevent.h:sctp_event2skb
>    Cyclomatic Complexity 23 net//sctp/stream_interleave.c:sctp_intl_store_reasm
>    Cyclomatic Complexity 6 net//sctp/stream_interleave.c:sctp_intl_reasm
>    Cyclomatic Complexity 13 net//sctp/stream_interleave.c:sctp_intl_store_ordered
>    Cyclomatic Complexity 5 net//sctp/stream_interleave.c:sctp_intl_retrieve_ordered
>    Cyclomatic Complexity 3 net//sctp/stream_interleave.c:sctp_intl_order
>    Cyclomatic Complexity 2 include/net/sock.h:sk_incoming_cpu_update
>    Cyclomatic Complexity 2 include/net/sctp/ulpevent.h:sctp_ulpevent_is_enabled
>    Cyclomatic Complexity 9 net//sctp/stream_interleave.c:sctp_enqueue_event
>    Cyclomatic Complexity 4 net//sctp/stream_interleave.c:sctp_intl_start_pd
>    Cyclomatic Complexity 6 net//sctp/stream_interleave.c:sctp_validate_idata
>    Cyclomatic Complexity 8 net//sctp/stream_interleave.c:sctp_chunk_assign_mid
>    Cyclomatic Complexity 1 include/linux/skbuff.h:skb_queue_head_init
>    Cyclomatic Complexity 6 net//sctp/stream_interleave.c:sctp_ulpevent_idata
>    Cyclomatic Complexity 7 net//sctp/stream_interleave.c:sctp_renege_events
>    Cyclomatic Complexity 3 net//sctp/stream_interleave.c:sctp_make_idatafrag_empty
>    Cyclomatic Complexity 3 net//sctp/stream_interleave.c:sctp_stream_interleave_init
>    net//sctp/stream_interleave.c: In function 'sctp_renege_events':
>>> net//sctp/stream_interleave.c:581:26: warning: 'sin' may be used uninitialized in this function [-Wmaybe-uninitialized]
>            cevent->mid = sin->mid &&
>                              ^
>    net//sctp/stream_interleave.c:550:32: note: 'sin' was declared here
>      struct sctp_stream_in *csin, *sin;
>                                    ^
>
> vim +/sin +581 net//sctp/stream_interleave.c
>
>    547
>    548  static struct sctp_ulpevent *sctp_intl_retrieve_first(struct sctp_ulpq *ulpq)
>    549  {
>    550          struct sctp_stream_in *csin, *sin;
>    551          struct sk_buff *first_frag = NULL;
>    552          struct sk_buff *last_frag = NULL;
>    553          struct sctp_ulpevent *retval;
>    554          struct sk_buff *pos;
>    555          __u32 next_fsn = 0;
>    556          __u16 sid = 0;
>    557
>    558          skb_queue_walk(&ulpq->reasm, pos) {
>    559                  struct sctp_ulpevent *cevent = sctp_skb2event(pos);
>    560
>    561                  csin = sctp_stream_in(ulpq->asoc, cevent->stream);
>    562                  if (csin->pd_mode)
>    563                          continue;
>    564
>    565                  switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
>    566                  case SCTP_DATA_FIRST_FRAG:
>    567                          if (first_frag)
>    568                                  goto out;
>    569                          if (cevent->mid = csin->mid) {
>    570                                  first_frag = pos;
>    571                                  last_frag = pos;
>    572                                  next_fsn = 0;
>    573                                  sin = csin;
>    574                                  sid = cevent->stream;
>    575                          }
>    576                          break;
>    577                  case SCTP_DATA_MIDDLE_FRAG:
>    578                          if (!first_frag)
>    579                                  break;
>    580                          if (cevent->stream = sid &&
>  > 581                              cevent->mid = sin->mid &&
>    582                              cevent->fsn = next_fsn) {
>    583                                  next_fsn++;
>    584                                  last_frag = pos;
>    585                          } else {
>    586                                  goto out;
>    587                          }
>    588                          break;
>    589                  case SCTP_DATA_LAST_FRAG:
>    590                          if (first_frag)
>    591                                  goto out;
>    592                          break;
>    593                  default:
>    594                          break;
>    595                  }
>    596          }
>    597
>    598          if (!first_frag)
>    599                  return NULL;
>    600
>    601  out:
>    602          retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
>    603                                               &ulpq->reasm, first_frag,
>    604                                               last_frag);
>    605          if (retval) {
>    606                  sin->fsn = next_fsn;
>    607                  sin->pd_mode = 1;
This is safe,  it comes here only when sin already gets initialized.

>    608          }
>    609
>    610          return retval;
>    611  }
>    612
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
