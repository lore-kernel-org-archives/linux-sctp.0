From: sonia bhattacharya <soniaruby1@gmail.com>
Date: Tue, 04 Aug 2020 02:40:51 +0000
Subject: Re: Regarding kernel SCTP module compliance to 4960
Message-Id: <CAMyZL9o14WtFT5+MfS4qWOpzSHLiX21vSLn0795Z-_mi4hGLyQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAMyZL9pE+343HvMHuci=+2aKS4HrtuL2GJ2oVwxw7PfL7=doKQ@mail.gmail.com>
In-Reply-To: <CAMyZL9pE+343HvMHuci=+2aKS4HrtuL2GJ2oVwxw7PfL7=doKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Marcelo,

We are using Ubuntu 18.04 with the following kernel version.
esi14-vm-23u:~$ uname -r
5.0.0-23-generic

Just to confirm, the modinfo sctp shows the following:
esi14-vm-23u:~$ modinfo sctp
filename:       /lib/modules/5.0.0-23-generic/kernel/net/sctp/sctp.ko
license:        GPL
description:    Support for the SCTP protocol (RFC2960)
author:         Linux Kernel SCTP developers <linux-sctp@vger.kernel.org>
alias:          net-pf-10-proto-132
alias:          net-pf-2-proto-132
srcversion:     5CD1A15EE663D4E98EAC641
depends:        libcrc32c
retpoline:      Y
intree:         Y
name:           sctp
vermagic:       5.0.0-23-generic SMP mod_unload
signat:         PKCS#7
signer:
sig_key:
sig_hashalgo:   md4
parm:           no_checksums:Disable checksums computing and verification (bool)

Kindly confirm that this is compliant to 4960 already. If that is the
case, then it would be great if atleast the description in modinfo
shows 4960.


Regards,
Sonia


On Mon, Aug 3, 2020 at 11:12 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Aug 03, 2020 at 03:53:35PM +0530, sonia bhattacharya wrote:
> > Hi Team,
> >
> >
> >
> > Is there a plan to upgrade the linux SCTP kernel module to be
> > compliant to RFC 4960?
> >
> > Right now, it is compliant to RFC 2960.
> >
> >
> > description:    Support for the SCTP protocol (RFC2960)
>
> Hi Sonia,
>
> There are several references to old RFCs throughout the code, just
> because they weren't updated to the newer versions. But in regards to
> your question, Linux SCTP kernel code is compliant to RFC4960 already.
> If you notice anything particular missing, it's a bug. :-)
>
> Thanks,
> Marcelo
