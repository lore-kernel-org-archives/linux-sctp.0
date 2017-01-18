From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 18 Jan 2017 04:38:42 +0000
Subject: Re: Issue with handling too long FORWARD-TSN-SUPPORTED parameter in INIT chunk
Message-Id: <CADvbK_fB1-rQ91U_uN6SaeOkMBDpX=r9iqXztr+Tg6PU3j6jOA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117131137.GE6494@aomx-netbook>
In-Reply-To: <20170117131137.GE6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Wed, Jan 18, 2017 at 4:03 AM, Julian Cordes <julian.cordes@gmail.com> wr=
ote:
> 2017-01-17 19:13 GMT+01:00 Xin Long <lucien.xin@gmail.com>:
>> On Tue, Jan 17, 2017 at 9:11 PM, Julian Cordes <julian.cordes@gmail.com>=
 wrote:
>>> An INIT-chunk with a FORWARD-TSN-SUPPORTED parameter having a length of
>>> 8 bytes is accepted by the linux kernel.
>>> According to the definition in https://tools.ietf.org/html/rfc3758#page=
-5
>>> the length of this parameter has to be 4 bytes long, so the
>>> implementation should ideally react with an ABORT.
>>>
>>> Testscript available at:
>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/erro=
r-cases/init-with-forward-tsn-too-long.pkt
>>
>> To react with an ABORT seems not RFC demands, no clear description for
>> that actually.
>> In sctp_verify_param(), sctp does send the necessary ABORT for the
>> other abnormal params that RFC demands.
>
> You are right,
> these situations are not specified clearly in the RFC. I have talked
> about this with Michael T=C3=BCxen before, he has suggested that the
> implementation should either silently discard the INIT-Chunk or send
> an ABORT-Chunk. The linux implementation accepts at the moment this
> invalid INIT-Chunk and replies with an INIT-ACK-Chunk. I am not sure
> if this is wanted behaviour?
It maybe just forget to check it, will think about it, and I need to check =
if
other params' processing also has the similar issue.
Thanks.
