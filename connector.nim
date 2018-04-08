# Copyright 2017 Yoshihiro Tanaka
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

  # http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Yoshihiro Tanaka <contact@cordea.jp>
# date  : 2018-04-07

import os
import osproc
import random
import tables
import subexes
import strutils
import sequtils

type
  ContainerNotFoundException = object of Exception
  ConnectionFailedException = object of Exception

const Containers = 10

proc getContainerNames(): array[Containers, string] =
  for i in 0..Containers-1:
    result[i] = subex("blockchain$#") % [ $i ]

proc findContainers(names: array[Containers, string]): Table[string, string] =
  result = initTable[string, string]()
  for name in names:
    let cmd = subex("docker inspect -f '{{ .NetworkSettings.IPAddress }}' $#") % [ name ]
    var (res, code) = execCmdEx cmd
    if code == 0:
      res.removeSuffix()
      result[name] = res
    else:
      raise newException(ContainerNotFoundException, "")

proc connect(source, target: string) =
  let cmd = subex("docker exec $# curl -X POST --silent http://localhost:8080/peer -d \"$#\"") % [
    source, target
  ]
  let (_, code) = execCmdEx cmd
  if code == 0:
    echo source, ": connect to ", target
  else:
    raise newException(ConnectionFailedException, "")

proc getConnectIp(own: string, ips: seq[string]): string =
  let ip = ips[rand(Containers) - 1]
  if ip == own:
    return getConnectIp(own, ips)
  else:
    return ip

when isMainModule:
  let
    names = getContainerNames()
    containers = findContainers(names)
    ips = toSeq(containers.values)
  for key, value in containers.pairs:
    let ip = getConnectIp(value, ips)
    connect(key, ip)
