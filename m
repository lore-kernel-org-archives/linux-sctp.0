From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 23 Jan 2015 16:08:52 +0000
Subject: Re: Fwd: Question on SCTP ABORT chunk is generated when the association_max_retrans is reached
Message-Id: <54C27214.9020003@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
In-Reply-To: <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On 01/23/2015 05:25 AM, Sun Paul wrote:
> Hi
> 
> I would like to check the behave in LKSCTP.
> 
> we are running DIAMETER message over SCTP, and we have set the
> parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.
> 
> We noticed that when remote peer have retry to send the same request
> for 4 times, the LKSCTP will initiate an ABORT chunk with reason
> "association exceeded its max_retrans count".
> 
> We would like to know whether this is the correct behavior? is there
> any other option that we can alter in order to avoid the ABORT chunk
> being sent?
> 

Why do you not want ABORT to be sent? SCTP has attempted to retransmit
the data maximum allows times, and at this point it will terminate
the association.  It sends an ABORT notifying the peer of this, but
most likely the peer is unreachable anyway.

Any message that a peer sends at this point will most likely result
in an ABORT to be send back or an association restart.  Might
as well start fresh.

-vlad

> Thanks
> 
> PS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

