Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5E943E9F9;
	Thu, 30 Jul 2026 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421784; cv=fail; b=ZmosKO77uh+g3hZYuhj29FTPtbIw0YNGpBw8zZJs5PIJzuJFLt8QAMt22njjeiOfsxrLdXOsqGbU3TEjGWhGTEQMVsWeyXzfUhUczANHNIugUh4Oq/5lzZJULRNyKU3nukFWS3PulsZryTBkhD+hHlwkWMspHJRbiYrng3MxQSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421784; c=relaxed/simple;
	bh=rhT7B9M0uDr2p0te1ZUe0niZnPGvDkPQpMja2TIA9/o=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LWt7Yw9uTQ3UPNNsBTltcq4fk6Ydx6BH11QxlnzVLCNcjfL8737tJlNxZAqyXIHiGtIERH89+O+s01cYfkz7nhW1WSrSTv6iBcxrPXXi/a+lJ25UO8ACSIo7v2mqfMvBp+50gYpFkoBf38hU8dhIrwJb91eeGrCols2AnpZ7ylo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5Rtwh6X; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5Rtwh6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785421780; x=1816957780;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=rhT7B9M0uDr2p0te1ZUe0niZnPGvDkPQpMja2TIA9/o=;
  b=I5Rtwh6XPhifjeCSIsardzMPaJW+We5SABnN7iOfmzRCqP5Lb4wvaAh1
   y3lFRcl2rp1f2ZRXZ33g8dfmO3pE1Zc6MWvgAuehpYXRQ153iBfVXkn1z
   nep1Roo7mA6Ked3aM95nvRgoKCG+WFkTTY0IGsA6D9wAkRXiDs6UJQndZ
   HPwAmeyFrl2qf7J75wrw5bN9fFgUWHmMAv/5g8w6Mq6SVzTi2QklnTjui
   xadqA5GbbHh6lPyvLyYFohMtlRBESDsGwXHkvZwYAklUmnm/P6R/fLnkM
   p3XAPeZuLru9tJafYKGEpX3fZhttEXyfsfufplxh9NQp0tHPnDYUGcwZk
   A==;
X-CSE-ConnectionGUID: 6bG999FpScG1Rv8NSW0P9w==
X-CSE-MsgGUID: NDMyMSS/Q3u58U7iEivAjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="85016934"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="85016934"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 07:29:39 -0700
X-CSE-ConnectionGUID: Viyn/s3URY6P5yGDnS5wuA==
X-CSE-MsgGUID: XGrixU1eTGO7INjMWbhT8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="258534427"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 07:29:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 07:29:38 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 07:29:38 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.13) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 07:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUMOnvkUla+gX1uhqRP54gS20+zOFqhvXuoiV6U0+qBs1EahqSYLdNMKbf2I9XVVasxTbXr1qENQuixMiugwIUNvlE6crJhJONDBI88fLPSd2Rbw2SxCVIW2UhvvyE3hY+QtD6MmA0882S8tFLmCND82gvYhsC+zn8PbMmkXPHkRfTj+n3mGK5C5CB4uMXFZuqjA4zdF9JuR5VR04sQPW0kghyGW+H6JaavcBsfFDcHcYne0dx7NjB2u81Xb2TRJeGj/tFfp46If+4E0G/tFNvj+7JG7ZOVIm/uXQ9atsTmG1IUu9X7xurME5F4vYCF/lWDpyOpO8USessnz81zoDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCiT3XNe9NZKvjhW0rx0McStUNJI9sOkXUo5Ig1VB0U=;
 b=NuKsnjy8WY6rRwnzLHpq55QpZu5CPb9wNgL8/DIpNk/QBAagCkvxJg/GdeCqwL1A4O9uCRtinjRFMI4J9YthSTBgRU/FpZBMyxwxuLTr4LAL9kFPsNPyAX6BPHCHT7EOwxYUxj/kCJURJceobuXZuiXlyTApY+eeUbGxz9cf/W3ca+bkODiVb23Q4YcP9srIE28HmOo6jklek5HaEQSoOP1AAxuwjIQwqLSewktO8j9sYvXpxaK/pcFL6oOeDaCLEP76vV1VZnc92zkFUetSjzVdUIjvcxhjNWeerO9vkSf2WVxLn6fM64YvNxhIzkCsCs6BN3UKy8cs8V9Gh4CclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM4PR11MB7758.namprd11.prod.outlook.com (2603:10b6:8:101::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 14:29:33 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 14:29:33 +0000
Date: Thu, 30 Jul 2026 22:29:20 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	<linux-atm-general@lists.sourceforge.net>, <netdev@vger.kernel.org>,
	<linux-can@vger.kernel.org>, <linux-sctp@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jakub Kicinski <kuba@kernel.org>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, Marc Kleine-Budde <mkl@pengutronix.de>,
	"Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>, Neal Cardwell
	<ncardwell@google.com>, Oliver Hartkopp <socketcan@hartkopp.net>, Paolo Abeni
	<pabeni@redhat.com>, Remi Denis-Courmont <courmisch@gmail.com>, Simon Horman
	<horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, "Willem
 de Bruijn" <willemdebruijn.kernel@gmail.com>, Xin Long
	<lucien.xin@gmail.com>, Petr Mladek <pmladek@suse.com>, Thomas
 =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>, Kees Cook
	<kees@kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH net-next v2] net: Replace %pK output with 0
