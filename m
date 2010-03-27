From: George Cheimonidis <gchimon@gmail.com>
Date: Sat, 27 Mar 2010 12:51:00 +0000
Subject: Re: connect() hangs after binding to three IP addresses and auth_enable
Message-Id: <4BADFF34.2050202@gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------070802080602080103020604"
List-Id: <linux-sctp.vger.kernel.org>
References: <001701cacc68$d6bb1390$84313ab0$@com>
In-Reply-To: <001701cacc68$d6bb1390$84313ab0$@com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------070802080602080103020604
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vlad!

I have recompiled the 2.6.33 kernel with your debug patch. I have also 
enabled SCTP debugging with with CONFIG_SCTP_DBG_MSG=y.
You can find the log messages in the attached file. Hope it helps!

Best regards
George


On 03/26/2010 03:36 PM, Vlad Yasevich wrote:
> Hi George
>
> George Cheimonidis wrote:
>    
>> Hi Vlad!
>>
>> I am sending this email, after the discussion that we had in the forum
>> thread
>> https://sourceforge.net/projects/lksctp/forums/forum/83479/topic/3615562.
>> This was related to the problem that I faced when using connect() after
>> binding to three IP addresses  (two IPv4 and one IPv6). The problem seemed
>> to occur when auth_enable is set.
>> I am willing to rebuild the SCTP module with the patches that you mentioned.
>> Please provide me with some instructions on how to apply these patches, if
>> possible.
>>
>> Best regards,
>> George
>>
>>      
>
> Here is a debug patch that should apply against either 2.6.31 or 2.6.33.
> To apply it, you'll need the Ubuntu sources or sources from kernel.org
>
> To apply them, just use
> 	$ patch -p1<  patchfile
>
> Then rebuild the kernel or just the sctp module if you don't want to wait too
> long.  To build the module you do
> 	$ make net/sctp/sctp.ko
>
> Thanks for doing this.
> -vlad
>    


--------------070802080602080103020604
Content-Type: text/plain;
 name="log_sctp_new.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log_sctp_new.txt"

