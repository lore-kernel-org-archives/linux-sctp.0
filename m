From: Luci Stanescu <luci@cnix.ro>
Date: Thu, 25 Jul 2019 09:53:28 +0000
Subject: Re: SCTP recvmsg MSG_TRUNC or something similar
Message-Id: <832157EB-93B2-4B69-AADF-44C251D41A4D@cnix.ro>
List-Id: <linux-sctp.vger.kernel.org>
References: <D588EC18-6A7B-4D2B-AB0A-2961A247DC3B@cnix.ro>
In-Reply-To: <D588EC18-6A7B-4D2B-AB0A-2961A247DC3B@cnix.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi Marcelo,

Many thanks for getting back to me!

> On 25 Jul 2019, at 02:21, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
>> 
>> From what I can tell, MSG_TRUNC, which would’ve solved my issue,
>> isn’t implemented for SCTP. Regarding this topic, I’ve only found
> 
> Agreed, but MSG_TRUNC would cause information loss.

In my particular context, of using SCTP as a transport for an internal, “proprietary” protocol, I know how large messages can be and my only intention is to efficiently discard messages which are deemed too large (why these messages would exist within a controlled environment in the first place is beyond the scope of this discussion).

Which means that, given a sufficient buffer, and, for the time being, ignoring partial deliveries, I’m comfortable discarding recvmsg() returns which don’t have MSG_EOR set; but I am still stuck with the trailing data and I would need to determine based on previous reads that this is not a complete message – a flag that signifies “start-of-record” would have been brilliant. Or I can simply process them as if they were a complete message and hope they’re not validly formed.

> What about using a larger buf?

But, how large? :-)

Cheers,
Luci
