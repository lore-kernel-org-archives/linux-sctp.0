From: Ashok Kumar <svashok79@gmail.com>
Date: Tue, 12 Dec 2017 16:51:41 +0000
Subject: How to restrict SCTP abort during a process crash
Message-Id: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,



We are using LKSCTP in our LTE product (HeNBGW). We have
high-availability support also in our product. In case of any failure
on active VM, standby VM will take over active role and all the SCTP
associations will be moved to that new active VM. The associations
should be moved transparent to the peers (a kind of SCTP reset before
SCTP heartbeat expires on the peer nodes).



But the problem that we face is that when a process crashes on active
VM, the LKSCTP stack immediately sends SCTP abort to the peers for all
associations before the system goes down completely. This creates
confusion with the peers. Is there any way to avoid sending SCTP abort
message in this scenario? If yes, please let us know how to do the
same? If it needs LKSCTP kernel code change, please give pointers on
what and where to change.



P.S: We tried to block the abort messages by dynamically using
IPtables through signal handler (for signal 11 and 6). But this did
not work.



A quick response will be highly appreciated.



Thanks,

Ashok
