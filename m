From: Pedro Henrique <phamorimrezende@gmail.com>
Date: Sun, 15 Apr 2018 20:41:11 +0000
Subject: Doubt about data chunks
Message-Id: <CAMMnvdWFCUudguj+TJ9fjmhJ8M5MYROOfoZu5F5XRKvN-DC36A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear members,

I'm very new to SCTP and don't know if what I'm trying to do is really
possible without extending the lksctp. Basically, I created a
connection between two hosts (Client and Server) via the SCTP socket.
I'm able to successfully send sctp data from the server to the client.
Moreover, I also created multiple streams on the same connection. Now,
here is the issue. According to the SCTP documentation, many data
chunks can be sent inside the same packet. However, for my
experiments, I would like that only the data chunks belonging to the
same stream ID are encapsulated in the same packet. Or, in the worst
case, only one data chunk is encapsulated in each packet. Is any of
these two approaches possible without changing the lksctp code? If
not, could someone please help me on how to implement one of these
approaches in lksctp?

Thank you,
Regards,

-- 
Pedro Henrique Amorim Rezende
