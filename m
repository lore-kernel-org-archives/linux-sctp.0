From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 07 Jul 2014 08:56:06 +0000
Subject: RE: [PATCH net-next 3/5] net: sctp: implement rfc6458, 5.3.5. SCTP_RCVINFO cmsg support
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1726D5B3@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-4-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-4-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: David Laight
...
> > +	memset(&rinfo, 0, sizeof(struct sctp_rcvinfo));
> > +	rinfo.rcv_sid = event->stream;
> > +	rinfo.rcv_ssn = event->ssn;
> > +	rinfo.rcv_ppid = event->ppid;
> > +	rinfo.rcv_flags = event->flags;
> > +	rinfo.rcv_tsn = event->tsn;
> > +	rinfo.rcv_cumtsn = event->cumtsn;
> > +	rinfo.rcv_assoc_id = sctp_assoc2id(event->asoc);
> > +	rinfo.rcv_context = event->asoc->default_rcv_context;
> > +
> > +	put_cmsg(msghdr, IPPROTO_SCTP, SCTP_RCVINFO,
> > +		 sizeof(rinfo), &rinfo);
> > +}
> 
> This gets called for every receive data chunk (since the user needs to
> verify the ssn and stream).

Clearly I meant ppid and stream :-(

	David



