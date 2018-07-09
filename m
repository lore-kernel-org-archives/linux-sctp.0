From: Petr Malat <oss@malat.biz>
Date: Mon, 09 Jul 2018 15:37:58 +0000
Subject: Re: [PATCH net] sctp: Free connecting association if there is a pending signal
Message-Id: <20180709153757.GA9733@bordel.klfree.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180709101142.GA1820@bordel.klfree.net>
In-Reply-To: <20180709101142.GA1820@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 09, 2018 at 08:15:12AM -0400, Neil Horman wrote:
> You can't restart a connect() system call because there may be packets on the
> wire that are implementing the state transitions needed to establish the 
> connection you requested.  Theres no way for the local system to determine if
> that state transition has completed properly yet or not.  Terminating the 
> connection as you are doing here leads to significant traffic overhead for what
> might otherwise be in most cases a successfull connection.
This is questionable as the reason for sending the signal can be a request to
terminate the connection attempt.

> Thats why Linux deviates from the
> standard and return EINPROGRESS, and requires that you check the SO_ERROR value
> to determine if the connection is successfull (SO_ERROR = 0), or if its still
> pending (note in the connect man page that you can select/poll a in-progress
> socket for writeability to determine completion of the connection operation).
It's not a generic Linux problem as TCP doesn't suffer from this discrepancy, it
exists only in linux-sctp. Also, this behavior is not documented anywhere.

Current manual page in lksctp git explicitly says EINPROGRESS and EALREADY can
be returned on non-blocking sockets only:

EINPROGRESS
The socket is non-blocking and the connection cannot be completed immediately.

If you think this behavior is desired, then the manual page should be updated
and say that EINPROGRESS and EALREADY can be also returned on a blocking socket
if a signal was handled in the mean time.

> Sorry, but this doesn't seem like its actually fixing anything.
It's actually fixing several usecases:
 1) SOCK_STREAM application uses alarm() to set a connection timeout (use of 
    SO_SNDTIMEO is not portable) and expects the connection attempt to be 
    terminated after the alarm is delivered. This applies mainly on ported
    TCP programs.
    These applications expect EINTR in a case of timeout, not EINPROGRESS.
 2) SOCK_SEQPACKET application uses signals to implement different connect
    timeouts for different peers as usage of SO_SNDTIMEO is not thread safe.
 3) Developer or administrator attaches gdb/strace to a process blocked in
    connect(), the application aborts as it doesn't expect to get EINPROGRESS on 
    a blocking socket.

To sum it up, the current documention and code are not aligned and one of them needs
to be fixed.
BR,
  Petr

@Neil: Sorry for the double post, I forgot to include CC addresses.