Message-ID: <202607301617.b436a538-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260720144031.oU6azheV@linutronix.de>
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM4PR11MB7758:EE_
X-MS-Office365-Filtering-Correlation-Id: 99d80531-04ef-419b-e43b-08deee46f931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|11063799006|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: yBHEtP1F/udE1DwsLvuEIhdlwVfWSXcZphilYj7432gj10SIGPu+zrXgpCGBdSFpHd1qbLeLGvQdxMNsug7wSrBKz0O63uBhFXt8CYbOOhAsXmtEw6syIfUnAq+SoccO4nUoRUVTfeNb51zJlTxr2x+pBJPFCbyE3o+oUKcfAm9YHzoH4XE2vcydHfPz8vX5D2J0rKH9tNIoXDrR71QcgrGgUjy0xp4UU+UtzTtzUNTE4amxifuy9nwitTcLVIc/QNNTncUkcHKWew4TDgJNzG5Zb3D6Pdh4BqRXRuQab554tfRfKtwJeiasIt6npUhUmWXuVpWm/G/w2i8EmxKRM9mSXbzBgsG9BKMOy8m39b7iI0Rxxzv11LOXvA3w43wotJtFyBkuHw43EbAQGJFG5w824whFBC2NQ3CGMPHzWuJs4UWxu4aF1D6rU+a+6Hej9qLjw4mGZUlPsissmL4jThmxHiSjSvFMrOruayF5N5PnZW9+6r/Ml9/p426WmuiCEa/f32EJG3X0Se97Eq6pgJvv2CrFr1r5I9ti/uJl3R6h+XiUdwDwrNUVgGydEpUS4M8W0U1XLKO3Dib3wtP81M7EGTDoDqAKq15p0SGEQGCt8e0ne+1PaL5bDSq1TKoy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Tt3WX13+uD8D2UL3olB4NMQ0s0oJ0p9M3K13RY+JTIpuOQ3PRMSa5g5TKDb?=
 =?us-ascii?Q?zQWaPXZHzzYcPqL+5NjlfTYOulFLr0d31jIYbAsvgP/FDUx97oXEj9ik2AsV?=
 =?us-ascii?Q?1TusxUyOyQsenaEEmQDxz4BTgJ5W9QVUvoyyceyRP5hVnjNXUe4koyYabktw?=
 =?us-ascii?Q?nxOUnia5Tl+q+3YWxIVxbKOSlSBiSqIcWNvhsvCaQwZwW6x+HkhRQSAgV6xQ?=
 =?us-ascii?Q?Mj9Vm8M9+Oj48AAZi134IxISasCmXmGx2H1pbqzLk9wd9n0Nx3MVjO82nPmW?=
 =?us-ascii?Q?dzEmThnHcNzzTEp+hw8jQh6cqc3ntp3ybQ3/nb0gthyY+LWSNLmF+3Xa+9sA?=
 =?us-ascii?Q?X8HJdjiqoxQMLQMOHz2ixv1KUVUNoLlT771eXWJN8brN10szVOorOLC5WxJ4?=
 =?us-ascii?Q?QVtY6kPqCFVPYKB8eYKR+UhKJLjxnjBiZ1ZD2IReobS225C5Om84ihtKpJXw?=
 =?us-ascii?Q?VxMOB2uWXH4SzcV4ZYzaUYzflkAuRoKrNXzB8OAiOvTTyXuSGcJJVz382skt?=
 =?us-ascii?Q?V9zjTHUkbIFaVM6kaytgZCF57lgVGIt2avw3xZ6yfybTouS3pnVLSdjS5o3I?=
 =?us-ascii?Q?RuA6wngr05DDZy4tfXsBQHOJlVF2vMMjeTdiaYBMcWJyEmA4iV/iKFwNPC1K?=
 =?us-ascii?Q?+9oUfgtDHgsZBG0CQWYAmjOeGYcDMv9rNQ0WcBDzepgxAygZwOu/U0zjjHg4?=
 =?us-ascii?Q?8w5FLoLBYetq7+zW+krl0tgkkXAkLWSbvLxm8fJV43doGiS3oSHXKbVCO4X+?=
 =?us-ascii?Q?FNpvXpTeVSopNIA9cmClwXk07G+bH/O9lkrNAY0C106MvzPMruP3xXFWWbPH?=
 =?us-ascii?Q?am1YMl8FIdeYdjGlkqBeo7v9wAUUgzeqvCN+av5zwqDaYHjcSl/eH9eB4AjP?=
 =?us-ascii?Q?xHVfNIPhdqt8JnNU6yBCsMuS5MrzXboYbEeDgswhSdxL6rPC3RMFkvJzcZLl?=
 =?us-ascii?Q?zdezg16lP6TdqzMfScw1hLTEYsWGtz10QTbWS92mHTXP0+QSTC85Q6BhqcZN?=
 =?us-ascii?Q?+m/UQHRcwctEa+Dn32daYK7PbCi2uBN0kDTE1RzcG1MsY7rs3JMwKxovhzZ1?=
 =?us-ascii?Q?ubHrvfHpim3hThBZIejNAJDV0CFCU0ZRVxh+/5foEW8vL2vb7k39RgQP+a7G?=
 =?us-ascii?Q?DdQMFNXIuL9ZElN33vXOE4yVGyCxGqFqmWLBRUprywGOyWCtcti+BXFhZFZq?=
 =?us-ascii?Q?Ktp9gdr02NGREE96yVsjMbaiiO4KhJ7D2XhyD2KR9r2cePwBgo1j/dOeB3PK?=
 =?us-ascii?Q?zUNgBiUtf9+qoGTBdkyJ874islvuvu/qjFsjrSn1WiDmxna8kl6cz/udVESs?=
 =?us-ascii?Q?i6P1M2+o83JgPFJIxIxfr1bQhCYV/KS9ZknW3VW2epcuOmeSIbNHSDT9q1n5?=
 =?us-ascii?Q?CcPAKiH69TEMj1eF1bENDJWJWK60w5rc2YSaHwMcQL6QTmxMmXd2lPz8fOfo?=
 =?us-ascii?Q?712/IkYkMOyLYoHhDsv1O67YHHfIXHqZOTAZdepThsh2n5KaS4uL/853qGSW?=
 =?us-ascii?Q?hQyGBlWMpmBVaY4RtidT7RypNMOafIIbc6Y8X1B2KtQHMb8b1yXKJyc5FVsL?=
 =?us-ascii?Q?xk1vgJDI9CoiSfiTX2iQCS9/8fkFW1Mcxy9idd3rgGbjRnJ0XwnN6jhKoxPo?=
 =?us-ascii?Q?Z9Khd1vsgmKkfaNWQ2/UKrDPmtFWmn1oxkWf0dxWtPY4FCkdFMSD8adPpHxa?=
 =?us-ascii?Q?E9rYeEXDE00LBFvhS1VCZjYCDErB0smIWEahYjTcvfquoLfaz4oWNLJr7c44?=
 =?us-ascii?Q?5TmggpMGVg=3D=3D?=
