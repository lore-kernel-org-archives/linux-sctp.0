From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 26 Apr 2011 08:06:17 +0000
Subject: Re: [PATCH net-next-2.6 4/7] sctp: remove useless arguments from
Message-Id: <4DB67CF9.1050508@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DB63F85.2090609@cn.fujitsu.com>	<4DB6405B.2060200@cn.fujitsu.com>	<20110426.001227.112589346.davem@davemloft.net> <20110426.002020.48493363.davem@davemloft.net>
In-Reply-To: <20110426.002020.48493363.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org


> From: David Miller <davem@davemloft.net>
> Date: Tue, 26 Apr 2011 00:12:27 -0700 (PDT)
>
>> I really get grumpy when I have to fix up stuff like this:
>>
>> net/sctp/ipv6.c: In function =A1sctp_v6_get_saddr=A2:
>> net/sctp/ipv6.c:382: warning: unused variable =A1daddr=A2
> Now I'm even more grumpy, if I only apply the first 3 patches:
>
> net/sctp/ipv6.c: In function =A1sctp_v6_dst_lookup=A2:
> net/sctp/ipv6.c:259: warning: assignment makes integer from pointer witho=
ut a cast
>
> it goes away later but you're not testing the intermediate steps
> of your SCTP patch backports and as a result you are going to
> break bisecting.
>
> I'm reverting this patch series, fix this up and actually test
> the intermediate builds and functionality before resubmission.
Hi David

 Sorry for sending those garbage and wasted your time so much,
I will fix those up and do all of the test before resubmit
those patch to you.


