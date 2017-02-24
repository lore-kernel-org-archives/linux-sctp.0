From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 24 Feb 2017 05:33:01 +0000
Subject: Re: netinet/sctp.h or linux/sctp.h?
Message-Id: <CADvbK_dUHM7Bm3K8xjJzusP3+iA9b0Ks+aop9WJK=6C=p_=Gag@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <333c3b86-5715-b8e7-5b7d-36051456ffdd@udel.edu>
In-Reply-To: <333c3b86-5715-b8e7-5b7d-36051456ffdd@udel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Feb 24, 2017 at 10:52 AM, Jonathan T. Leighton
<jtleight@udel.edu> wrote:
> On 2/23/17 5:42 PM, Jonathan T. Leighton wrote:
>>
>> I typically include netinet/sctp.h, but I've noticed that linux/sctp.h
>> contains some definitions that are not in netinet/sctp.h and which give
>> me access to a few additional socket options, such as SCTP_RECVRCVMSG.
>> Why does netinet/sctp.h not contain definitions for a few of the options
>> that the kernel supports?
>>
>> - Jon
>
>
> Ah - I think it's because I'm running a pre-release kernel. Is there a way
> to get a corresponding pre-release for libsctp-dev (currently at
> 1.0.16+dfsg-3)? My linux kernel is 4.10.0-rc6+.
Yep, netinet/sctp.h is more common use, it includes some standard apis,
which not only exist in linux. But for linux/sctp.h, other than common apis,
it also includes linux specific function.

In you case , you can install the kernel-headers and include "linux/sctp.h",
OR copy the function from the new  linux/sctp.h into netinet/sctp.h and
then include "netinet/sctp.h", since SCTP_RECVRCVINFO is a option
RFC demands. By now your system just does not yet introduce it.

>
>
> - Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
