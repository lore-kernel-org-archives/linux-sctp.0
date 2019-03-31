From: Matteo Croce <mcroce@redhat.com>
Date: Sun, 31 Mar 2019 19:22:58 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <CAGnkfhxQYuhpCfyr0FUQLM_DFtnOeuMLKkbJ649+atMkdEY=fA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1554022192.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1554022192.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Vladis Dronov <vdronov@redhat.com>

On Sun, Mar 31, 2019 at 10:53 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> sctp memory accounting is added in this patchset by using
> these kernel APIs on send side:
>
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_wmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
>
> and these on receive side:
>
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_rmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
>
> With sctp memory accounting, we can limit the memory allocation by
> either sysctl:
>
>   # sysctl -w net.sctp.sctp_mem=3D"10 20 50"
>
> or cgroup:
>
>   # echo $((8<<14)) > \
>     /sys/fs/cgroup/memory/sctp_mem/memory.kmem.tcp.limit_in_bytes
>
> When the socket is under memory pressure, the send side will block
> and wait, while the receive side will renege or drop.
>

I have tested this series with a tool which creates lot of SCTP
sockets and writes into them, without never reading.
Before the patch I was able to escape the cgroup limit and fill the
system memory, and the OOM killer killed random processes:

[  317.348911] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),glob=
al_oom,task_memcg=3D/system.slice/ifup@eth0.service,task=3Ddhclient,pid=188=
,uid=3D0
[  317.349084] Out of memory: Killed process 188 (dhclient)
total-vm:9484kB, anon-rss:1280kB, file-rss:1424kB, shmem-rss:0kB
[  317.743943] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),glob=
al_oom,task_memcg=3D/system.slice/systemd-journald.service,task=3Dsystemd-j=
ournal,pid=85,uid=3D0
[  317.744093] Out of memory: Killed process 85 (systemd-journal)
total-vm:24592kB, anon-rss:1024kB, file-rss:1112kB, shmem-rss:652kB
[  317.921049] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),glob=
al_oom,task_memcg=3D/system.slice/cron.service,task=3Dcron,pid"2,uid=3D0
[  317.921209] Out of memory: Killed process 222 (cron)
total-vm:8692kB, anon-rss:276kB, file-rss:1540kB, shmem-rss:0kB

Now the OOM killer behaves correctly and always kills the processes in
the right cgroup:

[  512.100054] Tasks state (memory values in pages):
[  512.100122] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes
swapents oom_score_adj name
[  512.100256] [    838]     0   838      550      184    36864
0             0 sctprank
[  512.100452] [    841]     0   841      550       18    36864
0             0 sctprank
[  512.100573] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),oom_=
memcg=3D/sctp,task_memcg=3D/sctp,task=3Dsctprank,pid=838,uid=3D0
[  512.100700] Memory cgroup out of memory: Killed process 838
(sctprank) total-vm:2200kB, anon-rss:64kB, file-rss:672kB,
shmem-rss:0kB
[  512.100899] oom_reaper: reaped process 838 (sctprank), now
anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

Series ACK.

Tested-by: Matteo Croce <mcroce@redhat.com>


--
Matteo Croce
per aspera ad upstream
