From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sat, 14 Dec 2013 17:06:18 +0000
Subject: Re: undetected closed apps
Message-Id: <BEBE71AD-0EB2-438A-B961-1BAF7ABE2D6B@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Dec 14, 2013, at 4:16 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> 
> I wasnt clear, sorry. Basically I kill the app after it sends
> a 100K or more messages (about 300 bytes each). The server
> is still thinking the client is connected. The client does
> a close/shutdown. I enabled SCTP heartbeats between the client
What does this mean? Do you call close() or shutdown()? Do you
kill the client?

Best regards
Michael
> and server and running tcpdump after killing the client
> shows heartbeats going on happily.
> 
> Sorry - I cant put out out the code, it is too big to cut
> down into something small enough to demonstrate.
> 
> cheers,
> jamal
> 
> 
> On 12/14/13 10:04, Jamal Hadi Salim wrote:
>> 
>> Folks,
>> 
>> I have a problem which manifests in kernels > 3.8. I am no sure how
>> best to debug it.
>> I have looked at strace and dont see anything different between when it
>> works (kernels <= 3.8) and when it doesnt (kernels > 3.8).
>> When i dump /proc/net/sctp/assocs I can see in the non-working case
>> the socket is still there - which means there is no way for the server
>> to be notified.
>> If kill the server, the socket disappears.
>> 
>> Is there something else that would help narrow this down?
>> 
>> cheers,
>> jamal
>> 
>> PS:
>> Essentially I have a client app that does some nasty stuff (on purpose
>> to test robustness). Client and server are connected locally within same
>> machine.
>> Client sends as fast as it can packets with partial reliability (timeout
>> of about 100ms). The only time client checks for any kernel obsoleted
>> msgs is when the send socket queue write will block.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

