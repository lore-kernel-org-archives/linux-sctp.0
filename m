From: Georgios Cheimonidis <gche@kth.se>
Date: Tue, 25 May 2010 19:53:14 +0000
Subject: Re: Source IP not corresponding to interface
Message-Id: <4BFC2AAA.3090303@kth.se>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BFBFB26.6050209@kth.se>
In-Reply-To: <4BFBFB26.6050209@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad!

Ok, it makes sense. I will test this patch tomorrow morning and let you 
know.

Best regards,
George


On 05/25/2010 09:12 PM, Vlad Yasevich wrote:
> Hi George
>
> Georgios Cheimonidis wrote:
>    
>> Hi Vlad!
>>
>> Thanks for the quick reply!
>> - The default route is recreated with a different metric but always
>> smaller than the metric corresponding to the default route of the 3G
>> interface.
>> - The IP addresses were all IPv4, but I used AF_INET6 sockets, since in
>> some other tests I add and remove IPv6 addresses as well. I don't know
>> if this matters.
>> - I am also attaching the kernel log from the client host. Address X of
>> the previous description is 192.XXX.XXX.XXX (client's wlan), Y is
>> 95.YYY.YYY.YYY (client's 3G) and Z is 213.ZZZ.ZZZ.ZZZ (server's single
>> IP address). I will also try to examine it and check the
>> sctp_v4_get_dst() calls.
>>
>> Nice to hear about the v6 patch! I will also do some testing and let you
>> know about the results. Have you already published it in the mailing list?
>>
>>      
> Ok, so here is a simple patch to try along with the explanation.
>
> When you add a address we send an ASCONF, but the new address is not usable
> for anything other then Heartbeats util ASCONF_ACK is received.
>
> Also, the addition of a new default route causes something to timeout or change
> such that the transport looses a route.  When we look up the new route, we get
> an updated route with the lower metric; however, we can't use the source
> provided by that route because we have not received the ASCONF_ACK yet.
> So, we try to do a lookup with the source addresses provided.  We still can only
> use 1 of the addresses (the 3G one).  The routing table still appears to return
> us the route with a lower metric.  I can reproduce this with a simple
> 'ip route get' command.  Try it on your system:
>
>     ip route get<dest>  from<second source>
>
> You will see a route that will have the source set to 'second source', but using
> the interface that the preferred source is configured on (since that one has a
> lower metric).
>
> Thus we end up using the wrong interface, with the 'correct' source address.
>
> I don't think there is anything we can do about this before ASCONF_ACK is
> received.  However, when we receive the ASCONF_ACK, we can trigger a route
> lookup and source address selection again.
>
> I've attached the patch.  So, looks like you will still see this strange
> condition for a short duration, but once ASCONF_ACK is received it should clear up.
>
> Let me know how if this works.  I'll look back in history to see why the code is
> the way it is.
>
> -vlad
>
>    
>> Best regards
>> George
>>
>>
>>
>> On 05/25/2010 07:11 PM, Vlad Yasevich wrote:
>>      
>>> Georgios Cheimonidis wrote:
>>>
>>>        
>>>> Hi!
>>>>
>>>> I have observed a problem while doing some tests with dynamic address
>>>> reconfiguration. Let me first describe my setup and application.
>>>>
>>>> Setup: I have two hosts, one that acts as a client and another that acts
>>>> as a server. The client has two IPv4 addresses (one on wlan, let's call
>>>> it X, and another on a 3G p-to-p connection, let's call it Y). There are
>>>> two default routes on the client, and the wlan default has a smaller
>>>> metric than the 3G default. The server is single homed. All addresses
>>>> belong to different subnets.
>>>> Both hosts are running the net-next kernel, downloaded from David
>>>> Miller's net-next source tree on 12-May-2010). I have also applied two
>>>> extra patches found in: (a)
>>>> http://www.spinics.net/lists/linux-sctp/msg00881.html and
>>>> (b)http://www.spinics.net/lists/linux-sctp/msg00882.html. I have also
>>>> enabled SCTP debugging messages.
>>>>
>>>>
>>>>          
>>> Hi George
>>>
>>> Thanks for this report.  I am setting up a reproduction environment now.
>>> Will let you know what I find.
>>>
>>> It sounds like the routing might get kind-of funky after you add the
>>> address back.  Does the default route get recreated with the right
>>> metric?
>>>
>>> Kernel logs are always nice to have.  You can even look through them
>>> and try finding references to sctp_v4_get_dst() call to see what
>>> it shows you.  Thats where routing and source address selection
>>> is done.
>>>
>>> I am also assuming that this is all v4, right?  I've got v6 patch
>>> ready finally.  Passed all the tests I could throw at it.
>>>
>>> -vlad
>>>
>>>        
>>      

