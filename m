From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Dec 2017 17:29:00 +0000
Subject: RE: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <b727ce7a5f8746219987775dab5d1e1a@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
 <20171208160001.GF3328@localhost.localdomain>
 <CADvbK_ckOgH9vzXVzckEtWAkJaYn9wuhJtZ+qpzep2T6C8Wung@mail.gmail.com>
 <27aff622f1574b329e18ba21922f6e7e@AcuMS.aculab.com>
 <CADvbK_ct1cGSFZ68RaTh8=T6-Z8v0nFSruMti-L2fA393ti9pA@mail.gmail.com>
In-Reply-To: <CADvbK_ct1cGSFZ68RaTh8=T6-Z8v0nFSruMti-L2fA393ti9pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

RnJvbTogWGluIExvbmcgLi4uDQo+IEhpLCBEYXZpZCwgU29ycnksICBJJ20gbm90IHN1cmUgd2Un
cmUgd29ycnlpbmcgYWJvdXQgdGhlIGNwdSBjb3N0IG9yDQo+IGNvZGVzIHN0eWxlIG5vdyA/DQo+
IA0KPiBGb3IgY3B1IGNvc3QsICBJIHRoaW5rIDB4ODQ4KCVyMTMpIG9wZXJhdGlvbiBtdXN0IGJl
IGJldHRlciB0aGFuIHRoZQ0KPiBnZW5lcmF0ZWQgY29kZSBvZiBpZi1lbHNlLg0KDQpOb3BlIC0g
dGhlIGNhbGwgeHh4KCVyeXl5KSBpcyBsaWtlbHkgdG8gYmUgYSBkYXRhIGNhY2hlIG1pc3MgYW5k
IGEgY29tcGxldGUNCmNwdSBwaXBlbGluZSBzdGFsbC4NCg0KVGhlIGNvbmRpdGlvbmFsIHdpbGwg
YmUgYSBkYXRhIGNhY2hlIGhpdCBhbmQgdGhlIGNvZGUgKGZvciBvbmUgYnJhbmNoKQ0Kd2lsbCBi
ZSBwcmVmZXRjaGVkIGFuZCBzcGVjdWxhdGl2ZWx5IGV4ZWN1dGVkLg0KDQpTb21lIHZlcnkgbW9k
ZXJuIGNwdSBtaWdodCBtYW5hZ2UgdG8gcHJlZGljdCBpbmRpcmVjdCBqdW1wcywgYnV0IGZvcg0K
bW9zdCBpdCBpcyBhIGZ1bGwgcGlwZWxpbmUgc3RhbGwuDQoNCglEYXZpZA0KDQo