From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 06 Aug 2016 15:26:54 +0000
Subject: Re: Regarding commit f2815633504b442ca0b0605c16bf3d88a3a0fcea (sctp: Use correct sideffect command i
Message-Id: <20160806152654.GA9750@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Sat, Aug 06, 2016 at 10:38:04AM +0000, Khandelwal, Deepak 1. (Nokia - IN=
/Bangalore) wrote:
> Hi,
>=20
> This is regarding below commit. I think we are facing a crash due to this=
 (back trace in the end).
>=20
> The newly created association or TCB was supposed to be a temporary one. =
But it is created using "sctp_association_new " as _not_ temporary (new_aso=
c->temp =3D 0).
> Since after below commit this newly created association or TCB will not b=
e hashed (was earlier done in SCTP_CMD_NEW_ASOC).
> When it does SCTP_CMD_DELETE_TCB, and try to delete the entry from hash l=
ist, this results in a crash.
>=20
>=20
> "
>     sctp: Use correct sideffect command in duplicate cookie handling
>=20
>     [ Upstream commit f2815633504b442ca0b0605c16bf3d88a3a0fcea ]
>=20
>     When SCTP is done processing a duplicate cookie chunk, it tries
>     to delete a newly created association.  For that, it has to set
>     the right association for the side-effect processing to work.
>     However, when it uses the SCTP_CMD_NEW_ASOC command, that performs
>     more work then really needed (like hashing the associationa and
>     assigning it an id) and there is no point to do that only to
>     delete the association as a next step.  In fact, it also creates
>     an impossible condition where an association may be found by
>     the getsockopt() call, and that association is empty.  This
>     causes a crash in some sctp getsockopts.
>=20
>     The solution is rather simple.  We simply use SCTP_CMD_SET_ASOC
>     command that doesn't have all the overhead and does exactly
>     what we need.
>=20
>     Reported-by: Karl Heiss <kheiss@gmail.com>
>     Tested-by: Karl Heiss <kheiss@gmail.com>
>     CC: Neil Horman <nhorman@tuxdriver.com>
>     Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
>     Acked-by: Neil Horman <nhorman@tuxdriver.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> "
>=20
>=20
>=20
> ****
> RFC 4960:
> 4)  If the State Cookie proves to be valid, unpack the TCB into a
>        temporary TCB.
> ****
>=20
>=20
>=20
> *****
> Duplicate Cookie handing...
>=20
> sctp_disposition_t sctp_sf_do_5_2_4_dupcook(const struct sctp_endpoint *e=
p,
>                     const struct sctp_association *asoc,
>                     const sctp_subtype_t type,
>                     void *arg,
>                     sctp_cmd_seq_t *commands)
> ...
>    new_asoc =3D sctp_unpack_cookie(ep, asoc, chunk, GFP_ATOMIC, &error,
>                       &err_chk_p);
> ...
>=20
>=20
> sctp_unpack_cookie function uses a method which create not temporary asso=
ciation.
>=20
> /* Make a new base association.  */
>     scope =3D sctp_scope(sctp_source(chunk));
>     retval =3D sctp_association_new(ep, ep->base.sk, scope, gfp);
>=20
>=20
> Finally with this retval->temp =3D 0  =3D> not temporary association..
>=20
> ****
>=20
>=20
> Crash Back Trace
> =3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> [  743.372001] CPU 0 Unable to handle kernel paging request at virtual ad=
dress 0000000000000000, epc =3D ffffffff8065a024, ra =3D ffffffff8065a01c
> [  743.397073] Oops[#1]:
> [  743.411706] Cpu 0
> [  743.425987] $ 0   : 0000000000000000 000000001000cce1 0000000000000000=
 0000000000000000
> [  743.508170] $ 4   : 0000000000000000 0000000000000000 0000000000000000=
 000000000004e51d
> [  743.590352] $ 8   : ffffffffffffffff 736865643a204379 70726573733a5363=
 74702d353a206173
> [  743.672537] $12   : 70726573733a5363 ffffffff80105e34 0000000000000028=
 0000000000000000
> [  743.754721] $16   : a8000001dce4f000 ffffffff80be0000 a8000001de599890=
 000000000b59c049
> [  743.836912] $20   : 0000000000000004 0000000000000001 0000000000000001=
 000000000000000a
> [  743.919094] $24   : 0000000000000000 ffffffff80113d80
> [  744.001275] $28   : ffffffff80df8000 ffffffff80dfb690 a8000001ddb58df0=
 ffffffff8065a01c
> [  744.083458] Hi    : 0000000000000500
> [  744.099390] Lo    : 0000000000000460
> [  744.115336] epc   : ffffffff8065a024 sctp_unhash_established+0x17c/0x2=
28
> [  744.134402]     Tainted: P
> [  744.150340] ra    : ffffffff8065a01c sctp_unhash_established+0x174/0x2=
28
> [  744.169400] Status: 1000cce3    KX SX UX KERNEL EXL IE
> [  744.273534] Cause : 8080000c
> [  744.288769] BadVA : 0000000000000000
> [  744.304701] PrId  : 000d0409 (Cavium Octeon+)
> [  744.321412] Modules linked in: e1000e octeon_ethernet ipmi_msghandler =
ipmi_devintf ipmi_serial ipmi_serial_terminal_mode sunrpc lockd nfs octeon_=
pow_ethernet 8021q ipmi_watchdog_gpio fptun fps vnb_linux vnb(P) rfpvi binf=
mt_misc loop isofs netconsole mtdoops ecc_driver_core ecc_driver_edac kbfd =
af_key esp4 ah4
> [  744.719771] Process swapper (pid: 0, threadinfo=FFffffff80df8000, task=
=FFffffff80e1a080, tls=0000000000000000)
> [  744.742133] Stack : a8000001dce4f000 a8000001dce4f000 ffffffff80dfb770=
 a8000001a6a06e00
> [  744.811795]         0000000000000000 ffffffff8063cef0 0000000000000001=
 ffffffff80bdea20
> [  744.893976]         0000000a00000000 a8000001de4dd800 ffffffff80be07a0=
 a8000001de4dd800
> [  744.976157]         0000000000000020 ffffffff80e20000 ffffffff80e60000=
 ffffffff80dfb7b0
> [  745.058338]         ffffffff80e60000 ffffffff80dfb770 0000000000000004=
 a8000001a6a06e00
> [  745.140519]         0000000000000001 ffffffff80bdea20 a8000001ddb58800=
 a8000001de4dd800
> [  745.222702]         ffffffff80be07a0 ffffffff8063d13c 0000000000000020=
 000000000000003f
> [  745.304884]         0000000000000000 0000002b00000000 a8000001dce4f000=
 0000002a00000000
> [  745.387064]         a8000001a6a06d00 0000000c00000000 a8000001dccff9a8=
 0000000b00000000
> [  745.469247]         a8000001dce4f000 0000004000000000 0000000000000000=
 0000000200000000
> [  745.551431]         ...
> [  745.603484] Call Trace:
> [  745.618302] [<ffffffff8065a024>] sctp_unhash_established+0x17c/0x228
> [  745.637030] [<ffffffff8063cef0>] sctp_side_effects+0x13a8/0x1508
> [  745.655406] [<ffffffff8063d13c>] sctp_do_sm+0xec/0x208
> [  745.672909] [<ffffffff80641d34>] sctp_assoc_bh_rcv+0x10c/0x208
> [  745.691107] [<ffffffff8065b468>] sctp_rcv+0x630/0x890
> [  745.708527] [<ffffffff80566818>] ip_local_deliver_finish+0x170/0x378
> [  745.727247] [<ffffffff80565e5c>] ip_rcv_finish+0x12c/0x488
> [  745.745098] [<ffffffff80566578>] ip_rcv+0x3c0/0x4f0
> [  745.762342] [<ffffffff80526774>] netif_receive_skb+0x674/0x828
> [  745.780540] [<ffffffff805269d0>] process_backlog+0xa8/0x108
> [  745.798484] [<ffffffff80526dc4>] net_rx_action+0x194/0x3a0
> [  745.816355] [<ffffffff80194970>] __do_softirq+0x120/0x2f8
> [  745.834124] [<ffffffff80194bb8>] do_softirq+0x70/0x78
> [  745.851540] [<ffffffff80194e98>] irq_exit+0x70/0x88
> [  745.868785] [<ffffffff80115d94>] native_plat_irq_dispatch+0x74/0xb8
> [  745.887420] [<ffffffff80102580>] ret_from_irq+0x0/0x4
> [  745.904834] [<ffffffff80100ca0>] r4k_wait+0x20/0x40
> [  745.922079] [<ffffffff801552fc>] cpu_idle+0xa4/0xb0
> [  745.939327] [<ffffffff80e80c70>] start_kernel+0x504/0x520
> [  745.957087]
> [  745.970935]
> [  745.970937] Code: 0200302d  de020000  de030008 <10400002> fc620000  fc=
430008  3c0480dd  662506c8  0200302d
> [  746.130614] Kernel panic - not syncing: Fatal exception in interrupt
>=20
>=20
>=20
>=20
> Best Regards,
> Deepak
>=20
Sounds like you should perhaps add a temp flag to sctp_unpack_cookie and use
that to call either sctp_association_new or sctp_association_temp_new.  Can=
 you
give that a try?

Neil

