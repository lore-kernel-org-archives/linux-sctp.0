From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 22 Feb 2020 10:55:32 +0000
Subject: Re: Possible SCTP bug in kernel 4.9.199 and later
Message-Id: <CADvbK_c85MCYmT08MxjszFHA-jxqKsFGsWjDdMkGFH9zDr+8bA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <etPan.5e4f0735.2451de02.6626@csiro.au>
In-Reply-To: <etPan.5e4f0735.2451de02.6626@csiro.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Fri, Feb 21, 2020 at 6:25 AM Craig, Daniel (CASS, Marsfield)
<Daniel.Craig@csiro.au> wrote:
>
> Hi,
>
> (Resending in plain HTTP mail)
>
> We’ve hit what seems to be a bug in a patch to SCTP in the 4.9 longterm kernel. We are using clvm as a key part of a dual-node high availability setup. Clvm uses DLM, which in our config (via corosync) uses SCTP as its underlying protocol.
>
> Since debian kernel 4.9.0-12-amd64 (based on 4.9.210) we have a problem where clvm fails to start (it times out) on cluster startup because DLM appears to fail to connect, in the process spamming the kernel log with messages like this:
>
> Feb 20 13:05:18 hatest00 kernel: [  283.197399] dlm: connecting to 168821374
> Feb 20 13:05:18 hatest00 kernel: [  283.197422] dlm: connecting to 168821374
> Feb 20 13:05:18 hatest00 kernel: [  283.197443] dlm: connecting to 168821374
> Feb 20 13:05:18 hatest00 kernel: [  283.197464] dlm: connecting to 168821374
>
> and on the other node:
>
> Feb 20 13:05:18 hatest01 kernel: [  279.140513] dlm: connecting to 168821373
> Feb 20 13:05:18 hatest01 kernel: [  279.140741] dlm: connecting to 168821373
> Feb 20 13:05:18 hatest01 kernel: [  279.140978] dlm: connecting to 168821373
> Feb 20 13:05:18 hatest01 kernel: [  279.141209] dlm: connecting to 168821373
>
> This has the ultimate effect of causing the HA cluster to be unusable, because without clvm we have no access to the cluster’s shared storage.
>
> The previously working debian kernel package 4.9.0-11-amd64 is based on kernel version 4.9.197. I’ve verified that this behaviour exists in the vanilla kernel in addition to the debian kernel. I’ve also verified that it still occurs on the latest vanilla kernel in the branch - currently 4.9.214.
>
> Our initial attempts to debug the problem involved reverting all DLM patches made between 4.9.198 and 4.9.210, this had no impact. We then looked at SCTP and were able to verify the problem was introduced in 4.9.199. Reverting both patches (individually) to SCTP in this series seems to point to the following commit as being the problematic one:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.9.y&id=f8b141077a9a8fd2a7f6bae447a710a6d224b44e
>
> Please let me know if you need any more information or you’d like me to run any tests.
Please backport this commit:

commit da3627c30d229fea1e070e984366f80a1c4d9166
Author: Gang He <ghe@suse.com>
Date:   Tue May 29 11:09:22 2018 +0800

    dlm: remove O_NONBLOCK flag in sctp_connect_to_sock
