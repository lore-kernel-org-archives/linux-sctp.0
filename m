From: malc <mlashley@gmail.com>
Date: Tue, 18 Aug 2015 17:17:38 +0000
Subject: Re: SCTP heartbeat transmission interval in not working as expected
Message-Id: <CAPkQJpRbQRJ6VUbG1Q9AoQH_ueLPNfaC9EC-v+eRmwsSW27vEw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
In-Reply-To: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

@Vlad - he only has single-homed here per the trace he sent (which the
list presumably filtered.)
@Ravi - are you inducing impairments in the network? Reason I ask is
in the trace, your association comes up and then .82 sends data chunks
in frames 5 and 6 - the response from .5 (frame 7) is a GAP-SACK for
the TSN in frame 6, indicating the DATA chunk in frame 5 was lost
somehow... If you have network impairments (either intentionally, or
otherwise) - then our best-case suggestions above will be off as you
will likely incur RTO doubling etc. For the random sampling of idle HB
intervals I looked at later in the trace (initiated by .82), they all
seem to fit the expected range as described above.

Cheers,
malc.
