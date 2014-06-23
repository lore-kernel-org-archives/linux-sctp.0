From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 23 Jun 2014 14:27:49 +0000
Subject: RE: [PATCH net-next] sctp: Add partially support for MSG_MORE to SCTP.
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1726152D@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1725FB90@AcuExch.aculab.com>
 <53A4B165.6050504@gmail.com>
In-Reply-To: <53A4B165.6050504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Vlad Yasevich
> On 06/20/2014 12:24 PM, David Laight wrote:
> > If MSG_MORE is set then buffer sends as if Nagle were enabled.
> > The first data chunk is still sent on its own, but subsequent chunks
> > will be bundled and full packets sent.
> > Full MSG_MORE support would require a timeout (preferably configurable
> > per-socket) to send the last chunk(s), instead of sending them
> > when there is nothing outstanding.
> >
> 
> Instead of using 1 and 2, can you define them as flags please

Will do....

It is worth inverting nagle/nodelay bit; so that:
0 => SCTP_NODELAY
1 => Nagle (default)
2 => MSG_MORE
4 => reserved for corked

That would require working out where the structure is initialised
(in order to default to Nagle).

	David



