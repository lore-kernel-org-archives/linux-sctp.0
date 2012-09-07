From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 12:24:46 +0000
Subject: Re: [PATCH] sctp: check dst validity after IPsec operations
Message-Id: <5049E78E.6080908@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1346953229-3825-1-git-send-email-nicolas.dichtel@6wind.com> <5048C984.3030306@gmail.com> <5048D219.4020001@6wind.com> <5048D774.3020008@gmail.com>
In-Reply-To: <5048D774.3020008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Le 06/09/2012 19:03, Vlad Yasevich a =E9crit :
> On 09/06/2012 12:40 PM, Nicolas Dichtel wrote:
>> Le 06/09/2012 18:04, Vlad Yasevich a =E9crit :
>>> On 09/06/2012 01:40 PM, Nicolas Dichtel wrote:
>>>> dst stored in struct sctp_transport needs to be recalculated when
>>>> ipsec policy
>>>> are updated. We use flow_cache_genid for that.
>>>>
>>>> For example, if a SCTP connection is established and then an IPsec
>>>> policy is
>>>> set, the old SCTP flow will not be updated and thus will not use the n=
ew
>>>> IPsec policy.
>>>>
>>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>>
>>> why doesn't this need to be done for TCP?  What makes SCTP special in
>>> this case?
>> Tests prove that the pb does not exist with TCP. I made the patch some
>> times ago, I will look again deeply to find the difference.
>>
>
> TCP appears to cache the flowi and uses that to re-route the packet.
> However, re-route still seems predicated on dst_check()...
Yes ... but I don't find the difference. Re-route is not done immediately i=
n=20
TCP, it takes few seconds.

>
>>>
>>> ip_queue_xmit does an __sk_dst_check() which is essentially what
>>> sctp_transport_dst_check() does.  That should determine if the
>>> currently cached
>>> route is valid or not.
>> The problem is that route will not be invalidated, because dst->check()
>> has no xfrm path so xfrm_dst_check() will never be called.
>>
>
> Shouldn't the cache be invalidated in this case?  If the cache is invalid=
ated,
> that should cause a new lookup.  If the cache isn't invalidated, then any
> established connections that may now be impacted by the policy will not p=
ick it up.
Yes, you're right. If I flush the cache manually (with the sysctl), route a=
re=20
correctly updated.
I will send a new proposal.


Regards,
Nicolas
