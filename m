From: Kees Cook <keescook@chromium.org>
Date: Mon, 20 Aug 2018 05:31:44 +0000
Subject: Re: [LKP] ab9ee8e38b [ 22.890412] WARNING: CPU: 0 PID: 632 at mm/usercopy.c:81 usercopy_warn
Message-Id: <CAGXu5jLHq_i-w2Tc75hkzV1VMO45vGyxsP=+670PLTiGEG7Acg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180820005204.GB31827@shao2-debian>
In-Reply-To: <20180820005204.GB31827@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <rong.a.chen@intel.com>
Cc: David Windsor <dave@nullcore.net>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>

On Sun, Aug 19, 2018 at 5:52 PM, kernel test robot
<rong.a.chen@intel.com> wrote:
> [   22.855033] Bad or missing usercopy whitelist? Kernel memory overwrite attempt detected to SLUB object 'SCTP' (offset 1332, size 4)!

For this .config, pahole reports 1332 as the offset of the whitelist,
so I'm not sure what's happening here. It's as if no whitelist was
used when building the cache?

I'm still trying to build a reproducers...

-Kees

-- 
Kees Cook
Pixel Security
