Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C50C433EF
	for <linux-sctp@archiver.kernel.org>; Sat, 16 Jul 2022 12:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiGPMNm (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Sat, 16 Jul 2022 08:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGPMNm (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Sat, 16 Jul 2022 08:13:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 146811C10A
        for <linux-sctp@vger.kernel.org>; Sat, 16 Jul 2022 05:13:35 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-230-08Eo3nYqMFK6fXeSk05hcg-1; Sat, 16 Jul 2022 13:13:32 +0100
X-MC-Unique: 08Eo3nYqMFK6fXeSk05hcg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Sat, 16 Jul 2022 13:13:31 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Sat, 16 Jul 2022 13:13:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'o.evistel@free.fr'" <o.evistel@free.fr>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     linux-sctp <linux-sctp@vger.kernel.org>
Subject: RE: Linux SCTP performance question
Thread-Topic: Linux SCTP performance question
Thread-Index: AdiZDXbD/Hs0BhtUSVuC4iETTaIO1g==
Date:   Sat, 16 Jul 2022 12:13:31 +0000
Message-ID: <fba43514485c4fdcb015ef931e7e3fc5@AcuMS.aculab.com>
References: <6f6f11b5c30bce3d6e77d719ef75112dee75250d.profile@marceloleitner.u.sourceforge.net>
 <YsbiDrG1PQ2Gng5T@t14s.localdomain>
 <1937458162.418765580.1657717120765.JavaMail.zimbra@free.fr>
In-Reply-To: <1937458162.418765580.1657717120765.JavaMail.zimbra@free.fr>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

RnJvbTogby5ldmlzdGVsQGZyZWUuZnINCj4gU2VudDogMTMgSnVseSAyMDIyIDEzOjU5DQo+IA0K
PiBJIGFtIHVzaW5nIGxpbnV4LXNjdHAgYXMgdHJhbnNwb3J0IGZvciBTSUdUUkFOIE0zVUEgb24g
UkhFTCA4LjQgYW5kIEkgYW0NCj4gdXNpbmcgc2N0cF9zZW5kbXNnKCkgYW5kIHNjdHBfcmVjdm1z
ZygpIHRvIHNlbmQvcmVjZWl2ZS4NCj4gSSB3b3VsZCBsaWtlIHRvIGtub3cgaWYgdGhlIHVzZSBv
ZiBzY3RwX3NlbmR2KCkgYW5kIHNjdHBfcmVjdnYoKSBlbmhhbmNlcyBwZXJmb3JtYW5jZXMgPw0K
DQpFdmVyeSBjb3B5IHRvL2Zyb20gYSB1c2VyIGJ1ZmZlciBoYXMgYSBzbWFsbCAoYnV0IG1lYXN1
cmFibGUpIGNvc3QuDQpTbyBhbnl0aGluZyB3aXRoIGFuIGlvdltdIGFycmF5IGlzIGEgYml0IHNs
b3dlciB0aGFuIGFuIGVxdWl2YWxlbnQNCmNhbGwgdGhhdCBvbmx5IGhhcyBhIHNpbmdsZSBidWZm
ZXIuDQpUaGlzIGlzIG1lYXN1cmFibGUgd2hlbiBjb21wYXJpbmcgc2VuZG1zZygpIGFuZCBzZW5k
dG8oKSBvbiAoc2F5KQ0KYSBVRFAgc29ja2V0Lg0KT1RPSCBpdCBpcyBhbGwgcHJvYmFibHkgbm9p
c2UgdW5sZXNzIHlvdSBhcmUgdHJ5aW5nIHRvIHNlbmQvcmVjZWl2ZQ0KJ3NpbGx5IG51bWJlcnMn
IG9mIG1lc3NhZ2VzLg0KDQpSZWR1Y2luZyB0aGUgbnVtYmVyIG9mIHN5c3RlbSBjYWxscyBtYXkg
aGVscC4NCkJ1dCB0aGUgY29zdCBvZiByZWN2bW1zZygpIGNoZWNraW5nIGZvciBhIHNlY29uZCBt
ZXNzYWdlIGlzDQpzaWduaWZpY2FudGx5IGdyZWF0ZXIgdGhhbiB1c2luZyBlcG9sbCgpLg0KU28g
dW5sZXNzIHlvdSBhY3R1YWxseSBleHBlY3QgbG90cyBvZiBtZXNzYWdlcyBpdCBwcm9iYWJseQ0K
aXNuJ3Qgd29ydGggdXNpbmcuDQoNCkFzc3VtaW5nIHlvdSBoYXZlIGRpc2FibGVkIE5hZ2xlLCB0
aGVuIHRoZSBiaWdnZXN0IHBlcmZvcm1hbmNlDQpnYWluIHdpbGwgYmUgZnJvbSBzZXR0aW5nIE1T
R19NT1JFIHdoZW4geW91IGtub3cgeW91IGhhdmUgYW5vdGhlcg0KbWVzc2FnZSB0byBzZW5kLg0K
V2l0aG91dCB0aGF0IHByZXR0eSBtdWNoIGV2ZXJ5IE0zVUEgbWVzc2FnZSBlbmRzIHVwIGluIGl0
cyBvd24NCmV0aGVybmV0IHBhY2tldC4NCg0KWW91IGRvbid0IG1lbnRpb24gd2h5IHlvdSB0aGlu
ayB5b3UgaGF2ZSBhIHBlcmZvcm1hbmNlIGlzc3VlIGluIFNDVFAuDQpJIHRoaW5rIHdlIGdvdCA0
MDAwMCByZWZsZWN0cy9zZWMgZnJvbSBhIHRjYXAgYXBwbGljYXRpb24gb3ZlciBNM1VBDQphbmQg
U0NUUCBsYXN0IHRpbWUgSSBtZWFzdXJlZCBvdXQgc3RhY2suDQoNCglEYXZpZA0KDQotDQpSZWdp
c3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9u
IEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

