From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 31 Jan 2018 12:31:05 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <20180131123105.GB23692@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130155909.GA25399@hmswarspite.think-freely.org>
 <085a2abc-36e3-74fd-8c3a-9352bdd05cf8@nokia.com>
 <20180130210353.GB25399@hmswarspite.think-freely.org>
 <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
In-Reply-To: <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Wed, Jan 31, 2018 at 11:42:24AM +0200, Tommi Rantala wrote:
> On 30.01.2018 23:03, Neil Horman wrote:
> > On Tue, Jan 30, 2018 at 09:24:17PM +0200, Tommi Rantala wrote:
> > > On 30.01.2018 17:59, Neil Horman wrote:
> > > > On Mon, Jan 29, 2018 at 05:55:45PM +0200, Tommi Rantala wrote:
> > > > > 
> > > > > ip netns add TEST
> > > > > ip netns exec TEST ip link set lo up
> > > > > ip link add dummy0 type dummy
> > > > > ip link add dummy1 type dummy
> > > > > ip link add dummy2 type dummy
> > > > > ip link set dev dummy0 netns TEST
> > > > > ip link set dev dummy1 netns TEST
> > > > > ip link set dev dummy2 netns TEST
> > > > > ip netns exec TEST ip addr add 192.168.1.1/24 dev dummy0
> > > > > ip netns exec TEST ip link set dummy0 up
> > > > > ip netns exec TEST ip addr add 192.168.1.2/24 dev dummy1
> > > > > ip netns exec TEST ip link set dummy1 up
> > > > > ip netns exec TEST ip addr add 192.168.1.3/24 dev dummy2
> > > > > ip netns exec TEST ip link set dummy2 up
> > > > > ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1 -p 20000
> > > > > -s -B 192.168.1.3
> > > > > ip netns del TEST
> > > > > 
> > > > Does the problem occur if you don't set lo up?
> > > 
> > > Still happens after dropping "ip netns exec TEST ip link set lo up".
> > > 
> > > Omitting "-B 192.168.1.3" from the sctp_test args helps.
> > > 
> > Thats....wierd.  I'll look at the sctp_test code in the AM
> 
> I think there's a problem in the dst refcounting in sctp_v4_get_dst()
> 
> There's a dst_entry struct that has >0 refcnt after running the testcase,
> which makes it impossible to delete the loopback device, as that dst is
> never freed.
> 
> I'll try to make a patch.
> 
Are you looking at the second for loop there, which uses ip_route_output_key,
but discards the result if dst is already set?  That does look a bit wonky, and
the same problem may exist in the ipv6 path.  Let me know what the result is.
Neil

> Tommi
> 
> 
