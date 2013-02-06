From: Bob Montgomery <bob.montgomery@hp.com>
Date: Wed, 06 Feb 2013 23:04:06 +0000
Subject: Re: Suspected renege problem in sctp
Message-Id: <1360191846.1992.8696.camel@amd.troyhebe>
List-Id: <linux-sctp.vger.kernel.org>
References: <5109DDE8.9050700@gmail.com>
In-Reply-To: <5109DDE8.9050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, 2013-02-06 at 10:58 -0500, Vlad Yasevich wrote:
> On 02/05/2013 06:56 PM, Bob Montgomery wrote:

> This is an interesting find.  Seems to me that 
> sctp_ulpq_retrieve_first() should make sure that we don't start pulling
> fragments off the reassembly queue with TSN > Cumulative Ack Point 
> (essentially no grabbing tsns that are after the gap).
> 
> This seems to be Day1 bug in that code as it blindly assumes that the 
> next first fragment is the right one to start with.  The same problem 
> also exist in sctp_ulpq_retrieve_partial().  There is no guarantee that 
> the first fragment on the queue has TSN that is before the gap, so I 
> might be possible to get into the exact same situation with middle/last 
> fragments as well.j

Lee Roberts is testing some ideas for fixing this reasm queue hang.

> > =======================
> >
> > The second hang does not involve the reasm queue.  It occurs on a test
> > where all the events are non-fragmented.  The final state of the
> > ulpq lobby is this:
> >
> > SSN   X
> > SSN   X+1
> > SSN   X+2
> > SSN   X+3
> > ...
> > SSN   X+last
> >
> > And the Next expected SSN value in ssnmap is X+1.
> > So we're waiting on X+1, but X is the first item in the queue.
> >
> > I think that is caused under these conditions:
> >
> > Say the lobby queue had:
> >
> > ssn  10
> > ssn  10  (duplicate)
> > ssn  11
> > ssn  12
> >
> > and we're waiting on ssn 9...
> 
> Hmm..  This is very strange.  We should never accept duplicate SSNs as 
> they should also have duplicate TSNs as well.

I believe we accepted it because when the second one came in, we didn't
think it was a duplicate.  In other words, I believe this problem is
caused by a problem in tsnmap management.

> >
> > call sctp_ulpq_order with event ssn 9:
> > ssn_next is incremented to 10
> > call sctp_ulpq_retrieve_ordered()
> > start down the list and find 10.
> > ssn_next is incremented to 11.
> > grab ssn 10 off the queue, add to event_list and go around.
> > find 10 again and it's != new ssn_next(11), so break.
> >
> > Now we're hung forever.
> >
> > We built a module with a BUG statement on putting a duplicate
> > into the lobby and hit it.
> >
> > The duplicate event was at the end of a group of sequential events,
> > followed by a gap and then another group of sequential events.
> > Coincidentally (or not), at the time the duplicate
> > was sent to the lobby, it was represented by a lone bit in a
> > word of the tsnmap:
> >
> > ...
> >    ssn = 0x30d,
> >    tsn = 0x5505020f,
> >
> >    ssn = 0x30e,     <<<<<<< About to insert this one again
> >    tsn = 0x55050210,
> >
> > Big actual gap
> >
> >    ssn = 0x378,
> >    tsn = 0x5505027a,
> >
> >    ssn = 0x379,
> >    tsn = 0x5505027b,
> > ...
> >
> > tsn_map = 0xffff8807aa430b80,
> > base_tsn = 0x550501d0,
> >
> > crash-6.0.8bobm> p/x 0x210-0x1d1
> > $8 = 0x3f
> > So 63 (0x3f) + 1 = 64 bits set,
> > then 106 (0x6a) - 1 = 105 bits clear,
> > then 12 (0xc) + 1 = 13 bits set.
> >
> > crash-6.0.5bobm> rd 0xffff8807aa430b80 8
> > ffff8807aa430b80:  fffffffffffffffe 0000000000000001   ................
> > ffff8807aa430b90:  007ffc0000000000 0000000000000000   ................
> >
> > fffffffffffffffe   1 off, 63 on
> > 0000000000000001   1 on , 63 off
> > 007ffc0000000000   42 off,  13 on
> 

