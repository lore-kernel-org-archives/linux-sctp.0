From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 09 Dec 2015 16:31:49 +0000
Subject: RE: [PATCH net] ipv6: sctp: clone options to avoid use after free
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1CBE9B1C@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+YjXJoh3uGDp=FJkYVnjaMxFSPY252ptbDGZ-LQ9JAEWw@mail.gmail.com>
	 <CANn89i+V-GeD3zCzGPAo4jY8Z6iTjFN3U1ixG44WyKKLOZ9Txw@mail.gmail.com>
	 <20151209145917.GA3884@mrl.redhat.com>
	 <CANn89iLhetNbtO6h99zZOrCiMYON50vzVsk7j_AtosXejvvm4Q@mail.gmail.com>
	 <1449674706.9768.5.camel@edumazet-glaptop2.roam.corp.google.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1CBE9A61@AcuExch.aculab.com>
 <1449676782.9768.9.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1449676782.9768.9.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Eric Dumazet' <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>

RnJvbTogRXJpYyBEdW1hemV0IFttYWlsdG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gU2Vu
dDogMDkgRGVjZW1iZXIgMjAxNSAxNjowMA0KPiBPbiBXZWQsIDIwMTUtMTItMDkgYXQgMTU6NDkg
KzAwMDAsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiA+IFNDVFAgaXMgbGFja2luZyBwcm9wZXIg
bnAtPm9wdCBjbG9uaW5nIGF0IGFjY2VwdCgpIHRpbWUuDQo+ID4gPg0KPiA+ID4gVENQIGFuZCBE
Q0NQIHVzZSBpcHY2X2R1cF9vcHRpb25zKCkgaGVscGVyLCBkbyB0aGUgc2FtZSBpbiBTQ1RQLg0K
PiA+ID4NCj4gPiA+IFdlIG1pZ2h0IGxhdGVyIGZhY3Rvcml6ZSB0aGlzIGNvZGUgaW4gYSBjb21t
b24gaGVscGVyIHRvIGF2b2lkDQo+ID4gPiBmdXR1cmUgbWlzdGFrZXMuDQo+ID4NCj4gPiBJJ20g
d29uZGVyaW5nIHdoYXQgdGhlIHJlYWwgaW1wYWN0IG9mIHRoaXMgYW5kIHRoZSBvdGhlciByZWNl
bnQNCj4gPiBTQ1RQIGJ1Z3MvcGF0Y2hlcyBpcyBvbiByZWFsIHdvcmtsb2Fkcz8NCj4gPiBXZSBo
YXZlIGVub3VnaCB0cm91YmxlIGdldHRpbmcgb3VyIGN1c3RvbWVycyB0byB1c2Uga2VybmVscw0K
PiA+IGxhdGVyIHRoYXQgdGhlIDIuNi4xOCBiYXNlZCBSSEVMNSAtIHdpdGhvdXQgaGF2aW5nIHRv
IHBlcnN1YWRlDQo+ID4gdGhlbSB0byB1c2Uga2VybmVscyB0aGF0IGNvbnRhaW4gdmVyeSByZWNl
bnQgZml4ZXMuDQo+IA0KPiBJdCBhbGwgZGVwZW5kcyBpZiB5b3VyIGN1c3RvbWVycyBsZXQgKGhv
c3RpbGUgPykgcGVvcGxlIHJ1biBwcm9ncmFtcyBvbg0KPiB0aGUgYm94ZXMuDQoNCklmIHRoZXkg
cmVxdWlyZSBob3N0aWxlIHByb2dyYW1zIEknbSBub3Qgd29ycmllZC4NCg0KQnV0IGl0IGlzbid0
IGVudGlyZWx5IGNsZWFyIGZyb20gdGhlc2Ugb29wcyByZXBvcnRzIHdoYXQgdGhlDQp0ZXN0IHBy
b2dyYW0gaXMgYWN0dWFsbHkgZG9pbmcuDQpTb21lIG9mIHRoZW0gbWlnaHQgYmUgdmFsaWQgc2Nl
bmFyaW9zLg0KTm90IHRoYXQgb3VyIGNvZGUgZG9lcyBhbnl0aGluZyBjbGV2ZXIuDQoNCglEYXZp
ZA0KDQo