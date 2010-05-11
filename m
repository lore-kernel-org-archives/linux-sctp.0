From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 11 May 2010 13:31:08 +0000
Subject: Re: Gap not retransmitted after switchover
Message-Id: <4BE95C1C.4050902@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org



Georgios Cheimonidis wrote:
> Hi Vlad!
> 
> I have repeated the test with the net-next kernel tree. It seems that
> the problem persists. Below, I summarize what I observed from the
> capture at the server side (the client's capture agrees with these
> observations). Although the timing differs somewhat from the previous
> test, the basic observation is still the same. After the server switches
> primary address and removes the previous primary from the association,
> some unacknowledged DATA packets that were transmitted to the previous
> primary (after it became unreachable) are never retransmitted to the new
> one.
> 

Thanks for testing.  I am looking to see what can be happening.

-vlad

> Observations from the capture at the server side:
> ------------------------------------------------------
> - Initially (before the client's ethernet cable is removed), the server
> sends (and receives acknowledgements for) the segments with TSNs up to #034.
> - Suddenly the address (X) that used to be the primary destination
> becomes unavailable – unreachable.
> - Server sends data segments with TSNs #035  to #039 to address X (which
> are never received by the client because this address is no longer
> usable – reachable).
> - Server retransmits data segments with TSNs #035, #036, #038 to address Y.
> - Server receives SACK from client (Cumulative: #036, Selective: -)
> - Server retransmits data segment #037
> - Server receives SACK from client (Cumulative: #036, Selective: From
> #38 to #38)
> - Server sends #040 to address X (which is never received by client
> because X is unreachable)
> - Server retransmits #039 to address Y
> - Server sends #041 to address X (which is never received by client...)
> - Server retransmits #039 to address Y
> - Server receives SACK from client (Cumulative: #039 Selective: -)
> ----------- at this point of time there is no gap, but #040 to #041 have
> not been acknowledged -----------
> - Server receives an ASCONF from the client to set its primary address to Y.
> - Server sends an ASCONF_ACK and bundles DATA #042 to address Y.
> - Server sends #043 to #047 to address Y.
> - Server receives an ASCONF from the client, that says to remove address
> X from the association.
> - Server sends an ASCONF_ACK.
> - Server receives SACKs from the client that acknowledge the received
> packets and also indicate that there is a gap (from #040 to #041). The
> server continues to send new packets but does not retransmit the gap.
> The exchange of DATA and SACKs between the server and the client
> continues until server sends #084 and client acknowledges it. The SACKs
> sent from the client always have a cumulative TSN of #039 and indicate
> that there is a gap (from #040 to #041). After that, the client and the
> server exchange only HEARTBEATs. No data transmission take place. The
> client application is blocked in recv() and the server application is
> blocked in send(). The last receive window reported by the client is
> 3136 bytes. The application messages are 4928 bytes.
> 
> I also attach the kernel log of the server host. The relation between
> the addresses mentioned above and the addresses shown in the kernel log is:
> X: 213.XXX.XXX.XXX   (client's eth)
> Y: 192.YYY.YYY.YYY    (client's wlan)
> Z: 213.ZZZ.ZZZ.ZZZ    (server's)
> 
> Hope this helps!
> /George
> 
> 
> On 05/10/2010 05:33 PM, Vlad Yasevich wrote:
>> Hi George
>>
>> Can you try this against net-next-2.6 tree.  There were a few patches
>> that went in recently that might fix what you are seeing.
>>
>> Also,  lksctp-developers list will drop attachments.  You are better of
>> using the linux-sctp@vger.kernel.org.
>>
>> -vlad
>>
>> Georgios Cheimonidis wrote:
>>   
>>> Hi!
>>>
>>> I have observed a problem while doing some tests with dynamic address
>>> reconfiguration. Let me first describe my setup and application.
>>>
>>> Setup: I have two hosts, one that acts as a client and another that acts
>>> as a server. The client has two IPv4 addresses (one on eth, let's call
>>> it X, and another on wlan, let's call it Y). The server is single homed.
>>> Both hosts are running 2.6.34-rc5 kernel, downloaded from David Miller's
>>> net-2.6 source tree on 05-May-2010). I have enabled SCTP debugging
>>> messages.
>>>
>>> Application: In my simple application, only the server transmits
>>> messages to the client, of 4928 bytes payload each (probably this
>>> doesn't matter). The server uses blocking send() and the client uses
>>> blocking recv(). My client application has a simple policy: When the
>>> ethernet cable is removed, a monitoring process reports this event to my
>>> application. This monitoring process at the same time removes the
>>> ethernet's IP address and relevant routes in the routing table. When my
>>> application receives this event notification, it takes two consecutive
>>> actions. First it calls setsockopt(SET_PEER_PRIMARY_ADDR) to change the
>>> peer's (server's) primary destination to address Y. Immediately after
>>> that, it calls sctp_bindx() to remove IP address X from the association.
>>> So, when I remove the ethernet cable from the client, the server should
>>> change its primary (destination) address to Y and then remove address X
>>> from its list of destination addresses.
>>>
>>> In the following experiment, I start the association with the client
>>> having both IP addresses (address X is used for the initial handshake)
>>> and after some seconds I remove the ethernet cable. In short, this is
>>> what happens (from the server's point of view according to the capture
>>> from wireshark; the capture on the client agrees with these observations):
>>>
>>> - Initially (before the client's ethernet cable is removed), the server
>>> sends (and receives acknowledgements) for the segments with TSNs up to
>>> #717.
>>> - Suddenly the client's address (X) that used to be the server's primary
>>> destination becomes unavailable
>>> - Server sends data segments with TSNs #718 to #722 to X (which are
>>> never received by the client because this address is no longer usable –
>>> reachable).
>>> - Server receives an ASCONF from the client and acknowledges it, to set
>>> its primary address to Y.
>>> - Server sends data segments with TSNs #723 to #727 to Y.
>>> - Server receives an ASCONF from the client and acknowledges it, to
>>> delete address X.
>>> - Server sends data segments with TSNs #728 to #762 to Y. The server
>>> receives SACKs from the client that indicate that there is a gap.
>>> Actually, the client always includes a cumulative acknowledgment TSN of
>>> #717 and also acknowledges all the TSNs after the gap. However, the
>>> server does NOT retransmit the gap (TSNs from #718 to #722).
>>> - After that, the server doesn't send any new TSNs (the server
>>> application blocks in send()), and the last reported receive window by
>>> the client is 7040 bytes. The server and client continue exchanging
>>> HEARTBEATs, but no data transfer takes place. The client also blocks in
>>> recv() because it cannot deliver the data to the upper layer due to the
>>> missing TSNs.
>>>
>>> I don't know why the server doesn't retransmit the gap even though the
>>> client reports it (in 40 consecutive SACKs). I am also attaching the
>>> kernel log of the server host. Any help is highly appreciated!
>>>
>>> Best regards,
>>> George
>>>
>>>
>>> ------------------------------------------------------------------------
>>>
>>> ------------------------------------------------------------------------------
>>>
>>>
>>>
>>> ------------------------------------------------------------------------
>>>
>>> _______________________________________________
>>> Lksctp-developers mailing list
>>> Lksctp-developers@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>     
> 
