From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 12:47:34 +0000
Subject: Re: EAGAIN
Message-Id: <5025EE9D-20B1-4A7C-B207-A135A082DB92@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 14:18, Andreas Fink <afink@list.fink.org> wrote:
> 
> Hello folks,
> 
> I run into a strange issue with SCTP under Linux and I'm not sure whats the right approach to fix this.
> 
> I have a listener thread which listens on a port for multiple inbound connections
> I have a sender thread which sends packets to peers by using the same socket and doing a sctp_sendv call.
> Sockets are always in non blocking mode.
So a single SOCK_SEQPACKET socket for sending and receiving, right?
> 
> When the remote side gets stopped (process killed),  the sctp_sendv starts returning 0 and errno is set to EAGAIN and we constantly retry.
When it returns 0, you can't look at errno. errno is only set to a correct value, if -1 is returned.

If you killed the peer, I would assume that there is an SCTP message containing an
ABORT chunk in the wire. Is that true? If that is true, you could subscribe to
SCTP_ASSOC_CHANGE notification, which should tell you.

Best regards
Michael
> We somehow didn't catch that this socket was down and end up in a busy loop (which we now fail after a certain amount of retries).
> 
> My question to you is whats the correct way to deal with EAGAIN here? Why are we not catching the assoc being down?
> We have a sender thread and a receiver thread. The receiver thread is listening to events and should know.
> Furthermore if the assoc is down the sctp_sendv could simply return something like socket not connected error instead of EAGAIN.
> 
> Or what am I missing here?
> 
> 
> Andreas
> 
> PS: above was under Linux Debian Kernel 5.4.0-0.bpo.4.
