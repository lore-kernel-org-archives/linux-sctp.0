From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Nov 2018 16:26:44 +0000
Subject: [PATCH net-next 3/4] sctp: rename enum sctp_event to sctp_event_type
Message-Id: <0c2ae084947de1de336988616b641ae11a54404d.1542039673.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542039672.git.lucien.xin@gmail.com>
 <7ecc29f2a93410e51c32a433417bcf84a9aaf44c.1542039673.git.lucien.xin@gmail.com>
 <fb63fe1e7b08dfc38a3da8670584296660ba5e16.1542039673.git.lucien.xin@gmail.com>
In-Reply-To: <fb63fe1e7b08dfc38a3da8670584296660ba5e16.1542039673.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_event is a structure name defined in RFC for sockopt
SCTP_EVENT. To avoid the conflict, rename it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h |  2 +-
 include/net/sctp/sm.h        |  4 ++--
 net/sctp/primitive.c         |  2 +-
 net/sctp/sm_sideeffect.c     | 12 ++++++------
 net/sctp/sm_statetable.c     |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 8dadc74..4588bdc 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -71,7 +71,7 @@ enum { SCTP_DEFAULT_INSTREAMS = SCTP_MAX_STREAM };
 					 SCTP_NUM_AUTH_CHUNK_TYPES)
 
 /* These are the different flavours of event.  */
-enum sctp_event {
+enum sctp_event_type {
 	SCTP_EVENT_T_CHUNK = 1,
 	SCTP_EVENT_T_TIMEOUT,
 	SCTP_EVENT_T_OTHER,
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 9e3d327..24825a8 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -173,7 +173,7 @@ sctp_state_fn_t sctp_sf_autoclose_timer_expire;
 __u8 sctp_get_chunk_type(struct sctp_chunk *chunk);
 const struct sctp_sm_table_entry *sctp_sm_lookup_event(
 					struct net *net,
-					enum sctp_event event_type,
+					enum sctp_event_type event_type,
 					enum sctp_state state,
 					union sctp_subtype event_subtype);
 int sctp_chunk_iif(const struct sctp_chunk *);
@@ -313,7 +313,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 
 /* Prototypes for statetable processing. */
 
-int sctp_do_sm(struct net *net, enum sctp_event event_type,
+int sctp_do_sm(struct net *net, enum sctp_event_type event_type,
 	       union sctp_subtype subtype, enum sctp_state state,
 	       struct sctp_endpoint *ep, struct sctp_association *asoc,
 	       void *event_arg, gfp_t gfp);
diff --git a/net/sctp/primitive.c b/net/sctp/primitive.c
index c0817f7a..a8c4c33 100644
--- a/net/sctp/primitive.c
+++ b/net/sctp/primitive.c
@@ -53,7 +53,7 @@
 int sctp_primitive_ ## name(struct net *net, struct sctp_association *asoc, \
 			    void *arg) { \
 	int error = 0; \
-	enum sctp_event event_type; union sctp_subtype subtype; \
+	enum sctp_event_type event_type; union sctp_subtype subtype; \
 	enum sctp_state state; \
 	struct sctp_endpoint *ep; \
 	\
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 85d3930..1d143bc 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -52,7 +52,7 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
-static int sctp_cmd_interpreter(enum sctp_event event_type,
+static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 				union sctp_subtype subtype,
 				enum sctp_state state,
 				struct sctp_endpoint *ep,
@@ -61,7 +61,7 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 				enum sctp_disposition status,
 				struct sctp_cmd_seq *commands,
 				gfp_t gfp);
-static int sctp_side_effects(enum sctp_event event_type,
+static int sctp_side_effects(enum sctp_event_type event_type,
 			     union sctp_subtype subtype,
 			     enum sctp_state state,
 			     struct sctp_endpoint *ep,
@@ -623,7 +623,7 @@ static void sctp_cmd_init_failed(struct sctp_cmd_seq *commands,
 /* Worker routine to handle SCTP_CMD_ASSOC_FAILED.  */
 static void sctp_cmd_assoc_failed(struct sctp_cmd_seq *commands,
 				  struct sctp_association *asoc,
-				  enum sctp_event event_type,
+				  enum sctp_event_type event_type,
 				  union sctp_subtype subtype,
 				  struct sctp_chunk *chunk,
 				  unsigned int error)
@@ -1162,7 +1162,7 @@ static void sctp_cmd_send_asconf(struct sctp_association *asoc)
  * If you want to understand all of lksctp, this is a
  * good place to start.
  */
-int sctp_do_sm(struct net *net, enum sctp_event event_type,
+int sctp_do_sm(struct net *net, enum sctp_event_type event_type,
 	       union sctp_subtype subtype, enum sctp_state state,
 	       struct sctp_endpoint *ep, struct sctp_association *asoc,
 	       void *event_arg, gfp_t gfp)
@@ -1199,7 +1199,7 @@ int sctp_do_sm(struct net *net, enum sctp_event event_type,
 /*****************************************************************
  * This the master state function side effect processing function.
  *****************************************************************/
-static int sctp_side_effects(enum sctp_event event_type,
+static int sctp_side_effects(enum sctp_event_type event_type,
 			     union sctp_subtype subtype,
 			     enum sctp_state state,
 			     struct sctp_endpoint *ep,
@@ -1285,7 +1285,7 @@ static int sctp_side_effects(enum sctp_event event_type,
  ********************************************************************/
 
 /* This is the side-effect interpreter.  */
-static int sctp_cmd_interpreter(enum sctp_event event_type,
+static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 				union sctp_subtype subtype,
 				enum sctp_state state,
 				struct sctp_endpoint *ep,
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 691d9dc..d239b94 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -79,7 +79,7 @@ static const struct sctp_sm_table_entry bug = {
 
 const struct sctp_sm_table_entry *sctp_sm_lookup_event(
 					struct net *net,
-					enum sctp_event event_type,
+					enum sctp_event_type event_type,
 					enum sctp_state state,
 					union sctp_subtype event_subtype)
 {
-- 
2.1.0
