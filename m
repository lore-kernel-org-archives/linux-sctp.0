From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 26 May 2010 20:31:41 +0000
Subject: Re: Source IP not corresponding to interface
Message-Id: <4BFD852D.3030509@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BFBFB26.6050209@kth.se>
In-Reply-To: <4BFBFB26.6050209@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Georgios Cheimonidis wrote:
> Hi Vlad!
> 
> I will do some more tests with various rto.initial values and let you know.
> About what you said regarding the transmission of a user HEARTBEAT at the
> server: do I get a notification when the address is added to the
> association? Because, from what I remember with some tests that I did with
> 2.6.31 kernel, this notification (SCTP_ADDR_ADDED) as well as
> SCTP_ADDR_REMOVED and SCTP_ADDR_MADE_PRIM were not received by my
> application (probably because they were not implemented yet). 
> 

Hmm.. You are right.  That's a bummer.

I guess we have more work to do... ;)

-vlad

> Best regards,
> George 
> 
> -----Original Message-----
> From: Vlad Yasevich [mailto:vladislav.yasevich@hp.com] 
> Sent: Wednesday, May 26, 2010 5:50 PM
> To: Georgios Cheimonidis
> Cc: linux-sctp@vger.kernel.org
> Subject: Re: Source IP not corresponding to interface
> 
> 
> 
> Georgios Cheimonidis wrote:
>> Hi!
>>
>> I repeated the test once again. The scenario for the attached log is the
>> following.
>> Client starts with 2 IPv4 addresses on the association (X: wlan and Y:
>> 3G). Server has only one address Z. I repeatedly do the following on the
>> client side:
>> - Remove address X and set Y as peer's (server's) primary (whenever
>> address X becomes unavailable).
>> - Add address X and set X as peer's primary (whenever address X becomes
>> available).
>> The above is repeated 12 times (12 removals and 12 additions of wlan's
>> IP address).
>> A measurable delay (about 1 second) occured during the #4, #6, #7, #9,
>> #10 and #12 addition of address Y. In the remaining cases the delay was
>> negligible. This delay was measured on the server side by examining the
>> capture from wireshark. On all occasions, it was the time between the
>> ASCONF_ACK sent from the server and the first packet sent from the
>> client (SACK most of the times) to the server from the wlan's IP address.
>> I have disabled debugging messages in my application.
> 
> Hi George
> 
> Looking at the look (iteration #4), I see lots of traffic at 16:13:16.
> Looks like the client gets the ASCONF_ACK for the ADD_IP parameter, and
> re-looks up the route to the server.  The route is now
> rt_dst:213.ZZZ.ZZZ.ZZZ,
> rt_src:192.XXX.XXX.XXX.
> 
> It sends the ASCONF for SET_PRIMARY and then doesn't get anything back from
> the server until 16:13:17 which is DATA.  Now, the kernel timesamps don't
> include milliseconds so it's not really possible to tell how much time has
> passed.   So at 16:13:17, there is DATA flow from the server and it triggers
> a
> SACK.  Looks like there is also a HEARTBEAT.
> 
> So it could be that the delay is the HEARTBEAT delay.  Try playing with
> rto.initial value, or even try forcing a user Heartbeat, when you see a
> new path come up on the server.
> 
> -vlad
> 
>> Best regards,
>> George
>>
>> On 05/26/2010 03:57 PM, Vlad Yasevich wrote:
>>>
>>> Georgios Cheimonidis wrote:
>>>> Hi Vlad!
>>>>
>>>> I have applied the patch and repeated the same test. The results are
>>>> good. I don't see any packets with wrong source IP in the wlan interface
>>>> any more. Most of the times the switchover from 3G to wlan (when wlan's
>>>> IP is made available and added to the association) is quite fast.
>>>> Sometimes, I observe a small delay between the ASCONF_ACK received from
>>>> the server (corresponding to the ASCONF for adding the wlan's IP
>>>> address) and the first packet (SACK or ASCONF for setting peer's
>>>> primary) transmitted from the wlan interface. The maximum value of this
>>>> delay is about 1 second. During this small delay, no packets are
>>>> transmitted from wlan or 3G interface.
>>> Interesting...  Can you send a log when this occurs?
>>>
>>> Also,  does this 1 second delay occur if you disable debug output?  I now
>>> sometimes the output itself can cause delays.
>>>
>>> -vlad
>>>
>>>> Best regards,
>>>> George
>>>>
>>>> On 05/25/2010 09:12 PM, Vlad Yasevich wrote:
>>>>> Hi George
>>>>>
>>>>> Georgios Cheimonidis wrote:
>>>>>> Hi Vlad!
>>>>>>
>>>>>> Thanks for the quick reply!
>>>>>> - The default route is recreated with a different metric but always
>>>>>> smaller than the metric corresponding to the default route of the 3G
>>>>>> interface.
>>>>>> - The IP addresses were all IPv4, but I used AF_INET6 sockets,
>>>>>> since in
>>>>>> some other tests I add and remove IPv6 addresses as well. I don't know
>>>>>> if this matters.
>>>>>> - I am also attaching the kernel log from the client host. Address
>>>>>> X of
>>>>>> the previous description is 192.XXX.XXX.XXX (client's wlan), Y is
>>>>>> 95.YYY.YYY.YYY (client's 3G) and Z is 213.ZZZ.ZZZ.ZZZ (server's single
>>>>>> IP address). I will also try to examine it and check the
>>>>>> sctp_v4_get_dst() calls.
>>>>>>
>>>>>> Nice to hear about the v6 patch! I will also do some testing and
>>>>>> let you
>>>>>> know about the results. Have you already published it in the mailing
>>>>>> list?
>>>>>>
>>>>> Ok, so here is a simple patch to try along with the explanation.
>>>>>
>>>>> When you add a address we send an ASCONF, but the new address is not
>>>>> usable
>>>>> for anything other then Heartbeats util ASCONF_ACK is received.
>>>>>
>>>>> Also, the addition of a new default route causes something to timeout
>>>>> or change
>>>>> such that the transport looses a route.  When we look up the new
>>>>> route, we get
>>>>> an updated route with the lower metric; however, we can't use the
>>>>> source
>>>>> provided by that route because we have not received the ASCONF_ACK yet.
>>>>> So, we try to do a lookup with the source addresses provided.  We
>>>>> still can only
>>>>> use 1 of the addresses (the 3G one).  The routing table still appears
>>>>> to return
>>>>> us the route with a lower metric.  I can reproduce this with a simple
>>>>> 'ip route get' command.  Try it on your system:
>>>>>
>>>>>      ip route get<dest>   from<second source>
>>>>>
>>>>> You will see a route that will have the source set to 'second source',
>>>>> but using
>>>>> the interface that the preferred source is configured on (since that
>>>>> one has a
>>>>> lower metric).
>>>>>
>>>>> Thus we end up using the wrong interface, with the 'correct' source
>>>>> address.
>>>>>
>>>>> I don't think there is anything we can do about this before
>>>>> ASCONF_ACK is
>>>>> received.  However, when we receive the ASCONF_ACK, we can trigger a
>>>>> route
>>>>> lookup and source address selection again.
>>>>>
>>>>> I've attached the patch.  So, looks like you will still see this
>>>>> strange
>>>>> condition for a short duration, but once ASCONF_ACK is received it
>>>>> should clear up.
>>>>>
>>>>> Let me know how if this works.  I'll look back in history to see why
>>>>> the code is
>>>>> the way it is.
>>>>>
>>>>> -vlad
>>>>>
>>>>>> Best regards
>>>>>> George
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 05/25/2010 07:11 PM, Vlad Yasevich wrote:
>>>>>>> Georgios Cheimonidis wrote:
>>>>>>>
>>>>>>>> Hi!
>>>>>>>>
>>>>>>>> I have observed a problem while doing some tests with dynamic
>>>>>>>> address
>>>>>>>> reconfiguration. Let me first describe my setup and application.
>>>>>>>>
>>>>>>>> Setup: I have two hosts, one that acts as a client and another that
>>>>>>>> acts
>>>>>>>> as a server. The client has two IPv4 addresses (one on wlan, let's
>>>>>>>> call
>>>>>>>> it X, and another on a 3G p-to-p connection, let's call it Y).
>>>>>>>> There are
>>>>>>>> two default routes on the client, and the wlan default has a smaller
>>>>>>>> metric than the 3G default. The server is single homed. All
>>>>>>>> addresses
>>>>>>>> belong to different subnets.
>>>>>>>> Both hosts are running the net-next kernel, downloaded from David
>>>>>>>> Miller's net-next source tree on 12-May-2010). I have also
>>>>>>>> applied two
>>>>>>>> extra patches found in: (a)
>>>>>>>> http://www.spinics.net/lists/linux-sctp/msg00881.html and
>>>>>>>> (b)http://www.spinics.net/lists/linux-sctp/msg00882.html. I have
>>>>>>>> also
>>>>>>>> enabled SCTP debugging messages.
>>>>>>>>
>>>>>>>>
>>>>>>> Hi George
>>>>>>>
>>>>>>> Thanks for this report.  I am setting up a reproduction environment
>>>>>>> now.
>>>>>>> Will let you know what I find.
>>>>>>>
>>>>>>> It sounds like the routing might get kind-of funky after you add the
>>>>>>> address back.  Does the default route get recreated with the right
>>>>>>> metric?
>>>>>>>
>>>>>>> Kernel logs are always nice to have.  You can even look through them
>>>>>>> and try finding references to sctp_v4_get_dst() call to see what
>>>>>>> it shows you.  Thats where routing and source address selection
>>>>>>> is done.
>>>>>>>
>>>>>>> I am also assuming that this is all v4, right?  I've got v6 patch
>>>>>>> ready finally.  Passed all the tests I could throw at it.
>>>>>>>
>>>>>>> -vlad
>>>>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
> 
