From: malc <mlashley@gmail.com>
Date: Fri, 15 Jan 2016 09:22:56 +0000
Subject: Re: how can I remove Adaptation Layer Indication parameter in INIT_ACK?
Message-Id: <CAPkQJpTjERMGWTM0cUNJnbNcob4xpk5xFCWJLKyO159ASda2KQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <BN3PR1201MB09327E89F594EB408BE798AE8BCD0@BN3PR1201MB0932.namprd12.prod.outlook.com>
In-Reply-To: <BN3PR1201MB09327E89F594EB408BE798AE8BCD0@BN3PR1201MB0932.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Are you using a particularly old kernel? This was patched years ago to
only include ALI in INIT{_ACK} if the user has specified a valid (i.e.
non-zero) application code-point.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?idoc791ee631728b2beddda87560f1af59e32230e

Cheers,
malc.

On Fri, Jan 15, 2016 at 7:42 AM, Wenzhuo Zhan <wenzhuo.zhan@mitel.com> wrote:
> Hi,
>
> This address of linux-sctp@vger.kernel.org
> can not  be sent successfully anyway.
>
> BR!
>
> -----Original Message-----
> From: lksctp-developers-owner@lists.sourceforge.net [mailto:lksctp-developers-owner@lists.sourceforge.net]
> Sent: 2016年1月13日 19:49
> To: Wenzhuo Zhan
> Subject: how can I remove Adaptation Layer Indication parameter in INIT_ACK?
>
> Please use linux-sctp@vger.kernel.org for posting SCTP questions.
>
> ________________________________
> NOTE: This e-mail (including any attachments) is for the sole use of the intended recipient(s) and may contain information that is confidential and/or protected by legal privilege. Any unauthorized review, use, copy, disclosure or distribution of this e-mail is strictly prohibited. If you are not the intended recipient, please notify Mitel immediately and destroy all copies of this e-mail. Mitel does not accept any liability for breach of security, error or virus that may result from the transmission of this message.
