From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 12 Dec 2017 19:38:24 +0000
Subject: Re: How to restrict SCTP abort during a process crash
Message-Id: <20171212193824.GG3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
In-Reply-To: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Dec 12, 2017 at 10:21:31PM +0530, Ashok Kumar wrote:
> Hi,
> 
> 
> 
> We are using LKSCTP in our LTE product (HeNBGW). We have
> high-availability support also in our product. In case of any failure
> on active VM, standby VM will take over active role and all the SCTP
> associations will be moved to that new active VM. The associations
> should be moved transparent to the peers (a kind of SCTP reset before
> SCTP heartbeat expires on the peer nodes).
> 
> 
> 
> But the problem that we face is that when a process crashes on active
> VM, the LKSCTP stack immediately sends SCTP abort to the peers for all

"... when a *process* crashes..."
Have you considered redesigning your application so that 1 process
handles 1 association?
May not be the optimal solution, but then such crashes won't bring
all other assocs down too.

> associations before the system goes down completely. This creates
> confusion with the peers. Is there any way to avoid sending SCTP abort
> message in this scenario? If yes, please let us know how to do the
> same? If it needs LKSCTP kernel code change, please give pointers on
> what and where to change.
> 
> 
> 
> P.S: We tried to block the abort messages by dynamically using
> IPtables through signal handler (for signal 11 and 6). But this did
> not work.
> 
> 
> 
> A quick response will be highly appreciated.
> 
> 
> 
> Thanks,
> 
> Ashok
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
