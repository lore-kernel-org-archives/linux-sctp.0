From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 09 Apr 2019 10:51:03 +0000
Subject: Re: WARNING: refcount bug in sock_wfree
Message-Id: <CACT4Y+boi0OYyiE+mYXziSzg-bLPv=b20YKdCyLVNSmGfxyr5Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a113f753879e5060565bf321f@google.com> <CADvbK_eandMH1aZvKnzdX=3xdS0NSo6_NAeCrKasqA9EON4B0A@mail.gmail.com>
 <CACT4Y+aqw1pG5fNr1gdLpbMuTtXshYw82zTyU=1x+s01fKE77Q@mail.gmail.com> <CADvbK_dH2rFzn78z3idxa4oQGL11JnzBCqZHOzGsKz8Qbhyk+g@mail.gmail.com>
In-Reply-To: <CADvbK_dH2rFzn78z3idxa4oQGL11JnzBCqZHOzGsKz8Qbhyk+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+98a809ad0f54884bde26@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Tue, Apr 9, 2019 at 12:32 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Apr 9, 2019 at 4:23 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Thu, Feb 22, 2018 at 10:50 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Wed, Feb 21, 2018 at 9:59 PM, syzbot
> > > <syzbot+98a809ad0f54884bde26@syzkaller.appspotmail.com> wrote:
> > > > Hello,
> > > >
> > > > syzbot hit the following crash on upstream commit
> > > > 79c0ef3e85c015b0921a8fd5dd539d1480e9cd6c (Mon Feb 19 19:58:19 2018 =
+0000)
> > > > Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> > > >
> > > > So far this crash happened 2 times on
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/maste=
r.
> > > > syzkaller reproducer is attached.
> > > > Raw console output is attached.
> > > > compiler: gcc (GCC) 7.1.1 20170620
> > > > .config is attached.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the =
commit:
> > > > Reported-by: syzbot+98a809ad0f54884bde26@syzkaller.appspotmail.com
> > > > It will help syzbot understand when the bug is fixed. See footer for
> > > > details.
> > > > If you forward the report, please keep this part and the footer.
> > > >
> > > > IPv6: ADDRCONF(NETDEV_UP): bridge0: link is not ready
> > > > IPv6: ADDRCONF(NETDEV_UP): bridge0: link is not ready
> > > > audit: type=1400 audit(1519151768.973:11): avc:  denied  { sys_chro=
ot } for
> > > > pidA69 comm=3D"syz-executor5" capability=18
> > > > scontext=3Dunconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> > > > tcontext=3Dunconfined_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=CAp=
_userns
> > > > permissive=3D1
> > > > ------------[ cut here ]------------
> > > > refcount_t: underflow; use-after-free.
> > > > WARNING: CPU: 0 PID: 5074 at lib/refcount.c:187
> > > > refcount_sub_and_test+0x167/0x1b0 lib/refcount.c:187
> > > > Kernel panic - not syncing: panic_on_warn set ...
> > > It seems that we also need to process the chunks in
> > > outqueue->control_chunk_list in sctp_for_each_tx_datachunk()
> > > when peeling off.
> >
> > Hi Xin,
> >
> > Did you mail any fix for this?
> No, I realized it doesn't make difference to add the process for
> control_chunk_list in sctp_for_each_tx_datachunk().
>
> > The bug is still open, but the crash did not happen in the past
> > months. It seems that 3 different bugs accumulated in this bug: there
> > was a splash of crashes in Feb 2018, then it stopped crashing, then
> > some crashes in May 2018, probably a different bug, then stopped
> > happening again, then another splash in Nov 2018, most likely a
> > different bugs, then it stopped happening again. If we keep it open,
> > it will continue accumulating more different bugs.
> We've had some fixes for peeling off process added in the latest kernel
> since then, which could be related. So I think we can close this one now,
> and let's see what the new bugs will look like.
>
> Thanks.

#syz invalid

