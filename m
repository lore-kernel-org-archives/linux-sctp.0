From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Sep 2016 17:58:03 +0000
Subject: Re: [PATCH net 1/6] sctp: remove the unnecessary state check in sctp_outq_tail
Message-Id: <CADvbK_cwbn9zkUrzBUHnx6COy2y5wrbhhxy2tZaRzRNmdJCStA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1473326067.git.lucien.xin@gmail.com> <1718155e984f63995d1be9b053c58aa1a645718e.1473326067.git.lucien.xin@gmail.com>
 <20160908142701.GC16608@hmsreliant.think-freely.org> <CADvbK_dxTYrPPFJT5UPZErZLbW9y9oRm+VWbQXxhruwV6UgOZA@mail.gmail.com>
 <20160908192319.GD16608@hmsreliant.think-freely.org> <CADvbK_ddvZ4855B1PPLYVY2JV1okKzYXCpv-quNMBXp0Qb5Otw@mail.gmail.com>
 <20160909142841.GB15908@hmsreliant.think-freely.org> <CADvbK_f-09NvfeCbeaZZF8+LuMASTYnrh+02RvTz5UR-huiR3g@mail.gmail.com>
 <20160912194838.GE17689@localhost.localdomain>
In-Reply-To: <20160912194838.GE17689@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

>
> I also don't see an issue with this patch, btw.
>
> Xin, you may want to add more/such details to the changelog, specially
> about the timer versus primitive handling.
>
OK, I will post v2 of this patchset.
