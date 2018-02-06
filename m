From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 06 Feb 2018 08:27:00 +0000
Subject: Re: [PATCH net v3] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <CACT4Y+Z8Kw4GSUBcxh60h5SFc7ony0GP2y2s9noF1=bgpEsTzg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180205194814.14006-1-tommi.t.rantala@nokia.com>
 <c242ed66-cc0c-0783-360a-88e73fe5d541@gmail.com> <CADvbK_ctBP8vsy2vSCjOcTMSaSrZp9kv__pHkfct51g_nW3AEQ@mail.gmail.com>
In-Reply-To: <CADvbK_ctBP8vsy2vSCjOcTMSaSrZp9kv__pHkfct51g_nW3AEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, Tommi Rantala <tommi.t.rantala@nokia.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Feb 6, 2018 at 6:06 AM, Xin Long <lucien.xin@gmail.com> wrote:
> On Tue, Feb 6, 2018 at 7:20 AM, David Ahern <dsahern@gmail.com> wrote:
>> On 2/5/18 12:48 PM, Tommi Rantala wrote:
>>> Fix dst reference count leak in sctp_v4_get_dst() introduced in commit
>>> 410f03831 ("sctp: add routing output fallback"):
>>>
>>> When walking the address_list, successive ip_route_output_key() calls
>>> may return the same rt->dst with the reference incremented on each call.
>>>
>>> The code would not decrement the dst refcount when the dst pointer was
>>> identical from the previous iteration, causing the dst refcnt leak.
>>>
>> ...
>>>   ...
>>>
>>> Fixes: 410f03831 ("sctp: add routing output fallback")
>>> Fixes: 0ca50d12f ("sctp: fix src address selection if using secondary addresses")
>>
>> any syzbot references for this bug?
> In Dmitry Vyukov mail, there was no syzbot reference provided.
> Not sure if there's another way to tell syzbot.


If we are talking about "net: hang in unregister_netdevice: waiting
for lo to become free":
https://groups.google.com/d/msg/syzkaller/-06_laheMF0/xqezy58kAwAJ
Then there is no syzbot tag. It was found with syzkaller, but not
reported by syzbot because the manifestation is too tricky, it could
have been reported as "no output from test machine" with no additional
details, which is not too actionable.
