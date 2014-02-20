From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 20 Feb 2014 09:31:02 +0000
Subject: Re: bag in sctp_connectx
Message-Id: <5305CB56.3060105@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5305AFB1.3030208@switchray.com>
In-Reply-To: <5305AFB1.3030208@switchray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 02/20/2014 08:33 AM, Sergey Udalov wrote:
> Hi,
>
> I am using sctp_darn with "--connectx" option and when I try to send any =
data then I get the error:
> ""sctp_darn: error connecting to addrs: Invalid argument.
>    connectx failed."
>
> Could you please analyze and fix the problem?
>
> Version lksctp-tools: 1.0.16.
> Version OS: 3.11-2-amd64 #1 SMP Debian 3.11.10-1 (2013-12-04) x86_64 GNU/=
Linux.

So you have a 3.11 64bit kernel. Do you have a 32bit user space, or, at lea=
st
lksctp-tools compilation?

If so, then you need the following commit that is for 3.14 and stable:

  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=FFd5939381c609056b33b7585fb05a77b4c695f3

Cheers,

Daniel

> Thank you in advanced.
> Sergey Udalov
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