That first one has to be there or the map will be updated and shifted.

> This seems like there are 2 gaps in the map.  The first GAP is CTSN+1 
> (since bit 0 in the map is not set).  You appear to be filling the 
> second very large gap which is OK.  Can you look through the ulpq to see
> which other TSN had the SSN 0x30e.  It should still be in the queue.

There is no different TSN with SSN 0x30e.  There is a copy of the
*same* TSN with SSN 0x30e.


Here is a dump of the two event structs and of their surrounding
sk_buffs. Check the date codes in the sk_buffs and check the head and
data pointers.

I think these are distinct in memory, and I think that means that we 
accepted the second one off the wire (probably) after sending a SACK
that said we needed it to be resent (because the first one's bit 
was missing from the tsnmap).

The duplicate that we got caught trying to insert in the lobby list:

crash-6.0.5bobm> sctp_ulpevent ffff8807a6b8dee8
struct sctp_ulpevent {
  asoc = 0xffff8807a60d5000, 
  stream = 0x0, 
  ssn = 0x30e, 
  flags = 0x0, 
  ppid = 0x0, 
  tsn = 0x55050210, 
  cumtsn = 0x0, 
  msg_flags = 0x83, 
  iif = 0x8, 
  rmem_len = 0x199
}

Enclosing sk_buff (starts 0x28 below the event):

crash-6.0.5bobm> struct sk_buff ffff8807a6b8dec0
struct sk_buff {
  next = 0xffff88082fcc3800, 
  prev = 0xffff88082fcc3800, 
  tstamp = {
    tv64 = 0x12ceda15c5be1876    <<<<<
  }, 
  sk = 0xffff8807a606c100, 
  dev = 0xffff88080bcf4000, 
  cb = "\000P\r\246\a\210\377\377\000\000\016\003\000\000\000\000\000
\000\000\000\020\002\005U\000\000\000\000\203\000\000\000\b\000\000\000
\231\001\000\000\000\000\000\000\000\000\000", 
  _skb_refdst = 0xffff88082b91ec81, 
  sp = 0x0, 
  len = 0xa9, 
  data_len = 0x0, 
  mac_len = 0xe, 
  hdr_len = 0x0, 
  {
    csum = 0x0, 
    {
      csum_start = 0x0, 
      csum_offset = 0x0
    }
  }, 
  priority = 0x0, 
  local_df = 0x0, 
  cloned = 0x1, 
  ip_summed = 0x0, 
  nohdr = 0x0, 
  nfctinfo = 0x0, 
  pkt_type = 0x0, 
  fclone = 0x0, 
  ipvs_property = 0x0, 
  peeked = 0x0, 
  nf_trace = 0x0, 
  protocol = 0x8, 
  destructor = 0xffffffffa02a663f <sctp_sock_rfree>, 
  nfct = 0x0, 
  nfct_reasm = 0x0, 
  nf_bridge = 0x0, 
  skb_iif = 0x8, 
  tc_index = 0x0, 
  tc_verd = 0x0, 
  rxhash = 0x0, 
  queue_mapping = 0x0, 
  ndisc_nodetype = 0x0, 
  ooo_okay = 0x0, 
  l4_rxhash = 0x0, 
  dma_cookie = 0x0, 
  secmark = 0x0, 
  {
    mark = 0x0, 
    dropcount = 0x0, 
    avail_size = 0x0
  }, 
  vlan_tci = 0x0, 
  transport_header = 0x62, 
  network_header = 0x4e, 
  mac_header = 0x40, 
  tail = 0x127, 
  end = 0x680, 
  head = 0xffff8807a603f800 "",    <<<<<<<<<<<<<<<<
  data = 0xffff8807a603f87e "",    <<<<<<<<<<<<<<<<
  truesize = 0x900, 
  users = {
    counter = 0x1
  }
}

========================
From the lobby list:

crash-6.0.5bobm> sctp_ulpevent ffff8807a6162ae8
struct sctp_ulpevent {
  asoc = 0xffff8807a60d5000,
  stream = 0x0,
  ssn = 0x30e,
  flags = 0x0,
  ppid = 0x0,
  tsn = 0x55050210,
  cumtsn = 0x0,
  msg_flags = 0x83,
  iif = 0x8,
  rmem_len = 0x199
}

