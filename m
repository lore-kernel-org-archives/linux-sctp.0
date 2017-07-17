From: "BOITEUX, Frederic" <fboiteux@prosodie.com>
Date: Mon, 17 Jul 2017 17:27:16 +0000
Subject: help about a lockup in sctp module
Message-Id: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

   Hello,

  I have a problem concerning sctp i would like to submit you :=A0on a Debi=
an 8.0 server with 3.16.0 Linux kernel,  using SCTP , we observe a soft loc=
kup in sctp_assoc_update_retran_path :

[ 724.633312] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
[ 724.633345] Modules linked in: hmac nfsd auth_rpcgss oid_registry nfs_acl=
 nfs lockd fscache sunrpc vmw_vsock_vmci_transport vsock vmwgfx ttm drm_kms=
_helper drm vmw_balloon coretemp ppdev evdev i2c_piix4 serio_raw pcspkr crc=
32_pclmul i2c_core aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_hel=
per cryptd vmw_vmci battery parport_pc parport shpchp processor thermal_sys=
 ac button sctp libcrc32c crc32c_generic loop kkcore(O) autofs4 ext4 crc16 =
mbcache jbd2 dm_mod sr_mod cdrom sg ata_generic sd_mod crc_t10dif crct10dif=
_generic crct10dif_pclmul crct10dif_common crc32c_intel psmouse ata_piix li=
bata vmw_pvscsi scsi_mod vmxnet3
[ 724.633376] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G O 3.16.0-4-amd64 #1 =
Debian 3.16.39-1+deb8u2
[ 724.633377] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Des=
ktop Reference Platform, BIOS 6.00 09/21/2015
[ 724.633379] task: ffffffff8181a460 ti: ffffffff81800000 task.ti: ffffffff=
81800000
[ 724.633380] RIP: 0010:[<ffffffffa01d1c96>] [<ffffffffa01d1c96>] sctp_asso=
c_update_retran_path+0x56/0xc0 [sctp] <<=3D=3D
[ 724.633388] RSP: 0018:ffff88023fc03c68 EFLAGS: 00000293
[ 724.633389] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX: 00000094d316=
0b1c
[ 724.633390] RDX: 0000000000000001 RSI: ffff8800ba2ae400 RDI: ffff8800ba2a=
e400
[ 724.633391] RBP: ffff8800bb14c128 R08: ffffffff81610640 R09: 000000000000=
0001
[ 724.633391] R10: 0000000000000003 R11: 0000000000000010 R12: ffff88023fc0=
3bd8

It's similar to Redhat bug (https://access.redhat.com/solutions/2039183) bu=
t our kernel already have the fix for this problem. We hadn't the latest De=
bian kernel version, but carefully looking at its changelog, we don't see p=
otential fix available.=20

As in the Redhat bug report, we also use SCTP with multiple  multi-homed en=
dpoints, and are facing this bug during transient global network failure.

In the sctp_assoc_update_retran_path(), we noted this loop :

        /* Iterate from retran_path's successor back to retran_path. */
        for (trans =3D list_next_entry(trans, transports); 1;
             trans =3D list_next_entry(trans, transports)) {
                /* Manually skip the head element. */
                if (&trans->transports =3D &asoc->peer.transport_addr_list)
                        continue;
                if (trans->state =3D SCTP_UNCONFIRMED)
                        continue;
                trans_next =3D sctp_trans_elect_best(trans, trans_next);
                /* Active is good enough for immediate return. */
                if (trans_next->state =3D SCTP_ACTIVE)
                        break;
                /* We've reached the end, time to update path. */
                if (trans =3D asoc->peer.retran_path)
                        break;
        }

We wonder if the lockup could occur if an association have multiple distant=
 peers, all in UNCONFIRMED state ? Because in this case, the 'continue' sta=
tement prevent to reach the last test which break the loop, no ?

We can't at now reproduce the problem in a deterministic way, limiting debu=
g, but we would appreciate a lot your expert point of view about this probl=
em.

     With regards,
	Fr=E9d=E9ric Boiteux.

This message contains information that may be privileged or confidential an=
d is the property of the Capgemini Group. It is intended only for the perso=
n to whom it is addressed. If you are not the intended recipient, you are n=
ot authorized to read, print, retain, copy, disseminate, distribute, or use=
 this message or any part thereof. If you receive this message in error, pl=
ease notify the sender immediately and delete all copies of this message.

