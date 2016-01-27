From: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>
Date: Wed, 27 Jan 2016 15:36:11 +0000
Subject: Query on SCTP:INIT re-transmission interval behavior
Message-Id: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

We are using LKSCTP version 1.0.16 and have configured the SCTP configuration parameters as follows:

SctpInitMaxAttempts : 10
SctpInitRTO : 3000
SctpMinRTO : 1000
SctpMaxRTO : 60000

We observed that SCTP:INIT re-transmission is occurring at interval  6,12,24.., 6,12,24.., 6,12,24....... As per our understanding re-transmission should occur at interval  3,6,12,24..., 3,6,12,24...3,6,12,24... since SctpInitRTO000.

Could you please let us know if it is an expected behavior or not. Also why re-transmission interval is not started with 3,6,12,24...


Regards,

Ravi

"DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
