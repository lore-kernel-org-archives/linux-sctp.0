From: Shuaijun Zhang <szhang@research.ait.ie>
Date: Wed, 21 Apr 2010 10:49:41 +0000
Subject: [PATCH 2.6.27.28]: fix kernel dead if sending SET_PRIMARY ASCONF
Message-Id: <g2vfe1c05ca1004210349wec6d5452u77fcc226a80f1d08@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

The linux kernel will die if an application send SET_PRIMARY ASCONF
immediately after ADDIP ASCONF.
The reason is that SCTP finishes processing ASCONF_ACK, it sends the next
pending ASCONF. Therefore the state machine function sctp_do_sm() run
recursively. The commands for ASCONF are executed before the commands
for ASCONF_ACK.
The command sequences are running in reversed order. Therefore, the T4
timer for the new ASCONF starts before the old T4 timer stops. However,
SCTP uses only one timer for all ASCONF chunks.

This fixes the problem if deleting the statements for sending the next
ASCONF during processing ASCONF_ACK, and instead, use a new command
"SCTP_CMD_SEND_NEXT_ASCONF" for sending the next ASCONF chunk in the
sideeffect function of ASCONF_ACK.

Kernel version: 2.6.27.28

diff -uprN a/include/net/sctp/command.h b/include/net/sctp/command.h
--- a/include/net/sctp/command.h=A0=A0=A0 2010-04-20 17:24:18.000000000 +01=
00
+++ b/include/net/sctp/command.h=A0=A0=A0 2010-04-21 09:55:37.000000000 +01=
00
@@ -105,6 +105,7 @@ typedef enum {
=A0=A0=A0=A0 SCTP_CMD_ASSOC_SHKEY,=A0=A0=A0 /* generate the association sha=
red keys */
=A0=A0=A0=A0 SCTP_CMD_T1_RETRAN,=A0=A0=A0 =A0/* Mark for retransmission aft=
er T1 timeout=A0 */
=A0=A0=A0=A0 SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
+=A0=A0=A0 SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after
processing ASCONF_ACK */
=A0=A0=A0=A0 SCTP_CMD_LAST
=A0} sctp_verb_t;

diff -uprN a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c=A0=A0=A0 2010-04-20 17:15:01.000000000 +0100
+++ b/net/sctp/sm_make_chunk.c=A0=A0=A0 2010-04-21 09:39:17.000000000 +0100
@@ -3290,21 +3290,6 @@ int sctp_process_asconf_ack(struct sctp_
=A0=A0=A0=A0 sctp_chunk_free(asconf);
=A0=A0=A0=A0 asoc->addip_last_asconf =3D NULL;

-=A0=A0=A0 /* Send the next asconf chunk from the addip chunk queue. */
-=A0=A0=A0 if (!list_empty(&asoc->addip_chunk_list)) {
-=A0=A0=A0 =A0=A0=A0 struct list_head *entry =3D asoc->addip_chunk_list.nex=
t;
-=A0=A0=A0 =A0=A0=A0 asconf =3D list_entry(entry, struct sctp_chunk, list);
-
-=A0=A0=A0 =A0=A0=A0 list_del_init(entry);
-
-=A0=A0=A0 =A0=A0=A0 /* Hold the chunk until an ASCONF_ACK is received. */
-=A0=A0=A0 =A0=A0=A0 sctp_chunk_hold(asconf);
-=A0=A0=A0 =A0=A0=A0 if (sctp_primitive_ASCONF(asoc, asconf))
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sctp_chunk_free(asconf);
-=A0=A0=A0 =A0=A0=A0 else
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 asoc->addip_last_asconf =3D asconf;
-=A0=A0=A0 }
-
=A0=A0=A0=A0 return retval;
=A0}

diff -uprN a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
--- a/net/sctp/sm_sideeffect.c=A0=A0=A0 2010-04-20 17:15:01.000000000 +0100
+++ b/net/sctp/sm_sideeffect.c=A0=A0=A0 2010-04-21 09:33:43.000000000 +0100
@@ -1082,6 +1082,25 @@ static int sctp_cmd_interpreter(sctp_eve
=A0=A0=A0=A0 =A0*/
=A0=A0=A0=A0 while (NULL !=3D (cmd =3D sctp_next_cmd(commands))) {
=A0=A0=A0=A0 =A0=A0=A0 switch (cmd->verb) {
+
+=A0=A0=A0 =A0=A0=A0 case SCTP_CMD_SEND_NEXT_ASCONF:
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 asoc =3D cmd->obj.ptr;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* Send the next asconf chunk from the addip=
 chunk queue. */
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (!list_empty(&asoc->addip_chunk_list)) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 struct list_head *entry =3D asoc->=
addip_chunk_list.next;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 struct sctp_chunk *asconf =3D list=
_entry(entry, struct
sctp_chunk, list);
+
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 list_del_init(entry);
+
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* Hold the chunk until an ASCONF_=
ACK is received. */
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sctp_chunk_hold(asconf);
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (sctp_primitive_ASCONF(asoc, as=
conf))
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sctp_chunk_free(asconf);
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 else
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 asoc->addip_last_asconf =
=3D asconf;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
+
=A0=A0=A0=A0 =A0=A0=A0 case SCTP_CMD_NOP:
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* Do nothing. */
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
diff -uprN a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
--- a/net/sctp/sm_statefuns.c=A0=A0=A0 2010-04-20 17:15:01.000000000 +0100
+++ b/net/sctp/sm_statefuns.c=A0=A0=A0 2010-04-21 09:54:15.000000000 +0100
@@ -3585,6 +3585,9 @@ sctp_disposition_t sctp_sf_do_asconf_ack
=A0=A0=A0=A0 if ((rcvd_serial =3D sent_serial) && asoc->addip_last_asconf) {
=A0=A0=A0=A0 =A0=A0=A0 sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RT=
O));
+
+=A0=A0=A0 =A0=A0=A0 sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SCTP_ASOC(asoc));

=A0=A0=A0=A0 =A0=A0=A0 if (!sctp_process_asconf_ack((struct sctp_associatio=
n *)asoc,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0 asconf_ac=
k))



Signed-off-by: Yuansong Qiao <ysqiao@research.ait.ie>
                        Shuaijun Zhang <szhang@research.ait.ie>
