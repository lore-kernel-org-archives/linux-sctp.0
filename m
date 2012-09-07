From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 12:07:05 +0000
Subject: Re: [PATCH] sctp: check dst validity after IPsec operations
Message-Id: <5049E369.9060901@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1346953229-3825-1-git-send-email-nicolas.dichtel@6wind.com> <5048C984.3030306@gmail.com>
In-Reply-To: <5048C984.3030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Le 06/09/2012 18:04, Vlad Yasevich a =E9crit :
> On 09/06/2012 01:40 PM, Nicolas Dichtel wrote:
>> dst stored in struct sctp_transport needs to be recalculated when ipsec =
policy
>> are updated. We use flow_cache_genid for that.
>>
>> For example, if a SCTP connection is established and then an IPsec polic=
y is
>> set, the old SCTP flow will not be updated and thus will not use the new
>> IPsec policy.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>
> why doesn't this need to be done for TCP?  What makes SCTP special in thi=
s case?
>
> ip_queue_xmit does an __sk_dst_check() which is essentially what
> sctp_transport_dst_check() does.  That should determine if the currently =
cached
> route is valid or not.
>
> Looks like sctp may need to change to using ip_route_output_ports() call
> as ip_route_output_key may not do all that is necessary
I try, but it doesn't solve the problem. In fact, it seems better to use=20
ip_route_output_ports(), would you like me to send a patch?


Regards,
Nicolas
