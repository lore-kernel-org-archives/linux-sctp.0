From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 21 Aug 2020 16:50:45 +0000
Subject: Re: 64k streams not supported
Message-Id: <20200821165045.GL3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
In-Reply-To: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Aug 21, 2020 at 03:59:42PM +0000, David Laight wrote:
> Isn't SCTP supposed to support 65536 data streams?

Hm, no? Why?

https://tools.ietf.org/html/rfc4960#section-5.1.1
"After the association is initialized, the valid outbound stream
identifier range for either endpoint shall be 0 to min(local OS,
remote MIS)-1."

Section 3.3.2:
   Number of Outbound Streams (OS): 16 bits (unsigned integer)

      Defines the number of outbound streams the sender of this INIT
      chunk wishes to create in this association.  The value of 0 MUST
      NOT be used.

...

   Number of Inbound Streams (MIS): 16 bits (unsigned integer)


      Defines the maximum number of streams the sender of this INIT
      chunk allows the peer end to create in this association.  The
      value 0 MUST NOT be used.

  Marcelo
