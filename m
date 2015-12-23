From: Roger Nyberg <r216837@bahnhof.se>
Date: Wed, 23 Dec 2015 07:13:31 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <567A499B.6020901@bahnhof.se>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi,

Is this fault corrected?
“Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer”
http://www.spinics.net/lists/linux-sctp/msg03323.html

I can’t from the mail list find out if it is corrected in the “Revert 
"net: sctp: Fix a_rwnd/rwnd management to reflect real state of the 
receiver's buffer"” correction, or if it remains unfixed.
If unfixed, is there any plan or work ongoing for a correction?

I have a customer case where my SCTP connection get stuck for ever with 
a_rwnd returning 0 size.

Best regards
Roger Nyberg


---
Detta e-postmeddelande har sökts igenom efter virus med antivirusprogram från Avast.
https://www.avast.com/antivirus

