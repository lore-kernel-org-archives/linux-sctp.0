From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 08 Jan 2009 16:56:28 +0000
Subject: Re: bad reference counting for module (was Re: BUG in sctp crashes
Message-Id: <4966303C.1070200@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090108145515.GF29698@dhcp35.suse.cz>
In-Reply-To: <20090108145515.GF29698@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michal Hocko wrote:
> Hi Vlad,
> 
> On Tue 06-01-09 08:50:15, Vlad Yasevich wrote:
>> Michal Hocko wrote:
>>> On Mon 05-01-09 18:05:21, Vlad Yasevich wrote:
>>>> Karsten, Michal
>>> Hi Vlad,
>>>
>>>> I think I found this cursed race.
>>>>
>>>> The problem is that nothing is guarding the asoc->base.sk reference.  This
>>>> reference changes during the accept()/peeloff() code paths and the only
>>>> guard around it is the socket lock.  But that lock is not taken when
>>>> the reference is used for reading as it is done in sctp_rcv().
>>>>
>>>> So, when we do sctp_bh_lock_sock(sk) in sctp_rcv(), we may be using
>>>> a stale cached copy of the sk which might have changed during sctp_accept().
>>>>
>>>> What this allows us to do is to have a user sending a packet on a socket
>>>> at the same time we may be processing and incoming packet on the same socket.
>>>> We just end up taking different locks which totally hoses us.
>>>>
>>>> -vlad
>>>>
>>>>
> [...]
>>> Can you reproduce with this patch? Unfortunately, I don't have any HW
>>> configuration available at the moment.
>> I've had the test run for a few hours without any issues.  Usually the
>> system crashes with the first 15 minutes.
>>
> [...]
>>> This test, however, has been removed by 61c9fed41638249f8b6ca5345064eb1beb50179f.
>>> AFAIU this patch deals with similar race in the receive path when socket
>>> is moved.
>> Yes.  The old code was insufficient, but this part should not have been removed.
>> The old code was still racy in other parts of the peel-off and resulted in
>> crashes you've seen.   However, this particular part or something along these
>> lines needs to be there.
>>
>> I really hate the this is done and currently looking at a way to protect this
>> pointer somehow, or rework it so it's not needed.  The problem is that we
>> perform other checks using the sk without locking it so there could be other
>> races as well that we just haven't seen because noone has an app yet that needs
>> the additional functionality.  So, even this patch I sent is not a complete
>> solution, but it is enough to fix the crash your customer is seeing.
>>
> [...]
> 
> You are right, we have backported 61c9fed41638249f8b6ca5345064eb1beb50179f 
> with the association change check along with the 
> cfdeef3282705a4b872d3559c4e7d2561251363c
> f26f7c480555812ca7c4037e0a50fa54afe2cb4a
> 
> and we are no longer able to reproduce skb overflow crash. 
> 
> Thanks for pointing this out! Really good hit!
> 
> However we are currently seeing another issue. It is not a crash (only
> process is killed with BUG message in the log - see attached) but it is
> the problem with module reference counting (
> BUG_ON(module_refcount(module)=0) in __module_get is called). 
> 
> I am not sure whether this is a real problem, because we were able to
> trigger this only on _one_ testing configuration while other one is OK.
> 
> I have checked all places where sctp decreases module reference count
> (sock_put) and it seems that all places are correctly balanced with
> sock_hold resp. __module_get:
> - sctp_association_init vs. sctp_association_destroy
> - sctp_association_migrate - put for old and hold for new
> - sctp_endpoint_int vs. sctp_endpoint_destroy
> - sctp_close - one artificial hold because of sk_common_release (which calls
>                put)
>              - one put balanced with sys_accept which calls __module_get
> 
> And all sock_put corresponds to the current upstream.
> 
> Do you have any idea or remember any problem in this area which could
> trigger this? 
> 
> It smells either as some misconfiguration of the testing system or
> another race condition or just I am overlooking something.
> 
> 

Try this commit: 027f6e1ad32de32f9fe1c61d0f744e329e8acfd9
SCTP: Fix a potential race between timers and receive path.

Also, what does lsmod tell you about the reference count on sctp module?

-vlad