Enclosing sk_buff:


sh-6.0.8bobm> struct sk_buff ffff8807a6162ac0
struct sk_buff {
  next = 0xffff8807a60b5e80, 
  prev = 0xffff8807a6162bc0, 
  tstamp = {
    tv64 = 0x12ceda15c58eb79b    <<<<<<<<<<<<
  }, 
  sk = 0xffff8807a606c100, 
  dev = 0xffff88080bcf4000, 
  cb = "\000P\r\246\a\210\377\377\000\000\016\003\000\000\000\000\000
\000\000\000\020\002\005U\000\000\000\000\203\000\000\000\b\000\000\000
\231\001\000\000\000\000\000\000\000\000\000", 
  _skb_refdst = 0xffff88082b91ec81, 
  sp = 0x0, 
  len = 0xa9, 
  data_len = 0x0, 
  mac_len = 0xe, 
  hdr_len = 0x0, 
  {
    csum = 0x0, 
    {
      csum_start = 0x0, 
      csum_offset = 0x0
    }
  }, 
  priority = 0x0, 
  local_df = 0x0, 
  cloned = 0x1, 
  ip_summed = 0x0, 
  nohdr = 0x0, 
  nfctinfo = 0x0, 
  pkt_type = 0x0, 
  fclone = 0x0, 
  ipvs_property = 0x0, 
  peeked = 0x0, 
  nf_trace = 0x0, 
  protocol = 0x8, 
  destructor = 0xffffffffa02a663f <sctp_sock_rfree>, 
  nfct = 0x0, 
  nfct_reasm = 0x0, 
  nf_bridge = 0x0, 
  skb_iif = 0x8, 
  tc_index = 0x0, 
  tc_verd = 0x0, 
  rxhash = 0x0, 
  queue_mapping = 0x0, 
  ndisc_nodetype = 0x0, 
  ooo_okay = 0x0, 
  l4_rxhash = 0x0, 
  dma_cookie = 0x0, 
  secmark = 0x0, 
  {
    mark = 0x0, 
    dropcount = 0x0, 
    avail_size = 0x0
  }, 
  vlan_tci = 0x0, 
  transport_header = 0x62, 
  network_header = 0x4e, 
  mac_header = 0x40, 
  tail = 0x58f, 
  end = 0x680, 
  head = 0xffff8807a60cd000 "",     <<<<<<<<<<
  data = 0xffff8807a60cd4e6 "",     <<<<<<<<<<
  truesize = 0x900, 
  users = {
    counter = 0x1
  }
}


And here is a result of a search through memory for the portion
of an sk_buff that includes the time stamp, sk, dev, asoc, and 
ssn for matches to this sk and asoc with SSN 0x30n.  I sorted by 
time stamps so you can see when the bulk of the SSN 30n pieces
came in and then you can see the much later arrival of the 
duplicate SSN 30e. 

Searching for all the ssn 30X values and (by hand) sorting by timestamp:



crash-6.0.5bobm> search -k -q skip 0xffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30MMMMM

ffff8807a686b5d0:
    12ceda15c58e649a ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3000000

ffff8807a60dc290: 
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3060000
ffff8807a60dc690:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3070000
ffff8807a60dc790:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3050000
ffff8807a60dc890:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3020000
ffff8807a60dca90:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3030000
ffff8807a60dce90:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3040000
ffff8807a686bed0:
    12ceda15c58e7ece ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3010000

ffff8807a6162ad0:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30e0000   <<<<<<<
ffff8807a6162bd0:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30d0000
ffff8807a66033d0:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3080000
ffff88080d7b3390:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30b0000
ffff88080d7b3490:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30a0000
ffff88080d7b3590:
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 3090000
ffff88080d7b3790: 
    12ceda15c58eb79b ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30c0000

ffff8807a6b8ded0:
    12ceda15c5be1876 ffff8807a606c100 ffff88080bcf4000 ffff8807a60d5000 30e0000  <<<<<<<

Output columns:
    sk_buff.tstamp   sk_buff.sk       sk_buff.dev      sk_buff.cb: asoc [stream, ssn, flags, ppid]

This last one at timestamp 12ceda15c5be1876 is the duplicate 30e. 

Bob Montgomery 


