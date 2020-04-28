From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 28 Apr 2020 10:55:53 +0000
Subject: Re: [PATCHv4] sctp: Don't add the shutdown timer if its already been added
Message-Id: <20200428105553.GA1505771@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1458592673-31247-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1458592673-31247-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Mon, Apr 27, 2020 at 02:34:17PM +0300, Jere Lepp=E4nen wrote:
> On Mon, 21 Mar 2016, Neil Horman wrote:
>=20
> > This BUG halt was recently reported:
> >=20
> > PID: 2879   TASK: c16adaa0  CPU: 1   COMMAND: "sctpn"
> >  #0 [f418dd28] crash_kexec at c04a7d8c
> >  #1 [f418dd7c] oops_end at c0863e02
> >  #2 [f418dd90] do_invalid_op at c040aaca
> >  #3 [f418de28] error_code (via invalid_op) at c08631a5
> >     EAX: f34baac0  EBX: 00000090  ECX: f418deb0  EDX: f5542950  EBP: 00=
000000
> >     DS:  007b      ESI: f34ba800  ES:  007b      EDI: f418dea0  GS:  00=
e0
> >     CS:  0060      EIP: c046fa5e  ERR: ffffffff  EFLAGS: 00010286
> >  #4 [f418de5c] add_timer at c046fa5e
> >  #5 [f418de68] sctp_do_sm at f8db8c77 [sctp]
> >  #6 [f418df30] sctp_primitive_SHUTDOWN at f8dcc1b5 [sctp]
> >  #7 [f418df48] inet_shutdown at c080baf9
> >  #8 [f418df5c] sys_shutdown at c079eedf
> >  #9 [f418df70] sys_socketcall at c079fe88
> >     EAX: ffffffda  EBX: 0000000d  ECX: bfceea90  EDX: 0937af98
> >     DS:  007b      ESI: 0000000c  ES:  007b      EDI: b7150ae4
> >     SS:  007b      ESP: bfceea7c  EBP: bfceeaa8  GS:  0033
> >     CS:  0073      EIP: b775c424  ERR: 00000066  EFLAGS: 00000282
> >=20
> > It appears that the side effect that starts the shutdown timer was proc=
essed
> > multiple times, which can happen as multiple paths can trigger it.  Thi=
s of
> > course leads to the BUG halt in add_timer getting called.
> >=20
> > Fix seems pretty straightforward, just check before the timer is added =
if its
> > already been started.  If it has mod the timer instead to min(current
> > expiration, new expiration)
> >=20
> > Its been tested but not confirmed to fix the problem, as the issue has =
only
> > occured in production environments where test kernels are enjoined from=
 being
> > installed.  It appears to be a sane fix to me though.
>=20
> Hi Neil,
>=20
> This patch was acked by Marcelo four years ago, but was then apparently=20
> forgotten about and never applied. I have a comment to the patch itself, =

> below, so would it possible for you to reroll another version?
>=20
> Here's one way - not necessarily the only way - to hit this kernel BUG:
>=20
Yeah, I'll take a look at it today

Best
Neil

