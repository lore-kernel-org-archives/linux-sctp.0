From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 17:49:45 +0000
Subject: Re: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Message-Id: <CADvbK_eWR8yw-kV_cVg93caRpEVziCwN_V6gnB7TLM9xxKWpeg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com> <F02013B3-C485-4998-B68A-26118D8ACF9C@fh-muenster.de>
In-Reply-To: <F02013B3-C485-4998-B68A-26118D8ACF9C@fh-muenster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <tuexen@fh-muenster.de>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>

On Wed, Sep 30, 2020 at 12:40 AM Michael Tuexen <tuexen@fh-muenster.de> wrote:
>
> > On 29. Sep 2020, at 15:48, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Description From the RFC:
> >
> >   The Main Reasons:
> >
> >   o  To allow SCTP traffic to pass through legacy NATs, which do not
> >      provide native SCTP support as specified in [BEHAVE] and
> >      [NATSUPP].
> >
> >   o  To allow SCTP to be implemented on hosts that do not provide
> >      direct access to the IP layer.  In particular, applications can
> >      use their own SCTP implementation if the operating system does not
> >      provide one.
> >
> >   Implementation Notes:
> >
> >   UDP-encapsulated SCTP is normally communicated between SCTP stacks
> >   using the IANA-assigned UDP port number 9899 (sctp-tunneling) on both
> >   ends.  There are circumstances where other ports may be used on
> >   either end, and it might be required to use ports other than the
> >   registered port.
> >
> >   Each SCTP stack uses a single local UDP encapsulation port number as
> >   the destination port for all its incoming SCTP packets, this greatly
> >   simplifies implementation design.
> >
> >   An SCTP implementation supporting UDP encapsulation MUST maintain a
> >   remote UDP encapsulation port number per destination address for each
> >   SCTP association.  Again, because the remote stack may be using ports
> >   other than the well-known port, each port may be different from each
> >   stack.  However, because of remapping of ports by NATs, the remote
> >   ports associated with different remote IP addresses may not be
> >   identical, even if they are associated with the same stack.
> >
> >   Because the well-known port might not be used, implementations need
> >   to allow other port numbers to be specified as a local or remote UDP
> >   encapsulation port number through APIs.
> Hi Xin Long,
>
> I really appreciate that UDP encapsulation gets implemented in Linux.
>
> The FreeBSD implementation initially had a bug due to missing text in
> RFC6951. Please make sure the implementation also follows
> https://www.ietf.org/id/draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html
Hi, Michael

Thanks for sharing this doc.

3. Handling of Out of the Blue Packets:
This patchset can handle it well.

4. Handling of SCTP Packets Containing an INIT Chunk Matching an
Existing Associations:
These cases responding with ABORT, I will need to add.

>
> The plan is to revise RFC6951 and let RFC6951bis include the contents of
> the above Internet Draft. But this most likely will happen after the
> NAT document is ready and RFC4960bis finished...
understand.

>
> If you want to do some interop testing, a web server supporting SCTP/UDP
> is running at interop.fh-muenster.de. You can find a client (phttpget) at
> https://github.com/NEAT-project/HTTPOverSCTP.
got it.
