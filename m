From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Thu, 17 Apr 2014 16:15:31 +0000
Subject: RE: Is SCTP throughput really this low compared to TCP?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31EFBC@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I should be able to, but won't be able to run the test until Tuesday April 22...

________________________________________
From: Vlad Yasevich [vyasevich@gmail.com]
Sent: Thursday, April 17, 2014 11:26 AM
To: Butler, Peter; Daniel Borkmann
Cc: linux-sctp@vger.kernel.org
Subject: Re: Is SCTP throughput really this low compared to TCP?

On 04/14/2014 12:47 PM, Butler, Peter wrote:
> Glad to be of help :o)
>

Hi Peter

Would you be able to run this test again with the following patch
on top of the problematic code.

Thanks
-vlad


commit c9888a220916284403c5115d6c6c7e33a00d0b55
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Thu Apr 17 09:21:52 2014 -0400

    sctp: Trigger window update SACK after skb has been freed.

    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>

diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 8d198ae..b59a7c5 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -1011,7 +1011,6 @@ static void sctp_ulpevent_release_data(struct
sctp_ulpevent *event)
 {
        struct sk_buff *skb, *frag;
        unsigned int    len;
-       struct sctp_association *asoc;

        /* Current stack structures assume that the rcv buffer is
         * per socket.   For UDP style sockets this is not true as
@@ -1036,11 +1035,7 @@ static void sctp_ulpevent_release_data(struct
sctp_ulpevent *event)
        }

 done:
-       asoc = event->asoc;
-       sctp_association_hold(asoc);
        sctp_ulpevent_release_owner(event);
-       sctp_assoc_rwnd_update(asoc, true);
-       sctp_association_put(asoc);
 }

 static void sctp_ulpevent_release_frag_data(struct sctp_ulpevent *event)
@@ -1071,12 +1066,21 @@ done:
  */
 void sctp_ulpevent_free(struct sctp_ulpevent *event)
 {
+       struct sctp_association *asoc = event->asoc;
+
        if (sctp_ulpevent_is_notification(event))
                sctp_ulpevent_release_owner(event);
        else
                sctp_ulpevent_release_data(event);

        kfree_skb(sctp_event2skb(event));
+       /* The socket is locked and the assocaiton can't go anywhere
+        * since we are walking the uplqueue.  No need to hold
+        * another ref on the association.  Now that the skb has been
+        * freed and accounted for everywhere, see if we need to send
+        * a window update SACK.
+        */
+       sctp_assoc_rwnd_update(asoc, true);
 }

 /* Purge the skb lists holding ulpevents. */
