From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 12 Jan 2010 20:52:42 +0000
Subject: Re: Query
Message-Id: <4B4CE11A.9090207@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f9a68846db1c.db1cf9a68846@huawei.com>
In-Reply-To: <f9a68846db1c.db1cf9a68846@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



RahulSrivastava 71616 wrote:
> Thanks!
> If sendmsg succedes like this then how its possible to maintain ordering of messages:
> Consider below order:
>   send1 ----> send2
> 
> send1 was not recieved but send2 was successfully recived by peer on same association. Application gets a notification of send1 (indicating send failed).
> 

No, that will not happen on the same association unless partial reliability is
used.

In the normal scenario (full reliability), if send1 fails, then the association
is destroyed.  The SEND_FAILED event is typically generated in the case of
excessive retransmissions that cause the association to terminate.  There are
a few other times it can be generated, but all those times have to do with
setting a time_to_live on the message.

So, if you are using implicit connect (i.e used the sendto/sendmsg() call
to establish an association), then the steps are these:

1) queue the message to the kernel queue.
2) start association procedure.
   a) if association is successful, send the message.
   b) if association fails, notify the user to association and send failure.

If if you already have an association, the protocol will attempt to deliver
all messages in order.  If the message has already been queued to the kernel,
and the association terminates due to retransmissions, you will get an
association termination notification and a send failed notification.
Any subsequent send calls by the applications will attempt to establish a
new association.

-vlad
> 
> 
> Regards,
> Rahul
> 
> 
> ******************************************************************************************
>  This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it!
>  *****************************************************************************************
> 
> ----- Original Message -----
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Monday, January 11, 2010 10:35 pm
> Subject: Re: Query
> To: RahulSrivastava 71616 <rahuls@huawei.com>
> Cc: linux-sctp@vger.kernel.org
> 
>>
>> RahulSrivastava 71616 wrote:
>>> Hi All,
>>>        I have a query. When using Linux SCTP one-to-many style 
>> sockets sendmsg succedes even though message is not delivered at 
>> the peer. When I ask the socket to wait for notification it gave 
>> send failed in notification.
>>> Is this possible for sendmsg to fail for even for one-to-many 
>> style socket (for peer errors)?
>> Yes.  sendmsg() will return success when the data has successfully 
>> been accepted
>> by the kernel.  However, if peer has problems, you may get a 
>> SEND_FAILEDnotification.
>>
>> This is not linux SCTP specific.  TCP can behave the same way 
>> (minus the
>> notification).
>>
>> -vlad
>>
>>> Regards,
>>> Rahul
>>>
>>>
>>>
>>>
>> ******************************************************************************************>  This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it!
>>>  
>> *****************************************************************************************> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-
>> sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
