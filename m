From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 19 Jan 2016 14:28:49 +0000
Subject: Re: X2AP:handoverPreparationFailure message is not received at source node
Message-Id: <569E4821.9010405@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <SG2PR0401MB1519DBCC7B5AEF0FD79DECAEFEF30@SG2PR0401MB1519.apcprd04.prod.outlook.com>
In-Reply-To: <SG2PR0401MB1519DBCC7B5AEF0FD79DECAEFEF30@SG2PR0401MB1519.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On 01/17/2016 11:35 AM, Ravi Puttachannaiah wrote:
> Hi Vlad,
> 
> Thanks for the response and the support.
> 
> From the application side I can see that message is successfully written to the socket (tracked till sctp_sendmsg() function call) and there is no error reported by sctp_sendmsg(). As indicated initially the problem is NOT seen when both the peer-1 and peer-2 connection is active but the problem is seen only when one of the connection is down (i.e peer-1 is not reachable).
> 
> Could you please let us know if there is any way to check if LKSCTP is received the message but not dropped or how to confirm it is a application or LKSCTP issue.
> 

You could turn on sctp debuging and look at the logs to see which socket/association you
are sending the packet on.

Outside of this, there is nothing much we can do on this list.

-vlad

> *********************************************************************************************************************************************************************
> 
> Scenario:
> 
>                 1.            We have source node connected to the two peer nodes peer-1 and peer-2.
>                 2.            Source node does not have a SCTP connectivity with peer-1 because the peer-1 was not reachable. In this case source node will re-try every 4-seconds to establish a SCTP connection by creating a new SCTP association and sending a SCTP:INIT. If there is no response for SCTP:INIT (once all the SCTP:INIT retries are exhausted) then source node will close the socket or sctp association and retry again after 4-seconds.
> 
> 
> Problem:
> 
>                 1.            It is observed that when the retry attempt is going on for peer-1 the X2AP message sent from peer-2 node to source node is not getting received at source node. The source node is sending X2AP:handoverPreparation to peer-2 node and this is successfully received at peer-2. But when peer-2 sends X2AP:handoverPreparationFailure to source node this message is not received at  source node.
> 
>                 2.            When there is no re-try attempt on-going(between source node to peer-1) then there is no issue observed and we can see that X2AP:handoverPreparationFailure is successfully received at source node.
> 
> ********************************************************************************************************************************************************************
> 
> Regards,
> 
> Ravi
> 
> 
> -----Original Message-----
> From: Vlad Yasevich [mailto:vyasevich@gmail.com]
> Sent: Thursday, January 14, 2016 9:30 PM
> To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>; malc <mlashley@gmail.com>; linux-sctp@vger.kernel.org
> Subject: Re: X2AP:handoverPreparationFailure message is not received at source node
> 
> On 01/14/2016 09:53 AM, Ravi Puttachannaiah wrote:
>> Hi Vlad,
>>
>> I have uploaded the logs at the following URL. The pcap is captured on the .1.46 machine.  Please check and help.
>>
>> https://www.dropbox.com/sh/qes9250bhbrzd43/AAAFkPS7DK8eM1F3Z_vZQvNra?d
>> l=0
> 
> The captures do not show .1.46 machine transmitting any data.  It does transmit SACKs and HB.
> 
> If there is a problem, it might be with the application during the probe phase.
> 
> -vlad
> 
>>
>> We also captured the nic stats. Looks like  there is no dropped or error frames in transmission packets on eth1 interface.
>>
>> ##################### Befor test ######################
>> eth1      Link encap:Ethernet  HWaddr 58:C2:32:FF:62:02
>>           inet addr:172.33.1.46  Bcast:172.33.1.255  Mask:255.255.255.0
>>           inet6 addr: fe80::58c2:3200:2ff:6202/64 Scope:Link
>>           UP BROADCAST RUNNING  MTU:1500  Metric:1
>>           RX packets:10028 errors:0 dropped:48 overruns:0 frame:0
>>           TX packets:1003 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:1372180 (1.3 MiB)  TX bytes:144817 (141.4 KiB)
>>
>> ##################### After test ######################
>> eth1      Link encap:Ethernet  HWaddr 58:C2:32:FF:62:02
>>           inet addr:172.33.1.46  Bcast:172.33.1.255  Mask:255.255.255.0
>>           inet6 addr: fe80::58c2:3200:2ff:6202/64 Scope:Link
>>           UP BROADCAST RUNNING  MTU:1500  Metric:1
>>           RX packets:18481 errors:0 dropped:57 overruns:0 frame:0
>>           TX packets:1725 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:2534149 (2.4 MiB)  TX bytes:228283 (222.9 KiB
>>
>>
>> Regards,
>>
>> Ravi
>>
>>
>> -----Original Message-----
>> From: Ravi Puttachannaiah
>> Sent: Wednesday, January 13, 2016 5:24 PM
>> To: 'Vlad Yasevich' <vyasevich@gmail.com>; malc <mlashley@gmail.com>;
>> linux-sctp@vger.kernel.org
>> Subject: RE: X2AP:handoverPreparationFailure message is not received
>> at source node
>>
>> Hi Vlad,
>>
>> Thanks for looking into the logs and sharing the analysis.
>>
>> We will capture the pcap on .1.46 and share the pcap files and also check for any dropped or error frames.
>>
>> Regards,
>>
>> Ravi
>>
>>
>> -----Original Message-----
>> From: Vlad Yasevich [mailto:vyasevich@gmail.com]
>> Sent: Tuesday, January 12, 2016 9:12 PM
>> To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>; malc
>> <mlashley@gmail.com>; linux-sctp@vger.kernel.org
>> Subject: Re: X2AP:handoverPreparationFailure message is not received
>> at source node
>>
>> On 01/12/2016 07:11 AM, Ravi Puttachannaiah wrote:
>>> Thanks Vlad..
>>>
>>> Please check and let me know if any more logs and details are required.
>>>
>>> Thanks for your support.
>>
>> Well, I looked at the traces and it doesn't show the packet even made it to destination host .1.47.  Up until that point everything appears to be working properly, there are no drops anywhere.
>>
>> I would recommend that you try capturing traffic on .1.46 during the troubling condition to make sure that the packet is actually sent on the wire.
>>
>> Also, check the nic stats to see if there are any dropped or error frames.
>> If there is switch between the systems, try to see if may be it is dropping packets.
>>
>> At this point, there isn't a whole lot we can do as it appears that the handoverPreparation:Unsuccessful message from .1.46 isn't making it to .1.47.
>> You need to try to find out where it is going?
>>
>> -vlad
>>
>>>
>>>
>>> Regards,
>>>
>>> Ravi
>>>
>>> -----Original Message-----
>>> From: Vlad Yasevich [mailto:vyasevich@gmail.com]
>>> Sent: Tuesday, January 12, 2016 5:38 PM
>>> To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>; malc
>>> <mlashley@gmail.com>; linux-sctp@vger.kernel.org
>>> Subject: Re: X2AP:handoverPreparationFailure message is not received
>>> at source node
>>>
>>> On 01/12/2016 06:29 AM, Ravi Puttachannaiah wrote:
>>>> Hi Vlad, Malc,
>>>>
>>>> I have uploaded the logs in the dropbox. Please use the below URL to access the logs.
>>>>
>>>> https://www.dropbox.com/sh/utmo1jbw7l6itmx/AABSCk04YNxu3XTnq_Bk8l2Ea?
>>>> d
>>>> l=0
>>>
>>> I'll take a look.
>>>>
>>>> Following is the details from the logs.
>>>>
>>>> working_sctp_s1ap_x2ap_logs.pcapng -In-case of an working logs you can observe that:
>>>>
>>>> 1. In packet no-471, the IP 172.33.1.47 is sending the
>>>> X2AP:handoverPreperation message to 172.33.1.46 2. In packet no-475,
>>>> the IP 172.33.1.46 is sending the X2AP:handoverPreperationFailure
>>>> 172.33.1.47
>>>>
>>>> non-working_sctp_s1ap_x2ap_logs.pcappng- In-case of an non-working
>>>> logs you can observe that
>>>>
>>>> 1. In packet no-162, the IP 172.33.1.47 is sending the
>>>> X2AP:handoverPreperation message to 172.33.1.46 2. But in this case we are not seeing the X2AP:handoverPreperationFailure sent by 172.33.1.46. In the application logs we could see that application is writing to the socket successfully (there are no errors).
>>>>
>>>> As indicated previously the issue is not seen "When there is no re-try attempt on-going(between source node to peer-1) then there is no issue observed and we can see that X2AP:handoverPreparationFailure is successfully received at source node."
>>>>
>>>> Response to Malc query.
>>>>
>>>> 1. Is peer-node-2 putting the packet on the wire?
>>>> RAVIP>> Yes.. From the application logs we can confirm that peer-node-2 is writing the message to the socket.
>>>
>>> Just because the packet was written to the socket doesn't mean it's on the wire.  It may still by buffered if there hasn't been an ack.  I haven't checked yet, but I hope the logs above contain traces from peer-node-2, so we can see the message.
>>>
>>>>
>>>> 2. When you say 'not getting received at source node' - Do you mean at the ethernet layer, the application layer, or ?
>>>> RAVIP>> We are not seeing message both at application level and also at wireshark. I suspect the message could be getting dropped at LKSCTP level.
>>>
>>> No, if you are not seeing it in wireshark, then sctp doesn't see the packet either.
>>> The packet capture happens before any protocol have an ability to drop anything.  Even some errors handled by the nic can be observed with wireshark.
>>>
>>> -vlad
>>>
>>>>
>>>> Regards,
>>>>
>>>> Ravi
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: Vlad Yasevich [mailto:vyasevich@gmail.com]
>>>> Sent: Monday, January 11, 2016 10:51 PM
>>>> To: Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com>; malc
>>>> <mlashley@gmail.com>; linux-sctp@vger.kernel.org
>>>> Subject: Re: X2AP:handoverPreparationFailure message is not received
>>>> at source node
>>>>
>>>> On 01/11/2016 10:27 AM, Ravi Puttachannaiah wrote:
>>>>> Hi Malc,
>>>>>
>>>>> We have collected both working and non-working logs. Could you please let us know where can we share the attachment (since you said the list drop the attachment). How other members share the attachments?
>>>>>
>>>>> Regards,
>>>>
>>>> Providing a pointer to tcpdump logs is the best way.
>>>>
>>>> -vlad
>>>>
>>>>>
>>>>> Ravi
>>>>>
>>>>>
>>>>> -----Original Message-----
>>>>> From: linux-sctp-owner@vger.kernel.org
>>>>> [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of malc
>>>>> Sent: Thursday, January 07, 2016 8:44 PM
>>>>> To: linux-sctp@vger.kernel.org
>>>>> Subject: Re: X2AP:handoverPreparationFailure message is not
>>>>> received at source node
>>>>>
>>>>> Ravi,
>>>>>
>>>>> I think in order for anyone to help, you're going to need to provide a packet capture from 'source node' and 'peer-node-2', showing the working case, and the failing case, both from INIT onwards. (since the list drops attachments, you will need to post that somewhere we can access it.
>>>>>
>>>>> 1. Is peer-node-2 putting the packet on the wire?
>>>>> 2. When you say 'not getting received at source node' - Do you mean at the ethernet layer, the application layer, or ?
>>>>>
>>>>> Cheers,
>>>>> malc.
>>>>>
>>>>> On Thu, Jan 7, 2016 at 8:55 AM, Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com> wrote:
>>>>>> Could somebody please respond and help.
>>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Ravi Puttachannaiah
>>>>>> Sent: Tuesday, January 05, 2016 2:35 PM
>>>>>> To: 'linux-sctp@vger.kernel.org' <linux-sctp@vger.kernel.org>
>>>>>> Subject: X2AP:handoverPreparationFailure message is not received
>>>>>> at source node
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>>                 We are using X2AP protocol over the LKSCTP (ver 1.0.16) and we are seeing the following issue.
>>>>>>
>>>>>> Scenario:
>>>>>>
>>>>>>                 1.            We have source node connected to the two peer nodes peer-1 and peer-2.
>>>>>>                 2.            Source node does not have a SCTP connectivity with peer-1 because the peer-1 was not reachable. In this case source node will re-try every 4-seconds to establish a SCTP connection by creating a new SCTP association and sending a SCTP:INIT. If there is no response for SCTP:INIT (once all the SCTP:INIT retries are exhausted) then source node will close the socket or sctp association and retry again after 4-seconds.
>>>>>>
>>>>>>
>>>>>> Problem:
>>>>>>
>>>>>>                 1.            It is observed that when the retry attempt is going on for peer-1 the X2AP message sent from peer-2 node to source node is not getting received at source node. The source node is sending X2AP:handoverPreparation to peer-2 node and this is successfully received at peer-2. But when peer-2 sends X2AP:handoverPreparationFailure to source node this message is not received at  source node.
>>>>>>
>>>>>>                 2.            When there is no re-try attempt on-going(between source node to peer-1) then there is no issue observed and we can see that X2AP:handoverPreparationFailure is successfully received at source node.
>>>>>>
>>>>>>                 Could you please help us to resolve this SCTP issue. Please let me know what logs are required to check this issue.
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>> Ravi
>>>>>>
>>>>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
>>>>>> in the body of a message to majordomo@vger.kernel.org More
>>>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
>>>>> in the body of a message to majordomo@vger.kernel.org More
>>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>>>> N     r  y   b X  ǧv ^ )޺{.n +    {   i {ay ʇڙ ,j   f   h   z  w
>>>>    j:+v   w j m         zZ+     ݢj"  !tml>>>>>
>>>>
>>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>>>
>>>
>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>>
>>
>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>
> 
> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
> 

