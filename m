From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 06 Oct 2010 18:52:39 +0000
Subject: Re: SACK is sent to wrong IP address
Message-Id: <4CACC577.3020201@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2B7783B1E18B2C4984C3979954E10AFC07E3EAC9@ZMY16EXM67.ds.mot.com>
In-Reply-To: <2B7783B1E18B2C4984C3979954E10AFC07E3EAC9@ZMY16EXM67.ds.mot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/06/2010 01:48 PM, B N Srikant-A21035 wrote:
> Hi,
>
> We have multihomed server (IP1, IP2) and single home client (IP3).
> Initially client has established association with multi homed server.
> Later the server has restarted and sent INIT. The IP1 is temporarily
> inactive and IP2 is active.
> So INIT is sent from IP2 and client has sent INIT ACK back to IP2. The
> Cookie and Cookie ack are also exchanged on new address.
>
> But when data was sent from server (IP2) to client the client is sending
> SACK to IP1 instead IP2.
> As per the RFC the SACK should be sent to the address from where data is
> coming.
>
> Is there any fix for this ? Or any suggestion to fix it is helpful.
>
> thanks
> Srikant
>
>

Hi Srikant

This looks like a bug during the restart procedure.

When the association is restarted, the concept of primary transport may have changed, but
that is not accounted for during the restart procedure.  When the association restarts,
the we need to check if we need to change the primary transport and perform the change
if required.

-vlad

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

