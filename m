Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D8736A01D;
	Thu, 16 Jul 2026 07:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187774; cv=fail; b=YQjIW/4CYH07sxLRVcjzjZDZ1Ws/SMqm59Nah/a8J+gmfYSAmNvxoxr38EUH9agQY4STbeC0YcmTGVTSP/v33g1UYvoSEfWFWPvwnX9UIGQ5QcSzzUoO6gBn9qXku7xAsVFLQklvPPGweVgrgHPswT532He2WCu36r4IMGMviAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187774; c=relaxed/simple;
	bh=Xu1TPa7RLwbbptxw7g3G6GHxsL+oxTs7PsDM8590aD8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c8WXAHAuIdvSrGeu+aSSRtxZbBhO2WH688yAQYicxnjsczojul5hc7WiBrXJA/1dSQiHaVQxK2PC1BHK/P8a1woj2+0X2xi8SoLj4BhH3urzzLXoxSOqCjvPR8X9XRU9OFbVMwUuqSEtxJLTU5vJ/xx4QTd73InjZsNwbhC7Mq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcjAAduK; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcjAAduK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784187772; x=1815723772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xu1TPa7RLwbbptxw7g3G6GHxsL+oxTs7PsDM8590aD8=;
  b=kcjAAduKImZZauEb/6nKzWjGF9E2SA7u512zyR98avEaTlXZJZq44604
   sZ8TXnlOwwSE0sHbm7hdAkQhVK8+GRLwjCAPaEshg8J8Ab2w754reMhSK
   S4zsl9GaBn8RJ/OFgiR7BpdOGq8NBPrJRRKoZO5AbeL8pvy897hmdEkEH
   B3CMrXiV+/ZNpetdIPA8WmnlM0a8BCQkoRjmx+VnMx1MX0vMvslsoZXHr
   5b5NZ9hQkxi2KIaW7w3QUe9EFPWUZo10nsGf0dZN85pcTyCTn8up8daLx
   0pH0L91fpRLON6GnEYzC6HkD2RaSBxDCBALW1GWsncCQPRSN2vyWo9ceY
   A==;
X-CSE-ConnectionGUID: iGDpZLZHQsWJAhheTdG2qw==
X-CSE-MsgGUID: jnQLTtXYRX+j/f1wOekRKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88517431"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="88517431"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 00:42:52 -0700
X-CSE-ConnectionGUID: o0L2xIxVTX2JT1PplhCmnA==
X-CSE-MsgGUID: K6O7demNQji8gA0vhdJYFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="255909422"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 00:42:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 00:42:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 16 Jul 2026 00:42:51 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 00:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cXGWwpzkGEHfhUeD+FUYa7yAbFVmXvGtfQPP1DNfsmMkXEVuXWSRVvK14GR3u5gluK9EiBp3OFkXeX3FzG8cWMsa1mR8HIgAiUd3qO4qCGRTz5hCFPKifsrUXBvuvJaLvURTOejCQCR/lvrXTVhlIoXQsvV2qKtTDzLeUGca8c82FMY7ba02KHXgadO6WOleVIBWprAJ1FD8E76pLeloFFdZ0QEJ9o3ftfWcWuy+I2a/itQ8EmqHpkj8nc9nwv/7a9Gx9dzsr5n5kaGsfDdu3Px1mq+3Gh6ugHCp9IG2ZYex5k2r7dIQzKjGghUzD4d4D7+BeWtagEjLAbJBKD8FjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nuWHv0agofcD3A0AHVB1zYV+OBg4xFkTitV53pQwgw=;
 b=JINvdH+EAFCBTVL8ME8ARL3LTERk8T3SMgarASZ1XvFLIVS1dghftJxl+bBwyrDI2WVd17BYJBb/ppicZWt+QlWyf+6DTDt6nt6Z0nUdXvsrKWV8wbpADO/jJKSCSRDJtPE15nvTabS7kUI44ar9ZmMDlyYzeCxq9c/BmpyBiJEPZGddyFE2RHl9QcPUhcnz86NDH6xdmFTerURUS0Ipmajdz2Fifnfm228jhctDczb9rzPevcV3JBHSWT5HRZTEU9nOi+N4b8+VIcIucyiNHpS6wdd3NfO13NXsndkWvMae9AGhJai418pG+FdMUo1lqFQMEqUQ2rYOlM3VBTpl7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5902.namprd11.prod.outlook.com (2603:10b6:510:14d::19)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 07:42:43 +0000
