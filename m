From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 05 Feb 2010 11:21:28 +0000
Subject: Re: [RFC Patch v2] net: reserve ports for applications using fixedport numbers
Message-Id: <201002052021.CIC81776.QVSMJOLtFOFFHO@I-love.SAKURA.ne.jp>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100204101533.4619.34599.sendpatchset@localhost.localdomain>
	<201002041959.JEG43202.JQOFHFOVSFMtLO@I-love.SAKURA.ne.jp>
	<4B6BA16E.3010002@redhat.com>
In-Reply-To: <4B6BA16E.3010002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, opurdila@ixiacom.com, eric.dumazet@gmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, davem@davemloft.net

Cong Wang wrote:
> Oh, IIUC, TOMOYO is something like SELinux?

Yes. It is a policy based mandatory access control implementation which is
applied to not only non root users but also root user. If MAC is enabled,
root user cannot freely modify via sysctl() or /proc/sys interface.

> So, it is somewhat weird to let users to use TOMOYO to reserve
> the ports with MAC.

To add reserved port

echo deny_autobind 0-1023 | ccs-loadpolicy -e
echo deny_autobind 3128 | ccs-loadpolicy -e
echo deny_autobind 8080 | ccs-loadpolicy -e

and to delete reserved port

echo delete deny_autobind 0-1023 | ccs-loadpolicy -e
echo delete deny_autobind 3128 | ccs-loadpolicy -e
echo delete deny_autobind 8080 | ccs-loadpolicy -e

That's all. Quite easy.

> For normal users /proc interface seems more friendly.

I think /proc/sys/net/ipv4/ip_local_reserved_ports interface wants
"struct list_head" for handling multiple sets of min/max pairs. I'm using
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/security/ccsecurity/autobind.c#L29
for that purpose.
