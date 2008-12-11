From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 11 Dec 2008 15:28:35 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <494131A3.5090602@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michal Hocko wrote:
> Hi Vlad,
> 
> I am starting this new thread because I am starting to believe that
> sles10sp2 kernel (based on 2.6.16 upstream kernel) experiences different
> issue than we can see in the upstream kernel (see bellow).
> 
> Karsten (CCing him) has found out following:
> "
> OK I think the
> KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
> net/ipv4/af_inet.c (149)
> 
> is related to the main problem here, it says that on the time a socket
> get destroyed here is still some wmem allocated. This mean here is still
> a transmit skb on the fly. Since sctp use skb destructors to do the
> memory accounting, this also means that after destroying the socket, the
> destructor of this skb will access the already freed socket struct,
> which will let in some cases (if the memory is in use again and the
> pointers are already overwritten) cause the crash with on
> {sock_wfree+48} (which is a call to sk->sk_write_space(sk);).  Of course
> it can crash in every other place, since the accounting may overwrite
> pointers in any other struct, which reuse this memory.
> 
> I instrument some routines with extra debug (eg. inet_sock_destruct) too
> see the amount of memory in sk->sk_wmem_alloc, it allmost show 
> 
> Dec 11 12:31:16 gw kernel: inet_sock_destruct:
> sk(ffff810116960e00)->sk_wmem_alloc 496
> Dec 11 12:31:17 gw kernel: inet_sock_destruct:
> sk(ffff8101144f1b00)->sk_wmem_alloc 496
> Dec 11 12:31:18 gw kernel: inet_sock_destruct:
> sk(ffff8101144f1b00)->sk_wmem_alloc -496
> Dec 11 12:31:20 gw kernel: inet_sock_destruct:
> sk(ffff81011d461a00)->sk_wmem_alloc 496
> Dec 11 12:31:21 gw kernel: inet_sock_destruct:
> sk(ffff81011d460080)->sk_wmem_alloc 496
> 
> Note the -496, I think this is a case in which the same memory was again
> allocated by a socket struct, so the memory still has valid pointers and
> so on the destructor call for the old socket it did decrement the memory
> on the new socket.
> 
> Do you agree with this analysis ?
> "
> 
> I am trying to go through git logs but maybe you remember some fix in
> this area.
> 
> If I understand correctly, then 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
> removes destructors from sctp completely, so the previous should not
> happen in upstream, shouldn't it?
> 


Here are a few commits that you need to check on:

61c9fed41638249f8b6ca5345064eb1beb50179f
[SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_rcv().

cfdeef3282705a4b872d3559c4e7d2561251363c
[SCTP]: Unhash the endpoint in sctp_endpoint_free().

f26f7c480555812ca7c4037e0a50fa54afe2cb4a
[SCTP]: Add bind hash locking to the migrate code


All of the above commits address races in the SCTP code and are not in the base
2.6.16 kernel.

-vlad