X-Exchange-RoutingPolicyChecked: gEAXPo4xOJGuL0FxRVY26F09YXfZ1JRGDWYddyOe82yeOA+Ug362hAutJr0nK4L18ujDAmqYbzUDESmYWKXaAkLeq5XsHgugTaSWSh1u/xLKBiKJW63CpHLmO6ZLwV0lyQBYxuC/9DxAgHbZqran5+Y+QCxqbxyqUwEaGbGagWoUSM53+CACYn6gpEnjRTG2Npn3On55bAFGABqExqx1cBGG1+/hObgxCdFCjwkqyQABEwf0V6MLqhtlY5SHtotJ6GmV9qckwdecsjCsrsXWSVCEjulsoMCYGYTAt5+3J6TkhliCJa8rj3k1njzsw751lQoRF9NsoQcweTw+ocNsBQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d80531-04ef-419b-e43b-08deee46f931
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 14:29:33.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYc+EyPcIxzzaxxuUQNeKM2/Ax3bKvNHYMh+SsVk5v31pindEEasOZA6UvDvzWkheDfeeOy3nVT25IIfa5GjYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7758
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed "kselftests.proc.setns-dcache.fail" on:

commit: 811e528547c505ab0de53847067208692ea8b974 ("[PATCH net-next v2] net: Replace %pK output with 0")
url: https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/net-Replace-pK-output-with-0/20260720-233043
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 298bb2b8903323f6ef2eab4819a2e477765f0ff1
patch link: https://lore.kernel.org/all/20260720144031.oU6azheV@linutronix.de/
patch subject: [PATCH net-next v2] net: Replace %pK output with 0

in testcase: kselftests
version: kselftests-x86_64-502d801f0ab0-1_20260623
with following parameters:

	group: proc



config: x86_64-rhel-9.4-kselftests
compiler: gcc-14
test machine: 16 threads Intel(R) Core(TM) i7-13620H (Raptor Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607301617.b436a538-lkp@intel.com


# timeout set to 300
# selftests: proc: setns-dcache
# setns-dcache: setns-dcache.c:124: main: Assertion `rv == strlen(S)' failed.
# Aborted
not ok 21 selftests: proc: setns-dcache # exit=134



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260730/202607301617.b436a538-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