Mar 27 13:43:46 george-netbook kernel: [ 3063.211917] sctp_init_sock(sk: e74103c0)
Mar 27 13:43:51 george-netbook kernel: [ 3068.471625] sctp_setsockopt(sk: e74103c0... optname: 100)
Mar 27 13:43:51 george-netbook kernel: [ 3068.471641] sctp_setsocktopt_bindx: sk e74103c0 addrs 085de240 addrs_size 32 opt 1
Mar 27 13:43:51 george-netbook kernel: [ 3068.471655] sctp_bindx_add (sk: e74103c0, addrs: ef788e60, addrcnt: 2)
Mar 27 13:43:51 george-netbook kernel: [ 3068.471668] sctp_do_bind(sk: e74103c0, new addr: 213.xxx.xxx.xxx, port: 0, new port: 0, len: 16)
Mar 27 13:43:51 george-netbook kernel: [ 3068.471682] sctp_get_port() begins, snum=0
Mar 27 13:43:51 george-netbook kernel: [ 3068.471696] sctp_do_bind(sk: e74103c0, new addr: 192.xxx.xxx.xxx, port: 38443, new port: 0, len: 16)
Mar 27 13:43:51 george-netbook kernel: [ 3068.471706] sctp_get_port() begins, snum=38443
Mar 27 13:43:51 george-netbook kernel: [ 3068.471712] sctp_get_port() found a possible match
Mar 27 13:43:51 george-netbook kernel: [ 3068.471722] sctp_send_asconf_add_ip: (sk: e74103c0, addrs: ef788e60, addrcnt: 2)
Mar 27 13:43:55 george-netbook kernel: [ 3072.472377] sctp_setsockopt(sk: e74103c0... optname: 100)
Mar 27 13:43:55 george-netbook kernel: [ 3072.472399] sctp_setsocktopt_bindx: sk e74103c0 addrs 085de240 addrs_size 28 opt 1
Mar 27 13:43:55 george-netbook kernel: [ 3072.472417] sctp_bindx_add (sk: e74103c0, addrs: ef7887e0, addrcnt: 1)
Mar 27 13:43:55 george-netbook kernel: [ 3072.472435] sctp_do_bind(sk: e74103c0, new addr: 2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx, port: 38443, new port: 0, len: 28)
Mar 27 13:43:55 george-netbook kernel: [ 3072.472456] sctp_get_port() begins, snum=38443
Mar 27 13:43:55 george-netbook kernel: [ 3072.472465] sctp_get_port() found a possible match
Mar 27 13:43:55 george-netbook kernel: [ 3072.472490] sctp_send_asconf_add_ip: (sk: e74103c0, addrs: ef7887e0, addrcnt: 1)
Mar 27 13:43:57 george-netbook kernel: [ 3074.472609] sctp_setsockopt(sk: e74103c0... optname: 11)
Mar 27 13:43:57 george-netbook kernel: [ 3074.472814] sctp_connect - sk: e74103c0, sockaddr: ef745ed8, addr_len: 28
Mar 27 13:43:57 george-netbook kernel: [ 3074.472977] Created asoc ef472000
Mar 27 13:43:57 george-netbook kernel: [ 3074.472989] sctp_assoc_add_peer:association ef472000 addr: 2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy port: 9877 state:65535
Mar 27 13:43:57 george-netbook kernel: [ 3074.473043] sctp_v6_get_dst: DST=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy 
Mar 27 13:43:57 george-netbook kernel: [ 3074.473067] rt6_dst:2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy rt6_src:0000:0000:0000:0000:0000:0000:0000:0000
Mar 27 13:43:57 george-netbook kernel: [ 3074.473081] sctp_v6_get_saddr: asoc:ef472000 dst:f463ce00 daddr:2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy 
Mar 27 13:43:57 george-netbook kernel: [ 3074.473093] saddr: 2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx
Mar 27 13:43:57 george-netbook kernel: [ 3074.473103] sctp_assoc_add_peer:association ef472000 PMTU set to 1500
Mar 27 13:43:57 george-netbook kernel: [ 3074.473113] sctp_packet_init: packet:e76a2914 transport:e76a2800
Mar 27 13:43:57 george-netbook kernel: [ 3074.473128] sctp_do_sm prefn: ep eec56700, EVENT_T_PRIMITIVE, PRIMITIVE_ASSOCIATE, asoc ef472000[STATE_CLOSED], sctp_sf_do_prm_asoc
Mar 27 13:43:57 george-netbook kernel: [ 3074.473143] DEBUG: INIT size prior to Auth 68
Mar 27 13:43:57 george-netbook kernel: [ 3074.473151] DEBUG: INIT size after AUTH and extensions(3) 123
Mar 27 13:43:57 george-netbook kernel: [ 3074.473172] skb_over_panic: text:f85d9265 len:130 put:6 head:e76a3800 data:e76a3800 tail:0xe76a3882 end:0xe76a3880 dev:<NULL>
Mar 27 13:43:57 george-netbook kernel: [ 3074.473223] ------------[ cut here ]------------
Mar 27 13:43:57 george-netbook kernel: [ 3074.473233] kernel BUG at net/core/skbuff.c:127!
Mar 27 13:43:57 george-netbook kernel: [ 3074.473242] invalid opcode: 0000 [#2] SMP 
Mar 27 13:43:57 george-netbook kernel: [ 3074.473253] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Mar 27 13:43:57 george-netbook kernel: [ 3074.473264] Modules linked in: sha256_generic sha1_generic sctp crc32c libcrc32c snd_hda_codec_realtek snd_hda_intel binfmt_misc snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss bridge stp snd_pcm ppdev snd_seq_dummy bnep snd_seq_oss snd_seq_midi arc4 snd_rawmidi snd_seq_midi_event snd_seq ath5k snd_timer snd_seq_device iptable_filter snd mac80211 ath ip_tables uvcvideo videodev cfg80211 x_tables soundcore psmouse lp v4l1_compat snd_page_alloc serio_raw led_class btusb joydev parport fbcon tileblit font bitblit softcursor usbhid i915 drm_kms_helper intel_agp drm sky2 i2c_algo_bit agpgart video output
Mar 27 13:43:57 george-netbook kernel: [ 3074.473429] 
Mar 27 13:43:57 george-netbook kernel: [ 3074.473443] Pid: 3048, comm: sctpapp Tainted: G      D    2.6.33-geo #1 NC10                       /NC10                       
Mar 27 13:43:57 george-netbook kernel: [ 3074.473457] EIP: 0060:[<c04a4227>] EFLAGS: 00210282 CPU: 0
Mar 27 13:43:57 george-netbook kernel: [ 3074.473473] EIP is at skb_over_panic+0x57/0x70
Mar 27 13:43:57 george-netbook kernel: [ 3074.473483] EAX: 00000087 EBX: f85d9265 ECX: c0774554 EDX: 00000000
Mar 27 13:43:57 george-netbook kernel: [ 3074.473494] ESI: 00000002 EDI: 0000007a EBP: ef745c80 ESP: ef745c58
Mar 27 13:43:57 george-netbook kernel: [ 3074.473504]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Mar 27 13:43:57 george-netbook kernel: [ 3074.473516] Process sctpapp (pid: 3048, ti=ef744000 task=ec650cb0 task.ti=ef744000)
Mar 27 13:43:57 george-netbook kernel: [ 3074.473524] Stack:
Mar 27 13:43:57 george-netbook kernel: [ 3074.473530]  c072f8e4 f85d9265 00000082 00000006 e76a3800 e76a3800 e76a3882 e76a3880
Mar 27 13:43:57 george-netbook kernel: [ 3074.473555] <0> c072d292 e76a387c ef745c8c c04a4a76 e77913c0 ef745cb0 f85d9265 ef4720ca
Mar 27 13:43:57 george-netbook kernel: [ 3074.473582] <0> e76a387a e76a3874 00000006 ef4720ca e77913c0 ef4720c4 ef745d14 f85db6ca
Mar 27 13:43:57 george-netbook kernel: [ 3074.473610] Call Trace:
Mar 27 13:43:57 george-netbook kernel: [ 3074.473644]  [<f85d9265>] ? sctp_addto_chunk+0x45/0x90 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473661]  [<c04a4a76>] ? skb_put+0x36/0x40
Mar 27 13:43:57 george-netbook kernel: [ 3074.473692]  [<f85d9265>] ? sctp_addto_chunk+0x45/0x90 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473724]  [<f85db6ca>] ? sctp_make_init+0x2ca/0x310 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473753]  [<f85cdeeb>] ? sctp_sf_do_prm_asoc+0x3b/0xa0 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473782]  [<f85d3a25>] ? sctp_do_sm+0x65/0x1b0 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473818]  [<f85e747a>] ? sctp_primitive_ASSOCIATE+0x3a/0x40 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473850]  [<f85e394e>] ? __sctp_connect+0x24e/0x4b0 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473869]  [<c058a022>] ? _raw_spin_lock_bh+0x12/0x20
Mar 27 13:43:57 george-netbook kernel: [ 3074.473901]  [<f85e3c17>] ? sctp_connect+0x67/0x90 [sctp]
Mar 27 13:43:57 george-netbook kernel: [ 3074.473919]  [<c0501f27>] ? inet_dgram_connect+0x27/0x70
Mar 27 13:43:57 george-netbook kernel: [ 3074.473935]  [<c049fc5e>] ? sys_connect+0xae/0xd0
Mar 27 13:43:57 george-netbook kernel: [ 3074.473951]  [<c0399f08>] ? tty_ldisc_deref+0x8/0x10
Mar 27 13:43:57 george-netbook kernel: [ 3074.473967]  [<c0392bf8>] ? tty_write+0x1b8/0x210
Mar 27 13:43:57 george-netbook kernel: [ 3074.473981]  [<c03967b0>] ? n_tty_write+0x0/0x3d0
Mar 27 13:43:57 george-netbook kernel: [ 3074.473995]  [<c032b898>] ? _copy_from_user+0x38/0x130
Mar 27 13:43:57 george-netbook kernel: [ 3074.474011]  [<c04a0e10>] ? sys_socketcall+0x270/0x2a0
Mar 27 13:43:57 george-netbook kernel: [ 3074.474027]  [<c0103063>] ? sysenter_do_call+0x12/0x28
Mar 27 13:43:57 george-netbook kernel: [ 3074.474036] Code: 00 00 89 4c 24 14 8b 88 a8 00 00 00 89 54 24 0c 89 4c 24 10 8b 40 50 89 5c 24 04 c7 04 24 e4 f8 72 c0 89 44 24 08 e8 dc 31 0e 00 <0f> 0b eb fe b9 92 d2 72 c0 eb ae 8d b4 26 00 00 00 00 8d bc 27 
Mar 27 13:43:57 george-netbook kernel: [ 3074.474177] EIP: [<c04a4227>] skb_over_panic+0x57/0x70 SS:ESP 0068:ef745c58
Mar 27 13:43:57 george-netbook kernel: [ 3074.474199] ---[ end trace b9ff72b81305a989 ]---
Mar 27 13:43:57 george-netbook kernel: [ 3074.474385] sctp_close(sk: 0xe74103c0, timeout:0)

--------------070802080602080103020604--
