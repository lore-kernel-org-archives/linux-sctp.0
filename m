From: =?UTF-8?B?4KSF4KSo4KWB4KSc?= <anuj01@gmail.com>
Date: Thu, 23 Jun 2011 12:54:44 +0000
Subject: Error in inserting sctp.ko module
Message-Id: <BANLkTimCeAv8KYQBNeMywv_=wa-hVZJCbg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi list


I installed freshly CentOS release 5.6 (Final) with kernel version
2.6.18-238.el5 64-bit.

# uname -a
Linux localhost.localdomain 2.6.18-238.el5 #1 SMP Thu Jan 13 15:51:15
EST 2011 x86_64 x86_64 x86_64 GNU/Linux

But when I try to insert module sctp.ko using

# insmod sctp.ko

I got error

insmod: error inserting
'/lib/modules/2.6.18-238.el5/kernel/net/sctp/sctp.ko': -1 Address
family not supported by protocol


I also tried with modprobe. And I also checked Ipv6 module is already inserted.


Please help.


Thanks & Regards,
--
Anuj Aggarwal

 .''`.
: :Ⓐ :   # apt-get install hakuna-matata
`. `'`
   `-
