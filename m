From: Luci Stanescu <luci@cnix.ro>
Date: Wed, 24 Jul 2019 13:46:09 +0000
Subject: SCTP recvmsg MSG_TRUNC or something similar
Message-Id: <D588EC18-6A7B-4D2B-AB0A-2961A247DC3B@cnix.ro>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi,

I’m not sure this is the right place to ask this kind of question, but, having not found a better forum, I’m trying my luck. Apologies in advance if this is outside the scope of the mailing list.

That being said, my question is: given a successful return of recvmsg() for a SOCK_SEQPACKET SCTP socket, is there no stateless way to determine if the read data, for which the MSG_EOR flag is set, is the trailing “fragment” of a larger record (either due to partial delivery or an insufficient buffer passed to a prior call to recvmsg() which returned with the MSG_EOR flag cleared), rather than a “full” message?

From what I can tell, MSG_TRUNC, which would’ve solved my issue, isn’t implemented for SCTP. Regarding this topic, I’ve only found old discussions, including some suggestions to add SOCK_RDM, which never materialised.

Many thanks for your time!

Luci
