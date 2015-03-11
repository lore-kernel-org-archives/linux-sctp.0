From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 11 Mar 2015 13:27:31 +0000
Subject: Re: Source IP address of SCTP INIT chunk and the IPv4 address parameter inside SCTP INIT chunk
Message-Id: <550042C3.3010106@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftK0QQiazx3MCdz+8rXosOLbXS0E52DyTjwDGiYZzTB8GQ@mail.gmail.com>
In-Reply-To: <CAFXGftK0QQiazx3MCdz+8rXosOLbXS0E52DyTjwDGiYZzTB8GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/10/2015 10:55 PM, Sun Paul wrote:
> Hi
> 
> I would like to ask about the IP address on dource IP address of SCTP
> INIT chunk and the IPv4 address parameter inside SCTP INIT chunk.
> 
> If the source IP of the SCTP INIT chunk is 10.1.1.84, but the IP
> address INSIDE the INIT chunk, i.e. the IPv4 address parameter, is
> using a different IP address, says 192.1.1.84, what will be happened?

This is part of multihoming support of sctp.  The system generating
such INIT chunk says that is can be reached via either address.  The
peer system will the create 2 paths, one to 10.1.1.84 and the other
to 192.1.1.84 and will use them in cases of failover and retransmission.

> 
> I did a testing on a SCTP server and client environment, and it seems
> the SCTP server tried to send INIT_ACK back to the source IP to the
> client, i.e. the destination IP address is 10.1.1.84. but somehow, the
> SCTP server generate two HEARTBEAT request, one to 10.1.1.84 and one
> to 192.1.1.84.
> 
> is it a problem on our SCTP server application?

No, this is behaving exactly how specified in the SCTP specification.

-vlad

> 
> any idea on this?
> 
> Thanks
> 
> - RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

