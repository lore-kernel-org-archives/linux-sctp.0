From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 09 Nov 2015 17:07:17 +0000
Subject: Re: About SCTP restart?
Message-Id: <5640D2C5.5030705@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <07B7943445653648AD9B4DBB916BB48F04FB3DC4@cnshjmbx01>
In-Reply-To: <07B7943445653648AD9B4DBB916BB48F04FB3DC4@cnshjmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Em 09-11-2015 00:17, YUAN Jia escreveu:
> Indeed, RFC4960 has been already supported. I was misled.

Okay.
Please don't top post. It makes reading the emails harder.

> Another question:
> I am making a suite of SCTP testing tools. The paragraph 5.2.4.1 of RFC 4960 describes an example of an association restart. But I don't know how to trig or simulate a procedure of endpoints' restart. I find there are only functions to handle restart initiated by peer, but I've not found functions to initiate restart from local. Does lksctp lib have APIs or functions to initiate a restart? Or some of code fractions in kernel can do so?
>
> Handling restart initiated by peer:
> sctp_do_sm
> 	=> sctp_sf_do_5_2_4_dupcook
> 		=> sctp_sf_do_dupcook_a	// Section 5.2.4, case 'A'

This is used to handle an error situation on which the peer was 
restarted, and not as a normal procedure. Please don't confuse it with 
stream reset. That said, I'm not aware of any mechanism in lksctp to 
trigger this willingly, but you may do it in your application. You can 
do it by:

1.bind your client socket to a known local port before connecting to the 
server
2.connect to remote server
3.add a firewall rule on client blocking outputs to that server (port)
4.kill your client application
(4.b.ensure association is really down)
5.remove firewall rule
6.restart your application (which should bind to the same local port)

The firewall rule will block the shutdown/abort from client to server 
when you close/kill your client app, thus simulating a crash from the 
server point of view.

Btw, you may want to take a look on TAHI then. It already supports quite 
some SCTP tests. http://networktest.sourceforge.net/ maybe you can help 
us improve it? :-)

Regards,
Marcelo

