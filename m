Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794829556;
	b=lKHCqaJkGR3vudSd4oCfJWwJ6YvV32/CmWn3QuWlEgCBBt1kBdCvG42pChQRKCYI+0gX
	 7KvPlVRdbJf2x4IS0eJworSg+6phIuAgl4Fm6vSTra+/N1jQRBOMs4gn/8TMQIvOqbk1T
	 i+jel0eUmPgIwr9RwUbYJpXfBBx1E/p7k/f580aqV1O/nQBxxM9NiZVettKfXTL7NcyMn
	 dI/PsxkNzKCuPXJSwFOGvidvv+Y0TMWXP8TSH8efoyM4FkiGZsGPtYNzQ4Dwq8ZvurZYc
	 87pNNiZcfuHxEUIK8ff02zi8GGNbLA0LthR3fzw9UZBvyzJW+3xh4azdW/0zLYzyGVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829556;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ncvAs8HK1ztypXwUFy/DD0aiHsuh8BRn3Ad8z+qMCnQ=;
	b=HM0d5aswa3fmGvhdN++ZAQ7uYNoM0elcDOXVDoBN3WkyEXk8ddrpCOGUK9WnXbpdV7DI
	 e7VlMhT2urYYI1dZWuCg8DtZy2u6vwmAMeQoXWAqCbEdyq9RMgWacVJtOZ+mqm5TmGsys
	 GpSZreWtSzSf1Xdb4IV3UZo9GS0m6RLCGzayNSSOcdXVUezbZzR4vFrsKGVYFQpRI2LYL
	 M0tDgKWxn3HfLqUbZvdIavTPP2FCmLrqFUopugnoP7B9tDnH8Km7VO+TeJtdRW5rj6MyI
	 o1wjwp9YwHKlOjegDtCg+zxAogIjIenRbe2DBglTzZUIpUt8wFArxHT7ZVeL9NrU7OA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BcCDCN12;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.27
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010027.outbound.protection.outlook.com [52.101.61.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A54606A323;
	Mon, 16 Nov 2026 11:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9A54606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BcCDCN12
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXA8JxJLe5tm+9TBVxCQeEXPcfBkvfbS/+QZsFUS2i+tniTk6Mu5loDm75yiTVV7NiYTPB2Yq1mWjWjT+0C/VrsoXufADJF7WnzoRVAOtGenqJGrdjb+lK6vD2L/NHwds9sjM6GtGw3CY9EaBGohiNB6cHBbx7sd+NbIANa6hj7aLL0zLtEK4a2pN10lilDv7YcFygCVt4QUr0zh0veG991HYl3fPEHX9CwkwNAfvYN9Q5lmhbKLUyp7x+Hp265T3qRkG91uECDFnXS8UciLPjDhMzo1x1EtiBTFv0RliaNzSeLSqMNKvhhGZNGQd5GCDuad3PPdPJHHNt2EFFVphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncvAs8HK1ztypXwUFy/DD0aiHsuh8BRn3Ad8z+qMCnQ=;
 b=KDwMrDU6EQHX9OMuhwVray+YJVYZ4U4FiC3kmvmKgKbvYwjk4fM8yyeGZRBEoYrqSVyq3iskbc8DbPAtFm0UiNYRSAwj6ei+iktFRb/9pNVgmWwyYDpfZDqIQvNjuRXH8/cyuUIKngz/TDQ7dl6yVEe4HF5xrUckl56xAXYbOm4A+t4Fc8kaULbLHDdnuIGhCHOaipgiG0rLqPVB0e4AXq/O8DCgq8FkxYekb75yVNWZeVG/g2+fVJF10w4hK+ZMH+Q+cPzew+GKAXNPXXPxXueQa33Vps08yAPHK2t6Y9OEhGOHpRDUrBaAXouvEMqMWkCErUsSgPtXN21Fc8qzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncvAs8HK1ztypXwUFy/DD0aiHsuh8BRn3Ad8z+qMCnQ=;
 b=BcCDCN12gfhjFfY3MeV+5ZagP69Al+iY4EU3qdj+JBiIWcIww7acvIM3lhvHTAKxQQNed54TpA/yToRXpdaLgm4xxnoP1eroCLOEgCP3wzyE9KWFb42+0dro0NAc0kHvEGUjTNqpH2IOBMneZju/S6v3dDm9PyYlpH3LrVB+PrdV7PEFyztXWgBA9MoGIzQyQBh/x8ggsilnuscLLbhNn3Ox2DNVqFg3Jv3mwNkD5sSAmrPGRsjaUqc+1NE80iEZy1CyctybtQHNQlSLfNr2Aepv56j16F9inxb1/6WV59vWXlWAMiUQfVWX5NLwbtaadK6LzEFPJaE1FDZ3f5DiIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by SJ2PR12MB7942.namprd12.prod.outlook.com (2603:10b6:a03:4c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 11:45:39 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 11:45:39 +0000
Date: Mon, 16 Nov 2026 13:45:29 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Eric Dumazet <edumazet@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Justin Iurman <justin.iurman@gmail.com>,
	Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Stefano Brivio <sbrivio@redhat.com>,
	Hyunwoo Kim <imv4bel@gmail.com>, netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org, dev@openvswitch.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net 2/5] ipv6: mcast: use
 skb_set_transport_header_careful() in ipv6_mc_check_exthdrs()
Message-ID: <20261116114529.GB208668@shredder>
References: <20261113124625.4010206-1-edumazet@kernel.org>
 <20261113124625.4010206-3-edumazet@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113124625.4010206-3-edumazet@kernel.org>
X-ClientProxiedBy: TL2P290CA0017.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::7)
 To LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|SJ2PR12MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6d5cbd-9308-4285-dca3-08df43d7228e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|18002099003|22082099003|261009223027099003|11063799006|4143699003|56012099006|261028144727099003|261102130727099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cSSeTN8W5vZO3wPiV+hDarX0pVc63BaJuD5iGfQdvrj6uUoCdKoSeFgAJZctjN9+BywsiQihmoNYNr6Iais2Erxa0WLPE2UTtsWyypCC5E9b1fRrucDpJDck0ar7TluVdpOjAUPhew7HhheKDAfuWBriZT9R43+Y/DMNbh6a6MwUVMRRiV4P/sL9ekqsi/UQmONZhOiXhf83vEAUC1NSwBAOL5aZtD9cI5ZREtlyUaVEHN7XQ+jfVPxj2i+1SKeuDuszTxFyK1G9bn8f81Szfj79h0Uor5icSBbIkPA5SIL/J7r1uewbz0gGrDJVABwS1cd1GC50TXnXaqWEionqTdBxt2npNUJNrX4ZMpBwbF3lCEt7e2Ii+7avJCuksEaH11nTVQTUM2JKy/UN0UZDsOVaYbEdFvT97dorUghtA4tf0ec593jIc5UD8QUnuykCFtnFcvJX58oV1GFY7136XqXzJIhkaBoShNj8YSuZJqzl9ePbfdTat/0tc9/zzEPJJWbqN1N0Q4EEpMSAnWtLK+9X4bce/hpG7ha4a72oMBiF4WkvEBA3fviSpbxFo6Gwgz2qzq37lmZe0ok8CDdD/YBapzgLZBf69lgoCCvvbVJ1hA88j76JkvsMMfV7uU0zPkz7tKZtkY74oX18zFfa0AotRU/+0htylfaXj+nd8DA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(261009223027099003)(11063799006)(4143699003)(56012099006)(261028144727099003)(261102130727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QmpgQe5WpnOT5cxEZ8fvJCiDj7CJ4kUpbz9m3QGBniFWGfoBlcEbFyxT9fwn?=
 =?us-ascii?Q?XfGgImSCqeYNuOS4ztppeW0rd6k3tduv4/SustmjdLiximoA+yWuhp9wg7cA?=
 =?us-ascii?Q?rmD1gXWMRs0JREysK6X/Oobj5YSKqpCV8qvrODm/XA/39HBHZBiYTeD8Kyrd?=
 =?us-ascii?Q?5Udni/tszW/0VyzG91UM8vxYjoiLDpN3CRF2awuaJ0Ewk1wSELFnEHkBKG9U?=
 =?us-ascii?Q?L0+UQKSF4CZrj86ZuIm2SgDEdA6Q+63V93xk1a605G1zRhiMwG55WOCjwoLv?=
 =?us-ascii?Q?RnTAVeb+AdRBwja/Xu/vdjU6lJfkeAupzgZyuyvvCMnnCfuA9XKnf1mjw91Q?=
 =?us-ascii?Q?gHTNrJTVYDIqOTQfo+uh7ecOPwueoviNuxWxZqnOfnNnEl0rslqQwtNrqQWq?=
 =?us-ascii?Q?DZILI8mT5jS/cXZf5FS9kCqtT0uX04T4pNPWABsxJMzFLmhRuAbEmCiCIiDl?=
 =?us-ascii?Q?3MCCtwCvBij8ZvPw62AnyFgCzfAhRXfeG4dIsBy474bduwHgKZMBxtNNX8nH?=
 =?us-ascii?Q?foojiSsE/oznpQwsPWO5zV+kHYYrj2PFNta5uO025SrZlOr3RqQjGsgRmv95?=
 =?us-ascii?Q?/geBxezZTOwJthIc4aKM9pD/CAuiUUzfVg2+6tz3bH5Ln4bkdPkc0N+XsJTH?=
 =?us-ascii?Q?2TRsbUKBxCax/4fgDIO/PdvwpskpFDzpRSkT+NLfzYWxZB+gVk0ZDQc7qcAg?=
 =?us-ascii?Q?DlHB+aQM0gm7HRc2pc9w7Yz4BGMu2isqarvBm6eqO4PmS+YISlJfqSlm8HA8?=
 =?us-ascii?Q?9vnJ5gmt2nnUw42WfGqFyzdz6VTwEx9jyRNhpI+sj70SIvq9TwfqLf0OUIsx?=
 =?us-ascii?Q?a/ZQScbUNQDwF2ceO30Bl5IUAOdTdIiXiAcZFqtJSB6hgXwYDgdFVnQVMZio?=
 =?us-ascii?Q?ia42/vgtxPMLMV7P9AIj2qRI5kaaiHX1mrYszgY/S/IPPOOSwPHXvbU/sQx0?=
 =?us-ascii?Q?12o8C0dC/2C0QIadc/p24pgG8GXvSTMovXCVZ9hduk81N+wFc4mdKJy8g8ag?=
 =?us-ascii?Q?sPygv/7GknRNHICPyD+7FXk885ChQ0Kbn4F6dJKNWR8xg840YZEmxV65U7rA?=
 =?us-ascii?Q?on04Gam5l6UOIxhcq13IVLc0s2xNoDCYwazC5vM/1w4SZwNZunwjvGFrPtZx?=
 =?us-ascii?Q?jPQwMP/9BL1ntpX2T4VgONHOmiR6W+xpwDwaGgkXeyzzFs+CvvTmoq4396in?=
 =?us-ascii?Q?D8T9CBCRdORHndkFLC5Ha8gQVhn+4ZT2RoFwdXvaS8jfLP7F5OUjCOymi4u6?=
 =?us-ascii?Q?Cce1mc+2ei8fEg3wU8dy8d1XT2Tj3difNBhBPDpeFg4+pREJ3BwBlQ3pZ3VU?=
 =?us-ascii?Q?XCFUZScbeR4ca0pgERTstrfq7U7w6MJvWZDRu7SrKw48PFk2z7HncFZH8TBx?=
 =?us-ascii?Q?E7uKhIdtuAN5R/Dcq9f8QTo5OqcdRZrBb/06tHhEp9UwcwaXQI6OX3RLOsX9?=
 =?us-ascii?Q?PLjeN/Y+MHoOParW/Im5Yr03JjvXWvd6XW33nbn/oUR6+7JaifqjA7Xles2d?=
 =?us-ascii?Q?yk45WTKkzj0TcwrJMZNPrmzU44X96FXZye0jtbEYriuAhEYXfUeuerPuOTsm?=
 =?us-ascii?Q?1A5BDV7RZQlH2yK+0kQ3B/pKahcIZ9L5WZ5pbnHU8yZzzDmpbhYKi+PfQRPp?=
 =?us-ascii?Q?9U4z7CBDzQaVtdsFyRuo+b7BaKqBpFkCdCb5QIn1kMHO2kvWXAaOeZyL1vIE?=
 =?us-ascii?Q?xCWImMz2HbjpxqAYPyiQrxzBG7DSpx+ccrna1BEQTsOsNb5L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6d5cbd-9308-4285-dca3-08df43d7228e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 11:45:38.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XNI5BbAGb/mJptsLjLbZFENBkMbq4496BrzfCl143tkYrWiKLM+sRqKsibdMeZ4Qnxcb9SwUgSU4IbOcZVxTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7942

On Fri, Nov 13, 2026 at 01:46:22PM +0100, Eric Dumazet wrote:
> skb->transport_header is a 16-bit offset from skb->head, and U16_MAX is
> reserved as the "not set" value. skb_set_transport_header() silently
> truncates an offset that does not fit.
> 
> ipv6_mc_check_exthdrs() stores the offset returned by ipv6_skip_exthdr(),
> which depends on the extension headers found in the packet. Should the
> value be truncated, ipv6_mc_check_icmpv6() and ipv6_mc_check_mld_msg()
> would then validate and parse the MLD message at the wrong place.
> 
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
> (24576 bytes), so this needs a large skb->data - skb->head on top of it,
> for instance after several nested decapsulations, each of them possibly
> pulling its own extension header chain. No reproducer was written,
> this is hardening.
> 
> Use skb_set_transport_header_careful() and treat such a packet as
> broken (-EINVAL).
> 
> Fixes: 9afd85c9e455 ("net: Export IGMP/MLD message validation code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
