From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 17 Feb 2014 13:22:45 +0000
Subject: Re: [PATCH lksctp-tools] Remove dependency to implementation-specific a_rwnd behavior
Message-Id: <53020D25.6020209@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52F72A2F.2070705@nsn.com>
In-Reply-To: <52F72A2F.2070705@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/09/2014 08:11 AM, Matija Glavinic Pecotic wrote:
> test_timetolive and test_sctp_sendrecvmsq take advantage of the following lksctp
> characteristic:
>
>   - SO_RECVBUF being set prior association is established will control initially
>     advertised rwnd
>   - Modifying SO_RECVBUF later will keep maximum rwnd at the initial value which
>     is defined at the association startup
>
> Test cases use this fact in order to initially advertise small rwnd, increase
> buffer later, but keeping the initial rwnd as maximum one. However, we may at
> later time increase buffer, and implementation may advertise this to the
> partner. RFC4960 only forbids decrease of the buffer space:
>
>     Advertised Receiver Window Credit (a_rwnd): 32 bits (unsigned
>     integer)
>
>        This value represents the dedicated buffer space, in number of
>        bytes, the sender of the INIT has reserved in association with
>        this window.  During the life of the association, this buffer
>        space SHOULD NOT be lessened (i.e., dedicated buffers taken away
>        from this association); however, an endpoint MAY change the value
>        of a_rwnd it sends in SACK chunks.
>
> Having in mind that rwnd reflects free space in receiver's buffer,
> implementation may advertise new value, and therefore test case should not
> rely on above defined behavior. There is no impact on functional behavior of
> test cases due to this change.
>
> This change was done in course of '[PATCH v2] net: sctp: Fix a_rwnd/rwnd
> management to reflect real state of the receiver's buffer', as with this patch
> behavior is changed from described to rwnd reflecting real buffer state.

Before applying this, does that break user space? I had a test run of
test_timetolive of the latest net tree and without this patch here,
test_timetolive is stuck forever; with this patch, it works again.
Before your kernel change, the test suite passed.

So you're saying that the test case is simply implemented wrong by
"violating" the RFC in the fact that it keeps/resets the old small
init rwnd along. Hence, these hunks should be removed as it "SHOULD
NOT" be lessened.

> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
