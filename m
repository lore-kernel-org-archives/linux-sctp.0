From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Feb 2019 12:42:26 +0000
Subject: Re: [Lksctp-developers] SCTP_COMM_ LOST question
Message-Id: <20190208124226.GB13299@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <HE1PR07MB3147EF7ABE5BF746BAE94FA087690@HE1PR07MB3147.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR07MB3147EF7ABE5BF746BAE94FA087690@HE1PR07MB3147.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Feb 08, 2019 at 06:54:52AM +0000, Buyo, Prinz (Nokia - PH/Quezon City) wrote:
> Hello,
> 
> We've been having this boggling SCTP_COMM_LOST occurring in our application.
> And it's only occurring on some machine but we can't figure out what's going on.
> The SCTP_COMM_LOST occurred ~2.192848s after init on alice side, and alice closed the socket(no abort sent to bob based on wireshark).
> Alice didn't have any pending send or retransmission when SCTP_COMM_LOST was received.
> Bob still unaware on the comm lost on alice, so when it sent a message to alice (data sent base on wireshark) at around ~14.043s after init,
> Alice immediately responded an abort presumably because the socket was already closed.
> 
> How would we know what caused the SCTP_COMM_LOST on alice side?
> System information is: Linux kiwi313 3.16.0-7-amd64 #1 SMP Debian 3.16.59-1 (2018-10-03) x86_64 GNU/Linux
> 
> Best Regards,
> Prinz Buyo
> 
Did you intend to send the wireshark capture along with this description?  If
so, it was dropped.  It would be helpful to see the contents of the capture in
its entirety.

Its also worth noting that your kernel is pretty old, so I'm not sure whats been
fixed regarding comm lost notifications in the kernel release set since 3.16
(we're currently up to 4.20), it would be good to try this on a newer kernel to
see if the failure still occurs to ensure we're not chasing a known problem.

Neil
