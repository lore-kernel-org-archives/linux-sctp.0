From: "Doug Graham" <dgraham@nortel.com>
Date: Fri, 31 Jul 2009 17:09:39 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet
Message-Id: <4A732553.30403@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>>
>> Why we need to send the SACK immediate? Just to make the one send one
>> recv mode happy?
>> In this case, it is better to disable the delay ack, is this correct?
>>     
>
> Consistent behavior.  A change in message size shouldn't cause a change in
> on the wire behavior.
>
> Either we always send a SACK if we have DATA to send, or we don't.  Having a
> weird "only if it fits" behavior will have unpredictable results.
>   
Exactly!

--Doug


