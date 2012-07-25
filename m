From: Xufeng Zhang <xufengzhang.main@gmail.com>
Date: Wed, 25 Jul 2012 02:28:19 +0000
Subject: Re: [PATCH] sctp: Make "Invalid Stream Identifier" ERROR follows SACK when bundling
Message-Id: <CA+=dFzg=Bpsv5bMzECoAXYVcbD95eYy6xDAzL6fwiHrunfq-tg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1342677450-21810-1-git-send-email-xufengzhang.main@gmail.com>
	<500CDE35.6000009@windriver.com>
	<42fcd21f-68bd-4dc7-8460-0cb968eb512e@email.android.com>
	<500E1057.3020509@windriver.com>
	<75bdd73e-1c47-4fd6-bc29-5b86ee6da69a@email.android.com>
In-Reply-To: <75bdd73e-1c47-4fd6-bc29-5b86ee6da69a@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: xufeng zhang <xufeng.zhang@windriver.com>, sri@us.ibm.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/24/12, Vlad Yasevich <vyasevich@gmail.com> wrote:
>>>> And I should clarify the above judgment code.
>>>> AFAIK, there should be two cases for the bundling when invalid
>>stream
>>>> identifier error happens:
>>>> 1). COOKIE_ACK ERROR SACK
>>>> 2). ERROR SACK
>>>> So I need to deal with the two cases differently.
>>>>
>>>>
>>> Sorry but I just don't buy that the above are the only 2 cases.  What
>>if there are addip chunks as well?  What if there are some other
>>extensions also.  This code has to be generic enough to handle any
>>condition.
>>>
>>Aha, you are right, this may happens.
>>So I think the general solution is to fix this problem in the enqueue
>>side.
>>What do you think? any better suggestion!
>>
>
> Don't have code in front of me but what if we carry the error condition to
> where we queue the Sack and add the error side effect then?
Yes, this is the most direct way to fix this problem.
But I don't think it's the best way since we will take care of a lot
of things and
it also involves in lots of changes to side effect processing.
I prefer to Neil Horman's way for the solution since only COOKIE_ACK chunk is
allowed to place ahead of SACK chunk when bundling into one packet.
What do you think?



Thanks,
Xufeng Zhang
>
> -vlad
