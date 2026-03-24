Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB8E23D7E6;
	Tue, 24 Mar 2026 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367173; cv=none; b=PgGP4kF9Lb4KzZRxOgm9L2Cr7rpNl6B/DzaxCpRWLhxC+Ayp1TCRJku19a1jXHQ+iW4vb3kRF+NkWk8JWc/SIrOB7o1PyLszWUwclHHFyo74JAAMSVJhEjmOx0nfGJCzxCF/9OpbT9ztiniGWPQ8YIakSLdRjBoYiiXpPPPcqFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367173; c=relaxed/simple;
	bh=pLt1XqU3RZcuHwA0yFwsdkAZPuickPwzxs96gflSBRI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKIh1kIbfoyFTXqxeZxZMlXOy6840g9+tH61TaySp891JZd+ZAE//cj5vIO3y3GTt+VeUp/0/Q6HYKI4wgKWe5Aj+0TxfIBVcF2wksaxj+OkcY9yoddqGmvV0QySz8XDLMoCL5NybTkERZGYOieVhV6n7fO+LeWfYiHHuUO35OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEFD388B35;
	Tue, 24 Mar 2026 15:36:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id F093718;
	Tue, 24 Mar 2026 15:36:48 +0000 (UTC)
Date: Tue, 24 Mar 2026 11:37:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaron Conole <aconole@redhat.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, Peter Zijlstra
 <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, Eelco
 Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>, Marcelo
 Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Willem de Bruijn
 <willemb@google.com>, Samiullah Khawaja <skhawaja@google.com>, Hangbin Liu
 <liuhangbin@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 dev@openvswitch.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/19] net: Use trace_call__##name() at guarded
 tracepoint call sites
Message-ID: <20260324113731.5252724e@gandalf.local.home>
In-Reply-To: <f7ttsu58con.fsf@redhat.com>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
	<20260323160052.17528-5-vineeth@bitbyteword.org>
	<f7ttsu58con.fsf@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 44qkot3uem9ayugoztbi5z8yeb6k7s7e
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: F093718
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+tQiMn63Ec6IOmabtDBFhjzQTi5TFzBjc=
X-HE-Tag: 1774366608-75188
X-HE-Meta: U2FsdGVkX19yuAlxy+EoRVjDrCnH7N5nKRqw/zEwwZC+0iz33Moky87HDcPHBdq7orWI1a5ex/4oOWmHKzFtnBCa+C49FaCGuGESvPmS6eZ+Yg7FW1CDh9GufeoAF7RG0MbJliPUtZnyFah7YBt3MUz8wzRb2slkVWkSdCnPR98osAg1Dv5cNHz+fvo4Rm/FeeyTXJhB3GR7WbPLLUpI27359JqfgGUZpS6mj02gpifyicIXkpQVM1FuCpTPvqu/QS4xU2T3ACQ+LE1YXEEaVkE/QVSk6ud7Bb4rOwYHU5U1cj60+lJz0HkA+QyxmF7zwiw8RbAoZJnkx7LY4I2JZY1LfL8PA3eumh07N3g04fE54z1+OipVfc+XHoobFK4GirBxqASTnUh57Y58A2OK8lhis1Y0GhcDtr3yfvdQzlAyMDeZBI6ofWRESVa6tnikL9TyMHTKDgVoCEHjprrt1Vu5o02xrlYKbo3y1RDFl/c4uV/O65kHRdh7Q5AaVYoZ/RLifpTQl1w=

On Tue, 24 Mar 2026 11:33:28 -0400
Aaron Conole <aconole@redhat.com> wrote:

> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> writes:
> 
> > Replace trace_foo() with the new trace_call__foo() at sites already
> > guarded by trace_foo_enabled(), avoiding a redundant
> > static_branch_unlikely() re-evaluation inside the tracepoint.
> > trace_call__foo() calls the tracepoint callbacks directly without
> > utilizing the static branch again.
> >
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> > Assisted-by: Claude:claude-sonnet-4-6
> > ---  
> 
> As noted before, I think we can just eliminate the guard in the
> openvswitch module (and that would probably be a more understandable
> fix) rather than replacing the call-in.

That should probably be a separate patch, as it actually changes the
code beyond the purpose of this patch.

Removing the guard first, and then have a patch like this to modify the
rest.

-- Steve
