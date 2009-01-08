From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 08 Jan 2009 14:55:16 +0000
Subject: bad reference counting for module (was Re: BUG in sctp crashes
Message-Id: <20090108145515.GF29698@dhcp35.suse.cz>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vlad,

On Tue 06-01-09 08:50:15, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > On Mon 05-01-09 18:05:21, Vlad Yasevich wrote:
> >> Karsten, Michal
> > 
> > Hi Vlad,
> > 
> >> I think I found this cursed race.
> >>
> >> The problem is that nothing is guarding the asoc->base.sk reference.  This
> >> reference changes during the accept()/peeloff() code paths and the only
> >> guard around it is the socket lock.  But that lock is not taken when
> >> the reference is used for reading as it is done in sctp_rcv().
> >>
> >> So, when we do sctp_bh_lock_sock(sk) in sctp_rcv(), we may be using
> >> a stale cached copy of the sk which might have changed during sctp_accept().
> >>
> >> What this allows us to do is to have a user sending a packet on a socket
> >> at the same time we may be processing and incoming packet on the same socket.
> >> We just end up taking different locks which totally hoses us.
> >>
> >> -vlad
> >>
> >>
[...]
> > 
> > Can you reproduce with this patch? Unfortunately, I don't have any HW
> > configuration available at the moment.
> 
> I've had the test run for a few hours without any issues.  Usually the
> system crashes with the first 15 minutes.
> 
[...]
> > This test, however, has been removed by 61c9fed41638249f8b6ca5345064eb1beb50179f.
> > AFAIU this patch deals with similar race in the receive path when socket
> > is moved.
> 
> Yes.  The old code was insufficient, but this part should not have been removed.
> The old code was still racy in other parts of the peel-off and resulted in
> crashes you've seen.   However, this particular part or something along these
> lines needs to be there.
> 
> I really hate the this is done and currently looking at a way to protect this
> pointer somehow, or rework it so it's not needed.  The problem is that we
> perform other checks using the sk without locking it so there could be other
> races as well that we just haven't seen because noone has an app yet that needs
> the additional functionality.  So, even this patch I sent is not a complete
> solution, but it is enough to fix the crash your customer is seeing.
> 
[...]

You are right, we have backported 61c9fed41638249f8b6ca5345064eb1beb50179f 
with the association change check along with the 
cfdeef3282705a4b872d3559c4e7d2561251363c
f26f7c480555812ca7c4037e0a50fa54afe2cb4a

and we are no longer able to reproduce skb overflow crash. 

Thanks for pointing this out! Really good hit!

However we are currently seeing another issue. It is not a crash (only
process is killed with BUG message in the log - see attached) but it is
the problem with module reference counting (
BUG_ON(module_refcount(module)==0) in __module_get is called). 

I am not sure whether this is a real problem, because we were able to
trigger this only on _one_ testing configuration while other one is OK.

I have checked all places where sctp decreases module reference count
(sock_put) and it seems that all places are correctly balanced with
sock_hold resp. __module_get:
- sctp_association_init vs. sctp_association_destroy
- sctp_association_migrate - put for old and hold for new
- sctp_endpoint_int vs. sctp_endpoint_destroy
- sctp_close - one artificial hold because of sk_common_release (which calls
               put)
             - one put balanced with sys_accept which calls __module_get

And all sock_put corresponds to the current upstream.

Do you have any idea or remember any problem in this area which could
trigger this? 

It smells either as some misconfiguration of the testing system or
another race condition or just I am overlooking something.

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sctp-bad-modulerefcount.log"

Bootdata ok (command line is root=/dev/disk/by-id/scsi-SATA_SAMSUNG_HM250JIS0TVJD0QB06108-part2 resume=/dev/sda1 splash=silent)
Linux version 2.6.16.60-0.33.TEST.440104.0-smp (geeko@buildhost) (gcc version 4.1.2 20070115 (SUSE Linux)) #1 SMP Fri Oct 31 14:24:07 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
 BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
 BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
 BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
DMI present.
No NUMA configuration found
Faking a node at 0000000000000000-000000013c000000
Bootmem setup node 0 0000000000000000-000000013c000000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Built 1 zonelists
Kernel command line: root=/dev/disk/by-id/scsi-SATA_SAMSUNG_HM250JIS0TVJD0QB06108-part2 resume=/dev/sda1 splash=silent
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
time.c: Detected 2393.986 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x165a000 - 0x565a000
Nosave address range: 000000000009d000 - 000000000009e000
Nosave address range: 000000000009e000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000d2000
Nosave address range: 00000000000d2000 - 00000000000d4000
Nosave address range: 00000000000d4000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Nosave address range: 00000000bf6b0000 - 00000000bf6cc000
Nosave address range: 00000000bf6cc000 - 00000000bf700000
Nosave address range: 00000000bf700000 - 00000000c0000000
Nosave address range: 00000000c0000000 - 00000000f0000000
Nosave address range: 00000000f0000000 - 00000000f4000000
Nosave address range: 00000000f4000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 00000000fec10000
Nosave address range: 00000000fec10000 - 00000000fed00000
Nosave address range: 00000000fed00000 - 00000000fed14000
Nosave address range: 00000000fed14000 - 00000000fed1a000
Nosave address range: 00000000fed1a000 - 00000000fed1c000
Nosave address range: 00000000fed1c000 - 00000000fed90000
Nosave address range: 00000000fed90000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000ff000000
Nosave address range: 00000000ff000000 - 0000000100000000
Memory: 3968568k/5177344k available (1985k kernel code, 150268k reserved, 906k data, 204k init)
Calibrating delay using timer specific routine.. 4793.99 BogoMIPS (lpj=9587990)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
checking if image is initramfs... it is
Freeing initrd memory: 3064k freed
 not found!
Using local APIC timer interrupts.
result 12468663
Detected 12.468 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4787.98 BogoMIPS (lpj=9575965)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -3 cycles, maxerr 348 cycles)
Brought up 2 CPUs
migration_cost=9
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
PCI: BIOS Bug: MCFG area is not E820-reserved
PCI: Not using MMCONFIG.
ACPI: Subsystem revision 20060127
ACPI: Found ECDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
ACPI: Embedded Controller [EC] (gpe 18) interrupt mode.
ACPI: Power Resource [PUBS] (on)
Brightness switching support detected
Brightness switching support detected
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000 (virtual 0xffffffffff5fe000), IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: fc000000-fdffffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: dc000000-df3fffff
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: dfb00000-dfbfffff
PCI: Bridge: 0000:00:1c.3
  IO window: 5000-5fff
  MEM window: d4000000-d5ffffff
  PREFETCH window: df800000-df8fffff
