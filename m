From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 21 Mar 2013 13:24:19 +0000
Subject: Re: [Lksctp-developers] ARP request being sent every 20 seconds or so
Message-Id: <514B0A03.5010704@gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------060505050801060406010900"
List-Id: <linux-sctp.vger.kernel.org>
References: <5149AE3F.50000@gmail.com>
In-Reply-To: <5149AE3F.50000@gmail.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------060505050801060406010900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/21/2013 03:38 AM, upma gandhi wrote:
> Hi Vlad,
>    I understand that  SCTP_MIB_OUTSCTPPACKS  is just for SCTP level stats.
> But in route module, when a packet( SCTP) is send out for some
> neighbor, we must be updating "used" variable with 'jiffies'  and
> which should not let ARP expiry timer kick in ? or is it that dst at
> SCTP layer doesn't match exactly to neighbor maintained at ARP layer ?
> I am asking all this for my understanding, pls. let me know if there
> is any document which talks about SCTP linux implementation.

The MIB attribute is just that.  It is used in the SNMP MIB.

The solution is for SCTP to call the proper dst/route code when the time 
is right.  Essentially, when SCTP determines that is has made forward 
progress in the connection, it can call dst_confirm().

I am attaching a patch that does this, but I have not tested it yet.
Give it a try and let me know if it works for you.

-vlad

>
> Thanks
> Upma
>
>
> On Wed, Mar 20, 2013 at 6:10 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>> On 03/20/2013 06:40 AM, upma gandhi wrote:
>>>
>>> Hi Vlad,
>>>       I am using linux kernel  2.6.32 and wondering if the fix you are
>>> referring is after that ?
>>> I would like to know if MIB variable SCTP_MIB_OUTSCTPPACKS  is picked
>>> up by ICMP to figure out if  neighbour is stale/unreachable/delay etc.
>>> ? Can you pls. point me to variable which is being set by SCTp on
>>> successful packet out and pickup by ARP to figure out if resolution is
>>> required or not ? I am sorry for writing personal mail but I am in
>>> need of solution faster.
>>
>>
>> I just checked, and we don't appear to have this fix.  Let me see if I can
>> cook something up for you to test.
>>
>> -vlad
>>
>>>
>>> Thanks
>>> Upma
>>>
>>> On Tue, Mar 19, 2013 at 5:37 PM, Vlad Yasevich <vyasevich@gmail.com>
>>> wrote:
>>>>
>>>> On 03/19/2013 05:03 AM, upma gandhi wrote:
>>>>>
>>>>> Hello All,
>>>>>      I have one basic SCTP client and server ( having single network
>>>>> connection) and client is continuously sending data to server every 1
>>>>> second. I am seeing that server is sending ARP request every 20
>>>>> seconds or so ( see below logs) for client IP address. If I use TCP
>>>>> client/ server  instead of SCTP, I see that ARP request is being sent
>>>>> every 4 minute. Can somebody clarify why its happening or if my
>>>>> observation is wrong ?
>>>>
>>>>
>>>> There was an old bug that SCTP didn't update the route forward progress
>>>> thus causing NUD to kick in even though reachability was configured
>>>> through SCTP.  I thought it was fixed a long time ago.  Which kernel
>>>> version are you using?
>>>>
>>>> -vlad
>>>>
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>>> ------------------------------------------------------------------------------
>>>>> Everyone hates slow websites. So do we.
>>>>> Make your web apps faster with AppDynamics
>>>>> Download AppDynamics Lite for free today:
>>>>> http://p.sf.net/sfu/appdyn_d2d_mar
>>>>> _______________________________________________
>>>>> Lksctp-developers mailing list
>>>>> Lksctp-developers@lists.sourceforge.net
>>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>>>
>>>>
>>>>
>>>>
>>>> ------------------------------------------------------------------------------
>>>> Everyone hates slow websites. So do we.
>>>> Make your web apps faster with AppDynamics
>>>> Download AppDynamics Lite for free today:
>>>> http://p.sf.net/sfu/appdyn_d2d_mar
>>>> _______________________________________________
>>>> Lksctp-developers mailing list
>>>> Lksctp-developers@lists.sourceforge.net
>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>
>>


--------------060505050801060406010900
Content-Type: text/x-patch;
 name="0001-sctp-Confirm-route-during-forward-progress.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-sctp-Confirm-route-during-forward-progress.patch"

From 6b5ccbdcddf0cfe763f27e0e264a685b53987a7c Mon Sep 17 00:00:00 2001
From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 21 Mar 2013 09:12:18 -0400
Subject: [PATCH] sctp: Confirm route during forward progress.

When SCTP makes forward progress (receives a SACK that acks new chunks,
renegs, or answeres 0-window probes) or when HB-ACK arrives, mark
the route as confirmed so we don't unnecessarily send NUD probes.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
---
 net/sctp/outqueue.c      |    9 +++++++++
 net/sctp/sm_sideeffect.c |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 01dca75..643c487 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1354,6 +1354,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 	__u8 restart_timer = 0;
 	int bytes_acked = 0;
 	int migrate_bytes = 0;
+	bool forward_progress = false;
 
 	/* These state variables are for coherent debug output. --xguo */
 
@@ -1435,6 +1436,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				bytes_acked += sctp_data_size(tchunk);
 				if (!tchunk->transport)
 					migrate_bytes += sctp_data_size(tchunk);
+				forward_progress = true;
 			}
 
 			if (TSN_lte(tsn, sack_ctsn)) {
@@ -1557,6 +1559,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				 * transmitted if it is not already running.
 				 */
 				restart_timer = 1;
+				forward_progress = true;
 			}
 
 			list_add_tail(lchunk, &tlist);
@@ -1690,6 +1693,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 						  __func__, sack_ctsn);
 				q->asoc->overall_error_count = 0;
 				transport->error_count = 0;
+				forward_progress = true;
 			}
 		}
 
@@ -1707,6 +1711,11 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				       jiffies + transport->rto))
 				sctp_transport_hold(transport);
 		}
+
+		if (forward_progress) {
+			if (transport->dst)
+				dst_confirm(transport->dst);
+		}
 	}
 
 	list_splice(&tlist, transmitted_queue);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8aab894..a657d87 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -733,6 +733,12 @@ static void sctp_cmd_transport_on(sctp_cmd_seq_t *cmds,
 		sctp_assoc_control_transport(asoc, t, SCTP_TRANSPORT_UP,
 					     SCTP_HEARTBEAT_SUCCESS);
 
+	/* HB-ACK was received for a the proper HB.  Consider this
+	 * forward progress.
+	 */
+	if (t->dst)
+		dst_confirm(t->dst);
+
 	/* The receiver of the HEARTBEAT ACK should also perform an
 	 * RTT measurement for that destination transport address
 	 * using the time value carried in the HEARTBEAT ACK chunk.
-- 
1.7.7.6


--------------060505050801060406010900--
