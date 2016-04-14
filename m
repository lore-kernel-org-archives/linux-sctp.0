From: Phil Sutter <phil@nwl.cc>
Date: Thu, 14 Apr 2016 09:13:18 +0000
Subject: Re: [PATCHv3 net-next 1/6] sctp: add sctp_info dump api for sctp_diag
Message-Id: <20160414091318.GC3715@orbyte.nwl.cc>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460618169.git.lucien.xin@gmail.com>
 <cd6bf9c2696f125a74491e1f82b77a30bb1005dd.1460618169.git.lucien.xin@gmail.com>
In-Reply-To: <cd6bf9c2696f125a74491e1f82b77a30bb1005dd.1460618169.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net, eric.dumazet@gmail.com

Hi Xin Long,

On Thu, Apr 14, 2016 at 03:35:30PM +0800, Xin Long wrote:
> sctp_diag will dump some important details of sctp's assoc or ep, we use
> sctp_info to describe them,  sctp_get_sctp_info to get them, and export
> it to sctp_diag.ko.
> 
> v2->v3:
> - we will not use list_for_each_safe in sctp_get_sctp_info, cause
>   all the callers of it will use lock_sock.
> 
> - fix the holes in struct sctp_info with __reserved* field.
>   because sctp_diag is a new feature, and sctp_info is just for now,
>   it may be changed in the future.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

You're mixing commit message and changelog here (and in the following
patches, too). In order to not make the changelog part of the commit
message, you should separate it with three dashes, just like
git-format-patch does with the diff stat. So please reformat the patches
to meet this pattern:

------------------8<--------------------
Commit message here

Signed-off-by
---
Changelog here
---
diff stat added by Git

diff --git a/foo/bar.c b/foo/bar.c
...
------------------8<--------------------

If you think some of the changelog's info should be preserved, better
integrate it into the message itself.

Cheers, Phil
