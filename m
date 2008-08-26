From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 26 Aug 2008 13:37:08 +0000
Subject: Re: [PATCH] sctp: add verification checks to SCTP_AUTH_KEY option
Message-Id: <48B40704.5040702@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080825164440.GA504@kernel.sg> <12196959323990-git-send-email-vladislav.yasevich@hp.com> <48B35561.2010001@redhat.com> <48B35B59.2020208@hp.com> <48B371F1.5080605@redhat.com>
In-Reply-To: <48B371F1.5080605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eugene Teo <eteo@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, security@kernel.org

Eugene Teo wrote:
> Vlad Yasevich wrote:
>> Eugene Teo wrote:
>>> Vlad Yasevich wrote:
> [...]
>>>> +	if (authkey->sca_keylength > optlen) {
>>>> +		ret = -EINVAL;
>>>> +		goto out;
>>> Is there a better upper bound check?
>> Hm...  optlen - sizeof(struct sctp_authkey)  is more accurate.
>>
>> There is really no other bound.
> 
> Linus suggested that it is better to declare an upper bound for key_len.
> I think it makes a lot of sense as a key shouldn't be as long as the
> boundary limit of its declared data type.
> 
>

I am starting to think that this might be completely unnecessary.

The sctp_auth_set_key() function is be called from two places:

  1) setsockopt() code path

  2) sctp_auth_asoc_set_secret() code path


In case (1), sca_keylength is never going to exceed 65536 since it's
bounded by a u16 from the user api.  As such, the malloc() will never
overflow.  This is the case we were really concerned about since the user
can supply bogus values.

In case (2), it is possible for the length to exceed 65536 since it's
trying to create a generated key and the algorithm takes raw pieces of the
SCTP handshake packets to do that.  However, there is no way that they can
exceed another 132K bytes because max IP datagram size is 65K and both ends
have to exchange security data.  Using IPv6 Jumbo extension I guess they can
go higher but we are probably going to fail memory allocations at that point.

That makes the theoretical maximum for the key to be 192K, but that discounts
the Jumbo usage.  So, I think using the current INT_MAX is sufficient to catch
possible overflows caused by case (2).   I think restricting the size further is
pointless and could end up being too restrictive.

-vlad

