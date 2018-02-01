From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 01 Feb 2018 18:02:07 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <CA+ydwtpiPeFuOB9PyCiOiKhzx69Ecu9mMt2ut=t0F-dwrt40Sg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130155909.GA25399@hmswarspite.think-freely.org> <085a2abc-36e3-74fd-8c3a-9352bdd05cf8@nokia.com>
 <20180130210353.GB25399@hmswarspite.think-freely.org> <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
 <20180131123105.GB23692@hmswarspite.think-freely.org> <aba6d3c5-4b26-5e61-e4c4-e5925749cd1e@nokia.com>
In-Reply-To: <aba6d3c5-4b26-5e61-e4c4-e5925749cd1e@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

2018-01-31 19:51 GMT+02:00 Tommi Rantala <tommi.t.rantala@nokia.com>:
> On 31.01.2018 14:31, Neil Horman wrote:
>>
>> On Wed, Jan 31, 2018 at 11:42:24AM +0200, Tommi Rantala wrote:
>>>
>>> I think there's a problem in the dst refcounting in sctp_v4_get_dst()
>>>
>>> There's a dst_entry struct that has >0 refcnt after running the testcase,
>>> which makes it impossible to delete the loopback device, as that dst is
>>> never freed.
>>>
>>> I'll try to make a patch.
>>>
>> Are you looking at the second for loop there, which uses
>> ip_route_output_key,
>> but discards the result if dst is already set?  That does look a bit
>> wonky, and
>> the same problem may exist in the ipv6 path.  Let me know what the result
>> is.
>
>
> Yes, that was it. Did you receive the email I sent with the patch?
> (I'm not seeing that message e.g. at spinics.net linux-sctp archive, so just
> wondering if that email got lost somehow...)
>
> I'll check the ipv6 case, did not try it yet.
>
> Tommi

As far as I can tell, the ipv6 code does not suffer from this.
The dst handling there looks good to me.

Tommi
