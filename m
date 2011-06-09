From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 09 Jun 2011 07:31:18 +0000
Subject: Re: Problem code multi-streaming
Message-Id: <4DF076C6.408@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DF0396D.50401@gmail.com>
In-Reply-To: <4DF0396D.50401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I have some code demo using multi-streaming, but it is not run right.I attach my code send file in this mail. I using this code from sctp_test, but i don't know why it error.
> I use sinfo->sinfo_stream = 1; and when send one chunk I change stream :
>

>  if(stream=1) stream=2;
>  if(stream=2)  stream=1;

The above code let stream always equal to 1.


if(stream=1)
   stream=2;
else if(stream=2)
   stream=1;

>
> But capture packet with Wireshark I see SID is always 1, I send packet is order, using multi-homing.
> All different functions run ok.I don't know why SID don't change.I read this darft of socket API SCTP in folder doc of LKSCTP, but I don't understand why I write code like sctp_test but sctp_test run ok.
