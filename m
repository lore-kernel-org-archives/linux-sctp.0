From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Dec 2017 16:22:05 +0000
Subject: RE: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <27aff622f1574b329e18ba21922f6e7e@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
 <20171208160001.GF3328@localhost.localdomain>
 <CADvbK_ckOgH9vzXVzckEtWAkJaYn9wuhJtZ+qpzep2T6C8Wung@mail.gmail.com>
In-Reply-To: <CADvbK_ckOgH9vzXVzckEtWAkJaYn9wuhJtZ+qpzep2T6C8Wung@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

RnJvbTogWGluIExvbmcNCj4gU2VudDogMDggRGVjZW1iZXIgMjAxNyAxNjoxOA0KPiANCi4uLg0K
PiA+PiBBbHRlcm5hdGl2ZWx5IHlvdSBjb3VsZCBwcmVmb3JtIHRoZSBkZXJlZmVyZW5jZSBpbiB0
d28gc3RlcHMgKGkuZS4gZGVjbGFyZSBhbiBzaQ0KPiA+PiBwb2ludGVyIG9uIHRoZSBzdGFjayBh
bmQgc2V0IGl0IGVxdWFsIHRvIGFzb2MtPnN0cmVhbS5zaSwgdGhlbiBkZXJlZg0KPiA+PiBzaS0+
bWFrZV9kYXRhZnJhZyBhdCBjYWxsIHRpbWUuICBUaGF0IHdpbGwgYXQgbGVhc3QgZ2l2ZSB0aGUg
Y29tcGlsZXIgYW4NCj4gPj4gb3Bwb3J0dW5pdHkgdG8gcHJlbG9hZCB0aGUgZmlyc3QgcG9pbnRl
ci4NCg0KWW91IHdhbnQgdG8gc2F2ZSB0aGUgZnVuY3Rpb24gcG9pbnRlciBpdHNlbGYuDQoNCi4u
Lg0KPiBBbm90aGVyIHNtYWxsIGRpZmZlcmVuY2U6DQo+ICAgYXMgeW91IGNhbiBzZWUsIGNvbXBh
cmluZyB0byAoWCksIChZKSBpcyB1c2luZyAweDI4KCVyc3ApIGluIHRoZSBsb29wLA0KPiAgIGlu
c3RlYWQgb2YgJXIxMy4NCj4gDQo+IFNvIHRoYXQncyB3aGF0IEkgY2FuIHNlZSBmcm9tIHRoZSBy
ZWxhdGVkIGdlbmVyYXRlZCBjb2RlLg0KPiBJZiAweDg0OCglcjEzKSBpcyBub3Qgd29yc2UgdGhh
biAweDI4KCVyc3ApIGZvciBjcHUsIEkgdGhpbmsNCj4gYXNvYy0+c3RyZWFtLnNpLT5tYWtlX2Rh
dGFmcmFnKCkgaXMgZXZlbiBiZXR0ZXIuIE5vID8NCg0KVGhhdCBjb2RlIG11c3QgaGF2ZSBmYXIg
dG9vIG1hbnkgbGlmZSBsb2NhbCB2YXJpYWJsZXMuDQpPdGhlcndpc2UgdGhlcmUncyBiZSBhIGNh
bGxlciBzYXZlZCByZWdpc3RlciBhdmFpbGFibGUuDQoNCglEYXZpZA0KDQo