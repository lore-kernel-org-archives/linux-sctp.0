From: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
Date: Thu, 07 Jan 2016 08:55:46 +0000
Subject: RE: X2AP:handoverPreparationFailure message is not received at source node
Message-Id: <PS1PR0401MB15132229FF3D4EBF9CC02E35FEF50@PS1PR0401MB1513.apcprd04.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <SG2PR0401MB1519DBCC7B5AEF0FD79DECAEFEF30@SG2PR0401MB1519.apcprd04.prod.outlook.com>
In-Reply-To: <SG2PR0401MB1519DBCC7B5AEF0FD79DECAEFEF30@SG2PR0401MB1519.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Could somebody please respond and help.

-----Original Message-----
From: Ravi Puttachannaiah
Sent: Tuesday, January 05, 2016 2:35 PM
To: 'linux-sctp@vger.kernel.org' <linux-sctp@vger.kernel.org>
Subject: X2AP:handoverPreparationFailure message is not received at source node

Hi,

                We are using X2AP protocol over the LKSCTP (ver 1.0.16) and we are seeing the following issue.

Scenario:

                1.            We have source node connected to the two peer nodes peer-1 and peer-2.
                2.            Source node does not have a SCTP connectivity with peer-1 because the peer-1 was not reachable. In this case source node will re-try every 4-seconds to establish a SCTP connection by creating a new SCTP association and sending a SCTP:INIT. If there is no response for SCTP:INIT (once all the SCTP:INIT retries are exhausted) then source node will close the socket or sctp association and retry again after 4-seconds.


Problem:

                1.            It is observed that when the retry attempt is going on for peer-1 the X2AP message sent from peer-2 node to source node is not getting received at source node. The source node is sending X2AP:handoverPreparation to peer-2 node and this is successfully received at peer-2. But when peer-2 sends X2AP:handoverPreparationFailure to source node this message is not received at  source node.

                2.            When there is no re-try attempt on-going(between source node to peer-1) then there is no issue observed and we can see that X2AP:handoverPreparationFailure is successfully received at source node.

                Could you please help us to resolve this SCTP issue. Please let me know what logs are required to check this issue.

Regards,

Ravi

"DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
