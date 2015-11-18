From: "g.o.m.o.n.o.v.y.c.h" <gomonovych@gmail.com>
Date: Wed, 18 Nov 2015 15:49:44 +0000
Subject: About rwnd_press?
Message-Id: <CAHYXAnL=yJ64EGLCCXROQHeJ=hXN0u5LmdKBMO8tj3aLm3dTTw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I would like to ask about asoc->rwnd_press in compared to asoc->rwnd.

sctp_assoc_rwnd_increase has next if case:
if (asoc->rwnd_press && asoc->rwnd >= asoc->rwnd_press)

I want ask community opinion about "asoc->rwnd >= asoc->rwnd_press"
I observed situation when association buffer was empty but "asoc->rwnd
>= asoc->rwnd_press"
returned false.
Next table shows this issue:
1. skb_payload = payload + skb; (skb=232)
2. If ulp will read all packets from buffer how much asoc->rwnd will be
rwnd_r      = (sk_rcvbuf / skb_payload) * payload;
3. for current payload size and sk_rcvbuf size how big initialization
value will be for rwnd_press (in sctp_assoc_rwnd_decrease).
rwnd_press  = sk_rcvbuf/2 - rwnd_r
On my laptop skb has sizeof(struct sk_buff) = 232 and sk_rcvbuf equal 212992.

payload     skb_payload         rwnd_r       rwnd_press
...
16              248             13744           92752
//asoc->rwnd>=asoc->rwnd_press - false. but buffer empty.
17              249             14552           91944
18              250             15336           91160
19              251             16131           90365
20              252             16920           89576
21              253             17682           88814
22              254             18458           88038
23              255             19228           87268
24              256             19968           86528
25              257             20725           85771
26              258             21476           85020
27              259             22221           84275
28              260             22960           83536
29              261             23693           82803
30              262             24390           82106
31              263             25110           81386
32              264             25824           80672
...
64              296             46080           60416
65              297             46670           59826
66              298             47190           59306
67              299             47771           58725
68              300             48280           58216
69              301             48852           57644
70              302             49420           57076
71              303             49913           56583
72              304             50472           56024
73              305             51027           55469
74              306             51578           54918
75              307             52050           54446
76              308             52592           53904
77              309             53130     <     53366
78              310             53664     >     52832
//asoc->rwnd>=asoc->rwnd_press - true
79              311             54115     >     52381
80              312             54640     >     51856

Should it ("asoc->rwnd >= asoc->rwnd_press") stay false even when buffer empty?

I tested on my laptop next solution:

--- a/net/sctp/associola.c    2015-08-15 19:07:16.527696361 +0200
+++ b/net/sctp/associola.c    2015-08-15 20:08:22.407812656 +0200
@@ -1458,10 +1458,18 @@ void sctp_assoc_rwnd_increase(struct sct
      * threshold.  The idea is to recover slowly, but up
      * to the initial advertised window.
      */
-    if (asoc->rwnd_press && asoc->rwnd >= asoc->rwnd_press) {
-        int change = min(asoc->pathmtu, asoc->rwnd_press);
-        asoc->rwnd += change;
-        asoc->rwnd_press -= change;
+    if (asoc->rwnd_press) {
+        int fr_count = asoc->base.sk->sk_rcvbuf;
+        if (asoc->ep->rcvbuf_policy)
+            fr_count -= atomic_read(&asoc->rmem_alloc);
+        else
+            fr_count -= atomic_read(&asoc->base.sk->sk_rmem_alloc);
+
+        if (fr_count > 0 && ((fr_count >> 1) >= asoc->rwnd_press)) {
+            int change = min(asoc->pathmtu, asoc->rwnd_press);
+            asoc->rwnd += change;
+            asoc->rwnd_press -= change;
+        }
     }

     pr_debug("%s: asoc:%p rwnd increased by %d to (%u, %u) - %u\n",
