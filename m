Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792851430;
	b=yA0sfnMLWqz8jWTXNsd+rutearpBWscFmnCK7KYXBKtHZvgxRQ9jvH07DUTv1yPiox6n
	 PJyIEgh6hnthmcGfvrBoE6fwPrrckNV/6hZ7rA5/Jf9H9BEjd6JC38fmjygFE0UGBKrpc
	 sf9MMZDI/gqDVIk0Do48p6+HE0I0NGYuIH7QyPXKCmLX2pp35815aUmMbI3oVLKiR9iYt
	 uWkGn5nbFenphPcF9Xuoj1Y2zj2Q1kpPpdiCDkDaHLiI6nmo9P5WYeEO71/BcQaPFVJb/
	 HTB3/nobpE3hngR/yDQI+GJhh5b9UnHLR6cnO0s8K7ZXGPkWYLru49Qu+aPn+alvirA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792851430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=z2NngLFK0fW7a0vPwyVLcGPllHS9ThMXqNhcoWREeq4=;
	b=G18j7JUG3mbRdSSEx1xyTKuW3v2nPJVyIcOOus5XtzHpJ3rMd/e6qD4h8/BBnGBoqLi8
	 Ko4wFASofjcXpKuFCvbnr4cOd8bR1K228CCkzW88RiiwdUVds+/B0HPgA2crmGyQJrT+U
	 lX+r3VoX7SaOlno9Esne4JQmvhpeLhjM0FF3BOLDuoul1uaYhcO0cd4adB48zCZ5ILTO/
	 xJipTU8kA1WeSoQos4WdEwUEorfaDYLpWZzEHQbiiZpaQyxaHpwN5QHHixwWWFEEE0Bvv
	 1gpAYXt/eTcOIsp82DcnmnHI72ROd29yVYUZQVicQpsQLpwmVeIQebyxNwl8pOTIcaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a7hVhX6A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.71
Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320A2606A31A
	for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 14:17:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 320A2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a7hVhX6A
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-3ac5c86570aso1768981fa.0
        for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 07:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792851423; cv=none;
        d=google.com; s=arc-20260327;
        b=Xubj0olIZ07Mc+N2AwDRBcLX1xS1Sox2la4sKI1cYgbLv8UgBAFDBsfL2UaP/CezEZ
         BkPRZMC2hR9RH4Eu0nJvY3mV3LdavCawsqF9bk7iIFCsK4QO9E3VZ57vi71G4BJdBwqP
         brM38USoJsichiWgo4xvdt8XbEwff0V7h+3j9D63vm3t75N3N8UdXPh4xF8xf7PzEHh7
         q0rAdjWyo+K0sxwL9W1/1jAyii6SRaGi6PHo1/1XByWvWgwMahVdOXnHxVYneWNa6yEo
         ayw/ilSmmeVIWoUiZrH3o/A7riymdPOaFYKDJFBmpp2fhfK9URXnON0stOP2BuNQUrmV
         c00g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=z2NngLFK0fW7a0vPwyVLcGPllHS9ThMXqNhcoWREeq4=;
        fh=a1DYb4jCFCPsZVIwetykaqNN/9xkT2JCZezIuhxk0O0=;
        b=TQbFbOIigmh/6rFPjDb302HcdHQPIzDCn2cf9Zxgi3p5GJThndlF6cFUG4s20jGclQ
         iI6HqMZvpspbLTClwucNh2bfOEwo1ez78+JfxgYBy+nrQQvjmc8SSIapkDHHTIpQePpa
         pbXTXZkZheC7exlJfB9CWw3uohuQ4BYMo+Zu1/wKKeOHtqUDlMh51ju0rBFoJ49hbKKx
         fqy+eDQfDg9JuDzWVTOW1/rOGEsxVK+1nUfvb01ty8T9T27alSs4UFQPgxwAIzps7api
         4UsGSoNMrZaMNSVYG4zLzXfxn51Dwg5AhI1daWrDKGxKrpRYBDFF6DHgVNx7WBvQXgyN
         GR5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792851423; x=1793456223; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z2NngLFK0fW7a0vPwyVLcGPllHS9ThMXqNhcoWREeq4=;
        b=a7hVhX6ACvsKHwuPFbJFvDIeQr8K62xX2IRA/Wi5bVxYO2BwkvYsNde1CY4olVb4Gw
         oxCfzn+ecVaoZ8lk9SAqRCc7wWtb4Vqdi+rV+eOO0ddT2ZC6S/Y3KGdlrtzMGX7lLQOo
         D0lyvrqx/Re+dXEA+k8qsTnRAQIBi8Md97P6IdMGu7EBMqpngrSwJO0q1tsprD06SQNR
         TnfUPIiidvY8s4y8ox42Qm9AJJQsIGglJTZ33E7LekzCIIYIZxVlck2gSwxrQxsgRQHz
         4+9KQYVJ8Lji2fKSXY/LoNv90LccHNIykHjCgV85VQd8bPVJZBp6WMMMS3mBifxClvcK
         9U6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792851423; x=1793456223;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z2NngLFK0fW7a0vPwyVLcGPllHS9ThMXqNhcoWREeq4=;
        b=PksHHBvsWohvvHJ1HmMUbFzw3+1Y5P3S1J1gxPNQzl83tF/qoWTFT2vGe8hpGW4yXS
         BgaPTK/0klX7VyX0jAGUVByoDXA3h/RTm77tXVYwGx4I5cqLMsI2rIbLzFBopFS5YUti
         zMFUDkcPyRkXAkpqVa0NeM+Ct/0NpqtMnjGL/OH1k9oSYTjdbUpJ/xyRyE+IjzuZ5Gyz
         q28GE4oj28r7P4Yu5qVuF0z50iS+kyKIJ6euKuHm3ATSLlr1sKNlDlJNYHLQqKpqpniy
         oEgs+T/+Q2yqZwyP7J7FeEYRklZUcyNXRC23dcGRER3Orlrdo6RCOl+i1hJO3LcVFmmm
         pJZw==
