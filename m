From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 28 Jun 2017 01:17:46 +0000
Subject: Re: TX_QUEUE and RX_QUEUE in /proc/net/sctp/assoc
Message-Id: <CAFXGftKHVLKTqO-E4CvhZ+N4mjkHp2wY-T0u1-bYWqec2xBckg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftJ5G6UAhVWkSM07_0TMoFaOgEbC_KNqf7fX+G7_9HP=HQ@mail.gmail.com>
In-Reply-To: <CAFXGftJ5G6UAhVWkSM07_0TMoFaOgEbC_KNqf7fX+G7_9HP=HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

hi Xin

do you mean TX_QUEUE/RX_QUEUE in /proc/net/sctp/assocs instead of last
two column?

 ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC

On Tue, Jun 27, 2017 at 7:41 PM, Xin Long <lucien.xin@gmail.com> wrote:
> On Tue, Jun 27, 2017 at 3:56 PM, Sun Paul <paulrbk@gmail.com> wrote:
>> Hi All
>>
>>
>> what is the max value of TX_QUEUE and RX_QUEUE in /proc/net/sctp/assoc?
> TX_QUEUE is assoc->sndbuf_used
> RX_QUEUE is assoc->rmem_alloc
>
> when sendmsg and ep->sndbuf_policy is set, it does the check:
>  (asoc->sndbuf_used < sk->sk_sndbuf)
>
> when recvmsg and ep->rcvbuf_policy is set, it does the check:
>  (asoc->rmem_alloc < sk->sk_rcvbuf)
>
> so what you're asking is how to know the value of sk->sk_sndbuf/sk_rcvbuf.
>
> by  /proc/net/sctp/assoc, it's the last two column: sndbuf rcvbuf
> by "sctp_diag interface", it's mem[SK_MEMINFO_SNDBUF/SK_MEMINFO_RCVBUF]
> by getsockopt, it's SO_SNDBUF/SO_RCVBUF
>
>
>>
>> How we can determine the value?
>>
>> - RBK
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
