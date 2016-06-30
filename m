From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 30 Jun 2016 19:18:12 +0000
Subject: sctp and tail loss recovery
Message-Id: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Michael,

Long story short, I'm chasing a performance issue on linux 
implementation and I think that TLR is the right fix for it. The receive 
operation is way more expensive than transmit and this causes its buffer 
to fill up, up to reach 0 window situation. Then, as the RFC allows, 
sender keeps sending 1 data chunk at a time, as a probe for possible 
unnoticed window updates due to SACK loss. But if the peer couldn't free 
any window in time, it will drop that chunk, and will cause a RTO.

I'm not seeing anything in the specs that would prevent this situation 
other than a TLR would do. Or I missed it?

On TLR, the most updated info I could find, is already (recently) 
expired and archived: 
https://datatracker.ietf.org/doc/draft-nielsen-tsvwg-sctp-tlr/
I could find Karen's email 
https://www.ietf.org/mail-archive/web/tsvwg/current/msg13703.html
But then nothing else. Do you know what happened?

Thanks,
Marcelo
