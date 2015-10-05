From: David Miller <davem@davemloft.net>
Date: Mon, 05 Oct 2015 10:17:04 +0000
Subject: Re: [PATCH 00/12] net: assorted y2038 changes
Message-Id: <20151005.031704.767722033063704258.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1443612402-3000775-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: arnd-r2nGTMty4D4@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-atm-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-can-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 30 Sep 2015 13:26:30 +0200

> This is a set of changes for network drivers and core code to
> get rid of the use of time_t and derived data structures.

Applied patches #1-#10 to net-next, using the updated v2 version of
the zatm change.