X-Forwarded-Encrypted: i=1; AKwUvBy2FiV6p3RaLcP30UQJCq7UrycZGhUua3X3fBbRmv8XV3xRznyZLTivnRM4DQCD4r2QvKAs6DJBZWrF@vger.kernel.org
X-Gm-Message-State: AFq9FYLFHCSz3C7Gu91wuToZNZwKZs+d1ajP3+B9n/eOVnH3ujHSTPPm
	xcI5YZyoin3X26G1K//xKojprrHd0MC5xligHr9JadCZhpRGdJ0Cjs09Np8jeXORUtpZg7xFDWV
	PJ25CshZK+W1PqOI3ObRWFkvVWy/v0lruTJH+dxAxvUa64EYxWA==
X-Gm-Gg: AYBFou0j3XIrdPOk3JGM4Jmj2WIfKvAls16AJaRklLhugYBoml1CINIkpc1B+/qD3sE
	G1PTB7YWnXqW1vZNZiq3m0bjuoqPjICUbMbL7JNmwhxFN+hHSl9JZW5CPsh36osFSJUDazKcpIR
	6pO9zIEGeaPvRjK4b2AeGhi0im3P8BLmcUizNz9UZaNEvmf2mxiSHY5r0CoSCNAcpyZMhKYCvOV
	RapOFZUZEEeC7NNGHjxs7yLhbzXIMBvW7zrNSCFxLM0l8q0kzf28XeHz22113ql/SWpfAsLUSV+
	mM9DEze3RYgni1h67foE6Rauakts//0+dZfko/8pRpD/lAhhPP//PtW9hFqyZpDFN3ZJYBuYrl4
	/xteq/KIEo3XyVQ1l8ZTdMD/bKNvxS4hqZfuuvw==
X-Received: by 2002:a05:651c:211b:b0:3ac:608e:c83d with SMTP id
 38308e7fff4ca-3ac6fffd4a4mr4587581fa.15.1792851422841; Sat, 24 Oct 2026
 07:17:02 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Sat, 24 Oct 2026 22:16:50 +0800
X-Gm-Features: AclHuK_IxK1bB7LXwBk9j9fcLpR8x3EgqdtPjRpKIm0y2fC-9IPA4LxrUYWfE-k
Message-ID: <CAO-4RZ1_wv1m7+EzxuRbx17PderBYS3zjXZ08M5k7oKhbx5Obw@mail.gmail.com>
Subject: [BUG] SCTP: KASAN use-after-free in sctp_unpack_cookie with
 fail_skb_realloc (7.3.0)
To: marcelo.leitner@gmail.com, lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marcelo and Xin,

