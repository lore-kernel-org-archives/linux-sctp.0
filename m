From: Dan Carpenter <error27@gmail.com>
Date: Mon, 06 Sep 2010 19:59:06 +0000
Subject: stack trace from sctp_getsockopt_local_addrs()
Message-Id: <20100906195905.GA7423@bicker>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

In sctp_getsockopt_local_addrs() we can potentially try allocate too
much memory depending on what the user passes to us as "len".

net/sctp/socket.c
  4489          to = optval + offsetof(struct sctp_getaddrs,addrs);
  4490          space_left = len - offsetof(struct sctp_getaddrs,addrs);
  4491  
  4492          addrs = kmalloc(space_left, GFP_KERNEL);
  4493          if (!addrs)
  4494                  return -ENOMEM;
  4495

It's harmless.  "space_left" is never zero and we handle memory
allocation failures correctly but it's still a little messy and can lead
to a stack trace.  It's a WARN_ONCE() so it's not a huge deal.

Sep  6 20:57:07 bicker kernel: [84533.160286] ------------[ cut here ]------------
Sep  6 20:57:07 bicker kernel: [84533.160304] WARNING: at mm/page_alloc.c:1971 __alloc_pages_nodemask+0x153/0x4ed()
Sep  6 20:57:07 bicker kernel: [84533.160311] Hardware name: 900HA
Sep  6 20:57:07 bicker kernel: [84533.160315] Modules linked in: ufs ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt pp
p_generic slhc sctp crc32c libcrc32c option usb_wwan usbserial ath5k atl1e ath
Sep  6 20:57:07 bicker kernel: [84533.160359] Pid: 8949, comm: a.out Not tainted 2.6.36-rc3+ #39
Sep  6 20:57:07 bicker kernel: [84533.160365] Call Trace:
Sep  6 20:57:07 bicker kernel: [84533.160380]  [<c103019e>] warn_slowpath_common+0x60/0x75
Sep  6 20:57:07 bicker kernel: [84533.160391]  [<c10301c2>] warn_slowpath_null+0xf/0x13
Sep  6 20:57:07 bicker kernel: [84533.160402]  [<c10914ff>] __alloc_pages_nodemask+0x153/0x4ed
Sep  6 20:57:07 bicker kernel: [84533.160414]  [<c10307de>] ? release_console_sem+0x177/0x1a4
Sep  6 20:57:07 bicker kernel: [84533.160428]  [<c10918a8>] __get_free_pages+0xf/0x21
Sep  6 20:57:07 bicker kernel: [84533.160440]  [<c10b1625>] __kmalloc+0x2f/0xf9
Sep  6 20:57:07 bicker kernel: [84533.160473]  [<f83964bc>] sctp_getsockopt+0x99d/0x16b5 [sctp]

This could happen if you called
 	getsockopt(sd, SOL_SCTP, SCTP_GET_LOCAL_ADDRS, getaddrs, &len);
without initializing "len".

regards,
dan carpenter

