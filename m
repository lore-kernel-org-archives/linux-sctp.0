From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 11 Jan 2010 17:05:21 +0000
Subject: Re: Query
Message-Id: <4B4B5A51.4030701@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f9a68846db1c.db1cf9a68846@huawei.com>
In-Reply-To: <f9a68846db1c.db1cf9a68846@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



RahulSrivastava 71616 wrote:
> Hi All,
>        I have a query. When using Linux SCTP one-to-many style sockets sendmsg succedes even though message is not delivered at the peer. When I ask the socket to wait for notification it gave send failed in notification.
> Is this possible for sendmsg to fail for even for one-to-many style socket (for peer errors)?
> 

Yes.  sendmsg() will return success when the data has successfully been accepted
by the kernel.  However, if peer has problems, you may get a SEND_FAILED
notification.

This is not linux SCTP specific.  TCP can behave the same way (minus the
notification).

-vlad

> Regards,
> Rahul
> 
> 
> 
> ******************************************************************************************
>  This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it!
>  *****************************************************************************************
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
