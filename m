From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Sun, 04 Feb 2018 09:05:41 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <92480b3b-73a6-86fb-f0bc-73d05fbaa0cb@nokia.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130155909.GA25399@hmswarspite.think-freely.org>
 <085a2abc-36e3-74fd-8c3a-9352bdd05cf8@nokia.com>
 <20180130210353.GB25399@hmswarspite.think-freely.org>
 <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
 <20180131123105.GB23692@hmswarspite.think-freely.org>
 <aba6d3c5-4b26-5e61-e4c4-e5925749cd1e@nokia.com>
 <CA+ydwtpiPeFuOB9PyCiOiKhzx69Ecu9mMt2ut=t0F-dwrt40Sg@mail.gmail.com>
 <20180201192355.GA4748@hmswarspite.think-freely.org>
 <CA+ydwtpWYtU9FDzjPkcM45iun8KQuG8nWkCj6=sbaCcRGoX7MQ@mail.gmail.com>
 <20180202123445.GA21773@hmswarspite.think-freely.org>
In-Reply-To: <20180202123445.GA21773@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, Tommi Rantala <tt.rantala@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Alexey Kodanev <alexey.kodanev@oracle.com>

On 02.02.2018 14:34, Neil Horman wrote:
> Patch looks good, but if you could please submit it with the proper title in a
> separate thread so it gets davem's attention properly, I'd appreciate it.
> Additional points if you update it to include the ipv6 fixes :)

Thanks, I'll send this patch properly.

I think I will let Alexey post the ipv6 fixes separately, as he's also 
planning another fix to sctp_v6_get_dst.

Tommi
