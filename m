From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 24 Nov 2008 13:35:37 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081124133537.GA5131@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Fri 21-11-08 09:28:37, Vlad Yasevich wrote:
> Michal

Hi Vlad,

>=20
> This really smells like the corruption of the sctp_packet structure.
> The number chunks printout out is 0, but the list appears to have multiple
> entries on it.
>=20
> Can you turn on CONFIG_DEBUG_LIST and may be even turn on memory
> debugging as well.

I have turned on some debug config options as you have suggested and
here is the trace (unfortunately there was no other output on my serial
console):

[  250.409580] SCTP: Hash tables configured (established 65536 bind 65536)
=FF[16142.417028] Possible SKB overflow: packet size =3D 1072, packet overh=
ead =3D 32, packet chunks =3D 4, mtu =3D 1500
[16142.426764] skb_over_panic: text:f849766f len:2092 put:1040 head:eaba680=
0 data:eaba6874 tail:0xeaba70a0 end:0xeaba6d00 dev:<NULL>
[16142.438508] ------------[ cut here ]------------
[16142.442483] kernel BUG at net/core/skbuff.c:128!
[16142.442483] invalid opcode: 0000 [#1] PREEMPT SMP=20
[16142.452135] last sysfs file: /sys/class/power_supply/CMB1/status
[16142.452135] Dumping ftrace buffer:
[16142.452135]    (ftrace buffer empty)
[16142.452135] Modules linked in: hmac sctp libcrc32c i915 drm fuse tun cor=
etemp hwmon arc4 ecb snd_hda_intel snd_pcm snd_seq iwl3945 snd_timer mac802=
11 snd_seq_device led_class snd fujitsu_laptop cfg80211 snd_page_alloc rtc_=
cmos rtc_core rtc_lib backlight sky2
[16142.452135]=20
[16142.452135] Pid: 0, comm: swapper Not tainted (2.6.28-rc5-sctp #23) LIFE=
BOOK S7110
[16142.452135] EIP: 0060:[<c035415f>] EFLAGS: 00010246 CPU: 1
[16142.452135] EIP is at skb_put+0x5f/0x6d
[16142.452135] EAX: 00000088 EBX: eaba70a0 ECX: c0608000 EDX: 00000101
[16142.452135] ESI: 00000410 EDI: eaba6c90 EBP: c0608db8 ESP: c0608d8c
[16142.452135]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[16142.452135] Process swapper (pid: 0, ti=C0608000 task=F7036280 task.ti=
=F7312000)
[16142.452135] Stack:
[16142.452135]  c0518e09 f849766f 0000082c 00000410 eaba6800 eaba6874 eaba7=
0a0 eaba6d00
[16142.452135]  c04dcc90 e9466d80 ea92a800 c0608e00 f849766f e9577318 e9577=
320 eaba6874
[16142.452135]  e9577200 ea911800 e889c3c0 e9466d80 01911c94 00000000 00000=
41c f6b26f00
[16142.452135] Call Trace:
[16142.452135]  [<f849766f>] ? sctp_packet_transmit+0x242/0x3f2 [sctp]
[16142.452135]  [<f849766f>] ? sctp_packet_transmit+0x242/0x3f2 [sctp]
[16142.452135]  [<f848f936>] ? sctp_outq_flush+0x62a/0x65e [sctp]
[16142.452135]  [<f848ed15>] ? sctp_retransmit_mark+0x17a/0x193 [sctp]
[16142.452135]  [<f848fcdb>] ? sctp_retransmit+0x1f9/0x215 [sctp]
[16142.452135]  [<f84878a6>] ? sctp_do_sm+0x526/0xd66 [sctp]
[16142.452135]  [<c03f20e2>] ? _spin_unlock_irqrestore+0x11/0x25
[16142.452135]  [<c0135046>] ? insert_work+0x3d/0x45
[16142.452135]  [<f84882cc>] ? sctp_generate_t3_rtx_event+0x61/0x91 [sctp]
[16142.452135]  [<c012f3aa>] ? run_timer_softirq+0x140/0x1a0
[16142.452135]  [<f848826b>] ? sctp_generate_t3_rtx_event+0x0/0x91 [sctp]
[16142.452135]  [<f848826b>] ? sctp_generate_t3_rtx_event+0x0/0x91 [sctp]
[16142.452135]  [<c012c26a>] ? __do_softirq+0x7d/0x11e
[16142.452135]  [<c012c1ed>] ? __do_softirq+0x0/0x11e
[16142.452135]  <IRQ> <0> [<c012bfcd>] ? irq_exit+0x3a/0x79
[16142.644018]  [<c01127c8>] ? smp_apic_timer_interrupt+0x71/0x7f
[16142.644018]  [<c01046c0>] ? apic_timer_interrupt+0x28/0x30
[16142.644018]  [<c025a5e1>] ? acpi_idle_enter_bm+0x2d3/0x355
[16142.644018]  [<c0140da1>] ? tick_nohz_get_sleep_length+0xe/0x26
[16142.644018]  [<c033f440>] ? cpuidle_idle_call+0x65/0x99
[16142.644018]  [<c0102b2a>] ? cpu_idle+0x71/0xa3
[16142.644018]  [<c03ed2cf>] ? start_secondary+0x18b/0x192
[16142.644018] Code: c0 85 d2 0f 45 c2 50 ff b1 94 00 00 00 53 ff b1 9c 00 =
00 00 ff b1 98 00 00 00 56 ff 71 50 ff 75 04 68 09 8e 51 c0 e8 68 ba 09 00 =
<0f> 0b 83 c4 24 eb fe 8d 65 f8 5b 5e 5d c3 55 89 e5 57 56 53 83=20
[16142.644018] EIP: [<c035415f>] skb_put+0x5f/0x6d SS:ESP 0068:c0608d8c


If you are interested in vmcore, system map and config file, you can find=20
them at:
ftp.novell.com/outgoing/System.map-2.6.28-rc5-sctp.debug.gz
ftp.novell.com/outgoing/vmcore.2.6.28-rc5-sctp.debug.gz
ftp.novell.com/outgoing/config-2.6.28-rc5-sctp.debug

Best regrads
--=20
Michal Hocko
L3 team=20
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
