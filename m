Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794828955;
	b=TOVd3khqgM1B9jMYsHx2Q6gz+/TGDCB9DtKTxs7YKmysYJ6LviW9gAwRilsg6L+uCv5j
	 N41JpR4/GR3q2Xdmw2lfppGrBvsW4Hk5qgMi0O1EmiJBHUEFkINe2HF0CfHttmtS4d8uX
	 UxOtHMe77z5NWBu/0GykYUAzI02zHDChXu7Yr0dP48siRL0is6t0MYehYBnkdpvcZ/llR
	 YhRlfad/C4ZbC8W+41lMmP7OXCcW6oZXBjcHBkg8+F1eoRMFNbdiNDMkEZY5lo6jMKdS8
	 VIVoLPYlUWLs8XFXNCM2p1sniGcH1SSO+DVpmlly6rn2V6EaL/dNz/d7LiqE2xCUzUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828955;
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
	bh=p38bYQE/M9ZesTuAXBTN1tA3+q49xB2OWSSXknJU4iA=;
	b=xiEwnrWbMFCDfzNPafG0kWgH1LAyLUlBJ1VvZCQWKxI2zi9TTC9NVNCx8PulRZoB5Y+C
	 MRp9mZxCUx8I024csU/sosiShge48tMoIXzr9mP0qlHDa9Nro9UNGzRtC63gMB+JG18q1
	 +Q89aXoENGcppQQiV8FswphwGb7ChFr95o7eY1lnVaVSU1y7CXaYD7b7J/JxJZTJ2l/Gd
	 DWaz2WQVuAFndpgDoAZO9xYSrCnEIBpPChOyLaa2JaKB6mvoakDAHb3d7OjgZ87TCe9nr
	 5k3nDL6HtwFYT7o3YP8glUSHiuA/FZ8SMeMIisTaKjYhZ7bvCimF5J0YnZNnOn6W+qA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ry5eZH56;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.68
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65A2606A329;
	Mon, 16 Nov 2026 11:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65A2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ry5eZH56
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rip13k81Oilg4OJkwXhSbiUEQW/n0JHeY7TWDOGYnKZP+Fr64tjxOYUA//xkMUtDox3YoUBab38FM3dXLPuDKbM65u+WpVy6HT89BJeBn1abY2K2f7uiuO7txNQoco+QNrPrQtFt1Xx33Xuvuw7iMkOgRNhcNX+u0cFtntbHtalv9/75ISi3S/elyrC7HoWvnxVGbhcsdneHOjfZ74CQQZC4nvzVpYpc3jOdrVj9lYRYtFNIHyCth1BOSK+UhR0Iq+onLaI+y61OjdK5tyF4pcCD4oUvXWV6iMbCOs/mIFKDx1ICvgXRsvyg0mVotpEM9ubY5Xw/ma0nCdQ+9filJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p38bYQE/M9ZesTuAXBTN1tA3+q49xB2OWSSXknJU4iA=;
 b=Vr5eQ4GEroG2UsDkRNjSXcaEMMmjfW2jyP83B3Nq/zQxUsV0eM1MsyrtR65Dqkyc5kCuNb49OWNOOBKFv1NsZwLPeMidoNEEIl3Ct3LvX6+VaI+GaaDlemyIXxkLzB7INNrJXsKhOUFSnn7Gg7fDwjAS37M0rSgBUYl1GyiwP76D+ds8+3WcXQHh1eUysKffNcw2tE4WwDs7rjoGdAGADFnY7jUTfTt4hTBCRJJ40MG/uhrpOqIBnzcUU5hwzuvNkYuYmow2yCgonq8BeW37NrCrm6jhmOLGoSDnCucbRxT8HobR9YJ4J/bOpb89gO9kcy+IMj1eFZXbV+pn0bAarA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p38bYQE/M9ZesTuAXBTN1tA3+q49xB2OWSSXknJU4iA=;
 b=ry5eZH56iuTA3YBlaEpZ2AMlhK4IT7UP0cXMuoIUkN6oHPDazocTTIcEq9QE7OHMCi/bk+Ag+3e/FfqwM0Xuv1RXu5VO+VDTyQmIh+DZ2Xg/j/AViKX3/DAVquB1L/O47OP+hWVD3EXgkQ8rOwAjoTWRAVWtV0x1v29PfQXHQJ7Q00HMEFaSVt17R5OoGB9791tLFTEPZSy/4Gsw/0Cng9wHQ5xbxvxFm1toYJ6VsbotNAu06zACnYm/MkuZFhD05IwxX5otm07b/fwf5WfPzdMCPsHkfKbpkOcM+2lrVoHf/YotymZgoXdV/zs3SLrCMZ/pqHGwXJMo1V7wp08O0Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by SJ2PR12MB8061.namprd12.prod.outlook.com (2603:10b6:a03:4cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 11:33:47 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 11:33:47 +0000
Date: Mon, 16 Nov 2026 13:33:38 +0200
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
Subject: Re: [PATCH net 1/5] ipv6: gro: limit the number of extension headers
Message-ID: <20261116113338.GA208668@shredder>
References: <20261113124625.4010206-1-edumazet@kernel.org>
 <20261113124625.4010206-2-edumazet@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113124625.4010206-2-edumazet@kernel.org>
X-ClientProxiedBy: TL2P290CA0006.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::6)
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|SJ2PR12MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: c83a91a5-1837-4bd0-746b-08df43d57a56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|22082099003|18002099003|261009223027099003|3023799007|11063799006|56012099006|10067099003|4143699003|261028144727099003|261026140227099003|261026121527099003|261021123027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	XzqjH4iJOd4ehu0vjvXlSucH6jryY2NFu7cuZIkG0ltkSbgp4xKeSIsXx06AJuse9sGgcS29GKRT+m7S5iWDRBj9BYXEHKluE+loiVF5PPOGdzYUQ0C4EFOTsi+NW5WJ1VfOipuKiv3IxPTPn7VQTcCClmvSElE5pDHGxfC8K9+9fxKpQMBGhS7nGP+t5RccADlRvfuEU0P8oCMikMfnDRNxdNb9vk2tuJjNbiAbY+Wlgt5yNU0JvhThOYEnlQIjv34Qw+NEdad5jefgwJvyKZYVUsZ41yfmnFguasFKwhB04fsUyOoAGNDWqYhL2YG0tvxlUAGOF6xbwQeX562Q0jKw+CjwTPEOKQEu83lkVI07SCtQYl4fmwj1IuduBxkisNSPcDPdGCAZ0Bka3ZUoxoWGbiEVDHEPC+3izTdR1K+uRHVHHajE2Ba9HC95+SbWcnFAL6BJrBTB8fpXLoTPrBpDmJNn/BeJvUjgmEO9n3wbdubiEnAw1nUrubFbKE5pvtjUloYhOZ3Jq2updF7yJWME72+BauN1jqFoS1okvHDGLsjvByYIQ4dyilcD6rTIyhwDCHrpY6v6tUhk8Mnm/Qy8t9Yu97dKGtSTMmDacXyVNsyeJpz+8QboRJi+Y3ONj7NSOkAyv2fv7F8OUNfyAJj8qSBUX21ntiQbhpF1CgA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(22082099003)(18002099003)(261009223027099003)(3023799007)(11063799006)(56012099006)(10067099003)(4143699003)(261028144727099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HtrdF8HvBISi04x2+moLKfEHc3EqqIvdixiugROBQHBsjewR0zjUMREGD3eZ?=
 =?us-ascii?Q?OwC+/ygJaIZaUF6sBy47eDgCqRChD0QScuR6ddE2vjc2CIJ0EeBKgOv6f58/?=
 =?us-ascii?Q?Cut+YxkBM2rG+Sup2z1m10Mbgif3gxZDwWlZvNcNa8EmjLxf47tZXfgEuEep?=
 =?us-ascii?Q?Nr0FkKWxKeW7mIGZzVlaRH/iEy3KVkergpHTUkxDX0D7B2HcBKfU8o6ZSIio?=
 =?us-ascii?Q?9JWQNJ+Ou+h36lguV6Oq+rxggSCeQnKPPuEhxPdkqtCGPijDwMdWPKcgJByJ?=
 =?us-ascii?Q?nSxEh6Hh69WRRg1khy7uy4BA8F097Pl0lFUoXPOOkBa5+XxEOhd3p//G3xnU?=
 =?us-ascii?Q?TxYBnn4qdrf46hEG364SD2UBZjXNjAqK9V/lGU2C+h0C/dFwuMrNueMl2h9+?=
 =?us-ascii?Q?aQ3ET8c09uKPY1ck3k2EVnyFgPytjhpN9TnmaqyTj4uE8GuH3JbjAIRql18e?=
 =?us-ascii?Q?1IJUzsSm86mJ1BtegVbqtEjDgWYb0bIAqh7UQiUJLl0UCBrMJa/waWJtqoKy?=
 =?us-ascii?Q?eQxI4jU8CAqQe45pz2Ai8yVD9rHXGtIhMQDz8eo4yQjsYc2dE9RNKOkLzOFz?=
 =?us-ascii?Q?TNkjvj8MV9748U3Bjc4SmPfnQhU++4g0736aY1gTxRB0DmRiYpMJ+NDhWtbA?=
 =?us-ascii?Q?JLrO/uPWFjjp2yPUFADpG8nkEsFOUn87u866a/6fyeCJyvO7BzkzPopTxp7i?=
 =?us-ascii?Q?7SEaS5NYyuMK+pfnOvUQXwbN09N0f0fxCvYkAlMWdmoNZ7teYoLI4zPoS9Yu?=
 =?us-ascii?Q?0HemyeHWwAPmRQYbTPXSEYdE9U7UjSw9+E1TdWyjxcKjUbV+KcjXiiC3s2kJ?=
 =?us-ascii?Q?Tj49IyWFl/2S9AY/n1LmY98T9AzuF35TGmCnMNZxeDx/4wvMTCr3O0PqhIni?=
 =?us-ascii?Q?opSrRlRO81LUCCrPMpbRp2xU7ULKFlTkhmOOjMNHlSkJcehzoluocreIMXhC?=
 =?us-ascii?Q?/i9BgbWo8KwbvJqMUkFkZ87kaU5A5Iro1QETPQINdNyFe93T4B+mdX6UZG/D?=
 =?us-ascii?Q?TM/sS+d5TDLD0DkQb/8sZBrs18++/ZMiNf3GhY3QiEmKdWxXdM4HpeGsPEy9?=
 =?us-ascii?Q?7F0wdgSdIk02aDRs55c2YKoGBkY1HoyIgXLIHnEto8eYvJHvSYKyaiI7g2Bv?=
 =?us-ascii?Q?bgV3Gl7SnVpaZ6SilmfvvpJbfW7hd+g3ig+1p3JxmcY56uo23+vQf+hGapVm?=
 =?us-ascii?Q?tT1jaqluHitKyGW9bMZ5eAiTYoBgAy7YPpJEJpjxxgfF2g6fRgU+tF/oZkog?=
 =?us-ascii?Q?BBaxaadK48t0sZ0XeL3pBEV1gU1kVd4Vk3NfgTG2yTwlPbDp+SlLFRI1aLys?=
 =?us-ascii?Q?Spyr16FvobiYJFFB7xH3l6Vyp1RVlQrxTJyTo+CtOZjyxIPsrgA9PPxNuJWH?=
 =?us-ascii?Q?WvWjpyTfeaZ59C6fUHVBuX/pk81EJqPl982uEmmU0EVT/rmmD/diK/R1RT3+?=
 =?us-ascii?Q?a9K09SGOVT8pasjMmcYbkhrLPXWAeJegguTKN4tjKuubVMzQaRnT0Ug/CAYQ?=
 =?us-ascii?Q?3vqbKyAWJsPFPP0DxjbjgVeO6soH3zitDBLt3/S0ID57waOclpt215Zg68Yb?=
 =?us-ascii?Q?Ca4ZFpw1gR4kTGi3qoGehUCgtVJUzWCfH2JsAD6iW/8AFJ43PXkhxe++g9Xm?=
 =?us-ascii?Q?PLxDxQ3865VLFsbfmzoSLQywYD0m9GlP0OnzBIcHRHhIZbFmFVzJQIJ6PJmR?=
 =?us-ascii?Q?fJt+sOUtacX4aqEw5Y5WKB4ryZ8yPUrhU7OfQSYV9PnzE1I4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83a91a5-1837-4bd0-746b-08df43d57a56
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 11:33:47.2180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4t+KDAH1NKwci9eKiE49G0bPlEsj2YhuNHWloGxfyANA4Nzv7gpOXyTerS4xR51AGJhIyWd5EBXCTkOzqznVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8061

On Fri, Nov 13, 2026 at 01:46:21PM +0100, Eric Dumazet wrote:
> Hyunwoo Kim reported that a long chain of IPv6 extension headers
> can push the transport header offset of a GRO packet beyond what
> the 16-bit skb->transport_header can store. The truncated offset
> is later used by gro_receive_network_flush() to locate the network
> header of a packet held in the GRO list, leading to an out-of-bounds
> read.
> 
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing"), ip6_protocol_deliver_rcu() drops packets carrying more than
> IP6_MAX_EXT_HDRS_CNT extension headers, but ipv6_gro_pull_exthdrs()
> was left unbounded.
> 
> There is no point trying to aggregate packets that the stack is going
> to drop anyway if they are locally delivered. Apply the same limit in
> ipv6_gro_pull_exthdrs().
> 
> When the limit is hit, @proto still designates an extension header.
> Extension header offloads have no gro_receive() callback, so
> ipv6_gro_receive() takes its existing "goto out" path with flush set,
> and the packet is given to the normal receive path. Local delivery
> drops it with SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS, while forwarded
> packets are simply not aggregated.
> 
> An extension header being at most 2048 bytes, this bounds a chain
> to 24576 bytes.
> 
> Note that offsets can still accumulate over nested encapsulations,
> so the places storing them should be hardened separately.
> 
> Fixes: 4b0ebbca3e16 ("net: gro: move L3 flush checks to tcp_gro_receive and udp_gro_receive_segment")
> Cc: stable@vger.kernel.org
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Link: https://lore.kernel.org/netdev/avTTQNyvwPP6LtGx@v4bel/
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