I observed a KASAN slab-use-after-free in sctp_unpack_cookie() while fuzzing
SCTP with syzkaller. I reproduced it on Linux 7.1.3 and on Linux 7.3.0. On
7.3.0, the crash was observed during replay of a 42-program execution sequence;
the standalone three-call reproducer did not trigger in two attempts.

The issue occurs while processing a COOKIE-ECHO through
sctp_sf_do_5_2_4_dupcook(). With the upstream skb fault-injection option
CONFIG_FAIL_SKB_REALLOC enabled and fail_nth: 43 on sendto(), the pskb_pull()
inside sctp_sf_do_5_2_4_dupcook() triggers pskb_expand_head() (through
skb_might_realloc()), which frees the old skb head buffer;
sctp_unpack_cookie() then reads (size 2) from the freed buffer.

Environment
-----------
- Kernel A (found and reproduced): 7.1.3-kernsight-kasan #13 SMP
PREEMPT_DYNAMIC,
  built 2026-10-13, x86_64. Built with KASAN/KCOV and
  CONFIG_FAIL_SKB_REALLOC=y. No SCTP changes were made for this testing.
- Kernel B (reproduced 2026-10-24): 7.3.0-kernsight-kasan #1 SMP
  PREEMPT_DYNAMIC, built 2026-10-20, x86_64. Vanilla 7.3.0 source tarball
  (sha256 87363c24f10e06321eb362765521094e94471f6bff8bce2d6b3e40f39f004953),
  built with KASAN/KCOV and CONFIG_FAIL_SKB_REALLOC=y. No SCTP source changes
  (net/sctp/ matches vanilla apart from build artifacts).
- Both kernels: CONFIG_KASAN=y, CONFIG_KCOV=y, CONFIG_FAULT_INJECTION=y,
  CONFIG_FAIL_SKB_REALLOC=y. CONFIG_FAIL_SKB_REALLOC and
  net/core/skb_fault_injection.c are upstream (present in the vanilla 7.3.0
  tarball).
- Guest: QEMU 6.2.0, 4 vCPU, 6 GiB, KVM, x86_64. A fresh VM was booted for
  every run.
- Syzkaller: revision 853b104bb454141a5b0fc0e4218ec78e9f34ffb1+ (2026-09-18).
  The "+" denotes local KernSight integration changes (seed ordering/state
  feedback: pkg/kernsight, prog/kernsight_*, syz-manager/kernsight_*,
  pkg/execbackend, snapshot support in vm/qemu). They do not change the SCTP
  syscall descriptions or the executor's fault-injection semantics.
- Kernel modifications / additional modules: none relevant to this report
  beyond the KASAN/KCOV/fault-injection build options above.
- Reproduction rate: 7.1.3: verified syz and C reproducer. 7.3.0: 1/1 with the
  stored 42-program sequence; the standalone three-call program did not
  reproduce in 2 attempts. (1/1 does not establish stability.)
- Kernel command line (7.1.3; 7.3.0 is identical, see repository):
  root=/dev/sda console=ttyS0 fstab=no rw earlyprintk=serial
net.ifnames=0 oops=panic panic_on_warn=1 panic=86400 hung_task_panic=1
softlockup_panic=1 nmi_watchdog=panic
sysctl.kernel.hung_task_all_cpu_backtrace=1
sysctl.kernel.panic_on_rcu_stall=1
sysctl.kernel.max_rcu_stall_to_panic=1 rcupdate.rcu_expedited=1
rcupdate.rcu_cpu_stall_cputime=1 no_hash_pointers page_owner=on
sysctl.vm.nr_hugepages=4 sysctl.vm.nr_overcommit_hugepages=4
secretmem.enable=1 msr.allow_writes=off coredump_filter=0xffff
vsyscall=native kvm-intel.nested=1 spec_store_bypass_disable=prctl
nopcid vivid.n_devs=64
vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
netrom.nr_ndevs=32 rose.rose_ndevs=32 smp.csd_lock_timeout=100000
watchdog_thresh=55 workqueue.watchdog_thresh=140
sysctl.net.core.netdev_unregister_timeout_secs=140 dummy_hcd.num=16
max_loop=32 nbd.nbds_max=32 comedi.comedi_num_legacy_minors=4
kunit.autorun=0 vcan.echo=1

