From: David Miller <davem@davemloft.net>
Date: Thu, 21 Feb 2013 18:02:32 +0000
Subject: Re: [PATCH 1/4 v2] sctp: fix association hangs due to off-by-one errors in sctp_tsnmap_grow()
Message-Id: <20130221.130232.875234888321258862.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <D64EC45690EF85409BA6C4730E0162244310DF62@G4W3231.americas.hpqcorp.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310DF62@G4W3231.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lee.roberts@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: "Roberts, Lee A." <lee.roberts@hp.com>
Date: Thu, 21 Feb 2013 17:57:46 +0000


When you are given feedback on patches you submit, you should wait
some time for all the feedback to settle, then resubmit your entire
series (not just the patches that needed changes).

> Patch applies to linux-3.8 kernel.

This is not appropriate to mention in a commit message, your patches
might get ported to -stable trees and elsewhere, and such a comment
looks awkward at best in such scenerios.
