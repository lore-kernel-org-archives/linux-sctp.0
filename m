From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Apr 2012 18:19:52 +0000
Subject: Re: question about net/sctp/socket.c
Message-Id: <4F79EDC8.9050906@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.DEB.2.02.1204021521460.1959@hadrien>
In-Reply-To: <alpine.DEB.2.02.1204021521460.1959@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 04/02/2012 12:31 PM, Julia Lawall wrote:
> On Mon, 2 Apr 2012, Vladislav Yasevich wrote:
> 
>> On 04/02/2012 10:59 AM, Julia Lawall wrote:
>>>
>>> On Mon, 2 Apr 2012, Vladislav Yasevich wrote:
>>>
>>>> On 04/02/2012 09:24 AM, Julia Lawall wrote:
>>>>> In the file net/sctp/socket.c, the function sctp_getsockopt_peeloff ends with:
>>>>>
>>>>>        retval = sock_map_fd(newsock, 0);
>>>>>         if (retval < 0) {
>>>>>                 sock_release(newsock);
>>>>>                 goto out;
>>>>>         }
>>>>>
>>>>>         SCTP_DEBUG_PRINTK("%s: sk: %p newsk: %p sd: %d\n",
>>>>>                           __func__, sk, newsock->sk, retval);
>>>>>
>>>>>         /* Return the fd mapped to the new socket.  */
>>>>>         peeloff.sd = retval;
>>>>>         if (put_user(len, optlen))
>>>>>                 return -EFAULT;
>>>>>         if (copy_to_user(optval, &peeloff, len))
>>>>>                 retval = -EFAULT;
>>>>>
>>>>> Should there be a call to sock_release in the final two error cases as well?  I don't see anything that removes the need for it.  And is some cleanup of the effect of sock_map_fd needed as well?
>>>>>
>>>>> thanks,
>>>>> julia
>>>>>
>>>>
>>>> Hi Julia
>>>>
>>>> This is an interesting case.  The possible issue I see calling sock_release here as well as after sock_map_fd
>>>> call is that if the peeloff call fails in these 3 instances, the association is terminated.  There is no
>>>> graceful recovery at all.
>>>>
>>>> It may make sense to re-arrange the code so that failures here are recoverable. By that I mean, that if a
>>>> call to peeloff() fails, the original socket and association lists aren't touched. That would allow
>>>> a repeated call to peeloff to potentially succeed.
>>>
>>> Thank you for the quick response.  I thought that sock_release could be used because it is used in sock_create on failure.  But I guess that the point is that the subsequent operations in sctp_do_peeloff increase the impact of sock_release, to affect the original socket as well?
>>
>> Calling it after sock_create is fine since the association is still attached to the old socket,
>> so a failure doesn't result in termination of the association.  However, once we move the
>> association to the newly created socket, calling sock_release() on that socket terminates
>> the association.
>>
>> Our alternatives are:
>> 1) move the association back to the original in case of failure
>> 2) restructure the code so that all setup is done first, and the move happens last.
> 
> The problem in both cases seems to be that the information that is required is in the middle of sctp_do_peeloff, and thisa function is exported, so maybe it should not be changed?  If this is not a constraint, then perhaps the sock_map_fd could be moved to just after the sock_create. The put_user could be moved quite far up, because it only wrires a constant value.  But perhaps the copy_to_user is stuck where it is because it would not be good to tell the user level about the file descriptor is set up properly?

We could always write 0 to user in case of of error.

>  But could the original association returned by create_sock be invalid once the socket has been migrated?

I can't parse that one.  Sockets aren't migrated, but associations are.  Think of association as a child under the socket.
The peeoloff() calls moves this child from one socket to another. 

The issue is that sctp_do_peeloff() is called by kernel modules.  Almost tempting to make 2 version of the function, one
to be called by user space, and one by kernel.

-vlad

> 
> julia
> 
>>
>>>
>>> I have the impression that this can be called from the user level, since there are two user level addresses as arguments.  If the provided optlen address is repeatedly invalid, could one eventually run out of sockets?
>>>
>>
>> That's actually the main usage scenario.  So, yes one can run out of file descriptors.  Not sure if one can run out of sockets.
>>
>> -vlad
>>
>>> julia
>>>
>>
>>
> 

