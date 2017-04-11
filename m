From: Deepak Khandelwal <dazz.87@gmail.com>
Date: Tue, 11 Apr 2017 19:20:05 +0000
Subject: SCTP getting EAGAIN but poll or select return socket is writable
Message-Id: <CAOci8dK9TZMY4Vty9PL5CHZdzaN_wVRq_==qrnAfAwJ-qSqBbg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
In-Reply-To: <45198365-50CE-456C-8F4A-8BDA672B97F7@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I am using 4.4.x kernel.

in context of LKSCTP, what could be the possible reasons that poll or
select on fd return false positive events, causing application do
write on fd but failed with EAGAIN ?


Best Regards,
Deepak
