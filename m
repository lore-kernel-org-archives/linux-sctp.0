From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 17 Jan 2017 17:49:03 +0000
Subject: Re: Issues on handshake with PR-SCTP
Message-Id: <CADvbK_dccpv1nJk_-eTA0-yLrmi5xafebUAutm5355r=W-qC7Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117130648.GA6494@aomx-netbook>
In-Reply-To: <20170117130648.GA6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jan 17, 2017 at 9:06 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
> When one side of an association does not support PR-SCTP and does not
> announce the support with the FORWARD-TSN-Supported- Parameter in the
> INIT-Chunk or INIT-ACK chunk during the handshake there are two issues:
>
> If the peer does not include the FORWARD-TSN-Supported-Parameter in the
> INIT-Chunk and later sends an FORWARD-TSN-Chunk, then the linux kernel
> does not respond with an ERROR-Chunk like defined in https://tools.ietf.org/html/rfc3758#section-3.3.1.
> It instead silently discards the FORWARD-TSN-Chunk.
>
> Testscript available at:
> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/handshake-with-forward-tsn/handshake-with-forward-tsn-4.pkt
>
> If the peer does not include the FORWARD-TSN-Supported-Parameter in the
> INIT-ACK-Chunk but sends later an FORWARD-TSN-Chunk, then the behaviour
> is different. The Forward-TSN-Chunk is processed and an SACK-Chunk is sent
> by the linux kernel. This should also be an ERROR-Chunk, because the peer
> has not announced support for PR-SCTP.
>
> Testscript available at:
> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/handshake-with-forward-tsn/handshake-with-forward-tsn-5.pkt

I think you're right, linux sctp seems not to check
peer.prsctp_capable before processing it.

Thanks.