Reproduction on 7.1.3
---------------------
Fresh KVM guest, kernel as above. Run from the guest's /tmp:

  scp syz-execprog syz-executor repro.prog root@guest:/tmp/
  ssh root@guest
  cd /tmp && chmod +x syz-execprog syz-executor
  ./syz-execprog -procs=1 -repeat=1 -disable=swap -executor
./syz-executor ./repro.prog

Execution settings: sandbox=none, threaded executor, procs=1, repeat=1, no
additional syzkaller features; a single program.

The minimised program (repro.prog) is:

  r0 = socket$inet6_sctp(0xa, 0x5, 0x84)
  setsockopt$inet6_sctp_SCTP_SOCKOPT_BINDX_ADD(r0, 0x84, 0x64,
&(0x7f0000000080)=[@in6={0xa, 0x4e21, 0x5, @loopback, 0x9}], 0x1c)
  sendto$inet6(r0, &(0x7f0000000000)='M', 0x1, 0x20004845,
&(0x7f0000000040)={0xa, 0x4e21, 0xffffff00, @loopback, 0x2}, 0x1c)
(fail_nth: 43)

The C reproducer also works on 7.1.3:

  gcc -x c -O2 -pthread -o repro repro.cprog && ./repro

Its console shows the same report:
  BUG: KASAN: slab-use-after-free in sctp_unpack_cookie+0xa56/0xdc0

Reproduction on 7.3.0
---------------------
Same procedure with the 7.3.0 kernel and the state-construction sequence
instead of the single program:

  scp syz-execprog syz-executor repro.kernsight.prog root@guest:/tmp/
  ssh root@guest
  cd /tmp && chmod +x syz-execprog syz-executor
  ./syz-execprog -procs=1 -repeat=1 -disable=swap -executor
./syz-executor ./repro.kernsight.prog

The sequence contains 42 programs replayed by a single executor process
(procs=1) one at a time in file order (repeat=1, sandbox=none, threaded
executor). The executor does not run programs in parallel, but a program can
leave kernel-side asynchronous work behind (timers, workqueues, networking),
so earlier programs' effects may still be active while later ones run. The
SCTP trigger is program #40 and appears again inside the final program #41.

Materials (programs, full logs, reports, kernel configs, command lines,
sha256 manifest, and a verify.sh that re-checks the numbers quoted here):
  https://github.com/Zheng-zheng-codes/sctp-unpack-cookie-repro

For reference, in our runs the sequence log contains exactly one KASAN report,
first printed at t=212.7 s; the two standalone 7.3.0 runs contain zero.

The standalone three-call program did not trigger in two runs on a fresh 7.3.0
guest. The preceding execution sequence may affect reproducibility, but I have
not isolated which preceding operations or environmental conditions matter.

Fault injection was enabled for this reproduction
-------------------------------------------------
The sendto() call is annotated with fail_nth: 43. During this execution, the
kernel logged a fail_skb_realloc injection, followed by the KASAN report:

  FAULT_INJECTION: forcing a failure.
  name fail_skb_realloc, interval 1, probability 0, space 0, times 1

No additional fail_skb_realloc debugfs configuration was required.

KASAN report (7.3.0, latest verification)
-----------------------------------------
BUG: KASAN: slab-use-after-free in sctp_unpack_cookie+0xb57/0xf30
Read of size 2 at addr ff1100017d7658e6 by task syz.0.57/11114

