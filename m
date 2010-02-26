From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 26 Feb 2010 03:15:31 +0000
Subject: [PATCH 1/3] sctp_darn: add inter command heartbeat for user initiated
Message-Id: <4B873CD3.7050307@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Add inter command heartbeat to sctp_darn, which is used for
request a user initiated heartbeat to be made immediately.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 src/apps/sctp_darn.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/src/apps/sctp_darn.c b/src/apps/sctp_darn.c
index 3d76730..625e541 100644
--- a/src/apps/sctp_darn.c
+++ b/src/apps/sctp_darn.c
@@ -142,7 +142,8 @@ enum inter_cmd_num {
 	INTER_SHUTDOWN,
 	INTER_ABORT,
 	INTER_NODELAY,
-	INTER_MAXSEG
+	INTER_MAXSEG,
+	INTER_HEARTBEAT
 };
=20
 enum shutdown_type {
@@ -168,6 +169,7 @@ struct inter_entry inter_commands[] =3D {
 	{"abort", INTER_ABORT},
 	{"nodelay", INTER_NODELAY},
 	{"maxseg", INTER_MAXSEG},
+	{"heartbeat", INTER_HEARTBEAT},
 	{NULL, -1},
 };
=20
@@ -189,6 +191,7 @@ static int bindx_func(char *, int, struct sockaddr *, i=
nt, int, int);
 static int connectx_func(char *, int, struct sockaddr *, int);
 static void  primary_func(char *, int, char *, int);
 static void  peer_primary_func(char *, int, char *, int);
+static void  spp_hb_demand_func(char *, int, char *, int);
 static int nodelay_func(char *, int, int val, int set);
 static int maxseg_func(char *, int, int val, int set);
 static int shutdown_func(char *argv0, int *skp, int shutdown_type);
@@ -1520,6 +1523,7 @@ parse_inter_commands(char *argv0, char *input, int sn=
d_only)
 		printf("sndbuf=3D<int>     - Get/Set send buffer size.\n");
 		printf("primary=3D<addr>   - Get/Set association's primary\n");
 		printf("peer_primary=ADdr- Set association's peer_primary\n");
+		printf("heartbeat=3D<addr> - Request a user initiated heartbeat\n");
 		printf("maxseg=3D<int>     - Get/Set Maximum fragment size.\n");
 		printf("nodelay=3D<0|1>    - Get/Set NODELAY option.\n");
 		printf("shutdown         - Shutdown the association.\n");
@@ -1600,6 +1604,9 @@ parse_inter_commands(char *argv0, char *input, int sn=
d_only)
 			case INTER_SET_PEER_PRIM:
 				peer_primary_func(argv0, inter_sk, p, set);
 				break;
+			case INTER_HEARTBEAT:
+				spp_hb_demand_func(argv0, inter_sk, p, set);
+				break;
 			case INTER_SHUTDOWN:
 				shutdown_func(argv0, &inter_sk, SHUTDOWN_SHUTDOWN);
 				break;
@@ -1990,6 +1997,56 @@ err:
 	        (set)?"setting":"getting", strerror(errno));
 }
=20
+static void
+spp_hb_demand_func(char *argv0, int sk, char *cp, int set)
+{
+	struct sctp_paddrparams params;
+	struct sockaddr_in *in_addr;
+	struct sockaddr_in6 *in6_addr;
+	int ret;
+	char *p =3D cp;
+
+	memset(&params, 0, sizeof(struct sctp_paddrparams));
+	params.spp_assoc_id =3D associd;
+	params.spp_flags =3D SPP_HB_DEMAND;
+
+	if (set) {
+		/* Set the buffer for address parsing.  */
+		while ('\n' !=3D *p)
+			p++;
+		*p =3D '\0';
+
+		if (strchr(cp, '.')) {
+			in_addr =3D (struct sockaddr_in *)&params.spp_address;
+			in_addr->sin_port =3D htons(remote_port);
+			in_addr->sin_family =3D AF_INET;
+			ret =3D inet_pton(AF_INET, cp, &in_addr->sin_addr);
+			if (ret <=3D 0)
+				goto err;
+		} else if (strchr(cp, ':')) {
+			in6_addr =3D (struct sockaddr_in6 *)&params.spp_address;
+			in6_addr->sin6_port =3D htons(remote_port);
+			in6_addr->sin6_family =3D AF_INET6;
+			ret =3D inet_pton(AF_INET6, cp, &in6_addr->sin6_addr);
+			if (ret <=3D 0)
+				goto err;
+		} else
+			goto err;
+	}
+
+	ret =3D setsockopt(sk, IPPROTO_SCTP, SCTP_PEER_ADDR_PARAMS,
+			    &params, sizeof(struct sctp_paddrparams));
+	if (ret < 0)
+		goto err;
+
+	return;
+err:
+	if (!errno)
+		errno =3D EINVAL;
+	fprintf(stderr, "%s: error %s peer_addr_params: %s.\n", argv0,
+	        (set)?"setting":"getting", strerror(errno));
+}
+
 static int
 nodelay_func(char *argv0, int sk, int val, int set)
 {
--=20
1.6.5.2


