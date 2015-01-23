From: Sun Paul <paulrbk@gmail.com>
Date: Fri, 23 Jan 2015 10:09:53 +0000
Subject: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
Message-Id: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi

I would like to check the behave in LKSCTP.

we are running DIAMETER message over SCTP, and we have set the
parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.

We noticed that when remote peer have retry to send the same request
for 4 times, the LKSCTP will initiate an ABORT chunk with reason
"association exceeded its max_retrans count".

We would like to know whether this is the correct behavior? is there
any other option that we can alter in order to avoid the ABORT chunk
being sent?

Thanks

PS