CPU: 3 UID: 0 PID: 11114 Comm: syz.0.57 Not tainted
7.3.0-kernsight-kasan #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x116/0x1b0
 print_report+0xf1/0x5c0
 ? __virt_addr_valid+0x23d/0x430
 ? sctp_unpack_cookie+0xb57/0xf30
 kasan_report+0x96/0xd0
 ? sctp_unpack_cookie+0xb57/0xf30
 sctp_unpack_cookie+0xb57/0xf30
 ? pskb_expand_head+0x591/0x10b0
 ? __pfx_sctp_unpack_cookie+0x10/0x10
 ? __pfx_pskb_expand_head+0x10/0x10
 ? dump_stack_lvl+0x15f/0x1b0
 ? should_fail_ex+0x35d/0x650
 sctp_sf_do_5_2_4_dupcook+0x2e2/0x3320
 ? __pfx_sctp_sf_do_5_2_4_dupcook+0x10/0x10
 ? sctp_sm_lookup_event+0x183/0x580
 ? kasan_save_track+0x14/0x30
 ? __kasan_slab_free+0x43/0x70
 ? kmem_cache_free+0x292/0x6a0
 ? sctp_chunk_put+0x20b/0x2c0
 ? sctp_inq_pop+0x691/0x10f0
 ? sctp_assoc_bh_rcv+0x113/0x700
 ? sctp_inq_push+0x262/0x310
 ? __pfx_sctp_cname+0x10/0x10
 sctp_do_sm+0x177/0x55a0
 ? rcu_is_watching+0x13/0xc0
 ? preempt_count_sub+0xfc/0x1a0
 ? __pfx_sctp_do_sm+0x10/0x10
 ? debug_check_no_obj_freed+0x293/0x520
 ? __lock_acquire+0x509/0x2110
 ? lockdep_hardirqs_on+0x7d/0x110
 ? kvm_clock_get_cycles+0x41/0x70
 sctp_assoc_bh_rcv+0x38f/0x700
 sctp_inq_push+0x262/0x310
 sctp_backlog_rcv+0x16c/0x5a0
 ? __pfx_sctp_backlog_rcv+0x10/0x10
 ? __pfx_sctp_backlog_rcv+0x10/0x10
 __release_sock+0x3a0/0x440
 release_sock+0x1ea/0x280
 sctp_sendmsg+0x8e4/0x1dd0
 ? __pfx_sctp_sendmsg+0x10/0x10
 ? aa_sock_msg_perm+0x127/0x200
 ? __pfx_sctp_sendmsg+0x10/0x10
 ? __pfx_inet_sendmsg+0x10/0x10
 inet_sendmsg+0x126/0x150
 __sys_sendto+0x474/0x520
 ? __pfx___sys_sendto+0x10/0x10
 ? fput+0x7d/0xe0
 ? fput+0x7d/0xe0
 ? fput+0x7d/0xe0
 ? trace_preempt_on+0x122/0x170
 ? fput+0x7d/0xe0
 ? preempt_count_sub+0xfc/0x1a0
 ? fput+0xa2/0xe0
 ? ksys_write+0x1a8/0x240
 ? __pfx_ksys_write+0x10/0x10
 __x64_sys_sendto+0xe5/0x1c0
 ? lockdep_hardirqs_on+0x7d/0x110
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f166adb2b7d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f166bd5cf98 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f166b045fa0 RCX: 00007f166adb2b7d
RDX: 0000000000000001 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f166bd5d010 R08: 0000200000000040 R09: 000000000000001c
R10: 0000000020004845 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f166b046038 R14: 00007f166b045fa0 R15: 00007f166bd3d000
 </TASK>

