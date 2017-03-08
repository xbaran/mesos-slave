#!/bin/bash
#echo `"$@" | sed -e 's/-v [^ ]*//g' -e 's/mesos-[^ ]*/mesos-xxx/g'` >> /tmp/commands.log
export DOCKER_API_VERSION=${DOCKER_API_VERSION:-1.23}
trap "echo SIGINT >> /tmp/command.log" SIGINT
trap "echo SIGTERM >> /tmp/command.log" SIGTERM
trap "echo EXIT >> /tmp/command.log" EXIT
tmp=`echo $* | sed -e 's/-v [^ ]*//g'`
echo $tmp >> /tmp/command.log
echo "--------------------------------" >> /tmp/command.log

/usr/bin/docker $tmp  > >( sed -e 's/"FinishedAt": ""/"FinishedAt": "0001-01-01T00:00:00Z"/g' -e 's/"StartedAt": ""/"StartedAt": "0001-01-01T00:00:00Z"/g' | tee -a /tmp/command.log) 2> >(tee -a /tmp/command.log >&2)