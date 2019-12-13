From: Lorenzo Colitti <lorenzo@google.com>
Date: Fri, 13 Dec 2019 00:25:42 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CAKD1Yr1jAv4ouHKu+wA-_basvzY3tN==QMq9u+4fmvpOHLBh1Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain> <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain>
In-Reply-To: <20191127230001.GO388551@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Thu, Nov 28, 2019 at 8:00 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> I'm no SELinux expert, but my /etc/ssh/sshd_config has this nice handy
> comment:
> # If you want to change the port on a SELinux system, you have to tell
> # SELinux about this change.
> # semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
>
> The kernel has no specific knowledge of 'ssh_port_t' and all I need to
> do to allow such port, is run the command above. No compiler, etc.
> The distribution would have to have a policy, say,
> 'unbindable_ports_t', and it could work similarly, I suppose, but I
> have no knowledge on this part.

For security reasons, Android does not allow reloading selinux policy
after boot. I'm not a selinux expert either, but semanage-port(8) has:

       -N, --noreload
              Do not reload policy after commit

which suggests that it works by reloading the policy.
