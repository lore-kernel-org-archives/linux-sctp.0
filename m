From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 06 Jul 2014 20:19:22 +0000
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <64889096-D302-4044-9569-C12CA9B0B6CB@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


On 04 Jul 2014, at 12:33, Winston V. Tizon <wtizon@tspi.com.ph> wrote:

> On Tue, 1 Jul 2014 07:20:01 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
>> Actually, its quite the opposite, this confirms that the sctp protocol is
>> functioning normally.  RFC 4960 says this about HB_ACK's:
>> 
>> 3.3.6.  Heartbeat Acknowledgement (HEARTBEAT ACK) (5)
>> 
>>   An endpoint should send this chunk to its peer endpoint as a response
>>   to a HEARTBEAT chunk (see Section 8.3).  A HEARTBEAT ACK is always
>>   sent to the source IP address of the IP datagram containing the
>>   HEARTBEAT chunk to which this ack is responding.
>> 
>> The only thing that a peer has to do regarding a HB frame is sent an HB_ACK to
>> the source ip address of the corresponding HB frame (in this case172.168.39.4),
>> which we do my recording the inbound transport that the HB frame arrived on.
>> The source address selection is made during L3 packet routing, which, according
>> to sctp_transport_route is made by querying the route tables.
>> 
>> The only thing thats a bit odd is the fact your not taking what is likely the
>> selected source address from the default route.  That usually indicates that
>> you're using path mtu features, and you're routing based on a locally selected
>> source and destination address.
>> 
>> The point however is, that a transport is only defined by a destination address
>> within an association, not by a source and a destination, the source address
>> selection is made by the local peer, and should not be relevant to the peer
>> receiving the data.
>> 
>> Neil
>> 
> TO: Neil, Daniel, Michael
> 
> Thank you very much for your answers. I misunderstood the SCTP RFC statement 
> regarding reply Chunks in a multi-homed association. I thought reply 
> chunks should be sent always to the same path from where DATA or Control 
> chunks were received.
> 
> I'm sorry if I haven't explained yet the other details of our problem using 
> the following  "Environment Setup" below.
> 
>    CLIENT                        SERVER     
> 172.168.39.91                172.168.40.93  
> +-----------+    +------+    +-----------+  
> |       eth0|----|  L2  |----|eth0       |  
> |           |    +------+    |           |  
> |           |       |        |           |  
> |           |  +----------+  |           |  
> |           |  |    L3    |  |           |  
> |           |  +----------+  |           |  
> |           |       |        |           |  
> |           |    +------+    |           |  
> |       eth1|----|  L2  |----|eth1       |  
> +-----------+    +------+    +-----------+  
> 172.168.39.92                172.168.40.94  
> 
> Our problem goes like this. Normal sequence is shown in "[NORMAL]" sequence.
> While our problem started when we've performed "[ABNORMAL]"sequence below.
> 
> [NORMAL]
> 
>      SERVER           L2 and L3         CLIENT      
> Secondary Primary           |      Primary Secondary 
>    |        |              |          |       |     
>    |        |              |          |       |     
>    |        |INIT-INIT_ACK |          |       |     
>    |        |<-------------|--------->|       |     
>    |        |COOKIE_ECHO-COOKIE_ACK   |       |     
>    |        |              |          |       |     
>    |        |<-------------|--------->|       |     
>    |        |HB/HB_ACK     |          |       |     
>    |        |              |          |       |     
>    |<-------|--------------|----------|       |     
>    |        |              |       HB |       |     
>    |        |--------------|--------->|       |     
>    |        |HB_ACK        |          |       |     
>    |        |        :     |          |       |     
>    |        |        :     |          |       |     
> 
> [ABNORMAL]
> 
>      SERVER           L2 and L3         CLIENT
> Secondary Primary           |      Primary Secondary 
>    |        |              |          |       |     
>    |        |              |          |       |     
>    |        |INIT-INIT_ACK |          |       |     
>    |        |<-------------|--------->|       |     
>    |        |COOKIE_ECHO-COOKIE_ACK   |       |     
>    |        |              |          |       |     
>    |        |<-------------|--------->|       |     
>    |        |HB/HB_ACK     |          |       |     
>    |        |              |          |       |     
>    |<-------|--------------|----------|       |     
>    |        |              |       HB |       |     
>    |        |---->X        |          |       |     
>    |        |HB_ACK        |          |       |     
>    |        |        :     |          |       |     
>    |<-------|--------------|----------|       |     
>                  ABORT
> 
> X  -> LAN cable unplug, cannot send HB_ACK to Client
> 
> Based on what happened in our environment, the Client sent ABORT chunk to 
> Secondary IP address of Server causing this path to be closed. 
> 
> We don't want this to happen in our environment.
> 
> It would be of great help to us if you have any idea on how we could 
> solve question #3 below.
> 
> [Question]
> 3. Is there a solution to force Server to use its Secondary path in 
>   sending the HEARTBEAT_ACK chunk to Client's primary?   
It is always difficult to have multiple addresses in the same network
configured on a host. I guess you problems go away if you use

   CLIENT                        SERVER     
172.168.39.91                172.168.39.93  
+-----------+    +------+    +-----------+  
|       eth0|----|  L2  |----|eth0       |  
|           |    +------+    |           |  
|           |       |        |           |  
|           |  +----------+  |           |  
|           |  |    L3    |  |           |  
|           |  +----------+  |           |  
|           |       |        |           |  
|           |    +------+    |           |  
|       eth1|----|  L2  |----|eth1       |  
+-----------+    +------+    +-----------+  
172.168.40.92                172.168.40.94  

assuming all masks being 255.255.255.0

Best regards
Michael
> 
> Wins
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

