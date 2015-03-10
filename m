From: Nirosan Paramanathan <pnirosan@gmail.com>
Date: Tue, 10 Mar 2015 16:38:20 +0000
Subject: Multihoming works but still some packets are tried to send through unreachable primary path.
Message-Id: <CAFwXAUtRAPBGmZXYJTaLPzXA7ErQeFJSi0uiD2Q+n0SJuDTApQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,

We have been testing multihoming using lksctp, expected outcome was
immediate primary path failure identification and
change over to secondary address at least within 2 seconds.
With the following sctp parameters, it took 63 seconds to recover.
net.sctp.rto_initial = 3000
net.sctp.rto_min = 1000
net.sctp.rto_max = 60000
net.sctp.path_max_retrans = 5
net.sctp.hb_interval = 30000

We can reason-out this observation according to total primary path RTO
expiration time calculation.
Since it was poor performance we have changed those parameters as
net.sctp.rto_min = 40
net.sctp.rto_max = 800
net.sctp.path_max_retrans = 4

it took 1 second to change over to secondary, but time to time fluctuation
is observed and at the time of fluctuation,
packets were tried to send through unavailable primary path and then
re-transmitted to secondary.

Are we missing any parameters related to multihoming ?

lksctp used: lksctp-tools-1.0.10-3.el5.rfx.x86_64.rpm
kernal: Linux x86_64 2.6.39-4.el5.elrepo

Below is the whole sctp parameters configured.
net.sctp.rto_initial = 3000
net.sctp.rto_min = 1000
net.sctp.rto_max = 60000
net.sctp.valid_cookie_life = 60000
net.sctp.max_burst = 15
net.sctp.association_max_retrans = 10
net.sctp.sndbuf_policy = 1
net.sctp.rcvbuf_policy = 1
net.sctp.path_max_retrans = 5
net.sctp.max_init_retransmits = 8
net.sctp.hb_interval = 30000
net.sctp.cookie_preserve_enable = 1
net.sctp.rto_alpha_exp_divisor = 3
net.sctp.rto_beta_exp_divisor = 2
net.sctp.addip_enable = 0
net.sctp.prsctp_enable = 1
net.sctp.sack_timeout = 1
net.sctp.sctp_mem = 11377184    11502912        11754368
net.sctp.sctp_rmem = 114096     11361500        114194304
net.sctp.sctp_wmem = 114096     1116384 114194304
net.sctp.auth_enable = 0
net.sctp.addip_noauth_enable = 0
net.sctp.addr_scope_policy = 1
net.sctp.rwnd_update_shift = 4


Thanks and regards,
P.Nirosan.
