From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 26 Apr 2019 16:39:11 +0000
Subject: Re: Few Questions About SCTP NAT
Message-Id: <CADvbK_ea9AHeTNfd7qCqf3yDBNinyg_4K9KxwtHhp0u3kMNP7w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_f22Xy_ZA-Ro1wXk-0GTyPo4jr7MocvZSfdwPk3r0YWag@mail.gmail.com>
In-Reply-To: <CADvbK_f22Xy_ZA-Ro1wXk-0GTyPo4jr7MocvZSfdwPk3r0YWag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Apr 26, 2019 at 8:33 PM Michael Tuexen <tuexen@fh-muenster.de> wrote:
>
> > On 25. Apr 2019, at 13:46, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Sorry, seems I sent to the wrong email address.
> > use tuexen@fh-muenster.de instead.
> ... I'm typically more responsive on this address than on the one
> I use for mailing lists...
> >
> > On Sat, Apr 20, 2019 at 6:45 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>
> >> cc'ing linux-sctp.
> >>
> >> On Sat, Apr 20, 2019 at 4:24 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>>
> >>> Hi, Michael,
> >>>
> >>> I'm trying to implement SCTP NAT
> >>> (https://tools.ietf.org/html/draft-ietf-tsvwg-natsupp-12) on linux,
> >>> but got some questions:
> >>>
> >>> 1.
> >>>                        +-------+
> >>>               /--------| NAT 1 |--------\       /--\/--\
> >>>   +------+   /         +-------+         \     /        \    +--------+
> >>>   | Host |==                             ==| Internet |==| Host B |
> >>>   |   A  |   \         +-------+         /     \        /    +--------+
> >>>   +------+    \--------| NAT 2 |--------/       \--/\--/
> >>>                        +-------+
> >>>
> >>> In this topo, after 4 shake-hands and asconf:
> >>>
> >>>          +---------+--------+----------+--------+-----------+
> >>>   NAT 1  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
> >>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
> >>>          +---------+--------+----------+--------+-----------+
> >>>          |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
> >>>          +---------+--------+----------+--------+-----------+
> >>>
> >>>          +---------+--------+----------+--------+-----------+
> >>>   NAT 2  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
> >>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
> >>>          +---------+--------+----------+--------+-----------+
> >>>          |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
> >>>          +---------+--------+----------+--------+-----------+
> >>>
> >>> Now there are 1 entry on nat1 and 1 entry on nat2. If the connection is
> >>> shutdown via nat1, the entry on nat1 will be deleted, right? What about
> >>> the entry on nat2, when can it be deleted?
> Deletion of state is purely timer based. This applies to NAT1 and NAT2.
> >>>
> >>> 2.
> >>>                                            /--\/--\
> >>>   +--------+              +-----+         /        \         +--------+
> >>>   | Host A | <----------> | NAT | <----> | Internet | <----> | Host B |
> >>>   +--------+              +-----+         \        /         +--------+
> >>>                                            \--/\--/
> >>>
> >>> In this topo,  if both paths with saddr 10.0.0.1 and 10.1.0.1 go through
> >>> NAT, will there be 2 entries created on this NAT after 4 shake-hands and
> >>> asconf like:
> >>>
> >>>          +---------+--------+----------+--------+-----------+
> >>>   NAT    |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
> >>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
> >>>          +---------+--------+----------+--------+-----------+
> >>>          |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
> >>>          +---------+--------+----------+--------+-----------+
> >>>          |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
> >>>          +---------+--------+----------+--------+-----------+
> >>>
> >>> or it will be handled as "Internal Port Number and Verification Tag
> >>> Collisions"?
> Which section are you referring to?
I was looking at:

6.3.  Handling of Internal Port Number and Verification Tag Collisions:

"two hosts in the Private-Address space want  to set up an SCTP association
with the same service provided by some hosts in the Internet"

"in this unlikely event the NAT box MUST send an ABORT chunk with the M-bit
set if the collision is triggered by an INIT or INIT-ACK chunk or send an
ERROR chunk with the M-bit set if the collision is triggered by an ASCONF
chunk"

Does it mean:
Users will fail to add the 2nd path by ASCONF chunk on the same NAT as
the 1st path? (if these 2 paths for one asoc go through the same one NAT,
NOT two different NATs).

like:
                                                  +--------+
                                  /--\/--\      /-|Router 1| \
   +------+         +-----+      /        \    /  +--------+  \ +------+
   | Host | <-----> | NAT | <-> | Internet | =                =| Host |
   |   A  |         +-----+      \        /    \  +--------+  / |   B  |
   +------+                       \--/\--/      \-|Router 2|-/  +------+

(10.0.0.1, 10.1.0.1)                             (203.0.113.1, 203.0.113.129)


After 4 shake-hands by 10.0.0.1:1 ---> 203.0.113.1:2:

          +---------+--------+----------+--------+-----------+
   NAT    |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
          +---------+--------+----------+--------+-----------+
          |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
          +---------+--------+----------+--------+-----------+

then the user wants to add the 2nd path, which will also go this NAT:

   ASCONF [ADD-IP=0.0.0.0, INT-VTag34, Ext-VTag = 5678]
   10.1.0.1:1 --------> 203.0.113.129:2
            Ext-VTag = 5678

What will happen on this NAT?

please let me know if it's still unclear. Thanks.

> >>>
> >>> 3.
> >>> For multipath, each entry for one path should maintain a 'state', like
> >>> closed, established, cookie-echo etc, right?  If they belong to a same
> >>> association, especially when they're on different nats, how do we keep
> >>> each entry's state consistent? or they don't have to be consistent?
> You don't need such a state as long as you delete state purely timer based.
> >>>
> >>> Thanks.
>
