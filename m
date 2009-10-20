From: "Chris Friesen" <cfriesen@nortel.com>
Date: Tue, 20 Oct 2009 21:55:59 +0000
Subject: question on SCTP_DELAYED_ACK and sctp_sack_info
Message-Id: <4ADE31EF.5040409@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Hi all,

I've got a question about the handling of SCTP_DELAYED_ACK.

In sctp_setsockopt_delayed_ack() the code looks to see if the size of
the struct being passed down matches the size of struct sctp_sack_info.
 If it doesn't, it accepts being passed struct sctp_assoc_value but it
complains about it.

However, the lksctp-tools package doesn't seem to define or use struct
sctp_sack_info anywhere, only struct sctp_assoc_value.

Are apps expected to copy the struct definition themselves?  Is there
any plan to update lksctp-tools?

Thanks,

Chris
