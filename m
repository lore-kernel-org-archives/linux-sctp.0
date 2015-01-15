From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 15 Jan 2015 17:02:14 +0000
Subject: Re: [PATCH] also expect EACCES when accept on an established socket
Message-Id: <54B7F296.6020401@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1421307575-28655-1-git-send-email-xu.simon@oracle.com>
In-Reply-To: <1421307575-28655-1-git-send-email-xu.simon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/15/2015 08:39 AM, Simon Xu wrote:
> When SELinux is set to enforcing, errno may be EACCES when accept
> on an established socket.
>
> Signed-off-by: Simon Xu <xu.simon@oracle.com>

Yep, that's due to a still missing SELinux support, thus it
interprets SCTP as raw sockets.

Applied to lksctp-tools, thanks Simon!
