From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Tue, 22 Apr 2014 21:50:18 +0000
Subject: RE: Is SCTP throughput really this low compared to TCP?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31FB23@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When I apply the patch you provided to the standard 3.14.0 kernel, I still get the highly erratic throughput (see output below).  It was only when I did the full "git revert" as suggested by Daniel that the erratic behaviour went away.

[root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.240.3 -V -l 1452 -t 60
iperf version 3.0.1 (10 January 2014)
Linux Lab200slot2 3.14.0 #1 SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
Time: Tue, 22 Apr 2014 21:44:24 GMT
Connecting to host 192.168.240.3, port 5201
      Cookie: Lab200slot2.1398203064.823332.513f07
[  4] local 192.168.240.2 port 55819 connected to 192.168.240.3 port 5201
Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, omitting 0 seconds, 60 second test
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.08   sec  23.9 MBytes   186 Mbits/sec                  
[  4]   1.08-2.13   sec  16.0 MBytes   128 Mbits/sec                  
[  4]   2.13-3.95   sec   198 MBytes   913 Mbits/sec                  
[  4]   3.95-4.00   sec  15.8 MBytes  2.62 Gbits/sec                  
[  4]   4.00-5.00   sec   226 MBytes  1.90 Gbits/sec                  
[  4]   5.00-6.84   sec   180 MBytes   819 Mbits/sec                  
[  4]   6.84-7.00   sec  44.0 MBytes  2.30 Gbits/sec                  
[  4]   7.00-8.01   sec  6.31 MBytes  52.2 Mbits/sec                  
[  4]   8.01-9.08   sec  21.3 MBytes   167 Mbits/sec                  
[  4]   9.08-10.12  sec  13.2 MBytes   107 Mbits/sec                  
[  4]  10.12-11.17  sec  14.8 MBytes   119 Mbits/sec                  
[  4]  11.17-12.97  sec   180 MBytes   839 Mbits/sec                  
[  4]  12.97-13.00  sec  8.25 MBytes  2.27 Gbits/sec                  
[  4]  13.00-14.10  sec  30.6 MBytes   234 Mbits/sec                  
[  4]  14.10-15.95  sec   191 MBytes   866 Mbits/sec                  
[  4]  15.95-16.00  sec  15.1 MBytes  2.51 Gbits/sec                  
[  4]  16.00-17.00  sec   219 MBytes  1.84 Gbits/sec                  
[  4]  17.00-18.09  sec  28.5 MBytes   218 Mbits/sec                  
[  4]  18.09-19.13  sec  11.4 MBytes  92.5 Mbits/sec                  
[  4]  19.13-20.17  sec  14.1 MBytes   114 Mbits/sec                  
[  4]  20.17-21.21  sec  13.0 MBytes   105 Mbits/sec                  
[  4]  21.21-23.27  sec  16.8 MBytes  68.4 Mbits/sec                  
[  4]  23.27-23.27  sec  0.00 Bytes  0.00 bits/sec                  
[  4]  23.27-24.00  sec   168 MBytes  1.91 Gbits/sec                  
[  4]  24.00-25.76  sec   179 MBytes   852 Mbits/sec                  
[  4]  25.76-26.00  sec  21.2 MBytes   760 Mbits/sec                  






-----Original Message-----
From: Vlad Yasevich [mailto:vyasevich@gmail.com] 
Sent: April-17-14 11:27 AM
To: Butler, Peter; Daniel Borkmann
Cc: linux-sctp@vger.kernel.org
Subject: Re: Is SCTP throughput really this low compared to TCP?

On 04/14/2014 12:47 PM, Butler, Peter wrote:
> Glad to be of help :o)
>

Hi Peter

Would you be able to run this test again with the following patch on top of the problematic code.

Thanks
-vlad


commit c9888a220916284403c5115d6c6c7e33a00d0b55
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Thu Apr 17 09:21:52 2014 -0400

    sctp: Trigger window update SACK after skb has been freed.

    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>

diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c index 8d198ae..b59a7c5 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -1011,7 +1011,6 @@ static void sctp_ulpevent_release_data(struct sctp_ulpevent *event)  {
 	struct sk_buff *skb, *frag;
 	unsigned int	len;
-	struct sctp_association *asoc;

 	/* Current stack structures assume that the rcv buffer is
 	 * per socket.   For UDP style sockets this is not true as
@@ -1036,11 +1035,7 @@ static void sctp_ulpevent_release_data(struct sctp_ulpevent *event)
 	}

 done:
-	asoc = event->asoc;
-	sctp_association_hold(asoc);
 	sctp_ulpevent_release_owner(event);
-	sctp_assoc_rwnd_update(asoc, true);
-	sctp_association_put(asoc);
 }

 static void sctp_ulpevent_release_frag_data(struct sctp_ulpevent *event) @@ -1071,12 +1066,21 @@ done:
  */
 void sctp_ulpevent_free(struct sctp_ulpevent *event)  {
+	struct sctp_association *asoc = event->asoc;
+
 	if (sctp_ulpevent_is_notification(event))
 		sctp_ulpevent_release_owner(event);
 	else
 		sctp_ulpevent_release_data(event);

 	kfree_skb(sctp_event2skb(event));
+	/* The socket is locked and the assocaiton can't go anywhere
+	 * since we are walking the uplqueue.  No need to hold
+	 * another ref on the association.  Now that the skb has been
+	 * freed and accounted for everywhere, see if we need to send
+	 * a window update SACK.
+	 */
+	sctp_assoc_rwnd_update(asoc, true);
 }

 /* Purge the skb lists holding ulpevents. */
