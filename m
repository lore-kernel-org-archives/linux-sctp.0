From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Wed, 04 Mar 2015 20:59:21 +0000
Subject: Does IPv6 have to be enabled to run lksctp-tools?
Message-Id: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

We had a strange problem using lksctp-tool where checksctp would hang
there on some of our machines and process cannot be killed anyway
(with status d/d+). After some investigation, we found out that
whether ipv6 is enabled could impact the behavior of the library. So,
my question is that, is this a requirement by design or it just
happens to occur that ipv6 is required? Any suggestion to bypass this
(not to rely on ipv6) would be appreciated very much.

Regards,
Jerry
