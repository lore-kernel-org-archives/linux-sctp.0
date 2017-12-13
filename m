From: Ashok Kumar <svashok79@gmail.com>
Date: Wed, 13 Dec 2017 04:50:57 +0000
Subject: Re: How to restrict SCTP abort during a process crash
Message-Id: <CAOTBYLac+x17HunUWhZ8tu=W99uySm8=yzAM1-tDQKB2dv1V0A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
In-Reply-To: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks Neil for the suggestion. Yes, it sounds to be a bad hack, but
we will give it a try. Meanwhile, if you can think of some other
solution please let me know.

Thanks,
Ashok

On Wed, Dec 13, 2017 at 12:02 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Dec 12, 2017 at 10:21:31PM +0530, Ashok Kumar wrote:
>> Hi,
>>
>>
>>
>> We are using LKSCTP in our LTE product (HeNBGW). We have
>> high-availability support also in our product. In case of any failure
>> on active VM, standby VM will take over active role and all the SCTP
>> associations will be moved to that new active VM. The associations
>> should be moved transparent to the peers (a kind of SCTP reset before
>> SCTP heartbeat expires on the peer nodes).
>>
>>
>>
>> But the problem that we face is that when a process crashes on active
>> VM, the LKSCTP stack immediately sends SCTP abort to the peers for all
>> associations before the system goes down completely. This creates
>> confusion with the peers. Is there any way to avoid sending SCTP abort
>> message in this scenario? If yes, please let us know how to do the
>> same? If it needs LKSCTP kernel code change, please give pointers on
>> what and where to change.
>>
>>
>>
>> P.S: We tried to block the abort messages by dynamically using
>> IPtables through signal handler (for signal 11 and 6). But this did
>> not work.
>>
>>
>>
>> A quick response will be highly appreciated.
>>
> You're not going to be able to reliably block ABORTS, or any packet only on a
> crash condition, just because the stack has points that operates asynchronously
> to the process.
>
> About the closest thing that I could think of would be to write a custom
> iptables rule to match on ABORT packets and send them to the NFQUEUE target.
> Write a userspace handler process for queue targeted packets which in turn just
> holds the abort packet for at least one cluster live heartbeat time (I'm
> assuming here that, being a clustered system it has some sort of liveness
> check).  Doing this hold may allow the cluster to shift to the new vm in a
> failure situation before your queue handler process releases any abort packets
> that it has, while in the event there is no failover, it will just release the
> abort a little late.
>
> I can't really recommend that approach mind you (its a horrid hack, and will
> likely cause other protocol issues), but its all I can think of at the moment.
>
> Regards
> Neil
>
>>
>>
>> Thanks,
>>
>> Ashok
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
