From: Chang <changxiangzhong@gmail.com>
Date: Sun, 13 Oct 2013 10:14:38 +0000
Subject: potential bug on SFR-CACC
Message-Id: <525A728E.8040007@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,
I'm reading the source code of LK-SCTP and find something that I 
couldn't understand on the SFR-CACC feature of LK-SCTP, which might be a 
bug.

When a sender receiving a SACK, ***sctp_check_transmitted()*** would be 
invoked to update the state variables related to SFR-CACC, including 
***highest_new_tsn_in_sack*** and ***cacc_saw_newack***.

---------------------------------------------------------
The scripts to update ***highest_new_tsn_in_sack*** is as follow. 
Function ***sctp_acked*** checks if the tsn is acked(EITHER cumulatively 
OR selectively) in the sack reply.
---------------------------------------------------------
if(sctp_acked(sack, tsn)) {
     ......
     *highest_new_tsn_in_sack  = tsn;
     ......
}
---------------------------------------------------------
The scripts to upate ***cacc_saw_newack*** is as follow. It checks if 
the tsn is less/euqal than the cumulatively acked TSN ONLY in the sack 
reply, which is INCONSISTENCY with the abovementioned.
---------------------------------------------------------
if (TSN_lte(tsn, sack_ctsn)) {// sack_ctsn is cumulatively-acked
     ......
     if (!tchunk->tsn_gap_acked) {
         if (transport && sack->num_gap_ack_blocks && 
q->asoc->peer.primary_path->cacc.changeover_active)
         transport->cacc.cacc_saw_newack = 1;
     }
     ......
}

I would appreicate if anyone could confirm this is a work-as-design or a 
bug?

Cheers!
