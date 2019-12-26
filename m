From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Thu, 26 Dec 2019 23:09:07 +0000
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Message-Id: <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
In-Reply-To: <20191226122917.431-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org



 >From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
 >Date: Thu, 26 Dec 2019 12:29:17 +0000
 >
 >> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
 >> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
 >> and trigger sctp_probe_path_trace in sctp_outq_sack.
 > ...
 >
 >Applied, but why did you remove the trace enabled check, just out of
 >curiosity?

Actually, the check in trace_sctp_probe_path_enabled also done in
trace_sctp_probe_path according to the Macro definition, both check
if (static_key_false(&__tracepoint_##name.key)).



include/linux/tracepoint.h
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
	extern struct tracepoint __tracepoint_##name;			\
	static inline void trace_##name(proto)				\
	{								\
		if (static_key_false(&__tracepoint_##name.key))		\
			__DO_TRACE(&__tracepoint_##name,		\
				TP_PROTO(data_proto),			\
				TP_ARGS(data_args),			\
				TP_CONDITION(cond), 0);			\
		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
			rcu_read_lock_sched_notrace();			\
			rcu_dereference_sched(__tracepoint_##name.funcs);\
			rcu_read_unlock_sched_notrace();		\
		}							\
	}
			
			
	static inline bool						\
	trace_##name##_enabled(void)					\
	{								\
		return static_key_false(&__tracepoint_##name.key);	\
	}
