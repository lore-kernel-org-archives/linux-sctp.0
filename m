From: Max Matveev <makc@redhat.com>
Date: Thu, 09 Jun 2011 04:27:37 +0000
Subject: Re: Problem code multi-streaming
Message-Id: <19952.19385.729252.681401@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DF0396D.50401@gmail.com>
In-Reply-To: <4DF0396D.50401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Thu, 09 Jun 2011 10:09:33 +0700, Nguyễn Phước Thành wrote:

 ht22.pt> I have some code demo using multi-streaming, but it is not run right.I 
 ht22.pt> attach my code send file in this mail. I using this code from sctp_test, 
 ht22.pt> but i don't know why it error.

 ht22.pt> I use sinfo->sinfo_stream = 1; and when send one chunk I change stream :

 ht22.pt>   if(stream=1) stream=2;
 ht22.pt>   if(stream=2)  stream=1;

 ht22.pt> But capture packet with Wireshark I see SID is always 1, I send packet 
 ht22.pt> is order, using multi-homing.

You also ignore return code from sendmsg in your send loop - it could
give you a clue about possible problems. For example, did you set the
correct number of outgoing streams? Keep in mind that 2 means 2
streams: 0 and 1, not stream 1 and 2.

max

