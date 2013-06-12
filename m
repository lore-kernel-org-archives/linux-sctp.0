From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 12 Jun 2013 13:04:14 +0000
Subject: Re: [PATCH net] net: sctp: sctp_seq_dump_local_addrs: fix NULL pointer dereference
Message-Id: <51B871CE.3090602@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1370969266-16974-1-git-send-email-dborkman@redhat.com> <20130612125600.GF13059@hmsreliant.think-freely.org>
In-Reply-To: <20130612125600.GF13059@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 06/12/2013 02:56 PM, Neil Horman wrote:
> On Tue, Jun 11, 2013 at 06:47:46PM +0200, Daniel Borkmann wrote:
>> The following NULL pointer dereference has occured on a 2.6.32-358 kernel,
>> but upstream is affected as well since there are not many differences:
>>
>> sctp protocol violation state 4 chunkid 8
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
>> IP: [<ffffffffa0354cac>] sctp_v4_cmp_addr+0xc/0x30 [sctp]
>> PGD c2758c067 PUD 87ecf1067 PMD 0
>> Oops: 0000 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:00.1/local_cpus
>> CPU 7
>> Modules linked in: [...]
>> Pid: 15475, comm: netstat Not tainted 2.6.32-358.el6.x86_64 #1 KONTRON AT8050/FYA/AT8050/FYA
>> RIP: 0010:[<ffffffffa0354cac>]  [<ffffffffa0354cac>] sctp_v4_cmp_addr+0xc/0x30 [sctp]
>> RSP: 0018:ffff880c280f3d08  EFLAGS: 00010206
>> RAX: 0000000000000002 RBX: ffff880827a25c00 RCX: 0000000000000001
>> RDX: 000000000000027f RSI: 0000000000000078 RDI: ffff880827a25c20
>> RBP: ffff880c280f3d08 R08: 00000000fffffffd R09: 0000000000000001
>> R10: 0000000000000003 R11: 0000000000000000 R12: ffff880c27d9d870
>> R13: ffffffffa03751c0 R14: ffff880827a25c20 R15: 0000000000000078
>> FS:  00007fb7b7d0f7a0(0000) GS:ffff8800282e0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   -- MORE --  forward: <SPACE>, <ENTER> or j  backward: b or k  quit: q
>> CR2: 0000000000000078 CR3: 000000087c36d000 CR4: 00000000000007e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process netstat (pid: 15475, threadinfo ffff880c280f2000, task ffff88091e361540)
>> Stack:
>>   ffff880c280f3d58 ffffffffa036dbac ffff880c280f3d28 ffff88098fefebc0
>> <d> ffff880c280f3d38 ffff880c27d9d800 ffff88098fefebc0 0000000000000f83
>> <d> ffff8808d12a7b80 ffff880c27d9d948 ffff880c280f3e18 ffffffffa036de3d
>> Call Trace:
>>   [<ffffffffa036dbac>] sctp_seq_dump_local_addrs+0x6c/0xc0 [sctp]
>>   [<ffffffffa036de3d>] sctp_assocs_seq_show+0x12d/0x250 [sctp]
>>   [<ffffffff811a4ee0>] ? seq_read+0x0/0x400
>>   [<ffffffff811a5169>] seq_read+0x289/0x400
>>   [<ffffffff811e966e>] proc_reg_read+0x7e/0xc0
>>   [<ffffffff811816c5>] vfs_read+0xb5/0x1a0
>>   [<ffffffff81181801>] sys_read+0x51/0x90
>>   [<ffffffff810dc565>] ? __audit_syscall_exit+0x265/0x290
>>   [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
>> Code: 02 00 08 8b 47 04 89 46 04 b8 08 00 00 00 c9 c3 66 66 66 66 66 66
>>        2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 0f b7 07 <66>
>>        3b 06 74 07 31 c0 c9 c3 0f 1f 00 0f b7 47 02 66 3b 46 02 75
>> RIP  [<ffffffffa0354cac>] sctp_v4_cmp_addr+0xc/0x30 [sctp]
>>   RSP <ffff880c280f3d08>
>> CR2: 0000000000000078
>>
>> ./decodecode < oops.file:
>>    ...
>>    1f:	55                   	push   %rbp
>>    20:	48 89 e5             	mov    %rsp,%rbp
>>    23:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>>    28:	0f b7 07             	movzwl (%rdi),%eax
>>    2b:*	66 3b 06             	cmp    (%rsi),%ax  <-- trapping instruction
>>    2e:	74 07                	je     0x37       (1st 'if' in sctp_v4_cmp_addr)
>>    30:	31 c0                	xor    %eax,%eax
>>    32:	c9                   	leaveq
>>    33:	c3                   	retq
>>    34:	0f 1f 00             	nopl   (%rax)
>>    37:	0f b7 47 02          	movzwl 0x2(%rdi),%eax
>>    ...
>>
>> There have been some approaches to fix corruptions with the same or
>> very similar stack trace such as 2eebc1e ("sctp: Fix list corruption
>> resulting from freeing an association on a list"), 0b0fe913 ("sctp:
>> proc: protect bind_addr->address_list accesses with rcu_read_lock()"),
>> 45122ca ("sctp: Add RCU protection to assoc->transport_addr_list")
>> that are all important fixes, but the panic still can occur in some
>> cases with such a stack trace above.
>>
>> When entering into sctp_seq_dump_local_addrs(), the sctp_ep_common
>> structure is correctly of type SCTP_EP_TYPE_ASSOCIATION, and has a
>> refcnt of 1 and dead is 0. Also from kdump, the ebp's pointer members
>> do not look corrupted. When entering sctp_v4_cmp_addr(), the first
>> sctp_addr argument looks good/valid, but the second sctp_addr argument
>> ('primary') is 0000000000000078 and results suddenly in a NULL pointer
>> _dereference_ in sctp_v4_cmp_addr() although in the test before it
>> seems to have been "primary != NULL".
>>
>> Now, how can this happen? Let's assume asoc->peer.primary_path is NULL
>> which is possible to happen. Here, we do not check for it, but take the
>> address (note we do not actually dereference it!) of its saddr member.
>> This is then exactly 0000000000000078 as reported in the trace, since
>> that is equal to the offset of saddr from the primary_path container
>> (in the reported kernel). Thus, the check for NULL (= (void *) 0) will
>> pass, eventually leading to the NULL pointer dereference in cmp_addr()
>> since this address is within the NULL page.
>>
>> Lets fix it by being paranoid and checking first if our primary transport
>> is != NULL and in case of != NULL if it is alive. Then, let us hold a
>> copy of the sctp_addr on the stack instead of using a pointer just in
>> case the transport could be destroyed at a later point in time (we're not
>> in a hurry anyway). By that, we can avoid this very scenario, only just
>> for the sake of printing this asterisk and can fix the NULL pointer
>> dereference eventually. Introduced by bca735bd ("Extend the info exported
>> via /proc/net/sctp to support netstat for SCTP.").
>>
> First off, nice analysis Daniel, that very clear and consice.  The patch below
> makes sense to me, but I'm getting the impression that, if we need to use the
> dead flag here, that rcu_locking isn't going to be safe. If we aren't guaranteed
> that saddr is going to be a valid pointer or NULL, and as a consequence are
> going to need to rely on the ->dead flag, then we have a potential race
> condition to worry about.  I think the transport pointer is safe here, as its
> rcu protected in the free path, but its parent association is not.  By getting
> the assocation that a given trasport points to, we risk a race with the
> destruction of that association (I think).  We probably need to convert the
> association create/free paths (as well as the endpoint, etc, create/free paths),
> to be rcu sensitive, but for the time being, it may be sufficient to simply hold
> the association in sctp_seq_dump_local_addrs.

Well, checking for ->dead might be unnecessary and can probably be deleted (if wished
I can do that and resubmit).

At the time of the crash, the association was in SCTP_STATE_CLOSED and the pointer to
primary_path in fact NULL.

The association looks as follows:

crash> sctp_association ffff880c27d9d800 |grep primary_path
     primary_path = 0x0,

The full structure is as follows:

crash> sctp_association ffff880c27d9d800
struct sctp_association {
   base = {
     node = {
       next = 0xffff880c25bd2000,
       pprev = 0xffff880c2ba0f838
     },
     hashent = 3971,
     type = SCTP_EP_TYPE_ASSOCIATION,
     refcnt = {
       counter = 1
     },
     dead = 0 '\000',
     malloced = 1 '\001',
     sk = 0xffff8808d12a7b80,
     inqueue = {
       in_chunk_list = {
         next = 0xffff880c27d9d828,
         prev = 0xffff880c27d9d828
       },
       in_progress = 0x0,
       immediate = {
         data = {
           counter = 0
         },
         entry = {
           next = 0xffff880c27d9d848,
           prev = 0xffff880c27d9d848
         },
         func = 0xffffffffa0358120 <sctp_assoc_bh_rcv>
       },
       malloced = 0
     },
     bind_addr = {
       port = 3868,
       address_list = {
         next = 0xffff880827a25c00,
         prev = 0xffff880827a25c80
       },
       malloced = 0
     }
   },
   asocs = {
     next = 0xffff880c1bf17888,
     prev = 0xffff880c25bd2088
   },
   assoc_id = 0,
   ep = 0xffff8808c0ab1800,
   c = {
     my_vtag = 1991531349,
     peer_vtag = 2306202495,
     my_ttag = 0,
     peer_ttag = 0,
     expiration = {
       tv_sec = 1368105862,
       tv_usec = 623303
     },
     sinit_num_ostreams = 4,
     sinit_max_instreams = 4,
     initial_tsn = 1248969237,
     peer_addr = {
       v4 = {
         sin_family = 2,
         sin_port = 36883,
         sin_addr = {
           s_addr = 3875562594
         },
         __pad = "\000\000\000\000\000\000\000"
       },
       v6 = {
         sin6_family = 2,
         sin6_port = 36883,
         sin6_flowinfo = 3875562594,
         sin6_addr = {
           in6_u = {
             u6_addr8 = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
             u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
             u6_addr32 = {0, 0, 0, 0}
           }
         },
         sin6_scope_id = 0
       },
       sa = {
         sa_family = 2,
         sa_data = "\023\220bd\000\347\000\000\000\000\000\000\000"
       }
     },
     my_port = 3868,
     prsctp_capable = 1 '\001',
     padding = 0 '\000',
     adaptation_ind = 2306202495,
     auth_random = "\200\002\000$L\347\r\360%\302\003O\337v\303W\342\326\341\033̓\331\064\r䎴\254\374\364\343\253\037\360", <incomplete sequence \320>,
     auth_hmacs = "\000\000\000\000\000\000\000\000\000",
     auth_chunks = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
     raw_addr_list_len = 16,
     peer_init = 0xffff880c27d9d93c
   },
   peer = {
     rwnd = 65535,
     transport_addr_list = {
       next = 0xffff880c27d9d948,
       prev = 0xffff880c27d9d948
     },
     transport_count = 0,
     port = 5008,
     primary_path = 0x0,
     primary_addr = {
       v4 = {
         sin_family = 0,
         sin_port = 0,
         sin_addr = {
           s_addr = 0
         },
         __pad = "\000\000\000\000\000\000\000"
       },
       v6 = {
         sin6_family = 0,
         sin6_port = 0,
         sin6_flowinfo = 0,
         sin6_addr = {
           in6_u = {
             u6_addr8 = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
             u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
             u6_addr32 = {0, 0, 0, 0}
           }
         },
         sin6_scope_id = 0
       },
       sa = {
         sa_family = 0,
         sa_data = "\000\000\000\000\000\000\000\000\000\000\000\000\000"
       }
     },
     active_path = 0x0,
     retran_path = 0x0,
     last_sent_to = 0x0,
     last_data_from = 0x0,
     tsn_map = {
       tsn_map = 0x0,
       base_tsn = 0,
       cumulative_tsn_ack_point = 0,
       max_tsn_seen = 0,
       len = 0,
       pending_data = 0,
       num_dup_tsns = 0,
       dup_tsns = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
     },
     sack_needed = 1 '\001',
     sack_cnt = 0,
     sack_generation = 1,
     ecn_capable = 0 '\000',
     ipv4_address = 1 '\001',
     ipv6_address = 0 '\000',
     hostname_address = 0 '\000',
     asconf_capable = 0 '\000',
     prsctp_capable = 1 '\001',
     auth_capable = 0 '\000',
     adaptation_ind = 2306202495,
     addip_disabled_mask = 0,
     i = {
       init_tag = 0,
       a_rwnd = 0,
       num_outbound_streams = 0,
       num_inbound_streams = 0,
       initial_tsn = 0
     },
     cookie_len = 0,
     cookie = 0x0,
     addip_serial = 0,
     peer_random = 0x0,
     peer_chunks = 0x0,
     peer_hmacs = 0x0
   },
   state = SCTP_STATE_CLOSED,
   cookie_life = {
     tv_sec = 60,
     tv_usec = 0
   },
   overall_error_count = 0,
   rto_initial = 2000,
   rto_max = 2000,
   rto_min = 500,
   max_burst = 4,
   max_retrans = 6,
   pf_retrans = 2147483647,
   max_init_attempts = 26352,
   init_retries = 0,
   max_init_timeo = 5049,
   hbinterval = 30000,
   pathmaxrxt = 3,
   pmtu_pending = 0 '\000',
   pathmtu = 0,
   param_flags = 41,
   sackdelay = 200,
   sackfreq = 2,
   timeouts = {0, 2000, 2000, 2000, 0, 0, 10000, 0, 200, 0},
   timers = {{
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa0354960 <sctp_generate_t1_cookie_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa0354940 <sctp_generate_t1_init_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa0354920 <sctp_generate_t2_shutdown_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa0354900 <sctp_generate_t4_rto_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa03548e0 <sctp_generate_t5_shutdown_guard_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa03548c0 <sctp_generate_sack_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }, {
       entry = {
         next = 0x0,
         prev = 0x0
       },
       expires = 0,
       function = 0xffffffffa03548a0 <sctp_generate_autoclose_event>,
       data = 18446612184522414080,
       base = 0xffff880c2dbf4000,
       start_site = 0x0,
       start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
       start_pid = -1
     }},
   shutdown_last_sent_to = 0x0,
   shutdown_retries = 0,
   init_last_sent_to = 0x0,
   next_tsn = 1248969237,
   ctsn_ack_point = 1248969236,
   adv_peer_ack_point = 1248969236,
   highest_sacked = 318833522,
   fast_recovery_exit = 0,
   fast_recovery = 0 '\000',
   unack_data = 0,
   rtx_data_chunks = 0,
   rwnd = 114688,
   a_rwnd = 114688,
   rwnd_over = 0,
   rwnd_press = 0,
   sndbuf_used = 0,
   rmem_alloc = {
     counter = 0
   },
   wait = {
     lock = {
       raw_lock = {
         slock = 0
       }
     },
     task_list = {
       next = 0xffff880c27d9dea0,
       prev = 0xffff880c27d9dea0
     }
   },
   frag_point = 0,
   user_frag = 0,
   init_err_counter = 0,
   init_cycle = 0,
   default_stream = 0,
   default_flags = 0,
   default_ppid = 0,
   default_context = 0,
   default_timetolive = 0,
   default_rcv_context = 0,
   ssnmap = 0x0,
   outqueue = {
     asoc = 0xffff880c27d9d800,
     out_chunk_list = {
       next = 0xffff880c27d9dee8,
       prev = 0xffff880c27d9dee8
     },
     out_qlen = 0,
     error = 0,
     control_chunk_list = {
       next = 0xffff880c27d9df00,
       prev = 0xffff880c27d9df00
     },
     sacked = {
       next = 0xffff880c27d9df10,
       prev = 0xffff880c27d9df10
     },
     retransmit = {
       next = 0xffff880c27d9df20,
       prev = 0xffff880c27d9df20
     },
     abandoned = {
       next = 0xffff880c27d9df30,
       prev = 0xffff880c27d9df30
     },
     outstanding_bytes = 0,
     fast_rtx = 0 '\000',
     cork = 0 '\000',
     empty = 1 '\001',
     malloced = 0 '\000'
   },
   ulpq = {
     malloced = 0 '\000',
     pd_mode = 0 '\000',
     asoc = 0xffff880c27d9d800,
     reasm = {
       next = 0xffff880c27d9df58,
       prev = 0xffff880c27d9df58,
       qlen = 0,
       lock = {
         raw_lock = {
           slock = 0
         }
       }
     },
     lobby = {
       next = 0xffff880c27d9df70,
       prev = 0xffff880c27d9df70,
       qlen = 0,
       lock = {
         raw_lock = {
           slock = 0
         }
       }
     }
   },
   last_ecne_tsn = 0,
   last_cwr_tsn = 318833522,
   numduptsns = 0,
   autoclose = 0,
   addip_last_asconf = 0x0,
   asconf_ack_list = {
     next = 0xffff880c27d9dfa0,
     prev = 0xffff880c27d9dfa0
   },
   addip_chunk_list = {
     next = 0xffff880c27d9dfb0,
     prev = 0xffff880c27d9dfb0
   },
   addip_serial = 1248969237,
   endpoint_shared_keys = {
     next = 0xffff8808477a5360,
     prev = 0xffff8808477a5360
   },
   asoc_shared_key = 0x0,
   default_hmac_id = 0,
   active_key_id = 0,
   need_ecne = 0 '\000',
   temp = 0 '\000'
}
crash>
crash>
crash>
crash>
crash> sctp_association ffff880c27d9d800 |grep primary_path
     primary_path = 0x0,
crash>
