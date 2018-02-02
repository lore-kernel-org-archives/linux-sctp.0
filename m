From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 02 Feb 2018 12:34:45 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <20180202123445.GA21773@hmswarspite.think-freely.org>
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
In-Reply-To: <CA+ydwtpWYtU9FDzjPkcM45iun8KQuG8nWkCj6=sbaCcRGoX7MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Feb 01, 2018 at 10:41:27PM +0200, Tommi Rantala wrote:
> 2018-02-01 21:23 GMT+02:00 Neil Horman <nhorman@tuxdriver.com>:
> > No, I can't say I saw the patch on the list.  Can you resend it?
> 
> Here's the patch again, sending from gmail this time.
> 
> The previous mail is now also at spinics, dunno what happened.
> https://www.spinics.net/lists/linux-sctp/msg07005.html
> 
> 
> From b94c037d27e36a3053e6862b7e7da5f07f2f5597 Mon Sep 17 00:00:00 2001
> From: Tommi Rantala <tommi.t.rantala@nokia.com>
> Date: Wed, 31 Jan 2018 11:24:31 +0000
> Subject: [PATCH] sctp: fix dst leak in sctp_v4_get_dst
> 
> Fix dst reference leak in sctp_v4_get_dst() introduced in commit
> 410f03831 ("sctp: add routing output fallback"):
> 
> When walking the address_list, successive ip_route_output_key() calls
> may return the same rt->dst with the reference incremented on each call.
> 
> The code would not decrement the dst refcount when the dst pointer was
> identical from the previous iteration, causing the dst leak.
> 
> Testcase:
>   ip netns add TEST
>   ip netns exec TEST ip link set lo up
>   ip link add dummy0 type dummy
>   ip link add dummy1 type dummy
>   ip link add dummy2 type dummy
>   ip link set dev dummy0 netns TEST
>   ip link set dev dummy1 netns TEST
>   ip link set dev dummy2 netns TEST
>   ip netns exec TEST ip addr add 192.168.1.1/24 dev dummy0
>   ip netns exec TEST ip link set dummy0 up
>   ip netns exec TEST ip addr add 192.168.1.2/24 dev dummy1
>   ip netns exec TEST ip link set dummy1 up
>   ip netns exec TEST ip addr add 192.168.1.3/24 dev dummy2
>   ip netns exec TEST ip link set dummy2 up
>   ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1
> -p 20000 -s -B 192.168.1.3
>   ip netns del TEST
> 
Patch looks good, but if you could please submit it with the proper title in a
separate thread so it gets davem's attention properly, I'd appreciate it.
Additional points if you update it to include the ipv6 fixes :)
Neil

