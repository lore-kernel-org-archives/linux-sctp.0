Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010058.outbound.protection.outlook.com [52.101.84.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900253E40EC;
	Thu, 15 Oct 2026 09:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055459; cv=fail; b=lSk8Njthd8RZxHPMnIUc1nf54nUh40GvxMp7xNF84tzJkFpqN7GnRECfOOb0PW8NETRRq8wp0rVYoj27USugtMrkGKBA9fnlJgnJ0JfwiNadLr7wlGE1ftgnsWoKNPJ5UvM/31475g8r8S+zz7rbmVAU9eEwXtePM6ehWoo5zXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055459; c=relaxed/simple;
	bh=JfTy3i8C7u9+VCp2+K1fF3eAebDx+UxXf5+Wbtpd8z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hWHCnjeFCOPicFxL9wGTr1CH3NF0FTCCizYoDe811peV3tMq2y808S7PAMuNTsNPvhaR6R5R2VOhWYJgJ1wwmnEHfOeusHtTAt7PyicuZPDZtzWd4oKRB+V/q0It6RhR/1rh+Bi2getvXd2ADb06mreryD2mY2gA6AeXlkr9F6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=LLUUzfN8; arc=fail smtp.client-ip=52.101.84.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="LLUUzfN8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwA9A2p2Z+4FAUZMe1ngc3VLekk0Qz1GVKwtW8chtprTPJN46Pjh6gOQMIIWFATIlqIhLEly/4feKlHTk2AfY3iHfLUHV1kKbm5nTBpwY7Vzre+TUsuk7QdN6n3PBzj6Kw28ZjLutIQ+uzKOeWERe1A8UtT7MKgJ3WlusPdmBOBtlCoUYsJzhE9SMcrvr8aumsjBLjjaWR4XwVpE6D8waitsi+niQ4DYQuCODbzD/u/oH4ZdW4FLSocUgf4oz6pS0sgWqHx42HH7yaVRQ+Uka+JPhLrcRlkg/4FYb7T77Y/Z6UXaKJDkqhHFFP7BGL7kp4bRABlYyI5D5IQen4wNlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GezyzJn2Tw8UeD36j4p92uqPuR2jsB9/1yn3sEUR/Qk=;
 b=AtXDzzblNT6ELc5B8i/HdjGhGSuprhSZCms9cLbm6MHO5Jyr2He+g7pLpc16sTby9Hxjdo0gDI/L00P6yw9kXURfatp9sR1ePJmuUqa3QG9YBcqKDHZANJxfqy9xvfBNazaYRXW7opH7VPEOPLsSdm/5ah/s+e+7pSVl6sdDqyC6uucMEZ058x/1xGi0jJ0UD+JPYSkflrZTUShm6sOBhkX+XdaUcmyaRRxckEZByuWWWXLPqT2lYftU3hbHJxBqmyOPRao/OPj7mqexgfRvEAOas3SLxnjk1jer0KgSafJ9R1NupQMoEAPHPKNMIYwy7s9FOv/35Hdo6zu41DUQFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GezyzJn2Tw8UeD36j4p92uqPuR2jsB9/1yn3sEUR/Qk=;
 b=LLUUzfN8yEUHRNagzao+pht5wOFpKHRTefAHNQBZe+uPi0j48XjSrbJtTJeGKtpMO37e7VJf6bmZVSOikoIpwBc5hsr6u2e0dtxJdaoIXAgffLjUM1KMojIFKU3xk0+1aYFCnUBE3osV+5k7ySwAwyNSDOyIwapCnXa/nmZ/kRvy34Nqe1Z4dxy+khTDcPwGfgCto7Sjt4RhgdRN684eyYZ1gsoWUOHuvw73PesnzJ4LobVYQMREk0Rnv8KRiP4nICac/veaBov8vWbtz9fP/fu2olv+dS9lr0hfLMKrW+Wb0Odu9jxoKTXIxR0OJpgT5G7iaPPD8EpeN3xko3Sr7Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from MI9PR04MB019273.eurprd04.prod.outlook.com
 (2603:10a6:290:d3::17) by AS8PR04MB9063.eurprd04.prod.outlook.com
 (2603:10a6:20b:446::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 09:10:54 +0000
Received: from MI9PR04MB019273.eurprd04.prod.outlook.com
 ([fe80::263c:943a:dcb0:29d8]) by MI9PR04MB019273.eurprd04.prod.outlook.com
 ([fe80::263c:943a:dcb0:29d8%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 09:10:54 +0000
Date: Thu, 15 Oct 2026 12:10:47 +0300
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Raju Rangoju <Raju.Rangoju@amd.com>, 
	Prashanth Kumar K R <PrashanthKumar.K.R@amd.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>, 
	Ratheesh Kannoth <rkannoth@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>, 
	Bharat Bhushan <bbhushan2@marvell.com>, Maxime Chevallier <maxime.chevallier@bootlin.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Simon Horman <horms@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Vladimir Oltean <olteanv@gmail.com>, Alexander Aring <alex.aring@gmail.com>, 
	Stefan Schmidt <stefan@datenfreihafen.org>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Jeremy Kerr <jk@codeconstruct.com.au>, Matt Johnston <matt@codeconstruct.com.au>, 
	Stephen Hemminger <stephen@networkplumber.org>, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Jiri Pirko <jiri@resnulli.us>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Tung Quang Nguyen <tung.quang.nguyen@est.tech>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename skb_unshare() to skb_unclone_full()
Message-ID: <x5xra7sdnpwdqnmw3znv5eyoxd4qv4z4ybznyu7ajpg6sogazo@4fzejnx2aur7>
References: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
X-ClientProxiedBy: FR3P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::7) To MI9PR04MB019273.eurprd04.prod.outlook.com
 (2603:10a6:290:d3::17)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI9PR04MB019273:EE_|AS8PR04MB9063:EE_
X-MS-Office365-Filtering-Correlation-Id: 069f95ad-8898-4789-9613-08df2a9c372a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|19092799006|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0MQspB3Whq+8Tl0m6LmguvqMT1Ttt+NP25tHcA1MqojwuJR9LF05e5P9xDphXJJ/xUaycdFYs7R8fJnQkqsOlXDVYD4sVdVL945RF3x+vpNkbhZLE/+jj+mJc30VFAswXngd06imSXPEYRggOIWszT8RE5HBtAIkK5PGdPOTNkHbrkGsIadXf1xMO1zXelVe48z7bxGn08DkZoDh7zgQINIvlpUeGoR+gJE3KWA7nMpJ6RkCLLvSEuhMwFWbvvE1+x/KVVHSCIq5Yyd0/I40iBEJyzPsuR2fyiUeH9K0W1N5qMlIEMid9UlvwJJaDRuaXkpwt3UMuRwK+a/cRDqYns1gWuwsiYjCY5NTzY5TxMWYzWsnl5d9vf9nUBNE8/R9Cen2bvCksIQGluNJzdcYEoHsZT3UpcO4u8AUAuqO74Oo93R4QvFhzosDcU+BrRZtg5KoIlbOkc2sgEAz7LBKNZGN4jQx936OTLXx0pxri6DbulZlRnKGvkkq8pNHAOJHR1oBfE0qtN0wc0lfR+wiRJRQunMv2sIyKa3TxeU387AxmO2HC6iym472y0HLncUkCGV6hnZBORNuY5IfrT3KgtFZ6pUcTNuJiztm/FDFsp5Rb0zBNuNabaNJ5odo++w1A/r7Gq2eG3yv1EVQUVJGSGZib6w+HaU/ZLy2KdK8gtQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI9PR04MB019273.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(19092799006)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sXsf7Q8JhCFnEKc+Qxj6g5bkNVw12jGvm4j2+D2bWlYD91hEC80gxhTPPw39?=
 =?us-ascii?Q?vvDBdHZNY5bBoK85qjamdEpqU4Y+pYyTMaOHFXWX7Zjrvqif+aMgIvfG5Nqp?=
 =?us-ascii?Q?6/JarVMc+w5Qd1+qUwfzgbLh/39zxsJfI3qtgJkpAWRa3lAdav8xby8Jaf0F?=
 =?us-ascii?Q?PfHqH9FsPmwIKhIIcQ2/VGUhnwHOYb9sArJC/G74TPTacvpclL4istZf0sMG?=
 =?us-ascii?Q?2S90Ng1i1i0UjQf+iHCGlDmDyoo0ON2O6zwWQzFCATOHl+Iy5oxGe5kBo1Gi?=
 =?us-ascii?Q?+f1m2l/3k7OTU7czxRQxdoGhaaTNoZ0OGdmdpualE1FjusfvXuczmsuaOgnu?=
 =?us-ascii?Q?8oWViWRK/KHTPYUhjRHaNnuFkvOfqlCQoXWK3REc8s6aknBiVz5hnzGQXrVt?=
 =?us-ascii?Q?rTEzr2xAkns7BFlHNh3oukm9IvBVAoxxwepx6pvXsccGboQ3Q9bpmevPrLXT?=
 =?us-ascii?Q?diWWbfFBQBypRa+FQwWhYbuWqNkrO9xN1VNJwUFwKqwU3NneCkznt2Ds6PEg?=
 =?us-ascii?Q?Rq4GLJFgbZKxV4KOUjGy2+muCHHmbjBxrwaYHCGM76xLoZlySmfIF32M4Fln?=
 =?us-ascii?Q?P2fU12PcP++9/TIXM1X7id6vTcxZT8PDzV0AkJwU2wMKT3Btg6B5QxOIIkGP?=
 =?us-ascii?Q?RDHQAdonMp2n1oW8c85fIFrzoUuNXHQQno9zt0zTIOGMqnM4c/Frxa7qAMZ/?=
 =?us-ascii?Q?Ut+LrQpJtN5z1jm6rDf6MGQsTlM2kAincv5st/13130e+mksMhROSVIyVct9?=
 =?us-ascii?Q?XCrfG36Q2hhdTIyzgz+HxjuRGkvQh/bEx/CGUHHlCQgnqCzrlS+w8KG//Rm6?=
 =?us-ascii?Q?7Ua9ZL7HEYtKKjLUy5OFIbW7MvNY8oRFhSKnkFa0OzSLD7gY8IJ7nnyB/H0G?=
 =?us-ascii?Q?j8y9FvKM3u0L69NTFXyT5zXu6+qg7KozULfpG4P5nMuUJZbRZ6Lb3OGzvHeS?=
 =?us-ascii?Q?EV1LHWMZyrsk73jjBzgv63pC05zjyeAhSKwjH8HCviBR1QkxJvTWF3WaUE6R?=
 =?us-ascii?Q?IaIzJA+qXO90o/VLuY4AYWEwZZChTjF8mWloeIGqMwhhEmpfHnOEiZ8D5hB0?=
 =?us-ascii?Q?4QFKlyw0V86Elf0OfaMGBOO1i2xQmTYwodX1jX6TbIyRAAE+c7pukFPXDV7R?=
 =?us-ascii?Q?xD444IIjBmzO7Re6i/6B2m9tntO4OtQNtbNip4molZ2kklUlZW0md1sOFGJh?=
 =?us-ascii?Q?qBJBhoxiJ8PFj8Br3aWf3V4JZdXa2JzxP67A8ddoH18wNV1d++yKWxpHignY?=
 =?us-ascii?Q?SdseZjBaFZLMH7DqoCIoFC1q7q/EqGsYYCvOTCd/7Z67CFuIl3DEORKrfdpS?=
 =?us-ascii?Q?SDZ9AfFy7/4QVQbVGhPP87ZVgCYeK6xhYQMPJMAvOZ94rei4SxO2BKzM6xAN?=
 =?us-ascii?Q?bUwDM1xlH3HU7RLn15hThSuP28JE7Ohrdu3lkmoU08uqdj+ogpuLYPocU2rG?=
 =?us-ascii?Q?jhsfwUI+/7EyupczdZx9BStrxAvyXUfCyJzhQdbwKmXAsTL4mFRv5BF5/nl+?=
 =?us-ascii?Q?5InBTO+jNl1m4AguweKahy+JI2Jjk2aRBNoyvzpk+whKBUKXpcYCcEkToL0P?=
 =?us-ascii?Q?izlTe5W3KALlksp9qIKqYtajCAxXNu1YnyGQJO0ZMP6Lf+0pZrSFH2uykJsQ?=
 =?us-ascii?Q?a9loSd8rG2uFVbHJdbKAOvyI7PMYQUariph4C/djbuQMxYW+zjMD8so6fWaV?=
 =?us-ascii?Q?1wWpllb9lVlSy18LYFmZmvVLnYzV6/GP2xVkg8GiaZuSxda1eTyDE0pYCRlf?=
 =?us-ascii?Q?ZV2D0qwnjQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 069f95ad-8898-4789-9613-08df2a9c372a
X-MS-Exchange-CrossTenant-AuthSource: MI9PR04MB019273.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 09:10:53.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fszJDd5z+GU2OWrPu1eXeN/KvM+6wyFdJYMVnj9U1lW7/40KhdK+znZdHlW8PRiFpUp040bYyoxEMj0CS0kh6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9063

On Thu, Oct 15, 2026 at 10:16:38AM +0200, Nicolai Buchwitz wrote:
> skb_unshare() only copies cloned skbs. A shared skb that is not a clone
> comes back unchanged, which the name doesn't suggest. The loopback
> selftest hooks got caught by this and hit BUG_ON(skb_shared()).
> 
> Rename it to skb_unclone_full(). Like skb_unclone() it only acts on
> clones, but it copies the whole skb, not just the head.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2

