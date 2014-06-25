From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 25 Jun 2014 10:28:28 +0000
Subject: Re: [PATCH net-next] sctp: Add partially support for MSG_MORE to SCTP.
Message-Id: <53AAA44C.5010206@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1725FB90@AcuExch.aculab.com> <53A4B165.6050504@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1726152D@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726152D@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Vlad Yasevich' <vyasevich@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

On 06/23/2014 04:27 PM, David Laight wrote:
> From: Vlad Yasevich
>> On 06/20/2014 12:24 PM, David Laight wrote:
>>> If MSG_MORE is set then buffer sends as if Nagle were enabled.
>>> The first data chunk is still sent on its own, but subsequent chunks
>>> will be bundled and full packets sent.
>>> Full MSG_MORE support would require a timeout (preferably configurable
>>> per-socket) to send the last chunk(s), instead of sending them
>>> when there is nothing outstanding.
>>
>> Instead of using 1 and 2, can you define them as flags please
>
> Will do....
>
> It is worth inverting nagle/nodelay bit; so that:
> 0 => SCTP_NODELAY
> 1 => Nagle (default)
> 2 => MSG_MORE
> 4 => reserved for corked
>
> That would require working out where the structure is initialised
> (in order to default to Nagle).

I think that should be fine, too.
