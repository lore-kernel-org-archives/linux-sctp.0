From: Mark Thomas <Mark.Thomas@metaswitch.com>
Date: Thu, 17 Oct 2013 16:53:50 +0000
Subject: RE: kernel BUG at net/sctp/sm_sideeffect.c:863
Message-Id: <4A7256EE0796CC44899E9868CE5B83989F646BE9@ENFIRHMBX1.datcon.co.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A7256EE0796CC44899E9868CE5B83989F6469DC@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <4A7256EE0796CC44899E9868CE5B83989F6469DC@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

No luck with that patch.  New stack dump below, although it looks exactly the same.

For our purposes we've backed out the change that introduced the BUG_ON, as we're actually running an older kernel with some backported fixes, and that change was accidentally backported alongside them.  So we don't need a fix, but it should obviously be fixed in the mainline kernel.

[   56.055967] ------------[ cut here ]------------
[   56.059793] kernel BUG at net/sctp/sm_sideeffect.c:863!
[   56.059793] invalid opcode: 0000 [#1] SMP 
[   56.059793] Modules linked in: hmac sctp crc32c libcrc32c cls_u32 sch_netem sch_prio bnep rfcomm bluetooth rfkill nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop joydev hid_generic usbhid hid snd_intel8x0 snd_ac97_codec snd_pcm ohci_pci ohci_hcd ehci_hcd usbcore snd_page_alloc snd_seq snd_timer snd_seq_device snd processor thermal_sys soundcore usb_common evdev ac97_bus psmouse parport_pc parport serio_raw pcspkr microcode ac i2c_piix4 i2c_core button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod crc_t10dif cdrom crct10dif_common ata_generic ata_piix ahci libahci libata e1000 scsi_mod
[   56.059793] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5+ #2
[   56.059793] Hardware name: innotek GmbH VirtualBox, BIOS VirtualBox 12/01/2006
[   56.059793] task: ffffffff81610440 ti: ffffffff81600000 task.ti: ffffffff81600000
[   56.059793] RIP: 0010:[<ffffffffa03a4d10>]  [<ffffffffa03a4d10>] sctp_do_sm+0x159/0x1091 [sctp]
[   56.059793] RSP: 0018:ffff88007fc03990  EFLAGS: 00010246
[   56.059793] RAX: ffff8800673e99c0 RBX: ffff88006b8f6000 RCX: ffff88006b8f66e0
[   56.059793] RDX: 0000000000002710 RSI: 0000000000000000 RDI: ffff88007fc03900
[   56.059793] RBP: ffff88007d368e80 R08: ffff88006b8f66e0 R09: 0000000064145e93
[   56.059793] R10: 0000000064145e93 R11: 0d38bc98639c4501 R12: ffff88007fc039e8
[   56.059793] R13: ffff88007fc03a08 R14: 0000000000000000 R15: ffff8800751e92c0
[   56.059793] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[   56.059793] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   56.059793] CR2: ffffffffff600400 CR3: 0000000061743000 CR4: 00000000000006f0
[   56.059793] Stack:
[   56.059793]  0000000000000001 ffff880030268000 0000000100000003 00000001751e92c0
[   56.059793]  0000000a00000001 ffff880030268000 0000000100000003 ffff8800751e92c0
[   56.059793]  000000000000000a ffff88007d3b7000 ffff880061553b80 ffff88007d368c80
[   56.059793] Call Trace:
[   56.059793]  <IRQ> 
[   56.059793]  [<ffffffffa03a80ac>] ? sctp_assoc_bh_rcv+0xe0/0x11d [sctp]
[   56.059793]  [<ffffffffa03b8cb2>] ? sctp_rcv+0x7c2/0x896 [sctp]
[   56.059793]  [<ffffffff812eca5b>] ? ip_local_deliver_finish+0x105/0x17b
[   56.059793]  [<ffffffff812c42d5>] ? __netif_receive_skb_core+0x44e/0x4c6
[   56.059793]  [<ffffffff812c450f>] ? netif_receive_skb+0x4c/0x7d
[   56.059793]  [<ffffffff812c4c69>] ? napi_gro_receive+0x35/0x76
[   56.059793]  [<ffffffffa003fd4c>] ? e1000_clean_rx_irq+0x330/0x3cd [e1000]
[   56.059793]  [<ffffffff8105f2f1>] ? update_entity_load_avg+0x14b/0x24f
[   56.059793]  [<ffffffffa003ecc5>] ? e1000_clean+0x5b9/0x725 [e1000]
[   56.059793]  [<ffffffff8105c141>] ? try_to_wake_up+0x17e/0x190
[   56.059793]  [<ffffffff812c4a15>] ? net_rx_action+0xa2/0x1c6
[   56.059793]  [<ffffffff81267274>] ? credit_entropy_bits.part.8+0x127/0x168
[   56.059793]  [<ffffffff8103ae04>] ? __do_softirq+0xe8/0x201
[   56.059793]  [<ffffffff813838dc>] ? call_softirq+0x1c/0x30
[   56.059793]  [<ffffffff81003b7c>] ? do_softirq+0x2c/0x60
[   56.059793]  [<ffffffff8103afe2>] ? irq_exit+0x3b/0x7f
[   56.059793]  [<ffffffff81003803>] ? do_IRQ+0x81/0x98
[   56.059793]  [<ffffffff8137d46a>] ? common_interrupt+0x6a/0x6a
[   56.059793]  <EOI> 
[   56.059793]  [<ffffffff81008aa3>] ? default_idle+0x15/0x3d
[   56.059793]  [<ffffffff81009021>] ? arch_cpu_idle+0x6/0x17
[   56.059793]  [<ffffffff8106fbad>] ? cpu_startup_entry+0x10d/0x180
[   56.059793]  [<ffffffff816adcd8>] ? start_kernel+0x3be/0x3c9
[   56.059793]  [<ffffffff816ad730>] ? repair_env_string+0x57/0x57
[   56.059793] Code: 50 12 80 fa 0a 75 1a f6 83 dc 07 00 00 02 75 11 8a 80 30 01 00 00 83 e0 03 3c 03 0f 85 1e 0f 00 00 48 83 bb 48 01 00 00 00 75 02 <0f> 0b 48 89 df e8 56 47 01 00 48 89 df e8 e3 41 00 00 e9 fd 0e 
[   56.059793] RIP  [<ffffffffa03a4d10>] sctp_do_sm+0x159/0x1091 [sctp]
[   56.059793]  RSP <ffff88007fc03990>


