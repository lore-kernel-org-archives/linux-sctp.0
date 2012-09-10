From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 10 Sep 2012 14:38:02 +0000
Subject: Re: [PATCH net-next v2] Take care of xfrm policy when checking dst entries
Message-Id: <504DFB4A.8080708@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20120907.144828.97793990734588625.davem@davemloft.net> <1347283338-4249-1-git-send-email-nicolas.dichtel@6wind.com> <504DFA97.7070509@gmail.com>
In-Reply-To: <504DFA97.7070509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Le 10/09/2012 16:35, Vlad Yasevich a =E9crit :
> On 09/10/2012 09:22 AM, Nicolas Dichtel wrote:
>> The goal of these patches is to fix the following problem: a session is
>> established (TCP, SCTP) and after a new policy is inserted. The current
>> code does not recalculate the route, thus the traffic is not encrypted.
>>
>> The patch propose to check flow_cache_genid value when checking a dst
>> entry, which is incremented each time a policy is inserted or deleted.
>>
>> v2: use net->ipv4.rt_genid instead of flow_cache_genid (and thus save a =
test
>>      in fast path). Also move it to net->rt_genid, to be able to use it =
for IPv6
>>      too. Note that IPv6 will have one more test in fast path.
>>
>> Patches are tested with TCP and SCTP, IPv4 and IPv6.
>>
>> Comments are welcome.
>>
>> Regards,
>> Nicolas
>>
>
> I am not sure this is right...  This has a side-effect that when an
> rt_cache_flush() is called, it invalidates IPv6 routes a well....
>
> Its all fine and good do this when a new policy is added, but not when IP=
v4
> routing table changes.
I already ask for this side effect, Eric answers me:
http://marc.info/?l=3Dlinux-netdev&m=134728265000776&w=3D2
