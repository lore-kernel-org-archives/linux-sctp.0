From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 23 Dec 2013 13:29:41 +0000
Subject: [PATCH v4 0/2] sctp: Consolidate and ratelimit deprecation warnings
Message-Id: <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

The SCTP protocol has several deprecation warnings in its setsockopt path that
can be triggered by unprivlidged users.  Since these are not ratelimited, we can
spam the logs quite easily here.  Since these are all deprecation warnings, and
that type of warning isn't uncommon in the rest of the kernel, lets make a
common pr_warn_deprecated macro to produce somewhat generalized ratelimited
deprecation warnings easily

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: David Miller <davem@davemloft.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org

---
Change notes

v2) Converted to use a pr_warn_deprecated macro
v3) Converted to use a DEPRECATED macro with regular pr_* macros
v4) CC netdev on all patches as per DaveM

