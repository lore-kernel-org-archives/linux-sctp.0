From: Fan Du <fan.du@windriver.com>
Date: Mon, 14 Jan 2013 02:40:46 +0000
Subject: Re: [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <50F3702E.8090909@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
In-Reply-To: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org



On 2013年01月11日 21:48, Neil Horman wrote:
> On Fri, Jan 11, 2013 at 03:22:41PM +0800, Fan Du wrote:
>> CLIENT repeatly call process_ready_sockets, which malloc without free,
>> so sctp_xconnect exit unexpectly.
>>
>> Signed-off-by: Fan Du<fan.du@windriver.com>
>> ---
>>   apps/sctp_xconnect.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/apps/sctp_xconnect.c b/apps/sctp_xconnect.c
>> index 5874c33..4e33040 100644
>> --- a/apps/sctp_xconnect.c
>> +++ b/apps/sctp_xconnect.c
>> @@ -573,6 +573,7 @@ void process_ready_sockets(int client_socket[], int assoc_num, fd_set *rfds) {
>>   			}
>>   		}
>>   	}
>> +	free(big_buffer);
>>   }
>>
> Definately a leak, but it seems like it would be better solved by making those
> buffers static allocations.  Its a single threaded app, why do all that malloc
> and free in a forever while loop when you don't really need to?

Hi, Neil

Thanks for your advice.

I have send another version to the list.

> Neil
>
>>   int main(int argc, char *argv[]) {
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

-- 
浮沉随浪只记今朝笑

--fan
