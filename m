From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 25 Oct 2013 10:03:22 +0000
Subject: Re: [PATCH ipvs 1/2] net: ipvs: sctp: add missing verdict assignments in sctp_conn_schedule
Message-Id: <526A41EA.1030403@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1af1d5e1aae9df91683625f0cb120b329e8d2f10.1382689350.git.dborkman@redhat.com>
In-Reply-To: <1af1d5e1aae9df91683625f0cb120b329e8d2f10.1382689350.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/25/2013 11:55 AM, Simon Horman wrote:
> On Fri, Oct 25, 2013 at 11:39:02AM +0200, Jesper Dangaard Brouer wrote:
>> On Fri, 25 Oct 2013 11:05:04 +0200
>> Daniel Borkmann <dborkman@redhat.com> wrote:
>>
>>> If skb_header_pointer() fails, we need to assign a verdict, that is
>>> NF_DROP in this case, otherwise, we would leave the verdict from
>>> conn_schedule() uninitialized when returning.
>>>
>>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>>> ---
>>
>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>
>> It looks like a good ide, and resembles how we handle these situations
>> else were in the IPVS code (e.g. for TCP and UDP).
>
> Likeiwse.
>
> I am wondering if this resolves a but and if so how severe it is.

Probably with malformed SCTP INIT packets, but haven't tried so far.
Just found it during code review.
