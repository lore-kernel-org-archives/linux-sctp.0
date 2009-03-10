From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 10 Mar 2009 01:33:09 +0000
Subject: Re: [net-next-2.6 PATCH 0/6] sctp: implement IETF SCTP Stream Reconfiguration
Message-Id: <49B5C355.8050200@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <49B48945.7060707@cn.fujitsu.com>
In-Reply-To: <49B48945.7060707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> Hi All
>>
>> The following series of 6 patches is the implementation of IETF STREAM-RESET
>> draft (http://tools.ietf.org/html/draft-stewart-tsvwg-sctpstrrst-01).
>>
>> With this series, we'll implement most of the draft's defines. We skip the
>> "deferred reset processing" on receiver side procedures for the Outgoing SSN
>> Reset Request Parameter. This may appear later as a patch.
>>
>> I'd really appreciate people take a look and review this patches.
>>
>>     
>
>   

Hi Vlad

Thank you for reply.

> Hi Wei
>
> This is an interesting draft, and it's good to have an prototype implementation,
> but I think there are some holes in the draft still.
>
> I think the biggest hole is the API.  Since it's not documented at all, I would
> be extremely hesitant of opening any of it.
>   

Yes, this is the biggest problem. Just like socket API, if it changed, we
will have much works to do.^_^

> I need to do a detailed review of this and I invite you to send any comments you
> have to Randy and the rest of the authors.
>   

I will do this.

> I think that by missing the deferred reset processing, we are open to some interesting
> problems.  The issue is that if the stream reset arrives prior to any pending TSNs, we
> need to enter this deferred processing state.  This could be very easy to hit and it needs
> to be done.  There are also some inconsistencies in the text for deferred processing.
>   

To do this, I need more document. I will send comments to the authors of
this draft.

> This is really an RFC series, since I think the spec needs a lot of work before I can
> take this for the main-line kernel.
>   

I will continue to develop this utils it become a RFC. And will do more test
using our test tool.