PCI: Bridge: 0000:00:1c.4
  IO window: 6000-6fff
  MEM window: d0000000-d1ffffff
  PREFETCH window: df500000-df5fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00007000-000070ff
  IO window: 00007400-000074ff
  PREFETCH window: f4000000-f5ffffff
  MEM window: fa000000-fbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-afff
  MEM window: f8300000-fbffffff
  PREFETCH window: f4000000-f7ffffff
PCI: ThinkPad Lenovo detected
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 169
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 177
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 185
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 169
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
GSI 20 sharing vector 0xC9 and IRQ 20
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 201
Simple Boot Flag at 0x35 set to 0x1
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
audit: initializing netlink socket (disabled)
audit(1231402641.848:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 169
assign_interrupt_mode Found MSI capability
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 177
assign_interrupt_mode Found MSI capability
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 185
assign_interrupt_mode Found MSI capability
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 193
assign_interrupt_mode Found MSI capability
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 169
assign_interrupt_mode Found MSI capability
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
ACPI wakeup devices: 
 LID SLPB IGBE EXP0 EXP1 EXP2 EXP3 EXP4 PCI1 USB0 USB1 USB2 USB3 USB4 EHC0 EHC1 HDEF 
ACPI: (supports S0 S3 S4 S5)
Freeing unused kernel memory: 204k freed
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SCSI subsystem initialized
ICH8M: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 201
ICH8M: chipset revision 3
ICH8M: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1c00-0x1c07, BIOS settings: hda:DMA, hdb:pio
hda: Optiarc DVD RW AD-7910A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 201
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
ahci 0000:00:1f.2: nr_ports (3) and implemented port map (0x5) don't match
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xFFFFC20000036100 ctl 0x0 bmdma 0x0 irq 66
ata2: DUMMY
ata3: SATA max UDMA/133 cmd 0xFFFFC20000036200 ctl 0x0 bmdma 0x0 irq 66
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8, max UDMA7, 488397168 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : ahci
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
  Vendor: ATA       Model: SAMSUNG HM250JI   Rev: HS10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write back
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (51 C)
ACPI: Thermal Zone [THM1] (45 C)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
sd 0:0:0:0: Attached scsi generic sg0 type 0
Attempting manual resume
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
reiserfs: using flush barriers
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
Adding 2104472k swap on /dev/disk/by-id/scsi-SATA_SAMSUNG_HM250JIS0TVJD0QB06108-part1.  Priority:-1 extents:1 across:2104472k
lp: driver loaded but no devices found
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 201
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:20c6]
Intel(R) PRO/1000 Network Driver - version 7.6.9.1-NAPI
Copyright (c) 1999-2007 Intel Corporation.
Yenta: ISA IRQ mask 0x0cb8, PCI irq 201
Socket status: 30000820
pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
GSI 21 sharing vector 0x4A and IRQ 21
ACPI: PCI Interrupt 0000:15:00.1[B] -> GSI 17 (level, low) -> IRQ 74
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 169
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[74]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:1c:25:72:9e:76
usbcore: registered new driver usbfs
usbcore: registered new driver hub
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 185
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: irq 185, io mem 0xfe226c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
USB Universal Host Controller Interface driver v2.3
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.16.60-0.33.TEST.440104.0-smp ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hw_random hardware driver 1.0.0 loaded
GSI 22 sharing vector 0x52 and IRQ 22
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 82
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: irq 82, io mem 0xfe227000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.16.60-0.33.TEST.440104.0-smp ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 169
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 169, io base 0x00001860
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.16.60-0.33.TEST.440104.0-smp uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 177
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 177, io base 0x00001880
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.16.60-0.33.TEST.440104.0-smp uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
drm: Loading module compiled for kernel version 2.6.16.60-0.23-smp into kernel version 2.6.16.60-0.33.TEST.440104.0-smp
[drm] Initialized drm 1.0.1 20051102
intel_agp: Loading module compiled for kernel version 2.6.16.60-0.21-smp into kernel version 2.6.16.60-0.33.TEST.440104.0-smp
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 201
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 201, io base 0x000018a0
usb usb5: new device found, idVendor=0000, idProduct=0000
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.16.60-0.33.TEST.440104.0-smp uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
pccard: CardBus card inserted into slot 0
uhci_hcd 0000:00:1d.1: UHCI Host Controller
loop: loaded (max 8 devices)
AppArmor: AppArmor initialized
audit(1231402656.427:2):  info="AppArmor initialized" pid=2343
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Power Button (FF) [PWRF]
ACPI: Lid Switch [LID]
ACPI: Sleep Button (CM) [SLPB]
Lenovo ThinkPad detected
ibm_acpi: Found video device \_SB.PCI0.VID
ibm_acpi: IBM ThinkPad ACPI Extras v0.12a
ibm_acpi: http://ibm-acpi.sf.net/
ibm_acpi: Found Lenovo ThinkPad with 15 brightness levels
ACPI: ACPI Dock Station Driver 
audit(1231402658.971:3): audit_pid=2900 old=0 by auid=4294967295
IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
IA-32 Microcode Update Driver v1.14 unregistered
e1000: eth0: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth2: link is not ready
IPv6 over IPv4 tunneling driver
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at include/linux/module.h:365
invalid opcode: 0000 [1] SMP 
last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:15:00.0/0000:16:00.0/irq
CPU 1 
Modules linked in: sctp ipv6 cpufreq_ondemand cpufreq_userspace cpufreq_powersave speedstep_centrino freq_table snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device dock ibm_acpi button battery ac apparmor loop dm_mod netconsole usbhid uinput hci_usb i915 bluetooth r8169 intel_agp drm pcmcia snd_hda_intel firmware_class snd_pcm snd_timer snd hw_random soundcore uhci_hcd ehci_hcd snd_page_alloc usbcore e1000 ohci1394 i2c_i801 yenta_socket rsrc_nonstatic ieee1394 ide_cd i2c_core cdrom pcmcia_core parport_pc lp parport reiserfs sg edd fan thermal processor ahci libata piix sd_mod scsi_mod ide_disk ide_core
Pid: 3526, comm: sctpcrash Tainted: G     X 2.6.16.60-0.33.TEST.440104.0-smp #1
RIP: 0010:[<ffffffff80282adf>] <ffffffff80282adf>{sys_accept+113}
RSP: 0018:ffff810130edbe98  EFLAGS: 00210246
RAX: 0000000000000000 RBX: ffffffff884d8280 RCX: 0000000000000000
RDX: 0000000000000080 RSI: 00000000000000d0 RDI: ffffffff884d8280
RBP: ffff810130974640 R08: 0000000000000000 R09: 00000000ffc08fb8
R10: ffff81013020adc0 R11: ffffffff80280e1d R12: ffff810132cb3740
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff810137a0d8c0(0063) knlGS:00000000f7c946b0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7fa3000 CR3: 0000000130ee7000 CR4: 00000000000006e0
Process sctpcrash (pid: 3526, threadinfo ffff810130eda000, task ffff810136ac67a0)
Stack: ffff81012ffa8498 ffff810130974640 ffff81012ffa8490 ffff81012ffa8498 
       ffff810130974690 ffff81013649a8a0 ffff81013649a8a0 ffffffff8019c27f 
       0000000000000008 0000000000000008 
Call Trace: <ffffffff8019c27f>{dput+44} <ffffffff8018701f>{__fput+355}
       <ffffffff801a08b7>{mntput_no_expire+29} <ffffffff8029947e>{compat_sys_socketcall+141}
       <ffffffff801226d4>{sysenter_do_call+27} <ffffffff80280e1d>{sock_destroy_inode+0}

Code: 0f 0b 68 f3 48 31 80 c2 6d 01 65 8b 04 25 24 00 00 00 48 98 
RIP <ffffffff80282adf>{sys_accept+113} RSP <ffff810130edbe98>
 
--X1bOJ3K7DJ5YkBrT--