Received: from PH0PR11MB5902.namprd11.prod.outlook.com
 ([fe80::f95a:602a:34d3:5d37]) by PH0PR11MB5902.namprd11.prod.outlook.com
 ([fe80::f95a:602a:34d3:5d37%4]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 07:42:43 +0000
From: "Jagielski, Jedrzej" <jedrzej.jagielski@intel.com>
To: luoqing <l1138897701@163.com>, "marcelo.leitner@gmail.com"
	<marcelo.leitner@gmail.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>
CC: "horms@kernel.org" <horms@kernel.org>, "linux-sctp@vger.kernel.org"
	<linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "luoqing@kylinos.cn" <luoqing@kylinos.cn>
Subject: RE: [PATCH 1/2] sctp: socket: Fix uninitialized error on socket
 shutdown
Thread-Topic: [PATCH 1/2] sctp: socket: Fix uninitialized error on socket
 shutdown
Thread-Index: AQHdFPAkL151NXqgdU26rSRCnEibUrZvwqMQ
Date: Thu, 16 Jul 2026 07:42:43 +0000
Message-ID: <PH0PR11MB5902DBD696C30DB0A2308A49F0C72@PH0PR11MB5902.namprd11.prod.outlook.com>
References: <20260716065259.872235-1-l1138897701@163.com>
In-Reply-To: <20260716065259.872235-1-l1138897701@163.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5902:EE_|IA4PR11MB9419:EE_
x-ms-office365-filtering-correlation-id: 2dca3593-a623-421c-003e-08dee30dd227
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|38070700021|22082099003|18002099003|56012099006|11063799006;
x-microsoft-antispam-message-info: BMnCSuI22/KcZE7Q1D+gQrUWBBoudfNNGL20U/MXDSZa8INoWIdg2Aus2WeDWOBjEueVTgrOTSuhgpCw9R3+u4nxIqVI9TWlIWMMFo1dBPiQv0+FqPolIOFkoBezYj4XOnTVgjucj8zL8gFWCMkFq0HPlQ6OZnyogzlqNxK2rQne1aJZFwwTqzTGSmvZqW9RhnAjVAhdnlLGnoWmhwyHqfUrDnG19YFv+mTQAs21o1ENgRgzhMkjNF0LqYLhVJmdzfd/xJ6oA4W5uyBuhDVt7sacdddZJoUWKzazMoms87JRFcQZtCiszjh4ylVWSynf0SfK4/CKZaytw3ZVCM6JUaR8Ch7hitSp9ozFQ2ncohlIcoWWH9/X4GYtHxwlVMPoVo8jZGTinZEpTvqkr5xfOGcilkda5+Pj/AXEmxusYHPHsa3M8KMmhvak7jSpsBb8ODtV2hBS/N+h2I7RMM7Xpzwb66ubvDWIIdX3nwyIrxueSKRi1P41B0NjA5K6nLpvURQS+JlSgsjRinsXUqOrng9zwnsOrjWBTEnxhRnLNkXll4/AnqEFgjdgHskuGTx0JrzJ25xeZmrJLBnUQiB3yium0cry40TDr+WEJptY7vRz3vmniqms++Nf94kpWT4Y3RWjU2cBD26NqE4DcFky/JDVu7fvcTUkNiNGmaY+TIwWNM9m2ErQ8GtNl9gc6MIss3P19PyNStQ4qIKSlSVgaqADPmUwwnkzOUt+PYNG0mQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5902.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(38070700021)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pBdr4p6rQ5v0eaJCvwaxYHiKWXzy2Kq9YKBO9rwPJDBMCA1/tbLqApC7B3pF?=
 =?us-ascii?Q?TTpEuF1vX3mX9WsAxuA/JNx5a6Sx7qvF5f0p1XvF7fVSKybdICJr4b9wQU6R?=
 =?us-ascii?Q?x9UbsKy5q6NgKZ2miMwbgKNSwCMyZG9XcJjXlXWQHH9a7i1cUry2lIOFA3PJ?=
 =?us-ascii?Q?fgviACCO5f51htCZjWqJtmqU5BigXzIQ+0UUA1ac6X/t6Yg7hFc8juyLU5HZ?=
 =?us-ascii?Q?ul5rxVpjS2kewgiTvgVGYtuV9C7NdCkzpZB+WpmKxFzsOB1e7+nKoMBuoWa8?=
 =?us-ascii?Q?3fTNmI7joODBNyu1wE+5NTdkAJ+tP74UeciLkewuQvb6pynJ7jE7QAfiOcqI?=
 =?us-ascii?Q?RhrvfR2ekQomCB59gAgJZR8YBBlnSyj/EshKyYkwwWwycLx4ndcif8ooFSeP?=
 =?us-ascii?Q?N0o8BvQjxetZuN85n0elZeYLf+jiljzZfsxcf2u88D5I6LuKnhw2Gz0YJt3d?=
 =?us-ascii?Q?ByocwGOPXI95ifjwHhEO6Kdt3TEj99UtQp4/CMk7zMcmv1abfX50cN7KgtYY?=
 =?us-ascii?Q?61sFq8DClhqXkaAP/JruAFhPoFak/MpC8DgRGy8urfMnIaCgDfdL36qVk0Bi?=
 =?us-ascii?Q?cz30OLBFu3LW77G8hdpmKzY+dTA5Fi9Oe+s/tevzUNoM5OW+L8rm3g/9vup3?=
 =?us-ascii?Q?5vbgEwhMPg23FRq7fph6n1jL6CYq1Ucw8RiVnGZx8+/twdlrGMxhYZu9aZQR?=
 =?us-ascii?Q?cULgNFXA8hC+4dunpKGmyCR+7Itwcqg6D/HBLdoQtnsJcgSD2e4OFIFBoYtg?=
 =?us-ascii?Q?eXFm/oWriSDcfNyWN/KU0tPsVGwRt9c/3iBenfpiVNzd8gksYkt4158YHfM5?=
 =?us-ascii?Q?7x3ySs9Z0ManliUgpWPJerbbrptGVl2P9s3CtuL7HrR4631J9ac75AkD7kzK?=
 =?us-ascii?Q?GI5uRw93Vcr23EL80x+Z3BNi1tUejvJMxAP7PdDtifwzviqmLI8pE+2QxiXh?=
 =?us-ascii?Q?hKIxdR+BwV2GSr57C3SswbnOub7xAjrO5+VfQ0rx+6URZO6br71r34ZUEj3k?=
 =?us-ascii?Q?bHayNcPeLdyjxr8kHPcmeRa8tdG2OfLnLyZF6as9BLSiG3RZgg6g9XOP/kMW?=
 =?us-ascii?Q?V/EgS1ETiF4u/Cmx8U1VUzpcXt4hGVfKvqKEpts6YUCw/KdmWrJHM50dhWp8?=
 =?us-ascii?Q?flioT3AXqESRfjo6VF5XOTVD8wKXIzBQ0EhXy6fkNKxhhSJIqPzvx/IibNMS?=
 =?us-ascii?Q?Ldg/9oYUGCFKD4wePy5xWmdOWuQxFLwkdtbSwY5MoWCupJLc1CQ/JLzJncFp?=
 =?us-ascii?Q?f+r3/U3KoHnAeicC7lKvDXtfDmYu3Z5e6zjYU9G1LEZtd+kj2weo2J9hY90H?=
 =?us-ascii?Q?g6e6ZoZh3tP+oJaqqvcKyMM38dA9J09TXD9gestTbIF2MksR9eA2kwAEiEpe?=
 =?us-ascii?Q?aS/4DLiaeuUOB6jsc03aCRWKt5fVaEQIG0g2K6OEn54r7GkVBMPRzTHBcdLq?=
 =?us-ascii?Q?cPK9BnTG3pZ4i3XYXBkC0JBXIgQTiUxXz9A/LM0LmIIZAm5mxhDX8kv76evL?=
 =?us-ascii?Q?dvri+YUEXl7WrcEhAzQdkUwKWyz1u44p2r0WplDiuX+ZOQ8OcdDjQX5lZ1mr?=
 =?us-ascii?Q?Uy9lokG92hiIAjX4FVwJCLRVKSXeSuFm5fqNJqXz5IHFhFJFHwl7M3j2BxdZ?=
 =?us-ascii?Q?IdCkvDO+ruO/JAGqWgSPz/zmeemAvP/L546mhtHiSjW/aFmz7Z0xzPOXKP5k?=
 =?us-ascii?Q?4C55B+/9k9LEkYz4YLx/oB0hd42bK1ik3D03aWLohPZnmBdpVt/XjDU8rIdT?=
 =?us-ascii?Q?SFRcspZRVQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: V8JaadCY4TgXjjFXeOPrM8ZD3LanMjlKKj28xTE/wVMVISUqVj3z+P+qaC0nhWZaag4tp6UTaUjBi3/ysBvJ+ulfGXQkL6jBJcbXHUgmkGf6blKk5UUHyPNeQ8zuRBDMbFYmora/hvEa6+ROxC6rG2a19pRzq6nGwEWCjyfdSaBkL7tYda4aRTNXKRn1yle5e/EXcyiiFekgaKUicrSC2ARTf+oGM+/6o7R/lXSNVuq95WS3B2EB3vWwZhoYPbMoUXmXgb0A4m5cm58NSEZtrMAHAHJsMNhsH44VhpieFI1AtXfDd+1JIUoRWvatprMHJxoFqz+uCZy3853JGD6/qw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5902.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dca3593-a623-421c-003e-08dee30dd227
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2026 07:42:43.3018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xfrl789UIFdHOguleQ3+3EddfgSRlH4IedCBGGi3IwxALCuQJIBVLi/nJGDtwdXJhSTA4EUiZR4EmBOni7gaLUIxhnzmR1P34grcATyBask=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

From: luoqing <l1138897701@163.com>=20
Sent: Thursday, July 16, 2026 8:53 AM

>From: luoqing <luoqing@kylinos.cn>
>
>When sctp_skb_recv_datagram() detects sk->sk_shutdown & RCV_SHUTDOWN,
>it breaks out of the loop and returns NULL without setting *err.
>This leaves the error pointer uninitialized or with a stale value,
>which can confuse callers expecting a clean shutdown indication.
>
>Compare with the generic __skb_wait_for_more_packets() in
>net/core/datagram.c which properly handles shutdown by setting *err =3D 0.
>
>Fix this by setting *err =3D 0 before breaking when the socket is shut dow=
n,
>indicating an orderly shutdown rather than an error condition.

Hi luoqing

patch title should contain target tree
fix patches should contain 'fixes' tag and be targeted to net tree
please put Name + Surname for the signed-off-by tag

>
>Signed-off-by: luoqing <luoqing@kylinos.cn>
>---
> net/sctp/socket.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>index c7b9e325ec1c..ea7050b27715 100644
>--- a/net/sctp/socket.c
>+++ b/net/sctp/socket.c
>@@ -9117,8 +9117,10 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock =
*sk, int flags, int *err)
> 		if (error)
> 			goto no_packet;
>=20
>-		if (sk->sk_shutdown & RCV_SHUTDOWN)
>+		if (sk->sk_shutdown & RCV_SHUTDOWN) {
>+			*err =3D 0;

from what i see any of the sctp_skb_recv_datagram() callers doesn't use
@err - so at this point that fix doesn't affect any code
i'm wondering if we could just drop @err

> 			break;
>+		}
>=20
>=20
> 		/* User doesn't want to wait.  */
>--=20
>2.25.1


