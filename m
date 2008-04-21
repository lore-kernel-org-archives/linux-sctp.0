From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 21 Apr 2008 18:12:02 +0000
Subject: Re: [Lksctp-developers] Is this a possible race condition.
Message-Id: <20080421181202.GB7236@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <480CB247.1090902@hp.com>
In-Reply-To: <480CB247.1090902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Apr 21, 2008 at 11:27:03AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
>> On Thu, Apr 17, 2008 at 12:45:47PM -0400, Vlad Yasevich wrote:
>>> Hi All
>>>
>>> Background:
>>>
>>> During the course of some stress testing we found an interesting scenario 
>>> when
>>> setting the socket send buffer fairly low.
>>>
>>> The applications we use sets the send buffer low, and them performs a 
>>> bunch of
>>> short sends followed by a single receive.  The test runs for about 10-12 
>>> hours
>>> with the application run a tight loop on each interface of the system.
>>>
>>> Once in while this application ends up sitting in sendmsg().  Looking at 
>>> the kernel
>>> stack dumps (SysRq-T), the task in scheduled out sleeping in 
>>> sctp_wait_for_sndbuf().
>>> Looking at the memory consumption, everything is 0, i.e. all the skbs 
>>> have been freed
>>> and there is nothing on any queues.
>>>
>>> This got me thinking that maybe wake-ups aren't getting to the socket.  I 
>>> am working on
>>> instrumenting a module to verify this, but looking through the wake-up 
>>> logic, I think
>>> we have a interesting race.
>>>
>>> Race:
>>>
>>> We charge every DATA chunk twice against the socket memory accounting, 
>>> once in sctp_sendmsg()
>>> and once in sctp_packet_transmit() when we allocated the skb that will 
>>> hold all the bundled
>>> chunks.  Now, a very important note is that we only perform the second 
>>> charge against the
>>> sk_wmem_alloc, so for short span of time socket wmem accounting does not 
>>> match association
>>> wmem accounting.  This is a separate bug, but it shows that the behavior 
>>> described in the
>>> Background section does not occur when sendbuf_policy is changed.
>>>
>>> What I believe is happening is this.  The interface queue becomes full 
>>> and thus a packet
>>> that was charged during sctp_packet_transmit() is still sitting on this 
>>> queue, while the
>>> sendmsg() call completes successfully.  The actually draining of the 
>>> queue happens later
>>> and freeing up of the buffer happen when the interface is cleaning its tx 
>>> rings.  This
>>> can happen asynchronously from subsequent sendmsg() calls and also 
>>> without any locking.
>>>
>>> So, my supposition is that sock_rfree() and thus sctp_write_space() call
>>> happens without a lock and in parallel with another sendmsg() call.  It 
>>> appears that
>>> the race is between checking to see if the asoc->wait queue is active and 
>>> the activation
>>> of this wait queue by the sctp_wait_for_sndbuf().  Thus, if by some very 
>>> odd coincidence,
>>> this happens to the last message that the application sent, the 
>>> application we be scheduled
>>> away and never wake up because the wake up logic already ran.
>>>
>>> As you can see, the timing of this is very very narrow, and for us it 
>>> takes about 10-12 hours
>>> to reproduce.  The problem also happens on one or two interfaces out of 
>>> 13 that are on the
>>> systems and it's never the same interfaces every time.
>>>
>>> Did I miss anything?  I was using e1000 as an example of how and when the 
>>> transmitted skb is
>>> freed and thus above is based on that.
>>>
>>> -vlad
>>
>>
>> Vlad, I'm still digesting all this, and it seems reasonable to me, but I was
>> under the impression that the task waitqueue scheme was specifically written to
>> be race tolerant.  the prepare_to_wait_exclusive function enqueues the task to a
>> waitqueue prior to that task calling schedule or schedule_timeout.  It does this
>> specifically so that, in the event that a wakeup occurs prior to the schedule
>> call, the task is immediately returned to the run queue, specifically so that
>> this sort of race doesn't occur.
>>
>> Of course, I could be missing something, like I said, I'm still digesting this.
>> Either way, it should be easy to test.  If you set your socket timeout for your
>> test app to be small (something like 10 seconds), instead of the default
>> unlmited timeout, you should be able to avoid this lockup, if the above
>> reasoning is correct.
>>
>> I'll provide more feedback as I continue to go through this.
>
> Hey Neil
>
> We just ran a 90 hour test with sndbuf_policy = 1 and it passed :).
>
I believe you.  I completely agree with your observation that there is a small
window during which our two accounting values are mismatches, and as a result we
might call schedule_timeout without actually having to.  My assertion (which may
well be wrong) is that the way the waitqueue api is constructed makes that
irrelevant (or at least it should).

