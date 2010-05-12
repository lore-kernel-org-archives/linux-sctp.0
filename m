From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 12 May 2010 16:14:59 +0000
Subject: Re: Gap not retransmitted after switchover
Message-Id: <4BEAD403.60403@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BE95C1C.4050902@hp.com>
In-Reply-To: <4BE95C1C.4050902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Georgios Cheimonidis wrote:
> Hi Vlad!
> 
> I made quite a lot of tests today. Here are my results.
> 
> When I repeated my previous test (IPv4 addresses only) I did not
> experience any problems. So, it seems that the patch worked! The server,
> after receiving three consecutive SACKs with the reported gap (three
> miss indications), it retransmitted the missing TSNs and the data flow
> continued normally. I repeated it many times and the result was always
> the same.
> 
> However, I experienced the same problem (not always but some times) when
> I had the following setup.
> - Server having both IPv4 and IPv6 addresses on ethernet interface.
> - Client having IPv6 on ethernet (X) and IPv4 on wlan (Y).
> - Association established with all the above addresses belonging to the
> association. The client uses its IPv6 address to contact the IPv6
> address of the server (initially), so the initial handshake is done
> using the IPv6 addresses. The client sends an ASCONF just after
> association establishment to tell the server to set its primary to the X.
> - Whenever the ethernet cable is removed at the client, the client calls
> setsockopt(SET_PEER_PRIMARY_ADDR) to tell the server to set Y as its
> primary and then calles sctp_bindx() to remove X from the association.
> In this scenario, sometimes the server does not retransmit the gap
> (after changing primary from X to Y and deleting Y from association).
> 
> Another observation that I have made, is that sometimes, after the
> ethernet cable is removed and I call setsockopt(SET_PEER_PRIMARY_ADDR)
> on the client to set the peer's primary to Y, the actual transmission of
> the ASCONF chunk is observed after many seconds (sometimes I observed
> the transmission 30 seconds after the call to setsockopt). I don't know
> if this is normal. Even with IPv4 only test I observed a small delay
> between calling setsockopt() and observing the ASCONF chunk, but it was
> about 1-2 seconds. With the IPv4/IPv6 test, this delay varied more.
> 

Interesting.  Looks like what happens is that we continue to try and use
the current primary destination, which uses the interface that lost the link.
So, that most likely triggers retransmissions.  Depending on the rto.max,
you might see a delay...

The DEL_IP ends up being delayed untill the first one succeeds.

What happens if you reverse your two calls?  Call bindx() first to remove the
address, and then call SET_PEER_PRIMARY.  BTW, with only 2 paths, you don't
really need to change the primary since there will only be 1 path and it will
automatically become primary.

Additionally, IPv6 routing is not always correct right now.  Thus, you may
end up with IPv6 route even though it should not be used any more.  The switch
in the call order above might help with that.  I am working on fixing the v6
routing right now.

-vlad

> Looking forward to your comments! Let me know if you want me to test
> something more.
> 
> Best regards,
> George
> 
> 
> 
> On 05/11/2010 05:35 PM, Vlad Yasevich wrote:
>>
>>
>> Vlad Yasevich wrote:
>>>
>>> Georgios Cheimonidis wrote:
>>>> Hi Vlad!
>>>>
>>>> I have repeated the test with the net-next kernel tree. It seems that
>>>> the problem persists. Below, I summarize what I observed from the
>>>> capture at the server side (the client's capture agrees with these
>>>> observations). Although the timing differs somewhat from the previous
>>>> test, the basic observation is still the same. After the server
>>>> switches
>>>> primary address and removes the previous primary from the association,
>>>> some unacknowledged DATA packets that were transmitted to the previous
>>>> primary (after it became unreachable) are never retransmitted to the
>>>> new
>>>> one.
>>>>
>>>
>>> Thanks for testing.  I am looking to see what can be happening.
>>>
>>> -vlad
>>>
>>
>> Hi George.
>>
>> I figured out why there were no retransmits.  Because you changed primary
>> path, you kicked in the SFR-CACC algorithm, and our implementation didn't
>> deal properly with the fact that some chunks may have moved from the old
>> primary to the new one without going though a retransmit.
>>
>> There are really 2 ways to deal with this:
>>     1).  If we are deleting a transport that had outstanding data,
>>     automatically retransmit the data on the new transport.
>>
>>     or.
>>
>>     2) Under the same condition as above, move the data to the new
>> primary
>>     destination and let fast-recovery take care of the issue.
>>
>> Linux implemented (2) from above, and thus this bug surfaced.
>>
>> Try the attached patch, and let me know if it fixes it for you.
>>
>> -vlad
> 
