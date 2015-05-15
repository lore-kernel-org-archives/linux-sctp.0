From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 15 May 2015 13:39:09 +0000
Subject: Re: Dropped SCTP Connections over slow network
Message-Id: <20150515133909.GB643@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAD26VjM6eAKVSKNorsdHeLu4qMt1xKpF04UN3ZRBvAugHMe13g@mail.gmail.com>
In-Reply-To: <CAD26VjM6eAKVSKNorsdHeLu4qMt1xKpF04UN3ZRBvAugHMe13g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, May 13, 2015 at 10:27:05AM -0400, Atalay Ozgovde wrote:
> We are essentially trying to implement "fire and forget" TCP with
> SCTP. That is, a single server port that services clients that
> establish separate connections. We are not broadcasting same messages
> over to every client. Each client can issue different sets of requests
> from the server and receive response as streams of messages over its
> own channel. Messages are time sensitive and expire fast, therefore
> retransmission of lost messages is not desirable. Due to large number
> of clients and uniqueness of clients' needs UDP is not an option.
> We have one-to-one SCTP connections to clients where we send unordered
> messages with short time to live parameters. When clients' network
> degrade to about 60% packet loss (which happens often in some
> regions), server can continue to write (sctp_sendmsg) to the clients
> connection but wireshark shows that message don't get to the wire
> (blocked at the transport layer).
> We enabled SCTP Kernel logging and here is what we see:
> We start getting the following for each write attempt (some lines are
> removed for brevity):
> May 11 09:58:43 localhost kernel: [250220.363867] sctp:
> sctp_outq_flush: could not transmit TSN: 0x0, status: 2
> May 11 09:58:43 localhost kernel: [250220.363870] sctp: sctp_do_sm
> post sfx: error 0, asoc ffff88036943a000[STATE_
> ESTABLISHED]
> 
> After several of the above eventually we get:
> 
> May 11 09:58:43 localhost kernel: [250220.363871] sctp: We sent primitively.
> May 11 09:58:43 localhost kernel: [250220.363933] sctp: sctp_close(sk:
> 0xffff880369693dc0, timeout:0)
> May 11 09:58:43 localhost kernel: [250220.363938] sctp: sctp_do_sm
> prefn: ep ffff8807d159e200, EVENT_T_PRIMITIVE, PRIMITIVE_SHUTDOWN,
> asoc ffff880         36943a000[STATE_ESTABLISHED],
> sctp_sf_do_9_2_prm_shutdown
>  May 11 09:58:43 localhost kernel: [250220.363941] sctp: sctp_do_sm
> postfn: asoc ffff88036943a000, status: DISPOSITION_CONSUME
> May 11 09:58:43 localhost kernel: [250220.363943] sctp:
> sctp_cmd_new_state: asoc ffff88036943a000[STATE_SHUTDOWN_PENDING]
> May 11 09:58:43 localhost kernel: [250220.363945] sctp: sctp_do_sm
> post sfx: error 0, asoc ffff88036943a000[STATE_CLOSED]
> May 11 09:58:43 localhost kernel: [250220.363947] sctp:
> sctp_destroy_sock(sk: ffff880369693dc0)
> 
> SCTP is abandoning the connection due to status = 2. I found in the
> kernel SCTP source that it means: SCTP_XMIT_RWND_FULL. ie. rwindow is
> full. Clearly SCTP reacting to what is sees as heavy congestion.
> We can detect congestion before connection is closed (using sctp
> events), my question is is there a way to reset a connection
> (association) without having to close it? Alternatively, is there a
> way to relax congestion parameters so that we can continue using the
> connection as we don't care about the packet loss?
> 
> Thanks,
> 
> Atalay

Theres no way to reset a failed connection short of closing it an
re-establishing a new one.  You also can't "relax" the rwnd congestion parameter
directly, but you can change sctp_mem/sctp_rmem so that newly established
connections compute a larger receive window when they are set up
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