> The only difference between the 2 is that second accounting done by
> sctp_packet_transmit().  It changes sk_wmem_alloc, but not assoc.sndbuf_used.
> Thus in one case, there is an extra change against the send buffer that
> causes us to exceed it temporarily and thus get scheduled out.  Since we
> never wake up, I am now starting to think that the wake-up code is
> called while the application is still running.  So the race is between
> a wake-up and a call to schedule_timeout.
>
Yes, I think this is exactly what you described above, that we enter
sctp_wait_for_sndbuf because we detect that we are out of sendbuffer space, and
that this happens in parallel with a call to sctp_write_space, and its use of
wake_up[_interruptible].  My assertion is that that should be, generally
speaking, ok.  The pthread library has a very simmilar problem in userspace,
in which they do in fact use a mutex to protect against this exact race (see
pthread_cond_wait and pthread_cond_signal).  The kernel however, has no
mechanism to atomically manipulate a spinlock or mutex, and remove oneself from
the scheduling queue).  So in the kernel we use queues.  My assertion (or
perhaps assumption), is that prepare_to_wait_exclusive (which is called from
sctp_wait_for_sndbuf) adds the task in question to the wait queue, and sets its
state to TASK_UNITERRUPTIBLE, or some other 'sleeping' state.  At this point the
wait mechanism is 'armed' for lack of a better term.  Even if the call to
wake_up happens between this point and the call to schedule[_timeout], all that
will (or should) happen is that you will be removed from the wait_queue that it
was added to, its task state will be reset to TASK_RUNNING, and it will be
rescheduled, without needing to wait for the timeout.  Thats why the call to
prepare_to_wait_exclusive is made in sctp_wait_for_sndbuf prior to us checking
association state, write space, etc.  Its safe to do there because, even if any
of those data values are changed right after we read them, the schedule_timeout
will effectively just fall through, and we'll break out of the loop on the next
iteration.  Thats why I suggested that you experiment with setting the sndtimeo
to a low value, that would break you out of the loop, and confirm thats where
you're deadlocking, and why.

So In summary, I'm saying that I completely agree with you that the way we
charge our skbs in the transmit path can lead to us calling wake_up on a given
associations wait_queue.  I just don't think that doing so is a problem, because
of the way the kernels wait_queues guard against the possiblility of a given
task scheduling itself away forever.  Please take a look and correct me if I'm
wrong, but thats how I read the wake up code.

That all being said, I wonder if we're not seeing a race in which the return
value of sctp_wspace toggles to a value that might cause a wake_up, and then
back to a value that causes a subsequent sleep.  You mentioned that your test
application runs on each interface of the system.  Is it multithreaded, or does
it form multiple processes and share a socket by any chance?  What if the
following were to happen:

1) process A and process B share socket 1
2) process A and B start sending sctp packets over socket 1
3) process A sends a packet, and while in sctp_sendmsg, discovers that its out
of send buffer space, it calls sctp_wait_for_sndbuf
4) process A adds itself to the wait queue, check to make sure that no extra
space has been returned, and winds up going to sleep.
5) A packet gets sent of the transmit queue and is reclaimed.  sctp_write_space
is called and updates the buffer accounting, and then wakes up process A.  The
packet transmit queue is now empty
6) process B tries to send a message over socket 1, get through sctp_sendmsg
before process A gets back on the cpu, and re-allocates the sndbuf space
7) process A loops back around, finds that the write space it thought it could
get was stolen back (by process B in (6)) and waits again.  But since the
transmit queue is empty, it will wait forever.  Or more precisely, until process
B transmits its chunk, and the corresponding data gets free.  If something else
is blocking process B, its deadlock.

Thats just pie in the sky though, adn makes lots of assumptions.

But, FWIW, my $0.02.  Feel free to poke holes in all of this.  I do think the
wait queue code is hardened against the scenario you are proposing though.

Thanks & Regards
Neil


> The reason this is not an issue for TCP is that TCP never drops the socket lock
> when going to sleep so the socket is still locked when the buffer cleanup
> happens.  That's not a case for SCTP.
>
> -vlad
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
