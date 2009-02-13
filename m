From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Feb 2009 18:33:40 +0000
Subject: [PATCH net-next 0/4] sctp: Updates and fixes
Message-Id: <1234550024-30915-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
In-Reply-To: <>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Hi David

Here are some updates and fixes for SCTP:
    - Allow disabling of checksum with a module parameter.
    - Cleanup the sctp checksum code to get rid of excessive casts
    - Fix the exponention RTO update with Heartbeats.
    - Preserve socket level options on accept/peeloff.

Thanks
-vlad
