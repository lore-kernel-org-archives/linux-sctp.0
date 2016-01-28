From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Thu, 28 Jan 2016 23:36:05 +0000
Subject: Re: [RFC PATCH net-next 0/3] sctp: add GSO support
Message-Id: <7DA10E71-2CE2-41E6-B53B-4C4D5BF341DA@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1453913331.git.marcelo.leitner@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1CCCEDE4@AcuExch.aculab.com> <9D5B8E18-A20A-4E27-8EB8-EE8856DFB184@lurchi.franken.de> <20160128210326.GD6602@mrl.redhat.com>
In-Reply-To: <20160128210326.GD6602@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, "brouer@redhat.com" <brouer@redhat.com>, "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>, "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>, "borkmann@iogearbox.net" <borkmann@iogearbox.net>, "marek@cloudflare.com" <marek@cloudflare.com>, "hannes@stressinduktion.org" <hannes@stressinduktion.org>, "fw@strlen.de" <fw@strlen.de>, "pabeni@redhat.com" <pabeni@redhat.com>, "john.r.fastabend@intel.com" <john.r.fastabend@intel.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>


> On 28 Jan 2016, at 22:03, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> 
> On Thu, Jan 28, 2016 at 06:54:06PM +0100, Michael Tuexen wrote:
>>> On 28 Jan 2016, at 14:51, David Laight <David.Laight@ACULAB.COM> wrote:
>>> 
>>> From: Marcelo Ricardo Leitner
>>>> Sent: 27 January 2016 17:07
>>>> This patchset is merely a RFC for the moment. There are some
>>>> controversial points that I'd like to discuss before actually proposing
>>>> the patches.
>>> 
>>> You also need to look at how a 'user' can actually get SCTP to
>>> merge data chunks in the first place.
>>> 
>>> With Nagle disabled (and it probably has to be since the data flow
>>> is unlikely to be 'command-response' or 'unidirectional bulk')
>>> it is currently almost impossible to get more than one chunk
>>> into an ethernet frame.
>>> 
>>> Support for MSG_MORE would help.
>> What about adding support for the explicit EOR mode as specified in
>> https://tools.ietf.org/html/rfc6458#section-8.1.26
> 
> Seizing the moment to clarify my understanding on that. :)
> Such multiple calls to send system calls will result in a single data
> chunk. Is that so? That's what I get from that text and also from this
No. It results in a single user message. This means you can send
a user message larger than the send buffer size. How the user message
is fragmented in DATA chunks is transparent to the upper layer.

Does this make things clearer?

Best regards
Michael
> snippet:
> "Sending a message using sendmsg() is atomic unless explicit end of
> record (EOR) marking is enabled on the socket specified by sd (see
> Section 8.1.26)."
> 
> Best regards,
> Marcelo
> 
>> Best regards
>> Michael
>>> 
>>> Given the current implementation you can get almost the required
>>> behaviour by turning nagle off and on repeatedly.
>>> 
>>> I did wonder whether the queued data could actually be picked up
>>> be a Heartbeat chunk that is probing a different remote address
>>> (which would be bad news).
>>> 
>>> 	David
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
> 

