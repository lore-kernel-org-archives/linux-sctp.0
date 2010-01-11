From: RahulSrivastava 71616 <rahuls@huawei.com>
Date: Mon, 11 Jan 2010 14:12:25 +0000
Subject: Query
Message-Id: <f9a68846db1c.db1cf9a68846@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All,
       I have a query. When using Linux SCTP one-to-many style sockets sendmsg succedes even though message is not delivered at the peer. When I ask the socket to wait for notification it gave send failed in notification.
Is this possible for sendmsg to fail for even for one-to-many style socket (for peer errors)?

Regards,
Rahul



******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it!
 *****************************************************************************************
