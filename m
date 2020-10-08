From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 08 Oct 2020 08:13:38 +0000
Subject: RE: Heartbeat on closed SCTP sockets?
Message-Id: <3600af6969d14fcfbe33e05cef8beac2@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1FB70B30-857C-4CD9-A05C-4BA15F57B1D2@list.fink.org>
In-Reply-To: <1FB70B30-857C-4CD9-A05C-4BA15F57B1D2@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Andreas Fink
> Sent: 08 October 2020 07:40
> 
> by reading the linux diver source I discovered this code segment in input.c around line 188
> 
> 
> /*
> 	 * RFC 2960, 8.4 - Handle "Out of the blue" Packets.
> 	 * An SCTP packet is called an "out of the blue" (OOTB)
> 	 * packet if it is correctly formed, i.e., passed the
> 	 * receiver's checksum check, but the receiver is not
> 	 * able to identify the association to which this
> 	 * packet belongs.
> 	 */
> 
> if (!asoc) {
> 	if (sctp_rcv_ootb(skb)) {
> 		__SCTP_INC_STATS(net, SCTP_MIB_OUTOFBLUES);
> 		goto discard_release;
> 	}
> }
> 
> This means out of the blue packets are always ignored and dropped.
> 
> the RFC however says:
> 
>    8) The receiver should respond to the sender of the OOTB packet with
>       an ABORT.  When sending the ABORT, the receiver of the OOTB packet
>       MUST fill in the Verification Tag field of the outbound packet
>       with the value found in the Verification Tag field of the OOTB
>       packet and set the T-bit in the Chunk Flags to indicate that no
>       TCB was found.  After sending this ABORT, the receiver of the OOTB
>       packet shall discard the OOTB packet and take no further action.
> 
> I think this is what I am seeing. The remote sends OOTB messages, we dont reply with abort which means
> the remote doesnt reset the connection.
> There must be a second issue that the socket structures are not in sync up.

But I'm not sure sending an ABORT is right.
You need to stop the remote sending messages to your IP address
not abort the SCTP connection itself.
Especially on an unverified path.

It is pretty easy to get an IP address that is just 'wrong'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
