From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Mon, 10 Jan 2011 11:51:31 +0000
Subject: Question regarding struct sctp_association
Message-Id: <4D2AF2C3.8010306@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I have a small consistency question. In sctp_packet_transmit of
net/sctp/output.c some parts of the method check if the asoc is valid, other
assume that there is one.

I have some questions regarding that.

The sctp_packet has a pointer to sctp_transport. Does every sctp_transport
hold a valid pointer to sctp_association? Does it hold a valid pointer if
authentication (sctp_auth) is used? Does it hold a valid pointer if chunks
were seen?

regards
	holger
