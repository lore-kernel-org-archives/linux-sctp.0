From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 22 Jan 2010 12:01:16 +0000
Subject: Re: Question regarding handling of ootb packets
Message-Id: <20100122120116.GA28924@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100119024254.GA2161@localhost.localdomain>
In-Reply-To: <20100119024254.GA2161@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jan 19, 2010 at 11:23:51AM +0800, Wei Yongjun wrote:
> Neil Horman wrote:
> > Hey all-
> > 	I'm having a bit of trouble understanding the implementation of
> > sctp_rcv_ootb.  Specifically I'm wondering why we allow packets checked in
> > sctp_rcv_ootb with malformed chunks into the receive queue.  For instance, if a
> > chunk in an ootb packet has a zero length, we break out of the loop and return
> > 0, which lets us eventually call sctp_inq_push to put it on the receive queue,
> > from which point on we seem to assume the chunk header length field is valid and
> > correct.  Am I missing something, or is this a bug?
> >
> >   
> 
> Before we put it to the receive queue, we had confirmed that
> this chunk has a lendth at least sizeof(struct sctp_chunkhdr).
>   int sctp_rcv(struct sk_buff *skb)
>   {
>     ...
>     /* Make sure we at least have chunk headers worth of data left. */
>     if (skb->len < sizeof(struct sctp_chunkhdr))
>         goto discard_it;
>     ...
>   }
> 
> We let this chunk go into process by sctp_inq_push() is because
> do this we can then send a ABORT to tell the sender the packet
> is malformed. the chunk header length check will be done later,
> sush as in sctp_sf_ootb().
> 
Got it, thanks Wei!
Neil

> >   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
