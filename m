From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 18 Feb 2014 10:48:28 +0000
Subject: Re: [PATCH lksctp-tools] Remove dependency to implementation-specific a_rwnd behavior
Message-Id: <53033A7C.1060703@redhat.com>
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
...
> This change was done in course of '[PATCH v2] net: sctp: Fix a_rwnd/rwnd
> management to reflect real state of the receiver's buffer', as with this patch
> behavior is changed from described to rwnd reflecting real buffer state.
>
> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>

Applied.
