From: Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 02 Apr 2012 14:59:08 +0000
Subject: Re: question about net/sctp/socket.c
Message-Id: <alpine.DEB.2.02.1204021624140.1959@hadrien>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.DEB.2.02.1204021521460.1959@hadrien>
In-Reply-To: <alpine.DEB.2.02.1204021521460.1959@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


On Mon, 2 Apr 2012, Vladislav Yasevich wrote:

> On 04/02/2012 09:24 AM, Julia Lawall wrote:
>> In the file net/sctp/socket.c, the function sctp_getsockopt_peeloff ends with:
>>
>>        retval = sock_map_fd(newsock, 0);
>>         if (retval < 0) {
>>                 sock_release(newsock);
>>                 goto out;
>>         }
>>
>>         SCTP_DEBUG_PRINTK("%s: sk: %p newsk: %p sd: %d\n",
>>                           __func__, sk, newsock->sk, retval);
>>
>>         /* Return the fd mapped to the new socket.  */
>>         peeloff.sd = retval;
>>         if (put_user(len, optlen))
>>                 return -EFAULT;
>>         if (copy_to_user(optval, &peeloff, len))
>>                 retval = -EFAULT;
>>
>> Should there be a call to sock_release in the final two error cases as well?  I don't see anything that removes the need for it.  And is some cleanup of the effect of sock_map_fd needed as well?
>>
>> thanks,
>> julia
>>
>
> Hi Julia
>
> This is an interesting case.  The possible issue I see calling sock_release here as well as after sock_map_fd
> call is that if the peeloff call fails in these 3 instances, the association is terminated.  There is no
> graceful recovery at all.
>
> It may make sense to re-arrange the code so that failures here are recoverable. By that I mean, that if a
> call to peeloff() fails, the original socket and association lists aren't touched. That would allow
> a repeated call to peeloff to potentially succeed.

Thank you for the quick response.  I thought that sock_release could be 
used because it is used in sock_create on failure.  But I guess that the 
point is that the subsequent operations in sctp_do_peeloff increase the 
impact of sock_release, to affect the original socket as well?

I have the impression that this can be called from the user level, since 
there are two user level addresses as arguments.  If the provided optlen 
address is repeatedly invalid, could one eventually run out of sockets?

julia
