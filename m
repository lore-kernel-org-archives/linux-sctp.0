From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 15 Aug 2013 17:28:03 +0000
Subject: Re: one-to-many question
Message-Id: <20130815172802.GC20294@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <520CAC87.5020402@skyge.com>
In-Reply-To: <520CAC87.5020402@skyge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Aug 15, 2013 at 05:13:10PM +0200, Michael Tuexen wrote:
> On Aug 15, 2013, at 1:42 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> 
> > On 08/15/2013 12:25 PM, xiong wei wrote:
> >> Hi, experts
> >> 
> >> For one-to-many mode. Suppose I have a socket which contain several
> >> associations in it. that means there are several clients connect with
> >> server.
> >> 
> >> If I use sendmsg(...) function to send msg from server, How does sctp
> >> identify which association will receive the data? Does all clients will
> >> receive the msg?
> >> 
> >> And, Does sctp provide a way for server to send msg to all associations
> >> in one syscall ?
> > 
> > Neil Horman wrote:
> > 
> > The receiving association is specified in either the msg_name field of the
> Can you specify on Linux an sctp_assoc_t? Or would you specify one of the
> remote IP addresses? Specifying an sctp_assoc_t would be Linux specific,
> I guess. At least this isn't covered by 
> http://tools.ietf.org/html/rfc6458
> as far as I know.
> 
Its a sockaddr structure that is used in the lookup of sctp_sendmsg, so It
should be a peer ip address (either v4 or v6)
Neil

> Best regards
> Michael
> > message header or the association id field of the sndrcv_info cmsg header in the
> > datagram.  IIRC there is no was to send to all associations at once in a single
> > syscall, unless you want to marshall up all the data and pass it down via the
> > sendmmsg syscall, which I don't think lksctp-tools supports yet (though that
> > would be a nice feature).
> > Neil
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
