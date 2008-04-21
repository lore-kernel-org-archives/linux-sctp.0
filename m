From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Apr 2008 19:41:33 +0000
Subject: Re: [Lksctp-developers] Is this a possible race condition.
Message-Id: <480CEDED.3080608@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <480CB247.1090902@hp.com>
In-Reply-To: <480CB247.1090902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Neil Horman wrote:
>>
> I believe you.  I completely agree with your observation that there is a small
> window during which our two accounting values are mismatches, and as a result we
> might call schedule_timeout without actually having to.  My assertion (which may
> well be wrong) is that the way the waitqueue api is constructed makes that
> irrelevant (or at least it should).
> 
>> The only difference between the 2 is that second accounting done by
>> sctp_packet_transmit().  It changes sk_wmem_alloc, but not assoc.sndbuf_used.
>> Thus in one case, there is an extra change against the send buffer that
>> causes us to exceed it temporarily and thus get scheduled out.  Since we
>> never wake up, I am now starting to think that the wake-up code is
>> called while the application is still running.  So the race is between
>> a wake-up and a call to schedule_timeout.
>>
> Yes, I think this is exactly what you described above, that we enter
> sctp_wait_for_sndbuf because we detect that we are out of sendbuffer space, and
> that this happens in parallel with a call to sctp_write_space, and its use of
> wake_up[_interruptible].  My assertion is that that should be, generally
> speaking, ok.  The pthread library has a very simmilar problem in userspace,
> in which they do in fact use a mutex to protect against this exact race (see
> pthread_cond_wait and pthread_cond_signal).  The kernel however, has no
> mechanism to atomically manipulate a spinlock or mutex, and remove oneself from
> the scheduling queue).  So in the kernel we use queues.  My assertion (or
> perhaps assumption), is that prepare_to_wait_exclusive (which is called from
> sctp_wait_for_sndbuf) adds the task in question to the wait queue, and sets its
> state to TASK_UNITERRUPTIBLE, or some other 'sleeping' state.  At this point the
> wait mechanism is 'armed' for lack of a better term.  Even if the call to
> wake_up happens between this point and the call to schedule[_timeout], all that
> will (or should) happen is that you will be removed from the wait_queue that it
> was added to, its task state will be reset to TASK_RUNNING, and it will be
> rescheduled, without needing to wait for the timeout.  Thats why the call to
> prepare_to_wait_exclusive is made in sctp_wait_for_sndbuf prior to us checking
> association state, write space, etc.  Its safe to do there because, even if any
> of those data values are changed right after we read them, the schedule_timeout
> will effectively just fall through, and we'll break out of the loop on the next
> iteration.  Thats why I suggested that you experiment with setting the sndtimeo
> to a low value, that would break you out of the loop, and confirm thats where
> you're deadlocking, and why.

Will try it.

> 
> So In summary, I'm saying that I completely agree with you that the way we
> charge our skbs in the transmit path can lead to us calling wake_up on a given
> associations wait_queue.  I just don't think that doing so is a problem, because
> of the way the kernels wait_queues guard against the possiblility of a given
> task scheduling itself away forever.  Please take a look and correct me if I'm
> wrong, but thats how I read the wake up code.

Ok,  here is a possible race:

CPU1                                                CPU2
prepare_to_wait_exclusive()
    wait->flags |= WQ_FLAG_EXCLUSIVE;
    spin_lock_irqsave(&q->lock, flags);
    if (list_empty(&wait->task_list))
        __add_wait_queue_tail(q, wait);
	 					   __sctp_write_space()
                                                        waitqueue_active()
                                                        wake_up_interruptible();

    set_current_state().
                                                   

This one should be possible.  The waitqueue_active() checks the 'q' list without
a lock.  So, it's possible for it to succeed and attempt wake-up before the process
state has changed.

> 
> That all being said, I wonder if we're not seeing a race in which the return
> value of sctp_wspace toggles to a value that might cause a wake_up, and then
> back to a value that causes a subsequent sleep.  You mentioned that your test
> application runs on each interface of the system.  Is it multithreaded, or does
> it form multiple processes and share a socket by any chance?  What if the
> following were to happen:

There is no socket sharing.  It's a stand alone app that just gets run multiple times.

-vlad