-----Original Message-----
From: Daniel Borkmann [mailto:dborkman@redhat.com] 
Sent: 17 October 2013 11:39
To: Mark Thomas
Cc: linux-sctp@vger.kernel.org
Subject: Re: kernel BUG at net/sctp/sm_sideeffect.c:863

On 10/17/2013 12:08 PM, Mark Thomas wrote:
> Hi,
>
> We've been experiencing crashes every few hours in SCTP with the above signature during some of our stress tests.  Full stack trace is at the bottom of this email.   After some effort I have come up with a reliable repro mechanism and a plausible explanation.  I'm not sure what the correct fix is, though.
>
> I've reproduced this on 3.12.0-rc5+ (as of 2013-10-16 17:00 GMT).
>
> The BUG_ON statement in question was added in commit f9e42b8535:
>
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c index 
> 8aab894..ff91f47 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -864,6 +864,7 @@ static void sctp_cmd_delete_tcb(sctp_cmd_seq_t *cmds,
> 		(!asoc->temp) && (sk->sk_shutdown != SHUTDOWN_MASK))
> 			return;
> +	BUG_ON(asoc->peer.primary_path = NULL);
> 	sctp_unhash_established(asoc);
> 	sctp_association_free(asoc);
> }
>
> Analyzing one of the crash dumps, it appears the original cause was receipt of a duplicate COOKIE-ECHO packet.  The repro mechanism is to provoke apparent duplicate COOKIE-ECHOs by dropping the COOKIE-ACK, causing the remote end to re-send the COOKIE-ECHO after a timeout.
>
> This can be done using netem and the following recipe:
>
> 	tc qdisc add dev eth0 root handle 1: prio bands 2 priomap 1 1 1 1 1 1
> 	tc qdisc add dev eth0 parent 1:2 handle 20: netem loss 20%
> 	tc filter add dev eth0 protocol ip parent 1: prio 2 u32 match ip 
> protocol 132 0xff match u8 0x0b 0xff at 32 flowid 1:2
>
> This drops 20% of COOKIE-ACK packets.
>
> Starting an SCTP server (e.g. sctp_darn) on the local machine, and then making a few connections from a remote system to it gives the kernel panic after several attempts.
>
> Trying to explain it, looking at sctp_sf_do_5_2_4_dupcook we do:
>
>    new_asoc = sctp_unpack_cookie(...); /* This creates a new, temporary, association. */
>    action = sctp_tietags_compare(new_asoc, asoc); /* This returns 'D' in the dump I looked at. */
>    sctp_sf_do_dupcook_d(..., new_asoc);