> --- clip ---
>=20
> # cat sctp_t2_double_start.c
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <sys/types.h>
> #include <netinet/in.h>
> #include <netinet/sctp.h>
> #include <arpa/inet.h>
>=20
> int main()
> {
> 	int listen_fd, server_fd, client_fd;
>=20
> 	struct sockaddr_in addr =3D {
> 		.sin_family =3D AF_INET,
> 		.sin_addr.s_addr =3D inet_addr("127.0.0.1"),
> 		.sin_port =3D htons(65000),
> 	};
>=20
> 	struct sockaddr_in caddr =3D addr;
> 	caddr.sin_port =3D htons(65001);
>=20
> 	listen_fd =3D socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
> 	bind(listen_fd, (struct sockaddr *)&addr, sizeof(addr));
> 	listen(listen_fd, 10);
> 	client_fd =3D socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
> 	bind(client_fd, (struct sockaddr *)&caddr, sizeof(caddr));
> 	connect(client_fd, (struct sockaddr *)&addr, sizeof(addr));
> 	struct linger lin =3D { .l_onoff =3D 1, .l_linger =3D 0, };
> 	setsockopt(client_fd, SOL_SOCKET, SO_LINGER, &lin, sizeof(lin));
> 	server_fd =3D accept(listen_fd, NULL, NULL);
> 	system("iptables -A INPUT -p sctp -j DROP");
> 	shutdown(server_fd, SHUT_WR);
> 	close(client_fd);
> 	system("iptables -D INPUT -p sctp -j DROP");
> 	client_fd =3D socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
> 	bind(client_fd, (struct sockaddr *)&caddr, sizeof(caddr));
> 	connect(client_fd, (struct sockaddr *)&addr, sizeof(addr));
> 	close(server_fd); // segfault and add_timer() kernel BUG
>=20
> 	return 0;
> }
> # gcc sctp_t2_double_start.c
> # ./a.out=20
> [  105.117695] ------------[ cut here ]------------
> [  105.120047] kernel BUG at kernel/time/timer.c:1135!
> [  105.122536] invalid opcode: 0000 [#1] SMP PTI
> [  105.124646] CPU: 8 PID: 1126 Comm: a.out Not tainted 5.5.15-200.fc31.x=
86_64 #1
> [  105.128029] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2=
014
> [  105.131380] RIP: 0010:add_timer+0x14a/0x200
> [  105.132382] Code: 5b 5d 41 5c 41 5d 41 5e c3 25 00 00 08 00 41 89 c6 e=
9 47 ff ff ff 48 c7 c5 00 d1 01 00 65 48 03 2d 4b 2b ea 5b e9 4b ff ff ff <=
0f> 0b 0f 0b 49 89 ec eb 8a e8 18 3f fa ff 48 c7 c2 80 be 01 00 89
> [  105.136724] RSP: 0018:ffff9c5440defba8 EFLAGS: 00010286
> [  105.137972] RAX: 0000000000000000 RBX: ffff8fc5ab0c6000 RCX: 00000000f=
ffd0462
> [  105.139658] RDX: 00000000fffd101a RSI: 0000000000000012 RDI: ffff8fc5a=
b0c6370
> [  105.141338] RBP: ffff8fc5ab0c6000 R08: ffff8fc5ab0c6018 R09: ffff8fc5a=
90a6204
> [  105.143026] R10: ffff8fc5c8c06d80 R11: ffff8fc5c16e7410 R12: 000000000=
0000000
> [  105.144725] R13: 0000000000000001 R14: ffff8fc5ab0c6370 R15: ffff9c544=
0defd50
> [  105.146391] FS:  00007f7b87b02540(0000) GS:ffff8fc5cf400000(0000) knlG=
S:0000000000000000
> [  105.148330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  105.149686] CR2: 00007f7b87937ff8 CR3: 0000000bf1fb8005 CR4: 000000000=
0160ee0
> [  105.151362] Call Trace:
> [  105.152007]  sctp_do_sm+0xc10/0x1e20 [sctp]
> [  105.153024]  ? pick_next_task_fair+0x19a/0x380
> [  105.154086]  ? __schedule+0x669/0x740
> [  105.154971]  ? __switch_to_asm+0x40/0x70
> [  105.155914]  ? __switch_to_asm+0x34/0x70
> [  105.156850]  ? __switch_to_asm+0x40/0x70
> [  105.157787]  ? __switch_to_asm+0x34/0x70
> [  105.158729]  ? __switch_to_asm+0x40/0x70
> [  105.159667]  ? __switch_to_asm+0x34/0x70
> [  105.160608]  ? __switch_to_asm+0x40/0x70
> [  105.161545]  ? __switch_to_asm+0x34/0x70
> [  105.162480]  ? __switch_to_asm+0x40/0x70
> [  105.163412]  ? __switch_to_asm+0x34/0x70
> [  105.164379]  ? __switch_to_asm+0x40/0x70
> [  105.165326]  sctp_primitive_SHUTDOWN+0x2f/0x40 [sctp]
> [  105.166537]  sctp_close+0x200/0x320 [sctp]
> [  105.167528]  inet_release+0x34/0x60
> [  105.168373]  __sock_release+0x3d/0xa0
> [  105.169265]  sock_close+0x11/0x20
> [  105.170072]  __fput+0xc1/0x250
> [  105.170822]  task_work_run+0x8a/0xb0
> [  105.171694]  exit_to_usermode_loop+0x102/0x130
> [  105.172760]  do_syscall_64+0x1a6/0x1c0
> [  105.173663]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  105.175557] RIP: 0033:0x7f7b87a2ac07
> [  105.177069] Code: ff ff e8 fc e8 01 00 66 2e 0f 1f 84 00 00 00 00 00 6=
6 90 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f 05 <=
48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 f3 41 f9 ff
> [  105.182798] RSP: 002b:00007ffe10833458 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000003
> [  105.185271] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f7b8=
7a2ac07
> [  105.187653] RDX: 0000000000000000 RSI: 00007ffe10833420 RDI: 000000000=
0000005
> [  105.190029] RBP: 00007ffe108334a0 R08: 0000000000000000 R09: 000000000=
0000000
> [  105.192398] R10: 0000000000000008 R11: 0000000000000246 R12: 000000000=
04010f0
> [  105.194779] R13: 00007ffe10833580 R14: 0000000000000000 R15: 000000000=
0000000
> [  105.197128] Modules linked in: iptable_filter sctp libcrc32c rfkill in=
tel_rapl_msr intel_rapl_common sb_edac kvm_intel snd_pcsp bochs_drm kvm drm=
_vram_helper snd_pcm irqbypass drm_ttm_helper ttm snd_timer ppdev drm_kms_h=
elper snd virg
> [  105.210029] ---[ end trace 8399eda7e3a18429 ]---
> [  105.211899] RIP: 0010:add_timer+0x14a/0x200
> [  105.213611] Code: 5b 5d 41 5c 41 5d 41 5e c3 25 00 00 08 00 41 89 c6 e=
9 47 ff ff ff 48 c7 c5 00 d1 01 00 65 48 03 2d 4b 2b ea 5b e9 4b ff ff ff <=
0f> 0b 0f 0b 49 89 ec eb 8a e8 18 3f fa ff 48 c7 c2 80 be 01 00 89
> [  105.220063] RSP: 0018:ffff9c5440defba8 EFLAGS: 00010286
> [  105.222102] RAX: 0000000000000000 RBX: ffff8fc5ab0c6000 RCX: 00000000f=
ffd0462
> [  105.224566] RDX: 00000000fffd101a RSI: 0000000000000012 RDI: ffff8fc5a=
b0c6370
> [  105.227022] RBP: ffff8fc5ab0c6000 R08: ffff8fc5ab0c6018 R09: ffff8fc5a=
90a6204
> [  105.229452] R10: ffff8fc5c8c06d80 R11: ffff8fc5c16e7410 R12: 000000000=
0000000
> [  105.231882] R13: 0000000000000001 R14: ffff8fc5ab0c6370 R15: ffff9c544=
0defd50
> [  105.234299] FS:  00007f7b87b02540(0000) GS:ffff8fc5cf400000(0000) knlG=
S:0000000000000000
> [  105.236935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  105.239040] CR2: 00007f7b87937ff8 CR3: 0000000bf1fb8005 CR4: 000000000=
0160ee0
> Segmentation fault
>=20
> --- clip ---
>=20
> The reason why this reproduces the BUG is because on the server side, the=
=20
> reconnect triggers an association restart, which moves the association to=
=20
> ESTABLISHED state, but leaves the T2 timer running. After that, close()=20
> triggers a new shutdown and an attempt to start the T2 timer again.
>=20
> With your patch, the BUG is not reproduced.
>=20
> Moving the association to ESTABLISHED state even though the socket is=20
> already closed is in itself a problem. I have a simple patch for that=20
> ready to be posted, but your patch should be handled first.
>=20
> >=20
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Vlad Yasevich <vyasevich@gmail.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> >=20
> > Change notes:
> >=20
> > v2) Removed WARN_ON, as its not useful
> >=20
> > v3) Actually commit my changes
> >=20
> > v4) Reduce code size by rolling expiration update into mod_timer line
> > ---
> >  net/sctp/sm_sideeffect.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index b5327bb..192ec99 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -1480,9 +1480,21 @@ static int sctp_cmd_interpreter(sctp_event_t eve=
nt_type,
> >  			timeout =3D asoc->timeouts[cmd->obj.to];
> >  			BUG_ON(!timeout);
> > =20
> > -			timer->expires =3D jiffies + timeout;
> > -			sctp_association_hold(asoc);
> > -			add_timer(timer);
> > +			/*
> > +			 * SCTP has a hard time with timer starts.  Because we process
> > +			 * timer starts as side effects, it can be hard to tell if we
> > +			 * have already started a timer or not, which leads to BUG
> > +			 * halts when we call add_timer. So here, instead of just starting
> > +			 * a timer, just determine the shorter of the two
> > +			 * timeouts and mod the timer to that.
> > +			 */
> > +			if (timer_pending(timer)) {
> > +				if (time_after(timer->expires, (jiffies + timeout)))
> > +					mod_timer(timer, jiffies + timeout);
> > +			} else {
> > +				sctp_association_hold(asoc);
> > +				mod_timer(timer, jiffies + timeout);
> > +			}
>=20
> Meanwhile, timer_reduce() has been added. Just call that instead?
>=20
> >  			break;
> > =20
> >  		case SCTP_CMD_TIMER_RESTART:
> > --=20
> > 2.5.5
> >=20
>=20
