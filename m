From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 17 Jul 2017 18:20:10 +0000
Subject: Re: help about a lockup in sctp module
Message-Id: <20170717182010.GV18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
In-Reply-To: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi,

On Mon, Jul 17, 2017 at 05:27:16PM +0000, BOITEUX, Frederic wrote:
>    Hello,
>=20
>   I have a problem concerning sctp i would like to submit you :=A0on a De=
bian 8.0 server with 3.16.0 Linux kernel,  using SCTP , we observe a soft l=
ockup in sctp_assoc_update_retran_path :
>=20
> [ 724.633312] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
> [ 724.633345] Modules linked in: hmac nfsd auth_rpcgss oid_registry nfs_a=
cl nfs lockd fscache sunrpc vmw_vsock_vmci_transport vsock vmwgfx ttm drm_k=
ms_helper drm vmw_balloon coretemp ppdev evdev i2c_piix4 serio_raw pcspkr c=
rc32_pclmul i2c_core aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_h=
elper cryptd vmw_vmci battery parport_pc parport shpchp processor thermal_s=
ys ac button sctp libcrc32c crc32c_generic loop kkcore(O) autofs4 ext4 crc1=
6 mbcache jbd2 dm_mod sr_mod cdrom sg ata_generic sd_mod crc_t10dif crct10d=
if_generic crct10dif_pclmul crct10dif_common crc32c_intel psmouse ata_piix =
libata vmw_pvscsi scsi_mod vmxnet3
> [ 724.633376] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G O 3.16.0-4-amd64 #=
1 Debian 3.16.39-1+deb8u2
> [ 724.633377] Hardware name: VMware, Inc. VMware Virtual Platform/440BX D=
esktop Reference Platform, BIOS 6.00 09/21/2015
> [ 724.633379] task: ffffffff8181a460 ti: ffffffff81800000 task.ti: ffffff=
ff81800000
> [ 724.633380] RIP: 0010:[<ffffffffa01d1c96>] [<ffffffffa01d1c96>] sctp_as=
soc_update_retran_path+0x56/0xc0 [sctp] <<=3D=3D
> [ 724.633388] RSP: 0018:ffff88023fc03c68 EFLAGS: 00000293
> [ 724.633389] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX: 00000094d3=
160b1c
> [ 724.633390] RDX: 0000000000000001 RSI: ffff8800ba2ae400 RDI: ffff8800ba=
2ae400
> [ 724.633391] RBP: ffff8800bb14c128 R08: ffffffff81610640 R09: 0000000000=
000001
> [ 724.633391] R10: 0000000000000003 R11: 0000000000000010 R12: ffff88023f=
c03bd8

Can you please include the rest here? Specially the call trace.
Will be helpful to know how sctp_assoc_update_retran_path got called.

>=20
> It's similar to Redhat bug (https://access.redhat.com/solutions/2039183) =
but our kernel already have the fix for this problem. We hadn't the latest =
Debian kernel version, but carefully looking at its changelog, we don't see=
 potential fix available.=20
>=20
> As in the Redhat bug report, we also use SCTP with multiple  multi-homed =
endpoints, and are facing this bug during transient global network failure.
>=20
> In the sctp_assoc_update_retran_path(), we noted this loop :
>=20
>         /* Iterate from retran_path's successor back to retran_path. */
>         for (trans =3D list_next_entry(trans, transports); 1;
>              trans =3D list_next_entry(trans, transports)) {
>                 /* Manually skip the head element. */
>                 if (&trans->transports =3D &asoc->peer.transport_addr_lis=
t)
>                         continue;
>                 if (trans->state =3D SCTP_UNCONFIRMED)
>                         continue;
>                 trans_next =3D sctp_trans_elect_best(trans, trans_next);
>                 /* Active is good enough for immediate return. */
>                 if (trans_next->state =3D SCTP_ACTIVE)
>                         break;
>                 /* We've reached the end, time to update path. */
>                 if (trans =3D asoc->peer.retran_path)
>                         break;
>         }
>=20
> We wonder if the lockup could occur if an association have multiple dista=
nt peers, all in UNCONFIRMED state ? Because in this case, the 'continue' s=
tatement prevent to reach the last test which break the loop, no ?

It would seem so, yes, but maybe some other check could have avoided
such situation.

Nevertheless, that for() probably can be re-written using
list_for_each_entry_continue(), would be safer. Would bring the last
if() to the for condition and avoid infinite loops.

>=20
> We can't at now reproduce the problem in a deterministic way, limiting de=
bug, but we would appreciate a lot your expert point of view about this pro=
blem.

The calltrace may give us more hints on that.

>=20
>      With regards,
> 	Fr=E9d=E9ric Boiteux.
>=20
> This message contains information that may be privileged or confidential =
and is the property of the Capgemini Group. It is intended only for the per=
son to whom it is addressed. If you are not the intended recipient, you are=
 not authorized to read, print, retain, copy, disseminate, distribute, or u=
se this message or any part thereof. If you receive this message in error, =
please notify the sender immediately and delete all copies of this message.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
