From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 15 May 2008 12:38:35 +0000
Subject: Re: retrans path update problem
Message-Id: <482C2ECB.80607@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482AA73D.5000507@cn.fujitsu.com>
In-Reply-To: <482AA73D.5000507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Gui Jianfeng wrote:
> Vlad Yasevich wrote:
>> Gui Jianfeng wrote:
>>> hello everybody,
>>> When updating retrans path(asoc->peer.retran_path), should we update
>>> the retran path to another transport even if only the original retrans
>>> path is active?
>>> In the other words, i think, retrans path should always be changed if
>>> there are more than one transport in an association.
>>>
>>> Am i right?
>> And we do that with sctp_assoc_update_retran_path().  If we
>> don't find another active transport, we'll still try set the
>> retran_path to the next transport in the list.
>>
>> Are you asking if we should only use ACTIVE transports?
> 
> Vlad,  
>   I'd like to know, if the current asoc->peer.retran_path is the only active
>   transport in the transport list, whether we should change asoc->peer.retran_path 
>   to another inactive one. The sctp_assoc_update_retran_path() won't change to a 
>   inactive transport(next one) in this scenario now, is that ok?

I see now.  The appears to be a bug in sctp_assoc_update_retran_path().  Even
though it attempts to change to a non-active one based on this comment,

      /* We have exhausted the list, but didn't find any
       * other active transports.  If so, use the next
       * transport.
       */

it never does, since it finds the active retran_path and just uses that again.

Feel free to fix.

-vlad
