From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 04 Dec 2019 09:02:28 +0000
Subject: Re: SCTP conntrack does not track init chunk types
Message-Id: <CADvbK_frK_WY2=J1MAjG9-f07+WoKjRKiqDjL5YrOFDhd4bk6A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CANpxKHFkTApZufGkL-7JSwt0BqTmPpp1=77jVhrqHZdo74e0Sw@mail.gmail.com>
In-Reply-To: <CANpxKHFkTApZufGkL-7JSwt0BqTmPpp1=77jVhrqHZdo74e0Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Nov 28, 2019 at 7:37 PM Naruto Nguyen
<narutonguyen2018@gmail.com> wrote:
>
> Hi everyone,
>
> I have followed a simple SCTP server and SCTP client at
> http://simplestcodings.blogspot.com/2010/08/sctp-server-client-implementation-in-c.html
>
> It works well. Client and server can communicate successfully. Then I
> tried to set up an iptable rule to drop INIT package on server node
>
> iptables -A INPUT -p sctp  -m conntrack --ctstate NEW -m sctp
> --chunk-types any INIT -j DROP
>
> It can drop and connection cannot establish from client anymore.
> However, when I tried to drop INIT_ACK sent from server by
>
> iptables -A OUTPUT -p sctp  -m conntrack --ctstate NEW -m sctp
> --chunk-types any INIT_ACK -j DROP
I think INIT_ACK as a reply dir packet, the conntrack ctstate may not be NEW.
can you pls try with others, like ESTABLISHED, RELATED or so.

>
> looks like it cannot drop INIT_ACK and connection from client is setup
> well. Could you please tell me if SCTP conntrack can drop INIT_ACK,
> COOKIE_ACK? My conntrack log does not show any INIT, INIT_ACK,
> COOKIE_ACK
what do you mean, show INIT and INIT_ACK, those are packet types.
you can see the sctp asoc state, like COOKIE_ECHOED, ESTABLISHED.

>
> [NEW] sctp     132 3 src9.569.9.50 dst9.569.9.51 sportW295
> dportb324 [UNREPLIED] src9.569.9.51 dst9.569.9.50 sportb324
> dportW295
>  [UPDATE] sctp     132 3 src9.569.9.50 dst9.569.9.51 sportW295
> dportb324 src9.569.9.51 dst9.569.9.50 sportb324 dportW295
>  [UPDATE] sctp     132 3 COOKIE_ECHOED src9.569.9.50
> dst9.569.9.51 sportW295 dportb324 src9.569.9.51
> dst9.569.9.50 sportb324 dportW295
>  [UPDATE] sctp     132 432000 ESTABLISHED src9.569.9.50
> dst9.569.9.51 sportW295 dportb324 src9.569.9.51
> dst9.569.9.50 sportb324 dportW295 [ASSURED]
>
> Is it expected? In tcp, conntrack log can show SYN_SENT/ SYN_RECEIVED.
I think so.