Allocated by task 11114:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x7f/0x90
 __kmalloc_node_track_caller_noprof+0x339/0x800
 kmalloc_reserve+0xeb/0x350
 __alloc_skb+0x197/0x740
 sctp_packet_transmit+0x1eb/0x3210
 sctp_outq_flush_transports+0x39d/0x7e0
 sctp_outq_uncork+0x18d/0x200
 sctp_do_sm+0x23d4/0x55a0
 sctp_assoc_bh_rcv+0x38f/0x700
 sctp_inq_push+0x262/0x310
 sctp_backlog_rcv+0x16c/0x5a0
 __release_sock+0x3a0/0x440
 release_sock+0x1ea/0x280
 sctp_sendmsg+0x8e4/0x1dd0
 inet_sendmsg+0x126/0x150
 __sys_sendto+0x474/0x520
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 11114:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x43/0x70
 kfree+0x27b/0x660
 skb_free_head+0xb9/0x150
 pskb_expand_head+0x3b3/0x10b0
 skb_might_realloc+0xb6/0xd0
 sctp_sf_do_5_2_4_dupcook+0x206/0x3320
 sctp_do_sm+0x177/0x55a0
 sctp_assoc_bh_rcv+0x38f/0x700
 sctp_inq_push+0x262/0x310
 sctp_backlog_rcv+0x16c/0x5a0
 __release_sock+0x3a0/0x440
 release_sock+0x1ea/0x280
 sctp_sendmsg+0x8e4/0x1dd0
 inet_sendmsg+0x126/0x150
 __sys_sendto+0x474/0x520
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ff1100017d765800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 230 bytes inside of
 freed 1024-byte region [ff1100017d765800, ff1100017d765c00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x17d760
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x17ff00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ff11000100038dc0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 017ff00000000040 ff11000100038dc0 dead000000000100 dead000000000122
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 017ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 9374, tgid 9374 ((spawn)), ts 163178481859
 post_alloc_hook+0xff/0x130
 get_page_from_freelist+0xdd0/0x2b70
 __alloc_frozen_pages_noprof+0x2bd/0x2e10
 new_slab+0xb5/0x6a0
 refill_objects+0x113/0x3d0
 __pcs_replace_empty_main+0x35f/0x680
 __kmalloc_noprof+0x5c5/0x7f0
 load_elf_phdrs+0x107/0x210
 load_elf_binary+0x233/0x4fc0
 bprm_execve+0x8d7/0x1930
 do_execveat_common.isra.0+0x48d/0x5e0
 __x64_sys_execve+0x98/0xd0
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 9372 tgid 9372 ts 163145729632 stack trace:
 __free_frozen_pages+0x870/0x1170
 qlist_free_all+0x4c/0xf0
 kasan_quarantine_reduce+0x195/0x1e0
 __kasan_slab_alloc+0x49/0x70
 kmem_cache_alloc_noprof+0x23a/0x680
 do_getname+0x39/0x3e0
 do_sys_openat2+0xa7/0x250
 __x64_sys_openat+0x144/0x200
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ff1100017d765780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ff1100017d765800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ff1100017d765880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ff1100017d765900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ff1100017d765980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Kernel panic - not syncing: KASAN: panic_on_warn set ...
CPU: 3 UID: 0 PID: 11114 Comm: syz.0.57 Not tainted
7.3.0-kernsight-kasan #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x3d/0x1b0
 vpanic+0x7f8/0xa80
 ? __pfx_vpanic+0x10/0x10
 ? __pfx_vprintk_emit+0x10/0x10
 ? sctp_unpack_cookie+0xb57/0xf30
 panic+0xc7/0xd0
 ? __pfx_panic+0x10/0x10
 ? _raw_spin_unlock_irqrestore+0x46/0x80
 ? sctp_unpack_cookie+0xb57/0xf30
 ? rcu_is_watching+0x13/0xc0
 ? _raw_spin_unlock_irqrestore+0x46/0x80
 check_panic_on_warn+0xb6/0xc0
 end_report+0x12c/0x180
 ? sctp_unpack_cookie+0xb57/0xf30
 kasan_report+0xa4/0xd0
 ? sctp_unpack_cookie+0xb57/0xf30
 sctp_unpack_cookie+0xb57/0xf30
 ? pskb_expand_head+0x591/0x10b0
 ? __pfx_sctp_unpack_cookie+0x10/0x10
 ? __pfx_pskb_expand_head+0x10/0x10
 ? dump_stack_lvl+0x15f/0x1b0
 ? should_fail_ex+0x35d/0x650
 sctp_sf_do_5_2_4_dupcook+0x2e2/0x3320
 ? __pfx_sctp_sf_do_5_2_4_dupcook+0x10/0x10
 ? sctp_sm_lookup_event+0x183/0x580
 ? kasan_save_track+0x14/0x30
 ? __kasan_slab_free+0x43/0x70
 ? kmem_cache_free+0x292/0x6a0
 ? sctp_chunk_put+0x20b/0x2c0
 ? sctp_inq_pop+0x691/0x10f0
 ? sctp_assoc_bh_rcv+0x113/0x700
 ? sctp_inq_push+0x262/0x310
 ? __pfx_sctp_cname+0x10/0x10
 sctp_do_sm+0x177/0x55a0
 ? rcu_is_watching+0x13/0xc0
 ? preempt_count_sub+0xfc/0x1a0
 ? __pfx_sctp_do_sm+0x10/0x10
 ? debug_check_no_obj_freed+0x293/0x520
 ? __lock_acquire+0x509/0x2110
 ? lockdep_hardirqs_on+0x7d/0x110
 ? kvm_clock_get_cycles+0x41/0x70
 sctp_assoc_bh_rcv+0x38f/0x700
 sctp_inq_push+0x262/0x310
 sctp_backlog_rcv+0x16c/0x5a0
 ? __pfx_sctp_backlog_rcv+0x10/0x10
 ? __pfx_sctp_backlog_rcv+0x10/0x10
 __release_sock+0x3a0/0x440
 release_sock+0x1ea/0x280
 sctp_sendmsg+0x8e4/0x1dd0
 ? __pfx_sctp_sendmsg+0x10/0x10
 ? aa_sock_msg_perm+0x127/0x200
 ? __pfx_sctp_sendmsg+0x10/0x10
 ? __pfx_inet_sendmsg+0x10/0x10
 inet_sendmsg+0x126/0x150
 __sys_sendto+0x474/0x520
 ? __pfx___sys_sendto+0x10/0x10
 ? fput+0x7d/0xe0
 ? fput+0x7d/0xe0
 ? fput+0x7d/0xe0
 ? trace_preempt_on+0x122/0x170
 ? fput+0x7d/0xe0
 ? preempt_count_sub+0xfc/0x1a0
 ? fput+0xa2/0xe0
 ? ksys_write+0x1a8/0x240
 ? __pfx_ksys_write+0x10/0x10
 __x64_sys_sendto+0xe5/0x1c0
 ? lockdep_hardirqs_on+0x7d/0x110
 do_syscall_64+0x12e/0x7a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f166adb2b7d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f166bd5cf98 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f166b045fa0 RCX: 00007f166adb2b7d
RDX: 0000000000000001 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f166bd5d010 R08: 0000200000000040 R09: 000000000000001c
R10: 0000000020004845 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f166b046038 R14: 00007f166b045fa0 R15: 00007f166bd3d000
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..

The 7.1.3 report is included in the repository
(logs/cebee8cfa01b-kasan-7.1.3.txt). It has the same paths: access in
sctp_unpack_cookie+0xa56/0xdc0 (net/sctp/sm_make_chunk.c:1744); allocation in
__alloc_skb() from sctp_packet_transmit() (net/sctp/output.c:598); free in
pskb_expand_head() -> skb_free_head(), reached through skb_might_realloc()
(net/core/skb_fault_injection.c) from pskb_pull() in
sctp_sf_do_5_2_4_dupcook() (net/sctp/sm_statefuns.c:2235); the subsequent call
that enters sctp_unpack_cookie() is at net/sctp/sm_statefuns.c:2244.

Analysis and related report
---------------------------
The report suggests that pointers into the skb data buffer become stale after
pskb_pull() triggers skb reallocation in sctp_sf_do_5_2_4_dupcook(). A
subsequent access in sctp_unpack_cookie() then reads from the old buffer.

I found the following related report concerning the HEARTBEAT path:
https://lists.openwall.net/netdev/2026/04/15/25

I also read Xin's response regarding skb linearization in the receive path:
https://lists.openwall.net/netdev/2026/04/15/178

My report concerns the COOKIE-ECHO path rather than the HEARTBEAT path. I have
not established whether this reallocation is reachable without fault injection,
or whether this should be treated as an issue with the fault-injection coverage
of an already-linearized skb. On 7.3.0 the minimised program alone did not
trigger while the 42-program sequence did; the preceding operations may matter,
but I have not isolated them.

Could you help determine whether this is an SCTP pointer-lifetime issue that
needs a fix, a related instance of the earlier report, or an artifact of forced
skb reallocation?

Attachments / repository contents
---------------------------------
  repro/repro.prog              syz program, includes fail_nth: 43 (7.1.3)
  repro/repro.cprog             C reproducer with fail-nth setup (7.1.3)
  repro/repro.kernsight.prog    42-program execution sequence (7.3.0)
  logs/cebee8cfa01b-kasan-7.1.3.txt   full 7.1.3 KASAN report
  logs/cebee8cfa01b-kasan-7.3.txt     full 7.3.0 KASAN report (also inline)
  logs/serial-7.3.log                  full 7.3.0 console (sequence replay)
  logs/serial-7.3-minimal-no-trigger.log   7.3.0 standalone run 1 (no trigger)
  logs/serial-7.3-minimal2-no-trigger.log  7.3.0 standalone run 2 (no trigger)
  logs/serial-7.1.3-c-repro.log       7.1.3 C-reproducer console
  kernel/kernel-7.1.3.config, kernel/kernel-7.3.config
  cmdline/cmdline-7.1.3.txt, cmdline/cmdline-7.3.0.txt
  verify.sh                     re-checks the numbers quoted in this mail
  MANIFEST.sha256               sha256 of every file

I am happy to provide additional information and test proposed patches.

Best regards,
Zheng Zheng
