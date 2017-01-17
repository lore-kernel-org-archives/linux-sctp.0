From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 17 Jan 2017 18:13:31 +0000
Subject: Re: Issue with handling too long FORWARD-TSN-SUPPORTED parameter in INIT chunk
Message-Id: <CADvbK_cooX4aJ83zrphc49VFew+VAwfEsSNxt+WJ-5CCWvx5Cw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117131137.GE6494@aomx-netbook>
In-Reply-To: <20170117131137.GE6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jan 17, 2017 at 9:11 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
> An INIT-chunk with a FORWARD-TSN-SUPPORTED parameter having a length of
> 8 bytes is accepted by the linux kernel.
> According to the definition in https://tools.ietf.org/html/rfc3758#page-5
> the length of this parameter has to be 4 bytes long, so the
> implementation should ideally react with an ABORT.
>
> Testscript available at:
> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/error-cases/init-with-forward-tsn-too-long.pkt

To react with an ABORT seems not RFC demands, no clear description for
that actually.
In sctp_verify_param(), sctp does send the necessary ABORT for the
other abnormal params that RFC demands.
