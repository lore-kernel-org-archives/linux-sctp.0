From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 30 Jun 2014 08:24:09 +0000
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <53B11EA9.2030905@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 06/28/2014 01:04 PM, Winston V. Tizon wrote:
> Hello everyone!
>
> We are having some issues regarding SCTP multihoming
> and we would like to ask your opinion on this matter.
> We have two RHEL6.4 (2.6.32-358.el6.x86_64, lksctp-tools
> -1.0.10-5(64 bit)) machines connected by two L2 switch
> and a L3 switch (please see "Environment Setup" below).
> When we execute SCTP connection (using multihoming) between
> the two machines, the following behavior occurred:
>
>        CLIENT           L2 and L3         SERVER
> Secondary Primary           |      Primary Secondary
>      |        |              |          |       |
>      |        |              |          |       |
>      |        |INIT-INIT_ACK |          |       |
>      |        |<-------------|--------->|       |
>      |        |COOKIE_ECHO-COOKIE_ACK   |       |
>      |        |              |          |       |
>      |        |<-------------|--------->|       |
>      |        |HB/HB_ACK     |          |       |
>      |        |              |          |       |
>      |<-------|--------------|----------|       |
>      |        |              |       HB |       |
>      |        |--------------|--------->|       |
>      |        |HB_ACK        |          |       |
>      |        |        :     |          |       |
>      |        |        :     |          |       |
>
> INIT/INIT_ACK handshake occurred in the primary
> path of both machines which is expected. When a
> Primary path sends HEARTBEAT to another Primary,
> HEARTBEAT_ACK was returned to the sender. But
> when a Primary path sends HEARTBEAT to a
> Secondary path, the HEARTBEAT_ACK chunk was sent
> by the Primary path. We expect that the
> HEARTBEAT_ACK would come from the Secondary.
>
> [Questions]
> 1. Is this a normal behavior with regards to SCTP multihoming?

So looking at the RFC, it says (RFC4960, 3.3.6. + 6.4.) ...

  An endpoint should send this chunk to its peer endpoint as a
  response to a HEARTBEAT chunk (see Section 8.3). A HEARTBEAT ACK
  is always sent to the source IP address of the IP datagram
  containing the HEARTBEAT chunk to which this ack is responding.

  [...]

  An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
  etc.) to the same destination transport address from which it
  received the DATA or control chunk to which it is replying. This
  rule should also be followed if the endpoint is bundling DATA chunks
  together with the reply chunk.

... it would be more correct to reply via the same transport, imho.
I just checked upstream kernel with multihoming on 2 machines with
5 interfaces each, and HB, HB-ACK replies seem to be fine there,
that is, HB-ACKs go via same transports.
