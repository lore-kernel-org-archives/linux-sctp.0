From: Sasha Levin <sashal@kernel.org>
Date: Mon, 08 Jun 2020 23:05:52 +0000
Subject: [PATCH AUTOSEL 5.6 227/606] sctp: Start shutdown on association restart if in SHUTDOWN-SENT state an
Message-Id: <20200608231211.3363633-227-sashal@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Jere Leppänen <jere.leppanen@nokia.com>

[ Upstream commit d3e8e4c11870413789f029a71e72ae6e971fe678 ]

Commit bdf6fa52f01b ("sctp: handle association restarts when the
socket is closed.") starts shutdown when an association is restarted,
if in SHUTDOWN-PENDING state and the socket is closed. However, the
rationale stated in that commit applies also when in SHUTDOWN-SENT
state - we don't want to move an association to ESTABLISHED state when
the socket has been closed, because that results in an association
that is unreachable from user space.

The problem scenario:

1.  Client crashes and/or restarts.

2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.

3.  Client reconnects using the same addresses and ports.

4.  Server's association is restarted. The association and the socket
    move to ESTABLISHED state, even though the server process has
    closed its descriptor.

Also, after step 4 when the server process exits, some resources are
leaked in an attempt to release the underlying inet sock structure in
ESTABLISHED state:

    IPv4: Attempt to release TCP socket in state 1 00000000377288c7

Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
an association is restarted in SHUTDOWN-SENT state and the socket is
closed, then start shutdown and don't move the association or the
socket to ESTABLISHED state.

Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 26788f4a3b9e..e86620fbd90f 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1856,12 +1856,13 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	/* Update the content of current association. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
-	if (sctp_state(asoc, SHUTDOWN_PENDING) &&
+	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
+	     sctp_state(asoc, SHUTDOWN_SENT)) &&
 	    (sctp_sstate(asoc->base.sk, CLOSING) ||
 	     sock_flag(asoc->base.sk, SOCK_DEAD))) {
-		/* if were currently in SHUTDOWN_PENDING, but the socket
-		 * has been closed by user, don't transition to ESTABLISHED.
-		 * Instead trigger SHUTDOWN bundled with COOKIE_ACK.
+		/* If the socket has been closed by user, don't
+		 * transition to ESTABLISHED. Instead trigger SHUTDOWN
+		 * bundled with COOKIE_ACK.
 		 */
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
-- 
2.25.1