Could you try out the following (compile-tested) patch if that fixes your problem:

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c index dfe3f36..6b10bfe 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1895,6 +1895,7 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(struct net *net,
  {
  	struct sctp_ulpevent *ev = NULL, *ai_ev = NULL;
  	struct sctp_chunk *repl;
+	sctp_init_chunk_t *peer_init;

  	/* Clarification from Implementor's Guide:
  	 * D) When both local and remote tags match the endpoint should @@ -1942,6 +1943,14 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(struct net *net,
  		}
  	}

+	/* new_asoc is a brand-new association, so these are not yet
+	 * side effects--it is safe to run them here.
+	 */
+	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+	if (!sctp_process_init(new_asoc, chunk, sctp_source(chunk), peer_init,
+			       GFP_ATOMIC))
+		goto nomem;
+
  	repl = sctp_make_cookie_ack(new_asoc, chunk);
  	if (!repl)
  		goto nomem;

> and then queue up commands SCTP_CMD_SET_ASOC(new_asoc), SCTP_CMD_DELETE_TCB.
>
> None of these steps appear to initialise new_asoc->peer.primary path, so when we get to handling the DELETE_TCB command, it is NULL.
>
> Either the assertion that asoc->peer.primary_path can never be NULL at delete_tcb time is wrong (and the BUG_ON should be removed), or the code that handles duplicate cookies needs to set it to some value.  I don't know which of these it should be.  There was some discussion about bugs in this area on linux-sctp back in March, but it looks like the problem still exists, at least in this form.
>
> This is potentially a DoS attack for any SCTP server, as you can fairly easily provoke it by sending INIT, COOKIE-ECHO, COOKIE-ECHO.
>
> Regards,
>
> Mark Thomas
>
> [   42.325370] ------------[ cut here ]------------
> [   42.329216] kernel BUG at net/sctp/sm_sideeffect.c:863!
> [   42.329216] invalid opcode: 0000 [#1] SMP
> [   42.329216] Modules linked in: hmac sctp crc32c libcrc32c cls_u32 sch_netem sch_prio rfcomm bnep bluetooth rfkill nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop joydev hid_generic usbhid hid snd_intel8x0 snd_ac97_codec snd_pcm snd_page_alloc snd_seq snd_timer snd_seq_device psmouse snd ohci_pci evdev parport_pc parport pcspkr serio_raw ohci_hcd ehci_hcd usbcore ac processor thermal_sys soundcore ac97_bus microcode usb_common button i2c_piix4 i2c_core ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom crc_t10dif crct10dif_common ata_generic ahci libahci ata_piix e1000 libata scsi_mod
> [   42.329216] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5+ #2
> [   42.329216] Hardware name: innotek GmbH VirtualBox, BIOS VirtualBox 12/01/2006
> [   42.329216] task: ffffffff81610440 ti: ffffffff81600000 task.ti: ffffffff81600000
> [   42.329216] RIP: 0010:[<ffffffffa03add10>]  [<ffffffffa03add10>] sctp_do_sm+0x159/0x1091 [sctp]
> [   42.329216] RSP: 0018:ffff88007fc03990  EFLAGS: 00010246
> [   42.329216] RAX: ffff8800000829c0 RBX: ffff88002fd0a000 RCX: ffff88002fd0a6e0
> [   42.329216] RDX: 0000000000002710 RSI: 0000000000000000 RDI: ffff88007fc03900
> [   42.329216] RBP: ffff88007ca1ce80 R08: ffff88002fd0a6e0 R09: 0000000072a65008
> [   42.329216] R10: 0000000072a65008 R11: 519a9b1ce38676a9 R12: ffff88007fc039e8
> [   42.329216] R13: ffff88007fc03a08 R14: 0000000000000000 R15: ffff88000003dbc0
> [   42.329216] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
> [   42.329216] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   42.329216] CR2: ffffffffff600400 CR3: 000000002fd43000 CR4: 00000000000006f0
> [   42.329216] Stack:
> [   42.329216]  0000000000000001 0000000000000286 ffff8800615d31c0 0000000100000000
> [   42.329216]  0000000a00000001 ffff880075107000 0000000100000003 ffff88000003dbc0
> [   42.329216]  0000000000000000 ffff88007d3b7000 ffff8800615d31c0 ffff88007ca1cc80
> [   42.329216] Call Trace:
> [   42.329216]  <IRQ>
> [   42.329216]  [<ffffffffa03b10ac>] ? sctp_assoc_bh_rcv+0xe0/0x11d [sctp]
> [   42.329216]  [<ffffffffa03c1cb2>] ? sctp_rcv+0x7c2/0x896 [sctp]
> [   42.329216]  [<ffffffff812eca5b>] ? ip_local_deliver_finish+0x105/0x17b
> [   42.329216]  [<ffffffff812c42d5>] ? __netif_receive_skb_core+0x44e/0x4c6
> [   42.329216]  [<ffffffff812c450f>] ? netif_receive_skb+0x4c/0x7d
> [   42.329216]  [<ffffffff812c4c69>] ? napi_gro_receive+0x35/0x76
> [   42.329216]  [<ffffffffa007ad4c>] ? e1000_clean_rx_irq+0x330/0x3cd [e1000]
> [   42.329216]  [<ffffffffa0079cc5>] ? e1000_clean+0x5b9/0x725 [e1000]
> [   42.329216]  [<ffffffff81051442>] ? autoremove_wake_function+0x9/0x2a
> [   42.329216]  [<ffffffff81056e7f>] ? __wake_up_common+0x42/0x78
> [   42.329216]  [<ffffffff812c4a15>] ? net_rx_action+0xa2/0x1c6
> [   42.329216]  [<ffffffff8103ae04>] ? __do_softirq+0xe8/0x201
> [   42.329216]  [<ffffffff813838dc>] ? call_softirq+0x1c/0x30
> [   42.329216]  [<ffffffff81003b7c>] ? do_softirq+0x2c/0x60
> [   42.329216]  [<ffffffff8103afe2>] ? irq_exit+0x3b/0x7f
> [   42.329216]  [<ffffffff81003803>] ? do_IRQ+0x81/0x98
> [   42.329216]  [<ffffffff8137d46a>] ? common_interrupt+0x6a/0x6a
> [   42.329216]  <EOI>
> [   42.329216]  [<ffffffff81008aa3>] ? default_idle+0x15/0x3d
> [   42.329216]  [<ffffffff81009021>] ? arch_cpu_idle+0x6/0x17
> [   42.329216]  [<ffffffff8106fbad>] ? cpu_startup_entry+0x10d/0x180
> [   42.329216]  [<ffffffff816adcd8>] ? start_kernel+0x3be/0x3c9
> [   42.329216]  [<ffffffff816ad730>] ? repair_env_string+0x57/0x57
> [   42.329216] Code: 50 12 80 fa 0a 75 1a f6 83 dc 07 00 00 02 75 11 8a 80 30 01 00 00 83 e0 03 3c 03 0f 85 1e 0f 00 00 48 83 bb 48 01 00 00 00 75 02 <0f> 0b 48 89 df e8 56 47 01 00 48 89 df e8 e3 41 00 00 e9 fd 0e
> [   42.329216] RIP  [<ffffffffa03add10>] sctp_do_sm+0x159/0x1091 [sctp]
> [   42.329216]  RSP <ffff88007fc03990>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
>
