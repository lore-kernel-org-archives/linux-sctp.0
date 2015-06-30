From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Tue, 30 Jun 2015 16:56:50 +0000
Subject: Clean up messages for a particular stream
Message-Id: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

 Hello everyone,

We currently encounter an issue where we re-use the streams in a SCTP
connection. However, data from different message contexts may co-exist
in the send/recv buffers for that reused stream. I'm wondering if
there is any special API that allow us to flush the data for just one
particular stream in a SCTP connection just before we reuse it, or we
have to do this from application?

I've been searching but were unable to find a good answer yet. Your
advices would be greatly appreciated!

Regards,
Jerry
