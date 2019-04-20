From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 20 Apr 2019 10:45:49 +0000
Subject: Re: Few Questions About SCTP NAT
Message-Id: <CADvbK_f22Xy_ZA-Ro1wXk-0GTyPo4jr7MocvZSfdwPk3r0YWag@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

cc'ing linux-sctp.

On Sat, Apr 20, 2019 at 4:24 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Hi, Michael,
>
> I'm trying to implement SCTP NAT
> (https://tools.ietf.org/html/draft-ietf-tsvwg-natsupp-12) on linux,
> but got some questions:
>
> 1.
>                         +-------+
>                /--------| NAT 1 |--------\       /--\/--\
>    +------+   /         +-------+         \     /        \    +--------+
>    | Host |==                             ==| Internet |==| Host B |
>    |   A  |   \         +-------+         /     \        /    +--------+
>    +------+    \--------| NAT 2 |--------/       \--/\--/
>                         +-------+
>
> In this topo, after 4 shake-hands and asconf:
>
>           +---------+--------+----------+--------+-----------+
>    NAT 1  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>           |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>           +---------+--------+----------+--------+-----------+
>           |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
>           +---------+--------+----------+--------+-----------+
>
>           +---------+--------+----------+--------+-----------+
>    NAT 2  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>           |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>           +---------+--------+----------+--------+-----------+
>           |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
>           +---------+--------+----------+--------+-----------+
>
> Now there are 1 entry on nat1 and 1 entry on nat2. If the connection is
> shutdown via nat1, the entry on nat1 will be deleted, right? What about
> the entry on nat2, when can it be deleted?
>
> 2.
>                                             /--\/--\
>    +--------+              +-----+         /        \         +--------+
>    | Host A | <----------> | NAT | <----> | Internet | <----> | Host B |
>    +--------+              +-----+         \        /         +--------+
>                                             \--/\--/
>
> In this topo,  if both paths with saddr 10.0.0.1 and 10.1.0.1 go through
> NAT, will there be 2 entries created on this NAT after 4 shake-hands and
> asconf like:
>
>           +---------+--------+----------+--------+-----------+
>    NAT    |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>           |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>           +---------+--------+----------+--------+-----------+
>           |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
>           +---------+--------+----------+--------+-----------+
>           |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
>           +---------+--------+----------+--------+-----------+
>
> or it will be handled as "Internal Port Number and Verification Tag
> Collisions"?
>
> 3.
> For multipath, each entry for one path should maintain a 'state', like
> closed, established, cookie-echo etc, right?  If they belong to a same
> association, especially when they're on different nats, how do we keep
> each entry's state consistent? or they don't have to be consistent?
>
> Thanks.
