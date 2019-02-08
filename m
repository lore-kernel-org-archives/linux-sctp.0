From: "Buyo, Prinz (Nokia - PH/Quezon City)" <prinz.buyo@nokia.com>
Date: Fri, 08 Feb 2019 06:54:52 +0000
Subject: [Lksctp-developers] SCTP_COMM_ LOST question
Message-Id: <HE1PR07MB3147EF7ABE5BF746BAE94FA087690@HE1PR07MB3147.eurprd07.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

We've been having this boggling SCTP_COMM_LOST occurring in our application.
And it's only occurring on some machine but we can't figure out what's going on.
The SCTP_COMM_LOST occurred ~2.192848s after init on alice side, and alice closed the socket(no abort sent to bob based on wireshark).
Alice didn't have any pending send or retransmission when SCTP_COMM_LOST was received.
Bob still unaware on the comm lost on alice, so when it sent a message to alice (data sent base on wireshark) at around ~14.043s after init,
Alice immediately responded an abort presumably because the socket was already closed.

How would we know what caused the SCTP_COMM_LOST on alice side?
System information is: Linux kiwi313 3.16.0-7-amd64 #1 SMP Debian 3.16.59-1 (2018-10-03) x86_64 GNU/Linux

Best Regards,
Prinz Buyo
