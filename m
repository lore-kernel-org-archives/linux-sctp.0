From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sat, 14 Dec 2013 20:06:35 +0000
Subject: Re: undetected closed apps
Message-Id: <A89D7FB9-D2C7-45EB-B1DC-2C06F4290A99@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Dec 14, 2013, at 8:09 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> On 12/14/13 13:47, Michael Tuexen wrote:
>> On Dec 14, 2013, at 7:35 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> 
>>> 
>>> Tried using close - no luck. I may have observed maybe 1 out
>>> 100 runs where a proper shutdown was sent - which maybe an
>>> an improvement, but i could be imagining that.
>> OK. What happens when the shutdown guard timer runs off
> 
> Where do i find this timer and how do i control it?
In FreeBSD it can be controlled by a sysctl:
net.inet.sctp.shutdown_guard_time: 180
Don't know about Linux.
> Waiting for a few hours last time didnt seem to cure this.
OK. 

But the suggested value is 3 Minutes...

Best regards
Michael
> I have one stuck right now, will give it another 5 minutes
> then close the client and see if things work.
> 
> My sctp configs:
> ----
> net.sctp.addip_enable = 0
> net.sctp.addip_noauth_enable = 0
> net.sctp.addr_scope_policy = 1
> net.sctp.association_max_retrans = 10
> net.sctp.auth_enable = 0
> net.sctp.cookie_hmac_alg = sha1
> net.sctp.cookie_preserve_enable = 1
> net.sctp.default_auto_asconf = 0
> net.sctp.hb_interval = 30000
> net.sctp.max_autoclose = 8589934
> net.sctp.max_burst = 4
> net.sctp.max_init_retransmits = 8
> net.sctp.path_max_retrans = 5
> net.sctp.pf_retrans = 0
> net.sctp.prsctp_enable = 1
> net.sctp.rcvbuf_policy = 0
> net.sctp.rto_alpha_exp_divisor = 3
> net.sctp.rto_beta_exp_divisor = 2
> net.sctp.rto_initial = 3000
> net.sctp.rto_max = 60000
> net.sctp.rto_min = 1000
> net.sctp.rwnd_update_shift = 4
> net.sctp.sack_timeout = 200
> net.sctp.sctp_mem = 138363	184487	276726
> net.sctp.sctp_rmem = 4096	865500	4194304
> net.sctp.sctp_wmem = 4096	16384	4194304
> net.sctp.sndbuf_policy = 0
> net.sctp.valid_cookie_life = 60000
> ---------
> 
> cheers,
> jamal
> 