> > > > CPU: 0 PID: 5074 Comm: syz-executor5 Not tainted 4.16.0-rc2+ #322
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS
> > > > Google 01/01/2011
> > > > Call Trace:
> > > >  __dump_stack lib/dump_stack.c:17 [inline]
> > > >  dump_stack+0x194/0x257 lib/dump_stack.c:53
> > > >  panic+0x1e4/0x41c kernel/panic.c:183
> > > >  __warn+0x1dc/0x200 kernel/panic.c:547
> > > >  report_bug+0x211/0x2d0 lib/bug.c:184
> > > >  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
> > > >  fixup_bug arch/x86/kernel/traps.c:247 [inline]
> > > >  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
> > > >  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
> > > >  invalid_op+0x58/0x80 arch/x86/entry/entry_64.S:957
> > > > RIP: 0010:refcount_sub_and_test+0x167/0x1b0 lib/refcount.c:187
> > > > RSP: 0018:ffff8801cf2b6490 EFLAGS: 00010282
> > > > RAX: dffffc0000000008 RBX: 0000000000000401 RCX: ffffffff815abdbe
> > > > RDX: 0000000000000000 RSI: 1ffff10039e56c42 RDI: 1ffff10039e56c17
> > > > RBP: ffff8801cf2b6520 R08: 1ffff10039e56bd9 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff10039e56c93
> > > > R13: 00000000ffffff01 R14: 0000000000000500 R15: ffff8801ae3c69fc
> > > >  sock_wfree+0xa6/0x140 net/core/sock.c:1819
> > > >  sctp_wfree+0x2eb/0x670 net/sctp/socket.c:8065
> > > >  skb_release_head_state+0x124/0x260 net/core/skbuff.c:612
> > > >  skb_release_all+0x15/0x60 net/core/skbuff.c:625
> > > >  __kfree_skb net/core/skbuff.c:641 [inline]
> > > >  consume_skb+0x153/0x490 net/core/skbuff.c:701
> > > >  sctp_chunk_destroy net/sctp/sm_make_chunk.c:1450 [inline]
> > > >  sctp_chunk_put+0x29c/0x420 net/sctp/sm_make_chunk.c:1477
> > > >  sctp_chunk_free+0x53/0x60 net/sctp/sm_make_chunk.c:1464
> > > >  __sctp_outq_teardown+0x244/0x1230 net/sctp/outqueue.c:234
> > > >  sctp_outq_free+0x15/0x20 net/sctp/outqueue.c:291
> > > >  sctp_association_free+0x2d0/0x930 net/sctp/associola.c:356
> > > >  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:939 [inline]
> > > >  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1343 [inline]
> > > >  sctp_side_effects net/sctp/sm_sideeffect.c:1210 [inline]
> > > >  sctp_do_sm+0x32e3/0x6ed0 net/sctp/sm_sideeffect.c:1181
> > > >  sctp_primitive_ABORT+0xa0/0xd0 net/sctp/primitive.c:119
> > > >  sctp_close+0x266/0x9a0 net/sctp/socket.c:1539
> > > >  inet_release+0xed/0x1c0 net/ipv4/af_inet.c:427
> > > >  sock_release+0x8d/0x1e0 net/socket.c:595
> > > >  sock_close+0x16/0x20 net/socket.c:1149
> > > >  __fput+0x327/0x7e0 fs/file_table.c:209
> > > >  ____fput+0x15/0x20 fs/file_table.c:243
> > > >  task_work_run+0x199/0x270 kernel/task_work.c:113
> > > >  exit_task_work include/linux/task_work.h:22 [inline]
> > > >  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
> > > >  do_group_exit+0x149/0x400 kernel/exit.c:968
> > > >  get_signal+0x73a/0x16d0 kernel/signal.c:2469
> > > >  do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
> > > >  exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
> > > >  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
> > > >  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
> > > >  do_syscall_64+0x6e5/0x940 arch/x86/entry/common.c:292
> > > >  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> > > > RIP: 0033:0x453da9
> > > > RSP: 002b:00007f297546ace8 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
0ca
> > > > RAX: fffffffffffffe00 RBX: 000000000072bf80 RCX: 0000000000453da9
> > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000072bf80
> > > > RBP: 000000000072bf80 R08: 0000000000000000 R09: 000000000072bf58
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > > R13: 0000000000a3e8ef R14: 00007f297546b9c0 R15: 0000000000000001
> > > > Dumping ftrace buffer:
> > > >    (ftrace buffer empty)
> > > > Kernel Offset: disabled
> > > > Rebooting in 86400 seconds..
> > > >
> > > >
> > > > ---
> > > > This bug is generated by a dumb bot. It may contain errors.
> > > > See https://goo.gl/tpsmEJ for details.
> > > > Direct all questions to syzkaller@googlegroups.com.
> > > >
> > > > syzbot will keep track of this bug report.
> > > > If you forgot to add the Reported-by tag, once the fix for this bug=
 is
> > > > merged
> > > > into any tree, please reply to this email with:
> > > > #syz fix: exact-commit-title
> > > > If you want to test a patch for this bug, please reply with:
> > > > #syz test: git://repo/address.git branch
> > > > and provide the patch inline or as an attachment.
> > > > To mark this as a duplicate of another syzbot report, please reply =
with:
> > > > #syz dup: exact-subject-of-another-report
> > > > If it's a one-off invalid bug report, please reply with:
> > > > #syz invalid
> > > > Note: if the crash happens again, it will cause creation of a new b=
ug
> > > > report.
> > > > Note: all commands must start from beginning of the line in the ema=
il body.
> > >
> > > --
> > > You received this message because you are subscribed to the Google Gr=
oups "syzkaller-bugs" group.
> > > To unsubscribe from this group and stop receiving emails from it, sen=
d an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/=
msgid/syzkaller-bugs/CADvbK_eandMH1aZvKnzdX%3D3xdS0NSo6_NAeCrKasqA9EON4B0A%=
40mail.gmail.com.
> > > For more options, visit https://groups.google.com/d/optout.
